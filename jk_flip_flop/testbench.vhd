library IEEE;
use IEEE.std_logic_1164.All;
use IEEE.std_logic_unsigned.All;

entity testbench is end testbench;

architecture tb_jkff of testbench is
    signal clk : std_logic := '0';
    signal j : std_logic;
    signal k : std_logic;
    signal q_out : std_logic;
    signal q_not_out : std_logic;

    constant twenty_five_nsec : time := 25 ns;

    component JKFlipFlop port (
        clk : in std_logic;
        j : in std_logic;
        k : in std_logic;
        q_out : inout std_logic;
        q_not_out : inout std_logic);
    end component JKFlipFlop;

    begin
    JKFlipFlop1 : JKFlipFlop
    port map (
        clk => clk,
        j => j,
        k => k,
        q_out => q_out,
        q_not_out => q_not_out);

    create_twenty_Mhz: process
    begin
        wait for twenty_five_nsec;
        clk <= NOT clk;
    end process;

    check_q: process
    begin
        wait for 50 ns;
        j <= '0';
        k <= '1';
        wait for 30 ns;
        assert q_out = '0' report "1 failed";
        wait for 20 ns;
        j <= '1';
        k <= '0';
        wait for 30 ns;
        assert q_out = '1' report "2 failed";
        wait for 20 ns;
        j <= '0';
        k <= '0';
        wait for 30 ns;
        assert q_out = '1' report "3 failed";
        wait for 20 ns;
        j <= '1';
        k <= '1';
        wait for 30 ns;
        assert q_out = '0' report "4 failed";
        wait for 20 ns;
        j <= '0';
        k <= '1';
        wait for 30 ns;
        assert q_out = '0' report "5 failed";
        wait for 20 ns;
        j <= '1';
        k <= '1';
        wait for 30 ns;
        assert q_out = '1' report "6 failed";
        wait for 20 ns;
        j <= '0';
        k <= '0';
        wait for 30 ns;
        assert q_out = '1' report "7 failed";
        wait for 20 ns;
        j <= '1';
        k <= '0';
        wait for 30 ns;
        assert q_out = '1' report "8 failed";
        wait for 20 ns;
        j <= '1';
        k <= '1';
        wait for 30 ns;
        assert q_out = '0' report "9 failed";
        wait for 20 ns;
        j <= '1';
        k <= '0';
        wait for 30 ns;
        assert q_out = '1' report "10 failed";
        wait for 20 ns;
        j <= '0';
        k <= '1';
        wait for 30 ns;
        assert q_out = '0' report "11 failed";
        wait for 20 ns;
        j <= '0';
        k <= '0';
        wait for 30 ns;
        assert q_out = '0' report "12 failed";
        wait;
    end process;

end tb_jkff;