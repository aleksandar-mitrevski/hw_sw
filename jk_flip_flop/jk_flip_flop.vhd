library IEEE;
use IEEE.std_logic_1164.All;

entity JKFlipFlop is port (
    clk : in std_logic;
    j : in std_logic;
    k : in std_logic;
    q_out : inout std_logic;
    q_not_out : inout std_logic);
end JKFlipFlop;

architecture arch_jkff of JKFlipFlop is
begin

    jkff: process (clk)
    begin
        if rising_edge (clk) then
            if j = '0' and k = '1' then
                q_out <= '0';
            elsif j = '1' and k = '0' then
                q_out <= '1';
            elsif j = '1' and k = '1' then
                q_out <= q_not_out;
            end if;
        end if;
    end process;

    q_not_out <= Not (q_out);

end arch_jkff;