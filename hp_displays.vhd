library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity displays is
    Port (  
        clk         : in std_logic;
        reset       : in std_logic;
        n_out : in  STD_LOGIC_VECTOR(15 downto 0);
        segments : out  STD_LOGIC_VECTOR(6 downto 0);
        digit_select : out  STD_LOGIC_VECTOR(3 downto 0)
    );
end displays;

architecture Behavioral of displays is
    signal number : integer;
    signal segments_temp : std_logic_vector(6 downto 0);
    signal digit_select_temp : std_logic_vector(3 downto 0);
    signal digit_counter : integer range 0 to 3 := 0;

begin
-- Multiplexor para seleccionar el dígito activo
digit_select: process(clk, reset)
    begin
        if reset = '1' then
            digit_counter <= 0;
        elsif rising_edge(clk) then
            if digit_counter = 3 then
                digit_counter <= 0;
            else
                digit_counter <= digit_counter + 1;
            end if;
        end if;

        case digit_counter is
            when 0 =>
                digit_select_temp <= "0001";
            when 1 =>
                digit_select_temp <= "0010";
            when 2 =>
                digit_select_temp <= "0100";
            when 3 =>
                digit_select_temp <= "1000";
            when others =>
                digit_select_temp <= "0000";
        end case;
    end process;

    digit_select <= digit_select_temp;

    signal decena  : integer range 0 to 9;
    signal unidad  : integer range 0 to 9;
    signal decima  : integer range 0 to 9;
    signal centesima : integer range 0 to 9;

    -- Conversión de n_out(15 downto 9) a decena y unidad
    -- Primero convertimos a entero
    signal parte_entera : integer range 0 to 100;
    signal parte_decimal : integer range 0 to 10;

begin
    parte_entera <= integer(n_out(15 downto 9));
    decena <= parte_entera / 10;
    unidad <= parte_entera mod 10;

    -- Conversión de n_out(8 downto 0) a decima y menos_significativa
    parte_decimal <= integer(n_out(8 downto 0));
    decima <= parte_decimal / 10;
    menos_significativa <= parte_decimal - (decima * 10);
    signal unidad  : integer range 0 to 9;
    signal decima  : integer range 0 to 9;
    signal menos_significativa : integer range 0 to 9;

    -- Conversión de n_out(15 downto 9) a decena y unidad
    decena  <= integer((n_out(15 downto 13));
    unidad  <= integer((n_out(12 downto 9));

    -- Conversión de n_out(8 downto 0) a decima y menos_significativa
    decima  <= integer((n_out(8 downto 5));
    menos_significativa <= integer((n_out(4 downto 0));

-- Decodificador de 7 segmentos
    process(clk, reset)
    begin
        if reset = '1' then
            segments_temp <= "0000000";
        elsif rising_edge(clk) then
            case digit_counter is
                when 0 =>
                    number <= integer((n_out(8 downto 0));
                when 1 =>
                    number <= integer((n_out(15 downto 9));
                when others =>
                    number <= 0;
            end case;

            case number is
                when 0 => segments_temp <= "0000001"; -- 0
                when 1 => segments_temp <= "1001111"; -- 1
                when 2 => segments_temp <= "0010010"; -- 2
                when 3 => segments_temp <= "0000110"; -- 3
                when 4 => segments_temp <= "1001100"; -- 4
                when 5 => segments_temp <= "0100100"; -- 5
                when 6 => segments_temp <= "0100000"; -- 6
                when 7 => segments_temp <= "0001111"; -- 7
                when 8 => segments_temp <= "0000000"; -- 8
                when 9 => segments_temp <= "0000100"; -- 9
                when others => segments_temp <= "1111111"; -- Error (todos apagados)
            end case;
        end if;
    end process;

    segments <= segments_temp;

end Behavioral;