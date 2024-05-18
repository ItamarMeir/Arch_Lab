library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_Shifter is
		CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    	CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    	CONSTANT m : INTEGER := 4;  -- 2^(k-1), here assumed to be 4
end tb_Shifter;
-------------------------------------------------------------------------------
architecture rtl of tb_Shifter is
	component Shifter is 

		GENERIC (
			CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 4  -- 2^(k-1), here assumed to be 4
		);
		PORT (
        	Y_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0);
        	X_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0);
        	ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);
       	 	Shifter_o: out std_logic_vector(n-1 DOWNTO 0);
			Shifter_cout: out std_logic
   		 );
	end component;

	SIGNAL X_Shifter_i, Y_Shifter_i, Shifter_o: std_logic_vector(7 DOWNTO 0);
	SIGNAL ALUFN: std_logic_vector (2 DOWNTO 0);
	SIGNAL Shifter_cout: std_logic;

	begin
		tester: Shifter generic map (n, k, m) port map(
		X_Shifter_i => X_Shifter_i, Y_Shifter_i => Y_Shifter_i, ALUFN => ALUFN, Shifter_cout => Shifter_cout, Shifter_o => Shifter_o);  

	--------- start of stimulus section ----------------------------------------		
        tb_ALUFN : process
        begin
		  ALUFN <= (others => '0');
		  for i in 0 to 4 loop
		  	wait for 50 ns;
			ALUFN <= ALUFN + 1;
			wait for 50 ns;
			ALUFN <= ALUFN - 1;
		  end loop;
		  ALUFN <= ALUFN + 3;
		  wait for 50 ns;
		  ALUFN <= ALUFN - 1;
		  wait for 50 ns;
		  wait;
        end process tb_ALUFN;
		
		
		
		tb_x : process
        begin
		  X_Shifter_i <= (others => '0');
		  for i in 0 to 10 loop
		  	wait for 100 ns;
			X_Shifter_i <= X_Shifter_i + 1;	
		  end loop;
		  wait;
        end process tb_x;

		tb_y : process
        begin
		  Y_Shifter_i <= (n-1 downto 1 => '0') & '1';
		  for i in 0 to 5 loop
		  	wait for 50 ns;
			Y_Shifter_i <= Y_Shifter_i + 3;	
		  end loop;
		  wait;
        end process tb_y;



end architecture rtl;
