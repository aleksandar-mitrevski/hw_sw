library IEEE;
use IEEE.std_logic_1164.All;

entity explorer_testbench is end explorer_testbench;

architecture tb_explorer of explorer_testbench is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal level : std_logic := '0';
    signal tick : std_logic := '0';

    constant twenty_five_nsec : time := 25 ns;

    component Explorer port (
        clk : in std_logic;
        reset : in std_logic);
    end component Explorer;

    begin
    Explorer1 : Explorer
    port map (
        clk => clk,
        reset => reset);

    create_twenty_Mhz: process
    begin
        wait for twenty_five_nsec;
        clk <= NOT clk;
    end process;

end tb_explorer;