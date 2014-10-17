library IEEE;
use IEEE.std_logic_1164.All;

entity testbench is end testbench;

architecture tb_velocity of testbench is
    signal encoder : std_logic := '0';
    signal speed : real;
    signal measurementType : std_logic;

    constant twenty_five_nsec : time := 25 ns;

    component HybridVelocityCounter port (
        encoder : in std_logic;
        speed : out real;
        measurementType: out std_logic);
    end component HybridVelocityCounter;

begin
    HybridVelocityCounter1 : HybridVelocityCounter
    port map (
        encoder => encoder,
        speed => speed,
        measurementType => measurementType);

end tb_velocity;
