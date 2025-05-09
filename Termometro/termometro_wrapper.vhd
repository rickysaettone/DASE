----------------------------------------------------------------------------------
-- V1.0
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity termometro_wrapper is
    Port (
        clk         :   in std_logic;
        rst         :   in std_logic;
        start       :   in std_logic;
        leds        :   out std_logic_vector (11 downto 0);
        Vaux1_v_n   :   in std_logic;
        Vaux1_v_p   :   in std_logic
    );
end termometro_wrapper;

architecture Behavioral of termometro_wrapper is
    
    constant zero : std_logic := '0';
    
    signal den, dwe, drdy   :   std_logic;
    signal di, do           :   std_logic_vector(15 downto 0);
    signal daddr            :   std_logic_vector(6 downto 0);

begin

    XADC_inst : entity work.xadc_wiz_0
    PORT MAP (
        di_in => di,
        daddr_in => daddr,
        den_in => den,
        dwe_in => dwe,
        drdy_out => drdy,
        do_out => do,
        dclk_in => clk,
        reset_in => rst,
        vp_in => zero,  --vp_in,
        vn_in => zero,  --vn_in,
        vauxp1 => Vaux1_v_p,
        vauxn1 => Vaux1_v_n,
        channel_out => open,
        eoc_out => open,
        alarm_out => open,
        eos_out => open,
        busy_out => open
    );

    Control : entity work.controller
    PORT MAP ( clk_i    =>  clk,
               rst_i    =>  rst,
               start_i  =>  start,
               leds_o   =>  leds,
               den_o    =>  den,
               daddr_o  =>  daddr,
               di_o     =>  di,
               do_i     =>  do,
               drdy_i   =>  drdy,
               dwe_o    =>  dwe
    );


end Behavioral;
