LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
------------------------- ALU MODULE
-- Module for ALU functions
-- Supports addition, subtraction and Getting Negative of a number
-- Outputs Zero, Carry, Negative flags when needed
--------ALU Entity---------------------------
ENTITY ALU IS
  GENERIC (Dwidth : INTEGER := 16);
  PORT ( A,B	  				  : IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
		 OPC 					  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         CFlag, Zflag, Nflag	  :	OUT STD_LOGIC;
         C		  				  :	OUT STD_LOGIC_VECTOR(Dwidth-1 downto 0));
END ALU;
---------ALU Architecture--------------------
ARCHITECTURE dfl OF ALU IS
	SIGNAL reg : std_logic_vector(Dwidth-1 DOWNTO 0) := (others => '0');
	SIGNAL A_temp, B_temp: std_logic_vector(Dwidth-1 DOWNTO 0);
	SIGNAL cin : std_logic;
	SIGNAL S_out : std_logic_vector(Dwidth-1 DOWNTO 0) := (others => '0');
	constant zero_vec : std_logic_vector(Dwidth-1 downto 0) := (others => '0');
BEGIN

	-- carry in should be LSB of OPC
	cin <= '1' WHEN (OPC = "0001" or OPC = "0011") ELSE '0';
	
	-- For NEG - Make A zero vector
	A_temp <= 	(OTHERS => '0') WHEN (OPC = "0011") ELSE A;
	
	-- B_tmp - OPC(0) = 0 - make sum; OPC(0) = 1 - make subtraction
	-- For subtraction, need xor with '1'
	B_tmp  : for i in 0 to Dwidth-1 generate
		B_temp(i) <= (B(i) xor '1')			WHEN (OPC = "0001" or OPC = "0011") ELSE  
					  B(i);
	end generate;
	
	-- First FA operation to ALU
	first: FA port map(A_temp(0), B_temp(0), cin, S_out(0), reg(0));
	
	-- Make the rest of the FA operations
	rest : for i in 1 to Dwidth-1 generate
		chain : FA port map(A_temp(i), B_temp(i), reg(i-1), S_out(i), reg(i));
	end generate;
	
	-- Take care of Flags only when the alu does an operation otherwise the flags stays unaffected
	CFlag <= reg(Dwidth-1) when (OPC = "0000") else unaffected; -- Get carry of the last FA ;
	Nflag <= unaffected when (OPC = "1111" or OPC = "0010") else S_out(Dwidth-1);   --Check MSB of the result 
	Zflag <= unaffected when (OPC = "1111" or OPC = "0010") else 
			'1' WHEN (S_out = zero_vec) ELSE '0'; -- Compare with zero vector  
	-- Sum to ALU output
	C <= S_out;

END dfl;