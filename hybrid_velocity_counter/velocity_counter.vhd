library IEEE;
use IEEE.std_logic_1164.All;

entity HybridVelocityCounter is port (
    encoder : in std_logic;
    speed : out real;
    measurementType: out std_logic);
end HybridVelocityCounter;

architecture velocity of HybridVelocityCounter is
    type measurementTypes is (HighSpeed, LowSpeed);
    constant samplingPeriod: time := 100 ns; --sampling period in nanoseconds
    constant minimumHighSpeedCounter : integer := 5;
    constant maximumLowSpeed : real := 0.05;

    signal currentMeasurementType : measurementTypes := HighSpeed;

begin
    speedMeasurement: process
        variable pulseCounter : integer := 0;
        variable startTime : time := 0 ns;
        variable timeChange : time := 0 ns;
        variable counted : std_logic;
        variable timeReal : real;
        variable currentSpeed : real;
    begin
        if currentMeasurementType = HighSpeed then
            startTime := now;
            timeChange := 0 ns;
            counted := '0';

            while timeChange < samplingPeriod loop
                if encoder = '1' then
                    if counted = '0' then
                        pulseCounter := pulseCounter + 1;
                        counted := '1';
                    end if;
                elsif counted = '1' then
                    counted := '0';
                end if;
                timeChange := now - startTime;
            end loop;

            --we switch to a low-velocity mode if the pulse counter
            --is below a predefined threshold
            if pulseCounter < minimumHighSpeedCounter then
                currentMeasurementType <= LowSpeed;
            end if;

            timeReal := real(samplingPeriod / 1 ns);
            speed <= real(pulseCounter) / timeReal;
            measurementType <= '0';

            --we reset the pulse counter
            pulseCounter := 0;
        else
            if encoder = '1' then
                wait until encoder = '0';
            end if;

            wait until encoder = '1';
            startTime := now;
            wait until encoder = '0';
            wait until encoder = '1';
            timeChange := now - startTime;

            timeReal := real(timeChange / 1 ns);
            currentSpeed := 1.0 / timeReal;

            if currentSpeed > maximumLowSpeed then
                currentMeasurementType <= HighSpeed;
            end if;

            speed <= currentSpeed;
            measurementType <= '1';
        end if;
    end process;
end velocity;
