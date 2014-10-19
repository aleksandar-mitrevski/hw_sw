library IEEE;
use IEEE.std_logic_1164.All;
use std.textio.all;

entity testbench is end testbench;

architecture tb_velocity of testbench is
    signal clk : std_logic := '0';
    signal encoder : std_logic := '0';
    signal speed : real;
    signal measurementType : std_logic;

    file encoder_switching_times : text open read_mode is "switching_times.dat";

    constant twenty_five_nsec : time := 25 ns;

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
        wait for twenty_five_nsec;
        clk <= NOT clk;
    end process;

    change_encoder: process
        variable currentLine : line;
        variable waitTime : time;
        variable timeChange : integer := 0;
    begin
        while not (endfile(encoder_switching_times)) loop
            if timeChange = 1500 then
                assert measurementType = '0' report "1 failed";
            elsif timeChange = 3000 then
                assert measurementType = '0' report "2 failed";
            elsif timeChange = 4500 then
                assert measurementType = '1' report "3 failed";
            elsif timeChange = 6000 then
                assert measurementType = '1' report "4 failed";
            elsif timeChange = 7500 then
                assert measurementType = '1' report "5 failed";
            elsif timeChange = 9000 then
                assert measurementType = '1' report "6 failed";
            elsif timeChange = 10500 then
                assert measurementType = '0' report "7 failed";
            end if;

            readline(encoder_switching_times, currentLine);
            read(currentLine, waitTime);
            timeChange := timeChange + (waitTime / 1 ns);

            wait for waitTime;
            encoder <= not encoder;
        end loop;
        wait;
    end process;

end tb_velocity;
