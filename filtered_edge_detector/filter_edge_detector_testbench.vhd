library IEEE;
use IEEE.std_logic_1164.All;

entity filtered_edge_detector_testbench is end filtered_edge_detector_testbench;

architecture tb_filtered_edge_detector of filtered_edge_detector_testbench is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal level : std_logic := '0';
    signal levelFiltered : std_logic := '0';
    signal tick : std_logic;

    constant twenty_five_nsec : time := 25 ns;

    component FilteredEdgeDetector port (
        clk : in std_logic;
        reset : in std_logic;
        level : in std_logic;
        levelFiltered : inout std_logic;
        tick : out std_logic);
    end component FilteredEdgeDetector;

    begin
    FilteredEdgeDetector1 : FilteredEdgeDetector
    port map (
        clk => clk,
        reset => reset,
        level => level,
        levelFiltered => levelFiltered,
        tick => tick);

    create_twenty_Mhz: process
    begin
        wait for twenty_five_nsec;
        clk <= NOT clk;
    end process;

    level <= '1' after 20 ns,
             '0' after 40 ns,
             '1' after 100 ns,
             '0' after 210 ns,
             '1' after 225 ns,
             '0' after 300 ns,
             '1' after 500 ns,
             '0' after 520 ns,
             '1' after 540 ns,
             '0' after 700 ns,
             '1' after 730 ns,
             '0' after 740 ns,
             '1' after 900 ns,
             '0' after 1100 ns,
             '1' after 1300 ns,
             '0' after 1340 ns,
             '1' after 1350 ns,
             '0' after 1500 ns;

end tb_filtered_edge_detector;