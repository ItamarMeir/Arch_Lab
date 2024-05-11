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
