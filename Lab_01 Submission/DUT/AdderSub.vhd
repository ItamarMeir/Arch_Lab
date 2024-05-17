LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
----------------entity decleration----------------------------------------
ENTITY AdderSub IS
	-- GENERIC (
	-- 		CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    -- 		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    -- 		CONSTANT m : INTEGER := 4;  -- 2^(k-1), here assumed to be 4
	-- )
	-- PORT (	x, y: IN std_logic_vector (n-1 DOWNTO 0);
	-- 		FN: IN std_logic_vector (k-1 DOWNTO 0);
	-- 		Sout: OUT std_logic_vector (n-1 DOWNTO 0);
	-- 		Cout: OUT std_logic);
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
END AdderSub;
--------------------architecture------------------------------------
ARCHITECTURE dataflow OF AdderSub IS

-------------------- F.A component ---------------------
	-- component Adder IS
	--   GENERIC (
	-- 		CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    -- 		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    -- 		CONSTANT m : INTEGER := 4;  -- 2^(k-1), here assumed to be 4
	-- )
	--   PORT (     cin: IN STD_LOGIC;
	-- 			 x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	-- 			cout: OUT STD_LOGIC;
	-- 			   s: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	-- END component;

--------------------------------------------------
	signal sub_cont:STD_LOGIC;
	signal X_0,Y_0:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);

BEGIN
	sub_cont <=  '1' when (ALUFN = "001" or ALUFN = "010") else  -- when we want to subtruct Y-X or neg(X), sub_cont='1'
				 '0' ;
				 
	U1: for i in 0 to n-1 generate -- generating X_0 and Y_0 according to sub_cont.
		X_0(i) <= (X_AddSub_i(i) xor sub_cont) when (ALUFN = "000" OR ALUFN = "001" OR ALUFN = "010") else
			      '0';
		Y_0(i) <= Y_AddSub_i(i) when (ALUFN = "000" OR ALUFN = "001") else -- when adding/subtructing Y=Yin when neg(X) Y=0
			      '0';
		end generate;		  
	
	----- Now using n F.As to do Y_0 + X_0 ------------

	first : FA port map(
			xi => X_0(0),
			yi => Y_0(0),
			cin => sub_cont,
			s => AddSub_o(0),
			cout => reg(0)
	);
	
	rest : for i in 1 to n-1 generate
		chain : FA port map(
			xi => X_0(i),
			yi => Y_0(i),
			cin => reg(i-1),
			s => AddSub_o(i),
			cout => reg(i)
		);
	end generate;
	
	AddSub_cout <= reg(n-1);
		
			
END dataflow;

