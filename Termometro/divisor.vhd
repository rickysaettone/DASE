----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 13:08:22
-- Design Name: 
-- Module Name: divisor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divisor is
    Port ( clk          : in std_logic;
           reset        : in std_logic;
           
           -- Componentes del divisor
           dividendo_i  : in  std_logic_vector (15 downto 0);
           divisor_i    : in  std_logic_vector (15 downto 0);
           division_o   : out std_logic_vector (15 downto 0);
           rdy_div_in       : in  std_logic;
           rdy_div_out      : out std_logic                   
    );
end divisor;

architecture Behavioral of divisor is

    component multiplicador
        generic (
            N_bits        : integer := 4;
            N_decimales     : integer := 9
        );
        Port (
            clk_i    : in  std_logic;
            rst_i    : in  std_logic;
            rdy_in   : in  std_logic;
            n1_in    : in  std_logic_vector(N_bits-1 downto 0);
            n2_in    : in  std_logic_vector(N_bits-1 downto 0);
            n_out    : out std_logic_vector(N_bits-1 downto 0);
            rdy_out  : out std_logic
        );
    end component;

    type state_type is (S_IDLE, S_ITER, S_FINAL);
    signal STATE : state_type := S_IDLE;
    
    constant cont_MAX   : integer := 4;
    signal cont         : integer range 0 to cont_MAX;
    signal result       : std_logic_vector (15 downto 0);
    
    -- Newton Raphson: x = (2 - D*x)*x
    signal x            : std_logic_vector (15 downto 0) := "000011001"; -- Val inicial 0.1
    signal N            : std_logic_vector (15 downto 0); -- Numerador
    signal D            : std_logic_vector (15 downto 0); -- Denominador
    
    -- Mult1: D*x
    signal mult_a1       : std_logic_vector (15 downto 0);
    signal mult_b1       : std_logic_vector (15 downto 0);
    signal mult_res1     : std_logic_vector (15 downto 0);
    signal rdy_mult_in1  : std_logic;
    signal rdy_mult_out1 : std_logic;
    
    -- Mult2: (2-Mult1)*x
    signal mult_a2       : std_logic_vector (15 downto 0);
    signal mult_b2       : std_logic_vector (15 downto 0);
    signal mult_res2     : std_logic_vector (15 downto 0);
    signal rdy_mult_in2  : std_logic;
    signal rdy_mult_out2 : std_logic;
    
    

begin
    mult1 : multiplicador
        generic map (
            N_bits => 16,
            N_decimales => 8
        )
        port map (
            clk_i   => clk,
            rst_i   => reset,
            rdy_in  => rdy_mult_in1,
            n1_in   => mult_a1,
            n2_in   => mult_b1,
            n_out   => mult_res1,
            rdy_out => rdy_mult_out1
        );
        
    mult2 : multiplicador
        generic map (
            N_bits => 16,
            N_decimales => 8
        )
        port map (
            clk_i   => clk,
            rst_i   => reset,
            rdy_in  => rdy_mult_in2,
            n1_in   => mult_a2,
            n2_in   => mult_b2,
            n_out   => mult_res2,
            rdy_out => rdy_mult_out2
        );
    
    N <= dividendo_i;
    D <= divisor_i;

    divisor : process(clk, reset)
    begin
        if (reset = '1') then
            STATE <= S_IDLE;
            result <= (others => '0');
            rdy_mult_in1 <= '0';
            rdy_mult_in2 <= '0';
            rdy_div_out <= '0';
    
        elsif rising_edge(clk) then
            case STATE is
        
                when S_IDLE =>
                
                    if (rdy_div_in = '1') then
                        STATE <= S_ITER;
                    end if;
                    
                    rdy_div_out <= '0';
                    
                when S_ITER =>
                
                    if (cont < cont_MAX) then
                        if (rdy_mult_in1 = '0' and rdy_mult_in2 = '0') then
                        
                            -- Establecer valores para la primera multiplicación D*x
                            rdy_mult_in1 <= '1';
                            mult_a1 <= D;
                            mult_b1 <= x;
                        
                        elsif (rdy_mult_out1 = '1' and rdy_mult_out2 = '0') then
                            
                            rdy_mult_in1 <= '0';
                            
                            -- Establecer valores para la segunda multiplicación resta*x
                            rdy_mult_in2 <= '1';
                            mult_a2 <= std_logic_vector(to_signed(2, 16) - signed(mult_res1));
                            mult_b2 <= x;
                        
                        elsif (rdy_mult_out2 = '1') then
                        
                            rdy_mult_in2 <= '0';
                            x <= mult_res2;
                            
                            cont <= cont + 1;
                            
                        end if;
                        
                    else
                        
                        -- Multiplicacion del dividendo y el inverso del divisor N*x
                        rdy_mult_in1 <= '1';
                        mult_a1 <= N;
                        mult_b1 <= x;
                        
                        STATE <= S_FINAL;
                        cont <= 0;
                        
                    end if;
                    
                when S_FINAL =>
                
                    rdy_mult_in1 <= '0';
                    result <= mult_res1;
                    rdy_div_out <= '1';
                    STATE <= S_IDLE;
                
            end case;
        end if;
    end process;
    
    division_o <= result;


end Behavioral;
