library ieee;
use ieee.std_logic_1164.all;
use work.exploration_pkg.all;

entity Explorer is port (
    currentCell : in integer;
    currentOrientation : in real;
    currentCellsInView : in gridArray;
    numberOfNuggetsToCollect : in integer;
    next_goal : out integer);
end Explorer;

architecture explorer of Explorer is
    component ExplorationGrid
        port(currentCellsInView: in gridArray;
             grid : out gridArray);
    end component;

    signal currentCellsinView : gridArray;
    signal grid : gridArray;
begin
    componentMap : ExplorationGrid port map (currentCellsInView => currentCellsInView, grid => grid);

    process(numberOfNuggetsToCollect)
        variable mapExplored : std_logic := '0';
    begin
        mapExplored := isGridExplored(grid, numberOfNuggetsToCollect);
        if mapExplored = '1' then
            next_goal <= -1;
        else
            if numberOfNuggetsToCollect = 0 then
                next_goal <= calculateCosts(currentCell, currentOrientation, grid);
            end if;
        end if;
    end process;
end explorer;