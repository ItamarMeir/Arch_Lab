LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.aux_package.all;

ENTITY Shifter IS
	generic ( n : integer :=8;
			  k : integer :=3);
	PORT (	x, y: IN std_logic_vector (n-1 DOWNTO 0);
			FN: IN std_logic_vector (k-1 DOWNTO 0); 
			res: OUT std_logic_vector (n-1 DOWNTO 0);
			Cout: OUT std_logic);
END Shifter;
--------------------------------------------------------
ARCHITECTURE dataflow OF Shifter IS
	subtype vector is std_logic_vector (n-1 DOWNTO 0);
	type matrix is array (k DOWNTO 0) of vector;
	signal row: matrix;
	signal sel:integer range 0 to n;

BEGIN
	sel <= x(k-1 DOWNTO 0);
	row(0) <= y;
	--mode1: if FN = "000" generate --- shift left
		   G1: for i in 1 to k generate
			   row(i) <= row (i-1)(n-2 DOWNTO 0) & '0' when FN = "000" else
			    		 '0' & row (i-1)(n-1 DOWNTO 1) when FN = "001";
			   				
			   Cout <= row (i-1)(n-1) when FN = "000" else
			   			row (i-1)(0) when FN = "001";
		   end generate G1;
	--end generate mode1;
	
	with sel select
		res <= row(0) when "000",
				row(1) when "001",
				

	res <= row(0); --- output of the shift
	
END dataflow;