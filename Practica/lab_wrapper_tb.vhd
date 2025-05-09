----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2025 06:04:53 PM
-- Design Name: 
-- Module Name: lab_wrapper_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xadc_wrapper_tb is
--  Port ( );
end xadc_wrapper_tb;

architecture Behavioral of xadc_wrapper_tb is

    constant CLK_PERIOD : time := 8 ns;
    signal clk, rst, start : std_logic;
    signal leds : std_logic_vector(11 downto 0);
    signal vaux1_n, vaux1_p : std_logic;

begin

    dut : entity work.xadc_wrapper
    port map (
        Vaux1_v_n   => vaux1_n,
        Vaux1_v_p   => vaux1_p,
        clk         => clk,
        leds        => leds,
        rst         => rst,
        start       => start
    );

    clk_stimuli : process
    begin
        clk <= '1';
        wait for CLK_PERIOD/2;
        clk <= '0';
        wait for CLK_PERIOD/2;
    end process;
    
    dut_stimuli : process
    begin
        rst <= '1';
        start <= '0';
        vaux1_p <= '0';
        vaux1_n <= '0';
        wait for 5*CLK_PERIOD;
        
        rst <= '0';
        wait for 5*CLK_PERIOD;
        
        start <= '1';
        wait for CLK_PERIOD;
        
        start <= '0';
        wait;
    end process;

    

end Behavioral;
