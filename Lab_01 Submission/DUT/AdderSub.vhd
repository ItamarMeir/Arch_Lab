LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
----------------entity decleration----------------------------------------
ENTITY AdderSub IS
	
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


	signal sub_cont:STD_LOGIC;
	signal X_0,Y_0:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);

BEGIN
	sub_cont <=  '1' when ((ALUFN = (k-1 downto 2 => '0') & "01") or (ALUFN = (k-1 downto 2 => '0') & "10")) else  -- when we want to subtruct Y-X or neg(X), sub_cont='1'
				 '0' ;
				 
	U1: for i in 0 to n-1 generate -- generating X_0 and Y_0 according to sub_cont.
		X_0(i) <= (X_AddSub_i(i) xor sub_cont) when ((ALUFN = (k-1 downto 2 => '0') & "00") OR (ALUFN = (k-1 downto 2 => '0') & "01") OR 
													(ALUFN = (k-1 downto 2 => '0') & "10"))
												else '0';
		Y_0(i) <= Y_AddSub_i(i) when ((ALUFN = (k-1 downto 2 => '0') & "00") OR (ALUFN = (k-1 downto 2 => '0') & "01")) else -- when adding/subtructing Y=Yin when neg(X) Y=0
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

