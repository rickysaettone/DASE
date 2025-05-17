library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity displays is
    generic (
        N_bits              : integer := 14;  -- Número de bits de n_out
        frec_pantalla       : integer := 125/4--*125*10**3; -- Frecuencia de pantalla
        frec_valor          : integer := 125/2--*125*10**6; -- Frecuencia de muestreo
    );
    Port ( clk_i    :   in  std_logic;
           rst_i    :   in  std_logic;
           n_out    :   in std_logic_vector(N_bits-1 downto 0);
           leds     :   out std_logic_vector(11 downto 0)     
    );   
end displays;



architecture Behavioral of displays is

    -- Divisor de frecuencia
    signal div_pantalla            : integer range 0 to frec_pantalla;
    signal div_valor               : integer range 0 to frec_valor;
    
    -- Selecciono el display activo
    signal digit_index     : unsigned(1 downto 0) := (others => '0');  -- Índice del dígito activo
    
    -- Conversión de n_out a enteros y decimales
    signal number          : std_logic_vector(3 downto 0) := (others => '0'); -- Número a mostrar
    signal dis_1       : std_logic_vector(3 downto 0) := (others => '0'); -- Centesimas
    signal dis_2       : std_logic_vector(3 downto 0) := (others => '0'); -- Decimas
    signal dis_3       : std_logic_vector(3 downto 0) := (others => '0'); -- Unidades
    signal dis_4       : std_logic_vector(3 downto 0) := (others => '0'); -- Decenas
    
    -- Cálculo de decenas
    signal n1_tb_decenas   : std_logic_vector(15 downto 0) := (others => '0'); -- Número 1 para multiplicador
    signal n2_tb_decenas   : std_logic_vector(15 downto 0) := (others => '0'); -- Número 2 para multiplicador
    signal rdy_tb_decenas  : std_logic := '0';                     -- Listo para multiplicar
    signal n_out_decenas   : std_logic_vector(15 downto 0) := (others => '0'); -- Salida del multiplicador
    signal rdy_out_decenas : std_logic := '0';                     -- Decenas listas


    -- Segmentos
    signal seg_temp        : std_logic_vector(6 downto 0) := (others => '0');      -- Salida a segmentos




begin


    mult_decenas: entity work.multiplicador
    generic map( N_bits         => 16,
                 N_decimales    => 15
    )
    port map ( clk_i    =>  clk_i,
               rst_i    =>  rst_i,
               rdy_in   =>  rdy_tb_decenas,
               n1_in    =>  n1_tb_decenas,
               n2_in    =>  n2_tb_decenas,
               n_out    =>  n_out_decenas,
               rdy_out  =>  rdy_out_decenas
    );


    -- DIVISOR DE FRECUENCIA PANTALLA Y VALOR
    process(clk,reset)
    begin
        if (reset = '1') then
            div_pantalla <= 0;
            div_valor <= 0;

            digit_index <= "00";
        elsif  (clk'event and clk = '1') then
            if (div_pantalla < frec_pantalla) then
                div_pantalla <= div_pantalla + 1;
                digit_index <= digit_index + 1;
            else
                div <= 0;
            end if;

            if (div_valor < frec_valor) then
                div_valor <= div_valor + 1;
            else
                div_valor <= 0;
            end if;
        end if;
    end process;

    rdy_tb_decenas <= '1' when (div_valor = frec_valor) else '0'; -- Listo para multiplicar
    n1_tb_decenas <= "00000000" & n_out(15 downto 8) when (div_valor = frec_valor) else (others => '0'); -- Número 1 para multiplicar
    n2_tb_decenas <= "0000110011001100" when (div_valor = frec_valor) else (others => '0'); -- Número 2 para multiplicar

    dis_4 <= signed(n_out_decenas) when (rdy_out_decenas = '1') else (others => '0'); -- Resultado Decenas

    -- Seleccionar el dígito activo
    case digit_index is
            when "00" => 
                leds(3 downto 0) <= "0001";
                number <= dis_1;
            when "01" => leds(3 downto 0) <= "0010";
            when "10" => leds(3 downto 0) <= "0100";
            when "11" => leds(3 downto 0) <= "1000";
            when others => leds(3 downto 0) <= "0000";
    end case;
    
 ---   -- Seleccionar el número a mostrar
 ---   case leds is
 ---       when "0001" => number <= dis4;  -- Decenas
 ---       when "0010" => number <= dis3;  -- Unidades
 ---       when "0100" => number <= dis2;  -- Decimas
 ---       when "1000" => number <= dis1;  -- Centesimas
 ---       when others => number <= "00";  -- Blanco
 ---   end case;

    -- Cálculo de decenas

 




    -- Decodificación a segmentos
    process(number)
    begin
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
    end process;

    leds(11 downto 5) <= seg_temp;


end Behavioral;
