----------------------------------------------------------------------------------
-- V1.0: Multiplicador que multipla 4 bits
-- Autor: Miguel Ángel García de Vicente
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplicador is
    generic (
        C_SAMPLE_FREQ   : integer := 125 --000000;
    );
    Port ( clk_i    :   in  std_logic;
           rst_i    :   in  std_logic;
           rdy_in   :   in  std_logic;
           --n_in     :   in  std_logic_vector(15 downto 0); -- 8 bits de parte entera y 8 de fraccionaria
           --n_out    :   out std_logic_vector(15 downto 0)  -- 8 bits de parte entera y 8 de fraccionaria
           n1_in    :   in  std_logic_vector(3 downto 0);
           n2_in    :   in  std_logic_vector(3 downto 0);
           n_out    :   out std_logic_vector(3 downto 0);
           rdy_out  :   out std_logic
    );

end multiplicador;

architecture Behavioral of multiplicador is

    type Status_g is (S_IDLE, S_MULT1);
    signal STATE        :   Status_g;

    signal n_A      :   std_logic_vector(8 downto 0);
    signal n_S      :   std_logic_vector(8 downto 0);
    signal n_P0     :   std_logic_vector(8 downto 0);
    signal n_P1     :   std_logic_vector(8 downto 0);
    signal n_P1d    :   std_logic_vector(8 downto 0);
    signal n_P2     :   std_logic_vector(8 downto 0);
    signal n_P2d    :   std_logic_vector(8 downto 0);
    signal n_P3     :   std_logic_vector(8 downto 0);
    signal n_P3d    :   std_logic_vector(8 downto 0);
    signal n_P4     :   std_logic_vector(8 downto 0);
    signal n_P4d    :   std_logic_vector(8 downto 0);

    --signal n_A      :   std_logic_vector(15 downto 0);
    --signal n_S      :   std_logic_vector(15 downto 0);
    --signal n_P0     :   std_logic_vector(15 downto 0);
    --signal n_P1     :   std_logic_vector(15 downto 0);
    --signal n_P2     :   std_logic_vector(15 downto 0);
    --signal n_P3     :   std_logic_vector(15 downto 0);
    --signal n_P4     :   std_logic_vector(15 downto 0);
    --signal n_P5     :   std_logic_vector(15 downto 0);
    --signal n_P6     :   std_logic_vector(15 downto 0);
    --signal n_P7     :   std_logic_vector(15 downto 0);
    --signal n_P8     :   std_logic_vector(15 downto 0);
    --signal n_P9     :   std_logic_vector(15 downto 0);

begin
    --FSM: process(clk_i, rst_i)
    --begin
    --
    --    if (rst_i = '1') then
    --
    --        STATE <= S_IDLE;
    --        --n_celsius <= "0";
    --
    --    elsif (rising_edge(clk_i)) then
    --
    --        case STATE is
    --
    --            when S_IDLE =>
    --
    --                if (rdy_in = '1') then
    --                    STATE <= S_MULT1;
    --                end if;
    --                
    --            when S_MULT1 =>
    --
    --                STATE <= S_IDLE;
    --
    --        end case;
    --    end if;
    --end process;
    
    activador: process(clk_i, rst_i)
    begin
    
        if (rst_i = '1') then
        
            rdy_out <= '0';
            n_out <= "0000";
            
        elsif (rising_edge(clk_i)) then
            
            if (STATE = S_IDLE) then
           
                if (rdy_in = '1') then
                    STATE <= S_MULT1;
                end if;
                
                rdy_out <= '0';
                
            elsif (STATE = S_MULT1) then
            
                n_out <= n_P4d(4 downto 1);
                rdy_out <= '1';
                STATE <= S_IDLE;
            
            end if;

        end if;
    end process;
    

    n_A  <= n1_in & "00000";
    n_S  <= std_logic_vector(signed(not(n1_in)) + 1) & "00000";
    n_P0 <= "0000" & n2_in & "0";
    n_P1 <= std_logic_vector(signed(n_P0) + signed(n_A)) when n_P0(1 downto 0) = "01" else
            std_logic_vector(signed(n_P0) + signed(n_S)) when n_P0(1 downto 0) = "10" else
            n_P0 when n_P0(1 downto 0) = "00" else
            n_P0 when n_P0(1 downto 0) = "11" else
            "000000000";
    n_P1d <= "0" & n_P1(8 downto 1) when n_P1(8) = '0' else
             "1" & n_P1(8 downto 1) when n_P1(8) = '1' else
             "000000000";
    n_P2 <= std_logic_vector(signed(n_P1d) + signed(n_A)) when n_P1d(1 downto 0) = "01" else
            std_logic_vector(signed(n_P1d) + signed(n_S)) when n_P1d(1 downto 0) = "10" else
            n_P1d when n_P1d(1 downto 0) = "00" else
            n_P1d when n_P1d(1 downto 0) = "11" else
            "000000000";
    n_P2d <= "0" & n_P2(8 downto 1) when n_P2(8) = '0' else
             "1" & n_P2(8 downto 1) when n_P2(8) = '1' else
             "000000000";
    n_P3 <= std_logic_vector(signed(n_P2d) + signed(n_A)) when n_P2d(1 downto 0) = "01" else
            std_logic_vector(signed(n_P2d) + signed(n_S)) when n_P2d(1 downto 0) = "10" else
            n_P2d when n_P2d(1 downto 0) = "00" else
            n_P2d when n_P2d(1 downto 0) = "11" else
            "000000000";
    n_P3d <= "0" & n_P3(8 downto 1) when n_P3(8) = '0' else
             "1" & n_P3(8 downto 1) when n_P3(8) = '1' else
             "000000000";
    n_P4 <= std_logic_vector(signed(n_P3d) + signed(n_A)) when n_P3d(1 downto 0) = "01" else
            std_logic_vector(signed(n_P3d) + signed(n_S)) when n_P3d(1 downto 0) = "10" else
            n_P3d when n_P3d(1 downto 0) = "00" else
            n_P3d when n_P3d(1 downto 0) = "11" else
            "000000000";
    n_P4d <= "0" & n_P4(8 downto 1) when n_P4(8) = '0' else
             "1" & n_P4(8 downto 1) when n_P4(8) = '1' else
             "000000000";


end Behavioral;