LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY Adder IS
  GENERIC (n : INTEGER := 8);
  PORT (     cin: IN STD_LOGIC;
			 x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            cout: OUT STD_LOGIC;
               s: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END Adder;
--------------------------------------------------------------
ARCHITECTURE dfl OF Adder IS
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
	SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);
BEGIN
	
	first : FA port map(
			xi => x(0),
			yi => y(0),
			cin => cin,
			s => s(0),
			cout => reg(0)
	);
	
	rest : for i in 1 to n-1 generate
		chain : FA port map(
			xi => x(i),
			yi => y(i),
			cin => reg(i-1),
			s => s(i),
			cout => reg(i)
		);
	end generate;
	
	cout <= reg(n-1);

END dfl;

