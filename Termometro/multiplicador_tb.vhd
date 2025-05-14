----------------------------------------------------------------------------------
-- V1.0
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplicador_tb is
--  Port ( );
end multiplicador_tb;

architecture Behavioral of multiplicador_tb is

    constant CLK_PERIOD     :   time := 8 ns;
    signal clk, rst, start  :   std_logic;
    signal leds             :   std_logic_vector(11 downto 0);
    signal vaux1_n, vaux1_p :   std_logic;
    signal rdy_mult         :   std_logic;
    signal n1_mult, n2_mult :   std_logic_vector(7 downto 0);

begin

    dut : entity work.termometro_wrapper
    port map (
        Vaux1_v_n   =>  vaux1_n,
        Vaux1_v_p   =>  vaux1_p,
        clk         =>  clk,
        leds        =>  leds,
        rst         =>  rst,
        start       =>  start,
        rdy_tb      =>  rdy_mult,
        n1_tb       =>  n1_mult,
        n2_tb       =>  n2_mult
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
    
    mult_stimuli : process
    begin
        
        rdy_mult <= '0';
        n1_mult <= (others => '0');
        n2_mult <= (others => '0');
        wait for 5*CLK_PERIOD;
        
        rdy_mult <= '1';
        n1_mult <= "00000101";
        n2_mult <= "00000011";
        wait for 1*CLK_PERIOD;
        
        rdy_mult <= '0';
        wait for 5*CLK_PERIOD;
        
        rdy_mult <= '1';
        n1_mult <= "00000001";
        n2_mult <= "00000001";
        wait for 1*CLK_PERIOD;
        
        rdy_mult <= '0';
        wait for 5*CLK_PERIOD;
        
        rdy_mult <= '1';
        n1_mult <= "00000011";
        n2_mult <= "00000010";
        wait for 1*CLK_PERIOD;
        
        rdy_mult <= '0';
        n1_mult <= (others => '0');
        n2_mult <= (others => '0');
        --wait for 1*CLK_PERIOD;
        
        --rdy_mult <= '0';
        wait;
    end process;


end Behavioral;
