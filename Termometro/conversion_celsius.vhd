----------------------------------------------------------------------------------
-- V3.0: Conversión de señal de 12 bits del XADC a 35-43ºC
-- Autor: Miguel Ángel García de Vicente
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity conversion_celsius is
    generic (
        N_bits          : integer := 16;
        N_decimales     : integer := 6
    );
    Port ( clk_i    :   in  std_logic;
           rst_i    :   in  std_logic;
           rdy_in   :   in  std_logic;
           n_in     :   in  std_logic_vector(11 downto 0);
           n_out    :   out std_logic_vector(N_bits-1 downto 0);
           rdy_out  :   out std_logic
    );
end conversion_celsius;

architecture Behavioral of conversion_celsius is


    signal n_xadc_adapt :   std_logic_vector(N_bits-1 downto 0);
    signal n_prop_cel   :   std_logic_vector(15 downto 0);


begin

    mult_celsius: entity work.multiplicador
    generic map( N_bits         => N_bits,
                 N_decimales    => N_decimales
    )
    port map ( clk_i    =>  clk_i,
               rst_i    =>  rst_i,
               rdy_in   =>  rdy_in,
               n1_in    =>  n_xadc_adapt,
               n2_in    =>  "0000000000000001",
               n_out    =>  n_prop_cel,
               rdy_out  =>  rdy_out
    );
    
    n_xadc_adapt <= '0' & n_in(11 downto 13+N_decimales-N_bits) & std_logic_vector(to_signed(0, N_decimales));
    n_out <= std_logic_vector(signed(n_prop_cel)+signed(std_logic_vector(to_signed(35, N_bits-N_decimales))&std_logic_vector(to_signed(0, N_decimales))));


end Behavioral;
