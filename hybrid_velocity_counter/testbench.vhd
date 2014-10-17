library IEEE;
use IEEE.std_logic_1164.All;

entity testbench is end testbench;

architecture tb_velocity of testbench is
    signal clk : std_logic := '0';
    signal encoder : std_logic := '0';
    signal speed : real;
    signal measurementType : std_logic;

    constant twenty_nsec : time := 20 ns;

    component HybridVelocityCounter port (
        clk : in std_logic;
        encoder : in std_logic;
        speed : out real;
        measurementType: out std_logic);
    end component HybridVelocityCounter;

begin
    HybridVelocityCounter1 : HybridVelocityCounter
    port map (
        clk => clk,
        encoder => encoder,
        speed => speed,
        measurementType => measurementType);

    create_twenty_Mhz: process
    begin
        wait for twenty_nsec;
        clk <= NOT clk;
    end process;

    encoder <= '1' after 300 ns,
               '0' after 500 ns,
               '1' after 700 ns,
               '0' after 900 ns,
               '1' after 1100 ns,
               '0' after 1300 ns,
               '1' after 1500 ns,
               '0' after 1700 ns,
               '1' after 1900 ns,
               '0' after 2100 ns,
               '1' after 2700 ns,
               '0' after 3300 ns,
               '1' after 3900 ns,
               '0' after 4500 ns;

end tb_velocity;
