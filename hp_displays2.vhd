library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity displays is
    Port (
        n_out : in  STD_LOGIC_VECTOR(15 downto 0);
        segments : out  STD_LOGIC_VECTOR(6 downto 0);
        digit_select : out  STD_LOGIC_VECTOR(3 downto 0)
    );
end displays;

architecture Behavioral of displays is
    signal decimal_value : REAL;
    signal integer_part : INTEGER range 0 to 127;
    signal fractional_part : REAL range 0.0 to 0.999;
    signal decenas : INTEGER range 0 to 9;
    signal unidades : INTEGER range 0 to 9;
    signal decimas : INTEGER range 0 to 9;
    signal centesimas : INTEGER range 0 to 9;
    signal current_digit : INTEGER range 0 to 3 := 0;
begin
    process(n_out)
        variable temp_decimal : REAL;
    begin
        integer_part <= to_integer(unsigned(n_out(15 downto 9)));
        fractional_part <= real(integer(unsigned(n_out(8 downto 0)))) / 512.0;
        temp_decimal := real(integer_part) + fractional_part;

        decenas <= integer(temp_decimal / 10.0);
        unidades <= integer(temp_decimal mod 10.0);
        decimas <= integer((temp_decimal * 10.0) mod 10.0);
        centesimas <= integer((temp_decimal * 100.0) mod 10.0);
    end process;

    process(current_digit)
    begin
        case current_digit is
            when 0 => segments <= (case decenas is
                when 0 => "0111111", -- 0
                when 1 => "0000110", -- 1
                when 2 => "1011011", -- 2
                when 3 => "1001111", -- 3
                when 4 => "1100110", -- 4
                when 5 => "1101101", -- 5
                when 6 => "1111101", -- 6
                when 7 => "0000111", -- 7
                when 8 => "1111111", -- 8
                when 9 => "1101111", -- 9
                when others => "0000000"
            );
            when 1 => segments <= (case unidades is
                when 0 => "0111111", -- 0
                when 1 => "0000110", -- 1
                when 2 => "1011011", -- 2
                when 3 => "1001111", -- 3
                when 4 => "1100110", -- 4
                when 5 => "1101101", -- 5
                when 6 => "1111101", -- 6
                when 7 => "0000111", -- 7
                when 8 => "1111111", -- 8
                when 9 => "1101111", -- 9
                when others => "0000000"
            );
            when 2 => segments <= (case decimas is
                when 0 => "0111111", -- 0
                when 1 => "0000110", -- 1
                when 2 => "1011011", -- 2
                when 3 => "1001111", -- 3
                when 4 => "1100110", -- 4
                when 5 => "1101101", -- 5
                when 6 => "1111101", -- 6
                when 7 => "0000111", -- 7
                when 8 => "1111111", -- 8
                when 9 => "1101111", -- 9
                when others => "0000000"
            );
            when 3 => segments <= (case centesimas is
                when 0 => "0111111", -- 0
                when 1 => "0000110", -- 1
                when 2 => "1011011", -- 2
                when 3 => "1001111", -- 3
                when 4 => "1100110", -- 4
                when 5 => "1101101", -- 5
                when 6 => "1111101", -- 6
                when 7 => "0000111", -- 7
                when 8 => "1111111", -- 8
                when 9 => "1101111", -- 9
                when others => "0000000"
            );
            when others => segments <= "0000000";
        end case;
        digit_select <= std_logic_vector(unsigned(current_digit, 4));
    end process;
end Behavioral;


