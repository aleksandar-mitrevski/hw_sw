library ieee;
use ieee.std_logic_1164.all;

entity FilteredEdgeDetector is port (
    clk, reset: in std_logic;
    level : in std_logic;
    levelFiltered : inout std_logic;
    tick : out std_logic);
end FilteredEdgeDetector;

architecture filtered_edge_detector of FilteredEdgeDetector is
    ------------------------------------------------
    --! Edge detector local signals
    ------------------------------------------------

    -- Moore machine states
    type state_type is (zero, edge, one);
    signal state_reg, state_next : state_type;


    ------------------------------------------------
    --! Filter local signals
    ------------------------------------------------

    -- shift register outputs
    signal q1 : std_logic := '0';
    signal q2 : std_logic := '0';
    signal q3 : std_logic := '0';
    signal q4 : std_logic := '0';

    -- jk flip flop output
    signal q : std_logic := '0';
    signal q_not : std_logic := '1';
begin
    ------------------------------------------------
    --! Updates the flip flops in the shift register
    ------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            q4 <= q3;
            q3 <= q2;
            q2 <= q1;
            q1 <= level;
        end if;
    end process;

    ------------------------------------------------
    --! Updates the filter's jk flip flop
    ------------------------------------------------
    process(q1,q2,q3,q4)
        variable j : std_logic := '0';
        variable k : std_logic := '0';
    begin
        j := q2 and q3 and q4;
        k := (not q2) and (not q3) and (not q4);
        if j = '0' and k = '1' then
            q <= '0';
        elsif j = '1' and k = '0' then
            q <= '1';
        elsif j = '1' and k = '1' then
            q <= q_not;
        end if;
    end process;

    q_not <= not q;

    ------------------------------------------------
    --! Outputs the value of the filter
    ------------------------------------------------
    process(q)
    begin
        levelFiltered <= q;
    end process;

    ------------------------------------------------
    --! Updates the state of the edge detector
    ------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            state_reg <= zero;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
    end process;

    ------------------------------------------------
    --! Updates the next state of the edge detector
    --! and outputs the detector value
    ------------------------------------------------
    process(state_reg, levelFiltered)
    begin
        state_next <= state_reg;
        tick <= '0';
        case state_reg is
            when zero =>
                if levelFiltered = '1' then
                    state_next <= edge;
                end if;
            when edge =>
                tick <= '1';
                if levelFiltered = '1' then
                    state_next <= one;
                else
                    state_next <= zero;
                end if;
            when one =>
                if levelFiltered = '0' then
                    state_next <= zero;
                end if;
        end case;
    end process;
end filtered_edge_detector;