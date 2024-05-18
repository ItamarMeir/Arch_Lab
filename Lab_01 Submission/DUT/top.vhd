LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

-----------------top entity decleration-----------------------
ENTITY top IS
  GENERIC (
		   n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	-- m=2^(k-1)
  );	   
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END top;

------------- ARCHITECTURE decleration --------------
ARCHITECTURE struct OF top IS 
------------- Signals decleration --------------
	SIGNAL 	Y_AddSub_i, X_AddSub_i, AddSub_o : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL	Y_Logic_i, X_Logic_i, Logic_o : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL	Y_Shifter_i, X_Shifter_i, Shifter_o : STD_LOGIC_VECTOR(n-1 DOWNTO 0); ---- All vector lines in width n
	SIGNAL AddSub_cout, Shifter_cout : std_logic;		---- Single bit lines
	SIGNAL Vflag_Add_temp, Vflag_Sub_temp, Vflag_middle_temp : std_logic;   ---- Temporary variables used


BEGIN
	
	--------- Initializeing components inputs -------------
	 --- ALUFN[4:3] 
	
	Y_AddSub_i <= Y_i when ALUFN_i (4 downto 3) = "01" else		--- Adder/Subtructor selected
				(others => '0');
	X_AddSub_i <= X_i when ALUFN_i (4 downto 3) = "01" else
				(others => '0');

	Y_Logic_i <= Y_i when ALUFN_i (4 downto 3) = "11" else		--- Logic selected
				(others => '0');
	X_Logic_i <= X_i when ALUFN_i (4 downto 3) = "11" else
				(others => '0');

	Y_Shifter_i <= Y_i when ALUFN_i (4 downto 3) =  "10" else	--- Shifter selected
				(others => '0');
	X_Shifter_i <= X_i when ALUFN_i (4 downto 3) =  "10" else
				(others => '0');



	------------ ALU output -----------

	  --- ALUFN[4:3] 
	ALUout_o <= 	
				AddSub_o when ALUFN_i (4 downto 3) = "01" else		-- ALUout_o = ADD/SUB output
				Shifter_o when ALUFN_i(4 downto 3) =  "10" else		-- ALUout_o = Shifter output
				Logic_o when ALUFN_i (4 downto 3) = "11" else		-- ALUout_o = Logic output
				(others => '0'); 								-- Illigal OPCODE											
	
	--- Nflag_o flag ---
	
	Nflag_o <= '0' when ALUFN_i(4 downto 3) = "00" else					-- Illigal OPCODE
				AddSub_o(n-1) when ALUFN_i(4 downto 3) =  "01" else		-- ALUout_o = ADD/SUB output
				Shifter_o(n-1) when ALUFN_i(4 downto 3) =  "10" else		-- ALUout_o = Shifter output
				Logic_o(n-1);																	-- ALUout_o = LOGIC output
	
	--- Zflag_o flag ---

Zflag_o <= '1' when ((ALUFN_i(4 downto 3) =  "01" AND AddSub_o = (n-1 downto 0 => '0')) OR -- AddSub_o=0 and chosen 
             		 (ALUFN_i(4 downto 3) =   "10" AND Shifter_o = (n-1 downto 0 => '0')) OR -- Shifter_o=0 and chosen 
              		(ALUFN_i(4 downto 3) =  "11" AND Logic_o = (n-1 downto 0 => '0'))) OR -- Logic_o=0 and chosen 
					ALUFN_i(4 downto 3) = "00"											-- Illigal OPCODE 
					else '0';
    			
														

	--- Cflag_o flag ---
  --- ALUFN[4:3] 
	Cflag_o <= AddSub_cout when ALUFN_i(4 downto 3) = "01"  else -- when Adder/Subtructior was activated take its carry
				Shifter_cout when ALUFN_i(4 downto 3) =  "10" else	-- when Shifter was activated take its carry
				'0';			-- else reset


	--- Vflag_o flag ---
		Vflag_Add_temp <= ((not (X_AddSub_i(n-1))) and (not (Y_AddSub_i(n-1))) and AddSub_o(n-1)) or
							((X_AddSub_i(n-1)) and (Y_AddSub_i(n-1)) and (not (AddSub_o(n-1))));  		--- When Addition applied Overflow is this boolean expression
		
		Vflag_Sub_temp <= ((not (Y_AddSub_i(n-1))) and (X_AddSub_i(n-1)) and AddSub_o(n-1)) or
							((Y_AddSub_i(n-1)) and (not(X_AddSub_i(n-1))) and (not (AddSub_o(n-1))));  		--- When Subtruction applied Overflow is this boolean expression

				Vflag_middle_temp <= Vflag_Add_temp when ALUFN_i (2 downto 0) = "000" else  --- When Add selcted
									Vflag_Sub_temp when ALUFN_i (2 downto 0) = "001" else	--- When Sub selected
									'0';

		--- ALUFN[4:3] 
			Vflag_o <= Vflag_middle_temp when ALUFN_i(4 downto 3) = "01" else	--- When Adder/Subtructor comp. selected
						'0';			-- else reset V bit

-------------------------- Port Map ----------------------------
	
Logic1: Logic generic map (
    n => n, k => k, m => m
) port map (
    Y_Logic_i => Y_Logic_i,
    X_Logic_i => X_Logic_i,
    ALUFN => ALUFN_i(2 downto 0),
    Logic_o => Logic_o
);

AddSub1: AdderSub generic map (
    n => n, k => k, m => m
) port map (
    Y_AddSub_i => Y_AddSub_i,
    X_AddSub_i => X_AddSub_i,
    ALUFN => ALUFN_i(2 downto 0),
    AddSub_o => AddSub_o,
    AddSub_cout => AddSub_cout
);

Shifter1: Shifter generic map (
    n => n, k => k, m => m
) port map (
    Y_Shifter_i => Y_Shifter_i,
    X_Shifter_i => X_Shifter_i,
    ALUFN => ALUFN_i(2 downto 0),
    Shifter_o => Shifter_o,
    Shifter_cout => Shifter_cout
);
	
			 
END struct;

