-------------------------------------------------------------------------------
-- (Behavioral)
--
-- File name : gray_to_binary.vhdl
-- Purpose   : A Gray to binary converter
--           :
-- Author(s) : Antonio Macrì
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity gray_to_binary is
    generic(N : positive := 4);
    port(clk   : in  std_logic;
         reset : in  std_logic;         -- active low
         g     : in  std_logic_vector(N - 1 downto 0);
         b     : out std_logic_vector(N - 1 downto 0)
    );
end;

architecture BEHAVIOURAL of gray_to_binary is
begin
    process(clk, reset)
        -- We need to use a variable since the output b is obtained from the
        -- input g and the output itself, but b is not readable (since it is
        -- declared 'out')
        variable b_buf : std_logic_vector(N - 1 downto 0);
    begin
        -- If reset is active, force the output to all-zero
        if (reset = '0') then
            b <= (others => '0');

        elsif (rising_edge(clk)) then
            b_buf(N - 1) := g(N - 1);
            for i in N - 2 downto 0 loop
                b_buf(i) := b_buf(i + 1) xor g(i);
            end loop;
            b <= b_buf;
        end if;
    end process;
end;
