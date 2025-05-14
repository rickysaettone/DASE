----------------------------------------------------------------------------------
-- V3.0: Multiplicador Booth genérico para señales de N_bits
-- Autor: Miguel Ángel García de Vicente
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplicador is
    generic (
        N_bits          : integer := 16;
        N_decimales     : integer := 9
    );
    Port ( clk_i    :   in  std_logic;
           rst_i    :   in  std_logic;
           rdy_in   :   in  std_logic;
           n1_in    :   in  std_logic_vector(N_bits-1 downto 0);
           n2_in    :   in  std_logic_vector(N_bits-1 downto 0);
           n_out    :   out std_logic_vector(N_bits-1 downto 0);
           rdy_out  :   out std_logic
    );

end multiplicador;

architecture Behavioral of multiplicador is

    type Status_g is (S_IDLE, S_MULT);
    signal STATE        :   Status_g;
    
    type array_P is array (0 to N_bits) of std_logic_vector(N_bits*2 downto 0);
    --type array_P_oper is array (0 to (N_bits-1)) of std_logic_vector(N_bits*2 downto 0);
    signal n_A      :   std_logic_vector(N_bits*2 downto 0);
    signal n_S      :   std_logic_vector(N_bits*2 downto 0);
    signal n_P      :   array_P;
    --signal n_P_oper :   array_P_oper;
    signal n_mult   :   std_logic_vector(N_bits*2 downto 0);
    
    constant zeros_N_bits : std_logic_vector(N_bits-1 downto 0) := (others => '0');
    

begin
    
    activador: process(clk_i, rst_i)
    begin
    
        if (rst_i = '1') then
        
            STATE <= S_IDLE;
            rdy_out <= '0';
            n_out <= (others => '0');
            
        elsif (rising_edge(clk_i)) then
            
            if (STATE = S_IDLE) then
           
                if (rdy_in = '1') then
                    STATE <= S_MULT;
                end if;
                
                rdy_out <= '0';
                
            elsif (STATE = S_MULT) then
            
                n_out <= n_mult(N_bits downto 1);
                --n_out <= (std_logic_vector(shift_right(signed(n_P(N_bits)), N_decimales)))(N_bits downto 1);
                --n_out <= std_logic_vector(shift_right(signed(n_P(N_bits)(N_bits downto 1)), N_decimales));
                --n_out <= n_P(N_bits)(N_bits downto 1);
                rdy_out <= '1';
                STATE <= S_IDLE;
            
            end if;

        end if;
    end process;
    

    n_A  <= n1_in & zeros_N_bits & "0";
    n_S  <= std_logic_vector(signed(not(n1_in)) + 1) & zeros_N_bits & "0";
    n_P(0) <= zeros_N_bits & n2_in & "0";

    --iteraciones_mult: for i in 0 to N_bits-1 generate

        --n_P_oper(i) <= std_logic_vector(signed(n_P(i)) + signed(n_A)) when n_P(i)(1 downto 0) = "01" else
        --               std_logic_vector(signed(n_P(i)) + signed(n_S)) when n_P(i)(1 downto 0) = "10" else
        --               n_P(i) when n_P(i)(1 downto 0) = "00" else
        --               n_P(i) when n_P(i)(1 downto 0) = "11" else
        --               (others => '0');
        --n_P(i+1) <= "0" & n_P_oper(i)(N_bits*2 downto 1) when n_P_oper(i)(N_bits*2) = '0' else
        --            "1" & n_P_oper(i)(N_bits*2 downto 1) when n_P_oper(i)(N_bits*2) = '1' else
        --            (others => '0');
    
    --iteraciones_mult: for i in 1 to N_bits generate
    --
    --    n_P(i) <= std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_A), 1)) when n_P(i-1)(1 downto 0) = "01" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_S), 1)) when n_P(i-1)(1 downto 0) = "10" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "00" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "11" else
    --              (others => '0');
    --
    --end generate iteraciones_mult;
    
    
    
    --iteraciones_mult_parte_decimal: for i in 1 to N_decimales generate
    --
    --    n_P(i) <= std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_A), 2)) when n_P(i-1)(1 downto 0) = "01" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_S), 2)) when n_P(i-1)(1 downto 0) = "10" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 2)) when n_P(i-1)(1 downto 0) = "00" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 2)) when n_P(i-1)(1 downto 0) = "11" else
    --              (others => '0');
    --
    --end generate iteraciones_mult_parte_decimal;
    --
    --iteraciones_mult: for i in N_decimales+1 to N_bits generate
    --
    --    n_P(i) <= std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_A), 1)) when n_P(i-1)(1 downto 0) = "01" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_S), 1)) when n_P(i-1)(1 downto 0) = "10" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "00" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "11" else
    --              (others => '0');
    --
    --end generate iteraciones_mult;
    
    
    
    --iteraciones_mult_parte_decimal: for i in 1 to N_bits-N_decimales generate
    --
    --    n_P(i) <= std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_A), 2)) when n_P(i-1)(1 downto 0) = "01" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_S), 2)) when n_P(i-1)(1 downto 0) = "10" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 2)) when n_P(i-1)(1 downto 0) = "00" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 2)) when n_P(i-1)(1 downto 0) = "11" else
    --              (others => '0');
    --
    --end generate iteraciones_mult_parte_decimal;
    --
    --iteraciones_mult: for i in N_bits-N_decimales+1 to N_bits generate
    --
    --    n_P(i) <= std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_A), 1)) when n_P(i-1)(1 downto 0) = "01" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_S), 1)) when n_P(i-1)(1 downto 0) = "10" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "00" else
    --              std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "11" else
    --              (others => '0');
    --
    --end generate iteraciones_mult;



    iteraciones_mult: for i in 1 to N_bits generate
    
        n_P(i) <= std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_A), 1)) when n_P(i-1)(1 downto 0) = "01" else
                  std_logic_vector(shift_right(signed(n_P(i-1)) + signed(n_S), 1)) when n_P(i-1)(1 downto 0) = "10" else
                  std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "00" else
                  std_logic_vector(shift_right(signed(n_P(i-1)), 1)) when n_P(i-1)(1 downto 0) = "11" else
                  (others => '0');
    
    end generate iteraciones_mult;
    
    n_mult <= std_logic_vector(shift_right(signed(n_P(N_bits)), N_decimales));
    


end Behavioral;