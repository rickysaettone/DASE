----------------------------------------------------------------------------------
-- V2.0
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divisor is
    generic (
            N_bits_div    : integer := 16;
            N_decim_div   : integer := 9;
            N_iter_div    : integer := 4
    );
    Port ( clk          : in std_logic;
           reset        : in std_logic;
           
           -- Componentes del divisor
           dividendo_i  : in  std_logic_vector (N_bits_div-1 downto 0);
           divisor_i    : in  std_logic_vector (N_bits_div-1 downto 0);
           division_o   : out std_logic_vector (N_bits_div-1 downto 0);
           rdy_div_in       : in  std_logic;
           rdy_div_out      : out std_logic                   
    );
end divisor;

architecture Behavioral of divisor is

    component multiplicador
        generic (
            N_bits        : integer := N_bits_div;
            N_decimales   : integer := N_decim_div
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

    type state_type is (S_IDLE, S_MULT1, S_MULT2, S_DIVIS, S_FINAL);
    signal STATE : state_type := S_IDLE;
    
    constant cont_MAX   : integer := N_iter_div;
    signal cont         : integer range 0 to cont_MAX;
    signal two          : std_logic_vector (N_bits_div-1 downto 0);
    signal result       : std_logic_vector (N_bits_div-1 downto 0);
    
    -- Newton Raphson: x = (2 - D*x)*x
    signal x            : std_logic_vector (N_bits_div-1 downto 0); -- Val inicial 0.1
    signal N            : std_logic_vector (N_bits_div-1 downto 0); -- Numerador
    signal D            : std_logic_vector (N_bits_div-1 downto 0); -- Denominador
    
    -- Mult1: D*x
    signal mult_a1       : std_logic_vector (N_bits_div-1 downto 0);
    signal mult_b1       : std_logic_vector (N_bits_div-1 downto 0);
    signal mult_res1     : std_logic_vector (N_bits_div-1 downto 0);
    signal rdy_mult_in1  : std_logic;
    signal rdy_mult_out1 : std_logic;
    
    -- Mult2: (2-Mult1)*x
    signal mult_a2       : std_logic_vector (N_bits_div-1 downto 0);
    signal mult_b2       : std_logic_vector (N_bits_div-1 downto 0);
    signal mult_res2     : std_logic_vector (N_bits_div-1 downto 0);
    signal rdy_mult_in2  : std_logic;
    signal rdy_mult_out2 : std_logic;
    
begin
    mult1 : multiplicador
        generic map (
            N_bits      => N_bits_div,
            N_decimales => N_decim_div
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
            N_bits      => N_bits_div,
            N_decimales => N_decim_div
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
            rdy_mult_in1 <= '0';
            rdy_mult_in2 <= '0';
            rdy_div_out <= '0';
    
        elsif rising_edge(clk) then
            case STATE is
        
                when S_IDLE =>
                
                    if (rdy_div_in = '1') then
                        
                        -- Establecer valor de el número 2 para N bits con M decimales
                        two <= std_logic_vector(to_signed(2**(N_decim_div+1), N_bits_div));
                        -- Establece un valor decimal inicial de x para N bits con M decimales
                        x <= (others => '0');
                        x(N_decim_div-3) <= '1'; 
                    
                        STATE <= S_MULT1;
                        
                    end if;
                    
                    rdy_div_out <= '0';
                    cont <= 0;
                    
                when S_MULT1 =>
                
                    
                    if (cont = 0) then -- Primera iteración
                    
                        -- Establecer valores para la primera multiplicación D*x
                        rdy_mult_in1 <= '1';
                        mult_a1 <= D;
                        mult_b1 <= x;
                        
                        STATE <= S_MULT2;
                        
                    else
                    
                        rdy_mult_in2 <= '0';
                    
                        if (rdy_mult_out2 = '1') then
                            
                            x <= mult_res2;
                            rdy_mult_in1 <= '1';
                            mult_a1 <= D;
                            mult_b1 <= mult_res2;
                            
                            STATE <= S_MULT2;
                        
                        end if;
                    
                    end if;
                    
                when S_MULT2 =>
                    
                    rdy_mult_in1 <= '0';
                    
                    if (rdy_mult_out1 = '1') then
                        
                        -- Establecer valores para la segunda multiplicación resta*x
                        rdy_mult_in2 <= '1';
                        mult_a2 <= std_logic_vector(signed(two) - signed(mult_res1));
                        mult_b2 <= x;
                                                                        
                        if (cont < cont_MAX) then
                            
                            STATE <= S_MULT1;
                            
                            cont <= cont + 1;
                            
                        else
                                                       
                            
                            STATE <= S_DIVIS;
                            
                        end if;
                        
                    end if;
                    
                when S_DIVIS =>
                
                    rdy_mult_in2 <= '0';
                
                    if (rdy_mult_out2 = '1') then
                    
                        -- Multiplicacion del dividendo y el inverso del divisor N*x
                        rdy_mult_in1 <= '1';
                        mult_a1 <= N;
                        mult_b1 <= x;
                        
                        STATE <= S_FINAL;
                        
                    end if;
                    
                when S_FINAL =>
                
                    rdy_mult_in1 <= '0';
                    
                    if (rdy_mult_out1 = '1') then
                    
                        result <= mult_res1;
                        rdy_div_out <= '1';
                    
                        STATE <= S_IDLE;
                        
                    end if;
                
            end case;
            
        end if;
        
    end process;
    
    division_o <= result;


end Behavioral;
