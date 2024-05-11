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

-------Shifter--------------
entity shifter is
    port (inp : in std_logic_vector (3 downto 0);
        sel : in integer (0 to 4);
        outp : out std_logic_vector (7 downto 0);
            );

architecture shifter of shifter is 
    type vect is array (7 downto 0) of std_logic;
    type matrix is array (integer range 0 to 4) of vect;
    signal row : matrix;
    
    row(0) <= "0000" & inp;
    G1: for i in 1 to 4 generate
            row(i) <= row(i-1) (6 downto 0) & '0';
        end generate;
        outp <= row(sel);
    
    end shifter;




