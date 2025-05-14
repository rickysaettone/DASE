library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity displays is
    Port (
        clk_i       : in  std_logic;
        rst_i       : in  std_logic;
        value_i     : in  std_logic_vector(15 downto 0);  -- Número a mostrar
        an_o        : out std_logic_vector(3 downto 0);   -- Dígito activo
        seg_o       : out std_logic_vector(6 downto 0);   -- a-g
        dp_o        : out std_logic                       -- Punto decimal
    );
end displays;

architecture Behavioral of displays is

    signal refresh_counter : unsigned(15 downto 0) := (others => '0'); -- para multiplexado (~1kHz por display)
    signal digit_index     : unsigned(1 downto 0) := (others => '0');  -- índice del dígito activo
    signal digits          : std_logic_vector(3 downto 0);             -- valores decimales individuales

    signal bcd_digits      : std_logic_vector(15 downto 0); -- 4x4 bits BCD
    signal current_digit   : std_logic_vector(3 downto 0);  -- Dígito actual
    signal seg_temp        : std_logic_vector(6 downto 0);

begin

    -- Multiplexing: seleccionar cada dígito
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                refresh_counter <= (others => '0');
                digit_index <= (others => '0');
            else
                refresh_counter <= refresh_counter + 1;
                if refresh_counter = 0 then
                    digit_index <= digit_index + 1;
                end if;
            end if;
        end if;
    end process;

    -- Conversión binario a BCD (método simple para 16 bits)
    process(value_i)
        variable bin_val : unsigned(15 downto 0);
        variable temp    : integer;
        variable d0, d1, d2, d3 : integer;
    begin
        bin_val := unsigned(value_i);
        temp := to_integer(bin_val);
        d3 := temp / 1000;
        temp := temp mod 1000;
        d2 := temp / 100;
        temp := temp mod 100;
        d1 := temp / 10;
        d0 := temp mod 10;
        bcd_digits <= std_logic_vector(to_unsigned(d3,4) & to_unsigned(d2,4) & to_unsigned(d1,4) & to_unsigned(d0,4));
    end process;

    -- Selección del dígito a mostrar
    process(digit_index, bcd_digits)
    begin
        case digit_index is
            when "00" => current_digit <= bcd_digits(3 downto 0);
            when "01" => current_digit <= bcd_digits(7 downto 4);
            when "10" => current_digit <= bcd_digits(11 downto 8);
            when others => current_digit <= bcd_digits(15 downto 12);
        end case;
    end process;

    -- Decodificación a segmentos
    process(current_digit)
    begin
        case current_digit is
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
    end process;

    -- Salidas
    seg_o <= seg_temp;
    dp_o  <= '1';  -- Punto decimal apagado

    an_o <= "1111";
    an_o(to_integer(digit_index)) <= '0'; -- Activar solo uno

end Behavioral;
