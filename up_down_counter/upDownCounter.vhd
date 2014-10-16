------------------------------------------------------
-- A simple up/down counter in the [0,4] range
-- whose direction is controlled by an input switch;
-- the value of the counter is displayed by four LEDs
--
-- Author: Aleksandar Mitrevski
------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity upDownCounter is
    Port (clk: in STD_LOGIC;
          inputSwitch : in  STD_LOGIC;
          led0 : out  STD_LOGIC;
          led1 : out  STD_LOGIC;
          led2 : out  STD_LOGIC;
          led3 : out  STD_LOGIC;
          counter : inout integer range 0 to 4;
          clockCounter : inout integer range 0 to 50000000);
end upDownCounter;

architecture Behavioral of upDownCounter is

Signal ledArrayValues : std_logic_vector(0 to 3);

begin
    counterUpdate: Process(clk, clockCounter, counter, ledArrayValues)
    begin
      if (rising_edge(clk)) then
        if clockCounter = 50000000 then
          clockCounter <= 0;
            if inputSwitch = '1' then
              if counter = 0 then
                counter <= 4;
                ledArrayValues <= "1111";
              else
                if counter = 1 then
                  ledArrayValues <= "0000";
                elsif counter = 2 then
                  ledArrayValues <= "1000";
                elsif counter = 3 then
                  ledArrayValues <= "1100";
                else
                  ledArrayValues <= "1110";
                end if;

                counter <= counter - 1;
              end if;
            else
              if counter = 4 then
                counter <= 0;
                ledArrayValues <= "0000";
              else
                if counter = 0 then
                  ledArrayValues <= "1000";
                elsif counter = 1 then
                  ledArrayValues <= "1100";
                elsif counter = 2 then
                  ledArrayValues <= "1110";
                else
                  ledArrayValues <= "1111";
              end if;

              counter <= counter + 1;
            end if;
          end if;
        else
          clockCounter <= clockCounter + 1;
        end if;
      end if;
    end Process;

    led0 <= ledArrayValues(0);
    led1 <= ledArrayValues(1);
    led2 <= ledArrayValues(2);
    led3 <= ledArrayValues(3);

end Behavioral;