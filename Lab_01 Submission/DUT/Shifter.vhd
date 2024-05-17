LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.aux_package.all;

ENTITY Shifter IS
	generic ( n : integer :=8;
			  k : integer :=3);
	PORT (	x, y: IN std_logic_vector (n-1 DOWNTO 0);
			FN: IN std_logic_vector (2 DOWNTO 0); 
			res: OUT std_logic_vector (n-1 DOWNTO 0);
			Cout: OUT std_logic);
END Shifter;
--------------------------------------------------------
ARCHITECTURE dataflow OF Shifter IS
	subtype vector is std_logic_vector (n-1 DOWNTO 0);
	type matrix is array (0 DOWNTO k) of vector;
	signal row: matrix;
	signal sel:integer range 0 to n;

BEGIN
	sel <= x(k-1 DOWNTO 0);
	row(0) <= y;
	mode1: if FN = "000" generate --- shift left
		   G1: for i in 0 to k generate
			   row(i) <= row (i-1)(n-2 DOWNTO 0) & '0';
			   Cout <= row (i-1)(n-1);
		   end generate G1;
	end generate mode1;
	
	mode2: if FN = "001" generate --- shift right
		   G2: for i in 0 to k generate
			   row(i) <= '0' & row (i-1)(n-1 DOWNTO 1);
			   Cout <= row (i-1)(0);
		   end generate G2;
	end generate mode2;	
	
	mode3: if (FN /= "001" or FN /= "000") generate --- undefined ALUFN
		   row(sel) <= (others =>'0');
	end generate mode3;

	res <= row(sel); --- output of the shift
	
END dataflow;