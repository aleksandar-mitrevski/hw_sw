library IEEE;
use IEEE.std_logic_1164.All;

package exploration_pkg is
    constant NUMBER_OF_ROWS : integer := 255;
    constant NUMBER_OF_COLUMNS : integer := 255;
    constant GRID_RESOLUTION : real := 0.1; --cm

    type CellsAndCosts is record
        row : integer;
        column : integer;
        linearCost : real;
        angularCost : real;
    end record;

    type rowArray is array (0 to NUMBER_OF_COLUMNS) of std_logic;
    type gridArray is array (0 to NUMBER_OF_ROWS) of rowArray;

    type real_array is array (integer range <>) of real;
    type integer_array is array (integer range <>) of integer;
    type cellsAndCostsArray is array (integer range <>) of CellsAndCosts;

    function isGridExplored(grid : gridArray) return std_logic;
    function gridToWorld(row,column: integer) return real_array;
    function worldToGrid(x,y: real) return integer_array;
    function findNearestCells(x,y: real) return cellsAndCostsArray;
end;

package body exploration_pkg is

    function gridToWorld(row, column: integer) return real_array is
        variable coordinates : real_array(0 to 1);
    begin
        coordinates(0) := (GRID_RESOLUTION / 2.0) + real(column) * GRID_RESOLUTION;
        coordinates(1) := (GRID_RESOLUTION / 2.0) + real(row) * GRID_RESOLUTION;
        return coordinates;
    end gridToWorld;

    function worldToGrid(x, y: real) return integer_array is
        variable coordinates : integer_array(0 to 1);
    begin
        coordinates(0) := integer(x / GRID_RESOLUTION);
        coordinates(1) := integer(y / GRID_RESOLUTION);
        return coordinates;
    end worldToGrid;

    function isGridExplored(grid : gridArray) return std_logic is
        variable isExplored : std_logic := '1';
    begin
        isExplored := '1';
        for i in 0 to NUMBER_OF_ROWS loop
            for j in 0 to NUMBER_OF_COLUMNS loop
                if grid(i)(j) = '0' then
                    isExplored := '0';
                end if;
            end loop;
        end loop;
        return isExplored;
    end isGridExplored;

    function findNearestCells(x,y: real) return cellsAndCostsArray is
        variable currentCoordinates : integer_array;
    begin
        currentCoordinates := worldToGrid(x, y);
        
    end findNearestCells;

end package body;