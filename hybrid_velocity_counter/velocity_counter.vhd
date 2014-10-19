library IEEE;
use IEEE.std_logic_1164.All;

entity HybridVelocityCounter is port (
    clk : in std_logic;
    encoder : in std_logic;
    speed : out real;
    measurementType: out std_logic);
end HybridVelocityCounter;

architecture velocity of HybridVelocityCounter is
    type measurementTypes is (HighSpeed, LowSpeed);
    constant clockFrequency : integer := 25; -- frequency in nanoseconds
    constant samplingPeriod: integer := 1500; -- sampling period in nanoseconds
    constant minimumHighSpeedCounter : integer := 5;
    constant maximumLowSpeed : real := 0.005;

    signal currentMeasurementType : measurementTypes := HighSpeed;

begin
    speedMeasurement: process(clk)
        variable pulseCounter : integer := 0;
        variable timeChange : integer := 0;
        variable counted : std_logic := '0';
        variable timeReal : real;
        variable currentSpeed : real;
        variable measuringTime : std_logic;
    begin
        if rising_edge(clk) then
            if currentMeasurementType = HighSpeed then
                if encoder = '1' then
                    if counted = '0' then
                        pulseCounter := pulseCounter + 1;
                        counted := '1';
                    end if;
                elsif counted = '1' then
                    counted := '0';
                end if;

                timeChange := timeChange + 2 * clockFrequency;
                if timeChange >= samplingPeriod then
                    --we switch to a low-velocity mode if the pulse counter
                    --is below a predefined threshold
                    if pulseCounter < minimumHighSpeedCounter then
                        currentMeasurementType <= LowSpeed;
                        measurementType <= '1';
                    else
                        measurementType <= '0';
                    end if;

                    timeReal := real(samplingPeriod);
                    speed <= real(pulseCounter) / timeReal;

                    -- we reset the variables to allow for new measurements
                    pulseCounter := 0;
                    timeChange := 0;
                    counted := '0';
                end if;
            else
                if encoder = '1' then
                    if measuringTime = '1' then
                        timeChange := timeChange + 2 * clockFrequency;
                        if counted = '0' then
                            timeReal := real(timeChange);
                            currentSpeed := 1.0 / timeReal;

                            if currentSpeed > maximumLowSpeed then
                                currentMeasurementType <= HighSpeed;
                                measurementType <= '0';
                            else
                                measurementType <= '1';
                            end if;

                            speed <= currentSpeed;

                            -- we reset the variables to allow for new measurements
                            timeChange := 0;
                            counted := '0';
                            measuringTime := '0';
                        end if;
                    else
                        counted := '1';
                        measuringTime := '1';
                    end if;
                else
                    if measuringTime = '1' then
                        timeChange := timeChange + 2 * clockFrequency;
                    end if;
                    if counted = '1' then
                        counted := '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
end velocity;
