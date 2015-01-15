library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.exploration_pkg.all;

package vector_pkg is
    type Vector is record
        x : real;
        y : real;
    end record;

    function norm(vec : Vector) return real;
end;

package body exploration_pkg is
    function norm(vec : Vector) return real is
        variable vectorNorm : real;
    begin
        vectorNorm := sqrt((vec.x * vec.x) + (vec.y * vec.y));
        return vectorNorm;
    end norm;
end package body;