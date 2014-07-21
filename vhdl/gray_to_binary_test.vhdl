-------------------------------------------------------------------------------
-- TestBench(gray_to_binary)
--
-- File name : gray_to_binary_test.vhdl
-- Purpose   : Generates stimuli for a Gray to binary converter
--           :
-- Author(s) : Antonio Macrì
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gray_to_binary_tb is
end gray_to_binary_tb;

architecture gray_to_binary_test of gray_to_binary_tb is
    component binary_to_gray
        generic(N : positive);
        port(clk   : in  std_logic;
             reset : in  std_logic;
             b     : in  std_logic_vector(N - 1 downto 0);
             g     : out std_logic_vector(N - 1 downto 0)
        );
    end component;
    component gray_to_binary
        generic(N : positive);
        port(clk   : in  std_logic;
             reset : in  std_logic;
             g     : in  std_logic_vector(N - 1 downto 0);
             b     : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    -- Input bits
    constant N           : integer := 4;
    -- Clock period
    constant ClockPeriod : time    := 100 ns;

    -- Clock
    signal clk : std_logic := '0';

    -- Input signals
    signal counter : integer                          := 0;
    signal binary  : std_logic_vector(N - 1 downto 0) := (others => '0');

    -- Output signals
    signal gray             : std_logic_vector(N - 1 downto 0);
    signal binary_delayed_1 : std_logic_vector(N - 1 downto 0);
    signal binary_delayed_2 : std_logic_vector(N - 1 downto 0);
    signal binary_output    : std_logic_vector(N - 1 downto 0);
    signal result           : std_logic;

begin
    B2G : binary_to_gray
        generic map(N)
        port map(clk, '1', binary, gray);
    G2B : gray_to_binary
        generic map(N)
        port map(clk, '1', gray, binary_output);

    -- Generate the clock
    clk <= not clk after ClockPeriod / 2;

    -- Wire the input signal of the converter to the binary value of counter
    binary <= std_logic_vector(to_unsigned(counter, binary'length));

    process(clk)
    begin
        if (rising_edge(clk)) then
            counter          <= counter + 1;
            binary_delayed_1 <= binary;
            binary_delayed_2 <= binary_delayed_1;
        end if;
    end process;

    process(binary_delayed_2, binary_output)
    begin
        -- If the original binary code (delayed) is equal to the reconstructed
        -- code, set result to 1
        if binary_delayed_2 = binary_output then
            -- It works!
            result <= '1';
        else
            -- Something wrong!
            result <= '0';
        end if;
    end process;

end gray_to_binary_test;
