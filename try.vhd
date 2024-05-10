library ieee
use ieee.std_logic_1164.all;
-- =========================
entity mux is 
    port (a,b,c,d,s0,s1 : in std_logic;
        y : out std_logic; );
-- =========================
architecture Log of mux is begin
    y <= (a and not s0 and not s1) or
        (b and not s1 and s0) or
        (c and s1 and not s0) or
        (d and s1 and s0);
    end Log;

--==========================

entity mux2 is 
    port (a,b,c, sela, selb : in std_logic;
          q : out std_logic;);

-------------------------
architecture arci2 of mux2 is begin
    q <= a when sela = '1' else
        b when selb ='1' else
        c;
        end arci2;

-----------Tristate ---------
constant N : integer :=8;


entity tristate is 
    port (input1 : in std_logic_vector (N-1 downto 0);
          en : in std_logic;
          output1 : in std_logic_vector (N-1 downto 0); );

architecture tri of tristate is begin
    output1 <= input1 when en ='0' else (others => 'z');
    end tri;
---------------