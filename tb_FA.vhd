library ieee;
use ieee.std_logic_1164.all;

entity tb_FA is
end tb_FA;

architecture rtl of tb_FA is

    component fa is
    port (x, y, cin : in std_logic;
          s, cout : out std_logic);
    end component;

    signal x, y, cin, s, cout : std_logic;

begin

    tester : fa port map (
        x => x, y => y, cin => cin, s => s, cout => cout
    );
  ----------- start sim -------
    tb_x : process
    begin
        x <= '0';
        wait for 50 ns;
        x <= not x;
        wait for 50 ns;
    end process tb_x;

   tb_y : process
    begin
        y <= '0';
        wait for 100 ns;
        y <= not y;
        wait for 100 ns;
    end process tb_y;

   tb_cin : process
    begin
        cin <= '0';
        wait for 200 ns;
        cin <= '1';
        wait;
    end process tb_cin;

end rtl;
