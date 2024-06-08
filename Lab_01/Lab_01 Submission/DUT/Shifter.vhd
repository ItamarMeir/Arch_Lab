LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.aux_package.all;

ENTITY Shifter IS
	GENERIC (
			CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 4  -- 2^(k-1), here assumed to be 4
	);
	PORT (	
			Y_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0); -- Y input
        	X_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0); -- X input
        	ALUFN: in STD_LOGIC_VECTOR (2 downto 0);		-- Shifter mode: for "000" shift left. for "001" shift right.
        	Shifter_o: out std_logic_vector(n-1 DOWNTO 0);	-- Shifter output
			Shifter_cout: out std_logic						-- Shifter carry output
		);
END Shifter;
--------------------------------------------------------
ARCHITECTURE dataflow OF Shifter IS

	subtype vector is std_logic_vector (n-1 DOWNTO 0);
	type matrix is array (k DOWNTO 0) of vector;

	signal choice_mat: matrix;
	signal carry_vector: vector;
	
BEGIN

	-- NOTE - shifting right can be preformed as this: Inverse the vector, shift left, inverse again.
	carry_vector(0) <= '0';
	First_line: for i in 0 to n-1 generate -- If SHL applied copy Y to choice_mat(0). If SHR copy reversed(Y) to choice_mat(0).
					choice_mat(0)(i) <= Y_Shifter_i(i) when ALUFN = "000" else   -- Shift left applied
										Y_Shifter_i(n-1-i) when ALUFN = "001" else -- Shift right applied (reverse)
										'0';	-- else ALUFN undefined
	end generate;

	-- generating the other lines: Looping on each bit of X. If the current bit is '1', preform shifting according to the step 'i'. else copy the previous line.
	GEN_out: for i in 1 to k generate
					choice_mat(i) <= choice_mat(i-1)(n-1-(2 ** (i-1)) downto 0) & (2 ** (i-1)-1 downto 0 => '0') when X_Shifter_i(i-1) = '1' else
									choice_mat(i-1);
					
					carry_vector(i) <= choice_mat(i-1)(n-(2 ** (i-1))) when  X_Shifter_i(i-1) = '1' else
									   carry_vector(i-1);

	end generate;


	Reverse: for i in 0 to n-1 generate
					Shifter_o(i) <= choice_mat(k)(i) when ALUFN = "000" else   -- Shift left applied
									choice_mat(k)(n-1-i) when ALUFN = "001" else -- Shift right applied (reverse)
									'0';	-- else ALUFN undefined
	end generate;

	Shifter_cout <= carry_vector(k) when ALUFN = "000" else
					carry_vector(k) when ALUFN = "001" else
	 				'0'; 
	

END ARCHITECTURE dataflow;