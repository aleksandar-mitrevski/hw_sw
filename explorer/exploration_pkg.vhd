library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.vector_pkg.all;

package exploration_pkg is
    constant NUMBER_OF_CELLS : integer := 256;
    constant NUMBER_OF_ROWS : integer := 16;
    constant CELLS_PER_ROW : integer := 16;

    constant CELL_HEIGHT : real := 14.4;
    constant CELL_WIDTH : real := 8.8;
    constant LINEAR_COST : real := 0.2;
    constant ANGULAR_COST : real := 0.8;
    constant INFINITY : real := 10000000.0;

    type gridArray is array (0 to NUMBER_OF_CELLS-1) of std_logic;
    type cellsAndCostsArray is array (integer range <>) of CellsAndCosts;
    type integer_array is array (integer range <>) of integer;
    type real_array is array (integer range <>) of real;

    function isGridExplored(grid : gridArray) return std_logic;
    function calculateCosts(currentCell : integer, currentOrientation : real, grid : gridArray) return integer;
    function calculateCellCost(cell: integer, currentCell : integer, orientation : real) return real;
    function normaliseAngle(angle : real) return real;
end;

package body exploration_pkg is

    --- Returns '1' if all cells in 'grid' have been marked '1', and, in addition, 
    --- 'numberOfNuggetsToCollect' is equal to 0; returns '0' otherwise.
    ---
    --- Arguments:
    ---     grid -- A GridArray array representing a boolean grid.
    ---     numberOfNuggetToCollect -- An integer denoting the number of visible nuggets that need to be collected.
    ---
    function isGridExplored(grid : gridArray, numberOfNuggetsToCollect : integer) return std_logic is
        variable isExplored : std_logic := '1';
    begin
        isExplored := '1';
        for i in 0 to NUMBER_OF_CELLS-1 loop
            if grid(i) = '0' then
                isExplored := '0';
            end if;
        end loop;

        if isExplored = '1' and numberOfNuggetsToCollect > 0 then
            isExplored := '0';
        end if;

        return isExplored;
    end isGridExplored;

    --- Calculates a cost for each of the unexplored cells given the current position and orientation of the robot.
    --- 
    --- Arguments:
    ---     currentCell -- An index denoting the current position of a robot.
    ---     currentOrientation -- A floating-point number denoting a robot's orientation.
    ---     grid -- A GridArray array representing a boolean grid.
    ---
    --- Returns:
    --- minimumCostCell -- An index denoting the cell with lowest combined linear and angular cost.
    ---
    function calculateCosts(currentCell : integer, currentOrientation : real, grid : gridArray) return integer is
        variable cellCosts: real_array(0 to NUMBER_OF_CELLS);
        variable minimumCost : real;
        variable minimumCostCell : integer;
    begin
        for i in 0 to NUMBER_OF_CELLS loop
            if i = currentCell or grid(cell) = '1' then
                cellCosts(i) := INFINITY;
            else
                cellCosts(i) := calculateCellCost(i, currentCell, currentOrientation);
            end if;
        end loop;

        minimumCost := cellCosts(0);
        minimumCostCell := 0;
        for i in 1 to NUMBER_OF_CELLS loop
            if minimumCost > cellCosts(i) then
                minimumCost := cellCosts(i);
                minimumcCostCell := i;
            end if;
        end loop;

        return minimumCostCell;
    end;

    --- Calculates the cost of 'cell' with respect to 'currentCell' and 'orientation'.
    --- 
    --- Arguments:
    ---     cell -- Index of a cell.
    ---     currentCell -- An index denoting the current position of a robot.
    ---     orientation --A floating-point number denoting a robot's orientation.
    ---
    --- Returns:
    --- cost -- A floating-point number representing the calculated cost.
    ---
    function calculateCellCost(cell: integer, currentCell : integer, orientation : real) return real is
        variable cost : real := 0.0;
        variable dotProduct : real;

        variable vectorToCell : Vector;
        variable directionVector : Vector;
        variable linearDistance : real;
        variable angularDistance : real;
    begin
        vectorToCell.x := (real(cell) * CELL_WIDTH) - (real(currentCell) * CELL_WIDTH);
        vectorToCell.y := (real(cell) * CELL_HEIGHT) - (real(currentCell) * CELL_HEIGHT);
        linearDistance := sqrt((xDistance * xDistance) + (yDistance * yDistance));

        directionVector.x := cos(orientation);
        directionVector.y := sin(orientation);

        dotProduct := vectorToCell.x * directionVector.x + vectorToCell.y * directionVector.y;
        angularDistance := normaliseAngle(arccos(dotProduct / norm(vectorToCell)));

        cost = LINEAR_COST * linearDistance + ANGULAR_COST * angularDistance;
        return cost;
    end calculateCellCost;

    --- Transforms 'angle' so that it lies in the (0,2*pi) range.
    ---
    --- Arguments:
    ---     angle -- A floating-point number representing an angle.
    ---
    function normaliseAngle(angle : real) return real is
    begin
        if angle < 0 then
            angle = angle + 2.0 * MATH_PI;
        end if;
        return angle;
    end normaliseAngle;

end package body;