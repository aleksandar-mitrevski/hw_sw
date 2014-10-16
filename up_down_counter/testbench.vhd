Library IEEE;
Use IEEE.std_logic_1164.All;
Use IEEE.std_logic_unsigned.All;

Entity testbench Is End testbench;

Architecture tb_upDownCounter Of testbench Is
    Signal clk : STD_LOGIC := '1';
    Signal inputSwitch : STD_LOGIC := '0';
    Signal led0 :  STD_LOGIC;
    Signal led1 :  STD_LOGIC;
    Signal led2 :  STD_LOGIC;
    Signal led3 :  STD_LOGIC;
    Signal counter : integer range 0 to 4;
    Signal clockCounter : integer range 0 to 50000000;

    Constant twenty_five_nsec : time := 25 ns;

    Component upDownCounter Port (
       clk: in STD_LOGIC;
       inputSwitch : in  STD_LOGIC;
       led0 : out  STD_LOGIC;
       led1 : out  STD_LOGIC;
       led2 : out  STD_LOGIC;
       led3 : out  STD_LOGIC;
       counter : inout integer range 0 to 4;
       clockCounter : inout integer range 0 to 5);
    End Component upDownCounter;

    Begin
    upDownCounter1 : upDownCounter
    Port Map (
        inputSwitch => inputSwitch,
        clk => clk,
        led0 => led0,
        led1 => led1,
        led2 => led2,
        led3 => led3,
        counter => counter,
        clockCounter => clockCounter);

    create_twenty_Mhz: Process
    Begin
        Wait For twenty_five_nsec;
        clk <= NOT clk;
    End Process;

    inputSwitch <= '1' After 500 ns,
                   '0' After 1500 ns;
End tb_upDownCounter;