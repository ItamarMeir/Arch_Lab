library IEEE;
use ieee.std_logic_1164.all;

package aux_package is

------------------------------------------------------
	component top is
	GENERIC (
            n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	 -- m=2^(k-1)
	);			
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	end component;

----------------Logic---------------------------------------	
	component Logic is
	GENERIC (
        CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
        CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
        CONSTANT m : INTEGER := 4   -- 2^(k-1), here assumed to be 4
    );
    PORT (
        Y_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);            --- ALUFN[2:0]
        Logic_o: out std_logic_vector(n-1 DOWNTO 0)
    );
	end component;
	
----------------------FA-----------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;

	------------------AdderSub---------------------------------------
	component AdderSub is
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
	end component;

	------------------Shifter---------------------------------------
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
---------------------------------------------------------------	
	
	
end aux_package;

