library ieee
use ieee.std_logic_1164.all;
=========================
entity mux is 
    port (a,b,c,d,s0,s1 : in std_logic;
        y : out std_logic; )
=========================
architecture Log of mux is begin
    y <= (a and not s0 and not s1) or
        (b and not s1 and s0) or
        (c and s1 and not s0) or
        (d and s1 and s0);
    end Log;