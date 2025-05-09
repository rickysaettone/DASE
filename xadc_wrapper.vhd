----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2025 17:23:20
-- Design Name: 
-- Module Name: xadc_wrapper - Behavioral
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

entity xadc_wrapper is
    Port (
        clk         :   in std_logic;
        rst         :   in std_logic;
        start       :   in std_logic;
        led         :   out std_logic_vector (11 downto 0);
        Vauxl_v_n   :   in std_logic;
        Vaux1_v_p   :   in std_logic
    );
end xadc_wrapper;

architecture Behavioral of xadc_wrapper is

--    component xadc_wiz_0 is
--    Port(   di_in       :   in std_logic;
--            daddr_in    :   in std_logic;
--            den_in      :   in std_logic;
--            dwe_in      :   in std_logic;
--            drdy_out    :   out std_logic;
--            do_out      :   out std_logic;
--            dclk_in     :   in std_logic;
--            reset_in    :   in std_logic;
--            vp_in       :   in std_logic;
--            vn_in       :   in std_logic;
--            vauxp1      :   in std_logic;
--            vauxn1      :   in std_logic;
--            channel_out :   out std_logic;
--            eoc_out     :   out std_logic;
--            alarm_out   :   out std_logic;
--            eos_out     :   out std_logic;
--            busy_out    :   out std_logic);
--    end component;
    
    component controller is
    Port ( clk_i    : in STD_LOGIC;
           rst_i    : in STD_LOGIC;
           start_i  : in std_logic;
           leds_o   : out std_logic_vector(11 downto 0);
           den_o    : out STD_LOGIC;
           daddr_o  : out STD_LOGIC_VECTOR (6 downto 0);
           di_o     : out STD_LOGIC_VECTOR (15 downto 0);
           do_i     : in STD_LOGIC_VECTOR (15 downto 0);
           drdy_i   : in STD_LOGIC;
           dwe_o    : out STD_LOGIC);
    end component;
    
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
        vauxp1 => Vaux1_v_p, -- No funciona porque vauxp1 y vauxn1 no están definidos en el componente original, los escribió el profesor por la cara
        vauxn1 => Vaux1_v_n,
        channel_out => open,
        eoc_out => open,
        alarm_out => open,
        eos_out => open,
        busy_out => open
      );
  
    Control : controller
        port map ( clk_i    =>  clk,
                   rst_i    =>  rst,
                   start_i  =>  start,
                   leds_o   =>  led,
                   den_o    =>  den,
                   daddr_o  =>  daddr,
                   di_o     =>  di,
                   do_i     =>  do,
                   drdy_i   =>  drdy,
                   dwe_o    =>  dwe
                   );


end Behavioral;
