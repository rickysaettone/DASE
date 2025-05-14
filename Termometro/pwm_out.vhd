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

    signal enable           : std_logic;
    constant div_MAX        : integer := 8191;-- Frecuencia de PWM de 15258 Hz
    signal div              : integer range 0 to div_MAX;
    signal pulse            : std_logic;
    signal comp_val_trun    : std_logic_vector(12 downto 0);
    
    signal pwm_signal       : std_logic;
    signal pwm_pulse        : std_logic;
    
begin
    
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
            comp_val_trun <= (others => '0');
        elsif  (clk'event and clk = '1') then
            if (enable = '1') then
                if (div < div_MAX) then
                    div <= div + 1;
                else
                    div <= 0;
                    comp_val_trun <= comp_val(15 downto 3);
                end if;
            end if;
        end if;
    end process;

    -- Comparador con señal
    pwm_pulse   <= '1' when (div = to_integer(unsigned(comp_val_trun)) and enable='1') else '0';
    -- Pulso de valor maximo
    pulse       <= '1' when (div = div_MAX and enable='1') else '0';


    process (clk,reset)
    begin
        if (reset = '1') then
            pwm_signal <= '0';
        elsif  (clk'event and clk = '1') then
            if (pwm_pulse = '1') then
                pwm_signal <= '0';
            elsif (pulse = '1') then
                pwm_signal <= '1';
            end if;
        end if;
    end process;
    
    -- Salida PWM
    pwm_out <= pwm_signal;

end Behavioral;
