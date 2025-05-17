library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity displays is
    generic (
        N_bits              : integer := 14;  -- Número de bits de n_out
        frec_pantalla       : integer := 125/4--*125*10**3; -- Frecuencia de pantalla
        frec_valor          : integer := 125/2--*125*10**6; -- Frecuencia de muestreo
    );    
    Port (
        clk_i   : in std_logic;
        rst_i   : in std_logic;
        D_i     : in std_logic_vector(3 downto 0);  -- Decenas a mostrar
        U_i     : in std_logic_vector(3 downto 0);  -- Unidades a mostrar
        d_i     : in std_logic_vector(3 downto 0);  -- Décimas a mostrar
        c_i     : in std_logic_vector(3 downto 0);  -- Centésimas a mostrar
        leds    : out std_logic_vector(11 downto 0); -- LEDs
    );
end displays;

architecture Behavioral of displays is

    signal refresh_counter : unsigned(15 downto 0) := (others => '0'); -- para multiplexado (~1kHz por display)
    signal digit_index     : unsigned(1 downto 0) := "00";  -- índice del dígito activo

    signal current_digit   : std_logic_vector(3 downto 0) := (others => '0');  -- Dígito actual
    signal punto_decimal   : std_logic := "1";                                  -- Punto decimal apagado inicialmente
    signal seg_temp        : std_logic_vector(6 downto 0) := (others => '1');   -- Todos apagados 

begin

    -- Multiplexing: seleccionar cada dígito
    digito: process(clk_i,rst_i)
    begin
        if rst_i = '1' then
            refresh_counter <= (others => '0');
            digit_index <= (others => '0');
        elsif rising_edge(clk_i) then
            if refresh_counter = std_logic_vector(to_unsigned(frec_pantalla, 16)) then
                refresh_counter <= (others => '0');
                digit_index <= digit_index + 1;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    -- Selección del dígito a mostrar
    case digit_index is
        when "00" => 
            leds(3 downto 0) <= "0001";
            number <= D_i;
        when "01" => 
            leds(3 downto 0) <= "0010";
            number <= U_i;
        when "10" => 
            leds(3 downto 0) <= "0100";
            number <= d_i;
        when "11" => 
            leds(3 downto 0) <= "1000";
            number <= c_i;
        when others =>
            leds(3 downto 0) <= "0000";
            number <= D_i;
    end case;


    -- Decodificación a segmentos
    segmentos: process(clk_i,rst_i)
    begin
        if rst_i = '1' then
            seg_temp <= "1111111"; -- Todos apagados
            punto_decimal <= '1'; -- Punto decimal apagado
        elsif rising_edge(clk_i) then
            case number is
                when "0000" => seg_temp <= "0000001"; -- 0
                when "0001" => seg_temp <= "1001111"; -- 1
                when "0010" => seg_temp <= "0010010"; -- 2
                when "0011" => seg_temp <= "0000110"; -- 3
                when "0100" => seg_temp <= "1001100"; -- 4
                when "0101" => seg_temp <= "0100100"; -- 5
                when "0110" => seg_temp <= "0100000"; -- 6
                when "0111" => seg_temp <= "0001111"; -- 7
                when "1000" => seg_temp <= "0000000"; -- 8
                when "1001" => seg_temp <= "0000100"; -- 9
                when others => seg_temp <= "1111111"; -- Blanco
            end case;
        end if;
    end process;

    leds (11 downto 5) <= seg_temp when refresh_counter = std_logic_vector(to_unsigned(frec_pantalla, 16)) else (others => '0'); -- Resultado Decenas
    punto_decimal <= '1' when refresh_counter = std_logic_vector(to_unsigned(frec_pantalla, 16)) else '0'; -- Punto decimal
    leds(4) <= punto_decimal; -- Punto decimal
    
end Behavioral;
