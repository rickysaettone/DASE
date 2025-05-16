----------------------------------------------------------------------------------
-- V1.0
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity divisor_tb is
--  Port ( );
end divisor_tb;

architecture Behavioral of divisor_tb is

    constant CLK_PERIOD                 :   time := 8 ns;
    signal clk, rst, start              :   std_logic;
    signal vaux1_n, vaux1_p             :   std_logic;
    signal rdy_in, rdy_out              :   std_logic;
    signal dividendo, divisor, division :   std_logic_vector(15 downto 0);

begin

    dut : entity work.divisor
    port map (
        clk          =>  clk,
        reset        =>  rst,
        dividendo_i  =>  dividendo,
        divisor_i    =>  divisor,
        division_o   =>  division,
        rdy_div_in   =>  rdy_in,
        rdy_div_out  =>  rdy_out
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
        wait for 5*CLK_PERIOD;
        
        rst <= '0';
        wait for 5*CLK_PERIOD;
        
        start <= '1';
        wait for CLK_PERIOD;
        
        start <= '0';
        wait;
    end process;
    
    mult_stimuli : process
    begin
        
        rdy_in    <= '0';
        dividendo <= (others => '0');
        divisor   <= (others => '0');
        wait for 5*CLK_PERIOD;
        
        rdy_in    <= '1';
        dividendo <= "0000100100000000"; -- 9
        divisor   <= "0000010100000000"; -- 5
        wait for 1*CLK_PERIOD;
        
        rdy_in <= '0';
        wait until rdy_out = '1';
        wait for 1*CLK_PERIOD;
        
        rdy_in    <= '1';
        dividendo <= "0000000100000000"; -- 1
        divisor   <= "0000001000000000"; -- 2
        wait for 1*CLK_PERIOD;
        
        rdy_in <= '0';
        wait until rdy_out = '1';
        wait for 1*CLK_PERIOD;
        --
        --rdy_in    <= '1';
        --dividendo <= "00000011";
        --divisor   <= "00000010";
        --wait for 1*CLK_PERIOD;
        --
        --rdy_in <= '0';
        --wait for 5*CLK_PERIOD;
        --
        --rdy_in    <= '1';
        --dividendo <= "00001010";
        --divisor   <= "00000110";
        --wait for 1*CLK_PERIOD;
        
        --rdy_in   <= '0';
        --dividendo <= (others => '0');
        --divisor   <= (others => '0');
        --wait for 1*CLK_PERIOD;
        
        --rdy_mult <= '1';
        --n1_mult <= std_logic_vector(shift_left(to_signed(5, n1_mult'length), 6));
        --n2_mult <= std_logic_vector(shift_left(to_signed(7, n1_mult'length), 6));
        --wait for 1*CLK_PERIOD;
        --
        --rdy_mult <= '0';
        --wait for 5*CLK_PERIOD;
        --
        --rdy_mult <= '1';
        --n1_mult <= "0000000101000000";
        --n2_mult <= "0000000011000000";
        --wait for 1*CLK_PERIOD;
        --
        --rdy_mult <= '0';
        --wait for 5*CLK_PERIOD;
        --
        --rdy_mult <= '1';
        --n1_mult <= "0000000001000000";
        --n2_mult <= "0000000001000000";
        --wait for 1*CLK_PERIOD;
        --
        --rdy_mult <= '0';
        --wait for 5*CLK_PERIOD;
        --
        --rdy_mult <= '1';    -- Para 35ºC
        --n1_mult <= "0000000000000000";
        --n2_mult <= "0000000000000001";
        --wait for 1*CLK_PERIOD;
        --
        --rdy_mult <= '0';
        --wait for 5*CLK_PERIOD;
        --
        --rdy_mult <= '1';    -- Para 39ºC
        --n1_mult <= "0100000000000000";
        --n2_mult <= "0000000000000001";
        --wait for 1*CLK_PERIOD;
        --
        --rdy_mult <= '0';
        --wait for 5*CLK_PERIOD;
        --
        --rdy_mult <= '1';    -- Para 43ºC
        --n1_mult <= "0111111111111111";
        --n2_mult <= "0000000000000001";
        --wait for 1*CLK_PERIOD;
        --
        --rdy_mult <= '0';
        ----n1_mult <= (others => '0');
        ----n2_mult <= (others => '0');

        wait;
    end process;


end Behavioral;
