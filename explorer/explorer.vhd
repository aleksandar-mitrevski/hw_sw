library ieee;
use ieee.std_logic_1164.all;
use work.exploration_pkg.all;

entity Explorer is port (
    currentX, currentY, currentTheta : in real;
    x, y : out integer);
end Explorer;

architecture explorer of Explorer is
    ---------------
    -- Conventions
    ---------------
    -- Whether to publish a new goal depends on whether the current pose of the robot is equal to the desired one

    component ExplorationGrid
        port(currentX, currentY: in real;
             grid : out gridArray);
    end component;

    signal gridMap : gridArray;
    signal gridExplored;
begin
    componentMap : ExplorationGrid port map (grid => gridMap);

    process(gridMap)
        variable mapExplored : std_logic;
        variable currentGridCoordinates : integer_array;
        variable goalGridCoordinates : integer_array;
    begin
        mapExplored := isGridExplored(gridMap);
        if mapExplored then
            x <= -1;
            y <= -1;
        else
            currentGridCoordinates := worldToGrid(currentX, currentY);
            --magic
            x <= grid
        end if;
    end process;
end explorer;