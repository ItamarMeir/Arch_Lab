library ieee;
use ieee.std_logic_1164.all;
-- =========================
entity mux is 
    port (a,b,c,d,s0,s1 : in std_logic;
        y : out std_logic );
    end mux;
-- =========================
architecture Log of mux is begin
    y <= (a and not s0 and not s1) or
        (b and not s1 and s0) or
        (c and s1 and not s0) or
        (d and s1 and s0);
    end Log;

--==========================
library ieee;
use ieee.std_logic_1164.all;

entity mux2 is 
    port (a,b,c, sela, selb : in std_logic;
          q : out std_logic);
    end mux2;
-------------------------
architecture arci2 of mux2 is begin
    q <= a when sela = '1' else
        b when selb ='1' else
        c;
        end arci2;

-----------Tristate ---------
package consts is 
    constant N : integer :=8;
end consts;

use work.consts.all;
library ieee;
use ieee.std_logic_1164.all;

entity tristate is 
    port (input1 : in std_logic_vector (N-1 downto 0);
          en : in std_logic;
          output1 : out std_logic_vector (N-1 downto 0));
          end tristate;

architecture tri of tristate is
begin
    output1 <= input1 when en ='0' else (others => 'z');
    end tri;

-------Shifter--------------
library ieee;
use ieee.std_logic_1164.all;

entity shifter is
    port (inp : in std_logic_vector (3 downto 0);
        sel : in integer range 0 to 4; -- Added 'integer' keyword
        outp : out std_logic_vector (7 downto 0)
            );
        end shifter;

architecture shifter of shifter is 
    type vect is array (7 downto 0) of std_logic;
    type matrix is array (integer range 0 to 4) of vect;
    signal row : matrix;
    begin
    row(0) <= "0000" & inp;
    G1: for i in 1 to 4 generate
            row(i) <= row(i-1) (6 downto 0) & '0';
        end generate;
        outp <= row(sel);
    
    end shifter;

---------1-bit F.A -------
library ieee;
use ieee.std_logic_1164.all;

entity fa is
    port (x,y,cin : in std_logic;
          s,cout : out std_logic);
        end fa;

architecture fa of fa is begin
    s <= x xor y xor cin;
    cout <= ((x xor y) and cin) or
            (x and y);
end fa;




