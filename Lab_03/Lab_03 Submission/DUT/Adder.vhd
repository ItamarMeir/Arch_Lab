LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY Adder IS
  GENERIC (Dwidth: integer:=16);
  PORT ( a, b: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          cin: IN STD_LOGIC;
            s: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
         cout: OUT STD_LOGIC);
END Adder;
--------------------------------------------------------
ARCHITECTURE rtl OF Adder IS

  SIGNAL A_temp, B_temp, S_out: STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
  SIGNAL reg: STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
BEGIN
  
  -- Assign the input signals
  A_temp <= a;
  B_temp <= b;

  	
	-- First FA operation to ALU
	first: FA port map(A_temp(0), B_temp(0), cin, S_out(0), reg(0));
	
	-- Make the rest of the FA operations
	rest : for i in 1 to Dwidth-1 generate
		chain : FA port map(A_temp(i), B_temp(i), reg(i-1), S_out(i), reg(i));
	end generate;

  -- Assign the output signals
  s <= S_out;
  cout <= reg(Dwidth-1);

	
END rtl;

