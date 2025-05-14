----------------------------------------------------------------------------------
-- V1.0: Multiplicador que multipla 4 bits
-- Autor: Miguel Ángel García de Vicente
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplicador is
    generic (
        C_SAMPLE_FREQ   : integer := 125; --000000;
        N_bits          : integer := 4
    );
    Port ( clk_i    :   in  std_logic;
           rst_i    :   in  std_logic;
           rdy_in   :   in  std_logic;
           --n_in     :   in  std_logic_vector(15 downto 0); -- 8 bits de parte entera y 8 de fraccionaria
           --n_out    :   out std_logic_vector(15 downto 0)  -- 8 bits de parte entera y 8 de fraccionaria
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
    type array_P_desp is array (0 to (N_bits-1)) of std_logic_vector(N_bits*2 downto 0);
    signal n_A      :   std_logic_vector(N_bits*2 downto 0);
    signal n_S      :   std_logic_vector(N_bits*2 downto 0);
    signal n_P      :   array_P;
    signal n_P_desp :   array_P_desp;
    
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
            
                --n_out <= n_P4d(4 downto 1);
                n_out <= n_P_desp(N_bits-1)(N_bits downto 1);
                rdy_out <= '1';
                STATE <= S_IDLE;
            
            end if;

        end if;
    end process;
    

    --n_A  <= n1_in & "00000";
    --n_S  <= std_logic_vector(signed(not(n1_in)) + 1) & "00000";
    --n_P(0) <= "0000" & n2_in & "0";
    n_A  <= n1_in & zeros_N_bits & "0";
    n_S  <= std_logic_vector(signed(not(n1_in)) + 1) & zeros_N_bits & "0";
    n_P(0) <= zeros_N_bits & n2_in & "0";
    
    n_P(1) <= std_logic_vector(signed(n_P(0)) + signed(n_A)) when n_P(0)(1 downto 0) = "01" else
              std_logic_vector(signed(n_P(0)) + signed(n_S)) when n_P(0)(1 downto 0) = "10" else
              n_P(0) when n_P(0)(1 downto 0) = "00" else
              n_P(0) when n_P(0)(1 downto 0) = "11" else
              (others => '0');
    n_P_desp(0) <= "0" & n_P(1)(N_bits*2 downto 1) when n_P(1)(N_bits*2) = '0' else
                   "1" & n_P(1)(N_bits*2 downto 1) when n_P(1)(N_bits*2) = '1' else
                   (others => '0');
                   
    iteraciones_mult: for i in 2 to N_bits generate

        n_P(i) <= std_logic_vector(signed(n_P_desp(i-2)) + signed(n_A)) when n_P_desp(i-2)(1 downto 0) = "01" else
                  std_logic_vector(signed(n_P_desp(i-2)) + signed(n_S)) when n_P_desp(i-2)(1 downto 0) = "10" else
                  n_P_desp(i-2) when n_P_desp(i-2)(1 downto 0) = "00" else
                  n_P_desp(i-2) when n_P_desp(i-2)(1 downto 0) = "11" else
                  (others => '0');
        n_P_desp(i-1) <= "0" & n_P(i)(N_bits*2 downto 1) when n_P(i)(N_bits*2) = '0' else
                         "1" & n_P(i)(N_bits*2 downto 1) when n_P(i)(N_bits*2) = '1' else
                         (others => '0');
    
    end generate iteraciones_mult;
    
    -- Revisar si me puedo desacer de n_P_desp metiendo la operacion en otro sitio
    -- igual ver si ya existe el operador
    
    -- meter n_P(1) en el for


end Behavioral;