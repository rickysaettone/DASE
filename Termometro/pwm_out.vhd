----------------------------------------------------------------------------------
-- V1.0
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_out is
    Port (  clk         : in std_logic;
            reset       : in std_logic;
            start       : in std_logic;
            pwm_out     : out std_logic;
            comp_val    : in std_logic_vector(15 downto 0)
          ); 
end pwm_out;

architecture Behavioral of pwm_out is

    signal enable       : std_logic;
    constant div_MAX    : integer := (125*10**6/14)-1;
    signal div          : integer range 0 to div_MAX;
    signal pulse        : std_logic;
    signal pwm_signal   : std_logic;
    
begin

-- Salida PWM
    pwm_out <= pwm_signal;
    
----------------- CONTROL -----------------

 control: process(clk,reset)
          begin
              if reset = '1' then
                  enable <= '0';
              elsif (clk'event and clk = '1') then
                  if start = '1' then
                      enable <= '1';
                  end if;
              end if;
              
          end process;

----------------- DIVISOR DE FRECUENCIA -----------------

    process(clk,reset)
    begin
        if (reset = '1') then
            div <= 0;
        elsif  (clk'event and clk = '1') then
            if (enable = '1') then
                if (div < div_MAX) then
                    div <= div + 1;
                else
                    div <= 0;
                end if;
            end if;
        end if;
    end process;

    --pulse <= '1' when (div = comp_val and enable='1') else '0'; -- comparador

----------------- REGISTRO DE SEÑAL PWM -----------------

    process (clk,reset)
    begin
        if (reset = '1') then
            pwm_signal <= '0';
        elsif  (clk'event and clk = '1') then
            if (pulse = '1') then
                pwm_signal <= not pwm_signal;
            end if;
        end if;
    end process;

end Behavioral;
