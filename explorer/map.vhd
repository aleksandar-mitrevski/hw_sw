library ieee;
use ieee.std_logic_1164.all;
use work.exploration_pkg.all;

entity ExplorationGrid is port (
    currentCellsInView: in gridArray;
    grid : out gridArray);
end ExplorationGrid;

architecture explorationGrid of ExplorationGrid is
    signal exploredGrid : gridArray;
begin
    
    process(currentCellsInView)        
    begin
        for i in 0 to currentCellsInView'length-1 loop
            exploredGrid(i) <= '1';
        end loop;
    end process;

    process(exploredGrid)
    begin
        grid <= exploredGrid;
    end process;

end explorationGrid;