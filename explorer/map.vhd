library ieee;
use ieee.std_logic_1164.all;
use work.exploration_pkg.all;

entity ExplorationGrid is port (
    currentX: in real;
    currentY: in real;
    grid : out gridArray);
end ExplorationGrid;

architecture explorationGrid of ExplorationGrid is
    signal exploredGrid : gridArray;
    signal currentXPosition : real;
    signal currentYPosition : real;
begin

    process(currentX, currentY)
    begin
        currentXPosition <= currentX;
        currentYPosition <= currentY;
    end process;

    process(currentXPosition, currentYPosition)
        variable currentGridCoordinates : integer_array(0 to 1);
    begin
        currentGridCoordinates := worldToGrid(currentXPosition, currentYPosition);
        exploredGrid(currentGridCoordinates(0))(currentGridCoordinates(1)) <= '1';
    end process;

    process(exploredGrid)
    begin
        grid <= exploredGrid;
    end process;

end explorationGrid;