library IEEE;
use ieee.std_logic_1164.all;

package aux_package is

--------------------------------------------------------
	component top is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	; -- m=2^(k-1)
		   SUBTYPE base_vector IS STD_LOGIC_VECTOR(n-1 DOWNTO 0));  -- Subtype based on 'n'
			
			
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	end component;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;

------------------Logic---------------------------------------	
	component Logic is
	GENERIC (
			CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 4;  -- 2^(k-1), here assumed to be 4
			
		)
	PORT (
		Y_Logic_i: in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		X_Logic_i: in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);

		Logic_out: out STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	);
	end component;
	
------------------Status_Register---------------------------------------	
	component Status_Register is
	GENERIC (
			CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 4;  -- 2^(k-1), here assumed to be 4
			SUBTYPE base_vector IS STD_LOGIC_VECTOR(n-1 DOWNTO 0);  -- Subtype based on 'n'
			SUBTYPE Logic_mat IS ARRAY (n-1 DOWNTO 0) of base_vector;  -- Matrix of all the optional outputs of Logic
		)
	PORT (
		Add_Sub_out: in base_vector;
		Logic_out: in base_vector;
		Shifter_out: in base_vector;
		ALUFN: in STD_LOGIC_VECTOR (m downto k);  -- ALUFN[4:3]

		ALUout: out base_vector; --- ALU n-bit output result
		--- SR flags ----
		overflow: out STD_LOGIC;
		zero: out STD_LOGIC;
		carry: out STD_LOGIC;
		negative: out STD_LOGIC
		-----------------
	);
	end component;	
	
	
	
	
	
	
	
	
	
	
	
	
end aux_package;
