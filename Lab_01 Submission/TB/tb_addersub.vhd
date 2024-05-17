library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_addersub is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	
end tb_addersub;
-------------------------------------------------------------------------------
architecture rtl of tb_addersub is
	component AdderSub IS
		GENERIC (
			CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 4  -- 2^(k-1), here assumed to be 4
	);
	PORT (
		Y_AddSub_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_AddSub_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);

        AddSub_o: out std_logic_vector(n-1 DOWNTO 0);
		AddSub_cout: out std_logic
    );
	END component;

	SIGNAL x, y, Sout: std_logic_vector(n-1 DOWNTO 0);
	SIGNAL FN: std_logic_vector (k-1 DOWNTO 0);
	SIGNAL Cout: std_logic;
begin
		tester: AdderSub port map(
			X_AddSub_i=>x, Y_AddSub_i=>y, ALUFN=>FN, AddSub_cout=>Cout, AddSub_o=>Sout); 


--------- start of stimulus section ----------------------------------------	
		testbench : process		
        begin
		
		  y <= "00110011","11001010" after 150 ns, "01111100" after 300 ns,"00101001" after 450 ns,
		  		"10010110" after 600 ns,"11111111" after 750 ns;
		  x <= "01001100","01110101" after 150 ns, "10011011" after 300 ns,"01010101" after 450 ns,
		  		"11100101" after 600 ns,"11111111" after 750 ns,"00000000" after 850 ns;
		  FN<= "000","001" after 50 ns, "010" after 150 ns,"000" after 200 ns,"001" after 250 ns, "010" after 300 ns,"000" after 350 ns,
		  		"001" after 400 ns, "010" after 450 ns, "000" after 500 ns,"001" after 550 ns, "010" after 650 ns,"111" after 700 ns,
				"000" after 750 ns,"001" after 800 ns,"111" after 850 ns;
		  wait;
--------- END of stimulus section ----------------------------------------
        end process testbench;
		 

end architecture rtl;
