----------------------------------------------------------------------------------
-- V1.0
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplicador is
    generic (
        C_SAMPLE_FREQ   : integer := 125 --000000;
    );
    Port ( clk_i    :   in std_logic;
           rst_i    :   in std_logic;
           rdy_in  :   in std_logic;
           n_in     :   std_logic_vector(15 downto 0);
           n_out    :   std_logic_vector(15 downto 0)
    );

end multiplicador;

architecture Behavioral of multiplicador is

    type Status_g is (S_IDLE, S_MULT1);
    signal STATE        :   Status_g;

    signal n_celsius    :   std_logic_vector(15 downto 0);

begin
    FSM: process(clk_i, rst_i)
    begin

        if (rst_i = '1') then

            STATE <= S_IDLE;
            n_celsius <= "0";

        elsif (rising_edge(clk_i)) then

            case STATE is

                when S_IDLE =>

                    if (rdy_in = '1') then
                        STATE <= S_MULT1;
                    end if;
                    
                when S_MULT1 =>

                    STATE <= S_IDLE;

            end case;
        end if;
    end process;


    --n_out <= n_celsius;


end Behavioral;