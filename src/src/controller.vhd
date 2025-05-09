----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- 
-- Create Date: 03/13/2025 02:52:49 PM
-- Design Name:
-- Module Name: xadc_controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    generic (
        C_SAMPLE_FREQ   : integer := 125;--000000;
        C_CHANNEL_ADDR  : std_logic_vector(6 downto 0) := "0010001"
    );
    Port ( clk_i    : in STD_LOGIC;
           rst_i    : in STD_LOGIC;

           -- User ports
           start_i  : in std_logic;
           leds_o   : out std_logic_vector(11 downto 0);
           -- User ports end

           -- DRP interface
           den_o    : out STD_LOGIC;
           daddr_o  : out STD_LOGIC_VECTOR (6 downto 0);
           di_o     : out STD_LOGIC_VECTOR (15 downto 0);
           do_i     : in STD_LOGIC_VECTOR (15 downto 0);
           drdy_i   : in STD_LOGIC;
           dwe_o    : out STD_LOGIC);
end controller;

architecture Behavioral of controller is

    type Status_g is (S_IDLE, S_ACQ, S_WAIT);
    signal STATE        :   Status_g;

    signal cont         :   integer range 0 to C_SAMPLE_FREQ;

begin
    FSM: process(clk_i, rst_i)
    begin

        if (rst_i = '1') then

            STATE <= S_IDLE;
            cont <= 0;

        elsif (rising_edge(clk_i)) then

            case STATE is

                when S_IDLE =>

                    if (start_i = '1') then
                        STATE <= S_ACQ;
                    end if;

                when S_ACQ =>

                    STATE <= S_WAIT;

                when S_WAIT =>

                    if (cont < C_SAMPLE_FREQ) then
                        cont <= cont + 1;
                    else
                        cont <= 0;
                        STATE <= S_ACQ;
                    end if;

            end case;
        end if;
    end process;

    daddr_o <= C_CHANNEL_ADDR;
    den_o <= '1' when STATE = S_ACQ else '0';

end Behavioral;