LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

-----------------top entity decleration-----------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	; -- m=2^(k-1)
		   
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
	SIGNAL 	Y_AddSub_i, X_AddSub_i, AddSub_o,
			Y_Logic_i, X_Logic_i, Logic_o,
	 		Y_Shifter_i, X_Shifter_i, Shifter_o : STD_LOGIC_VECTOR(n-1 DOWNTO 0); ---- All vector lines in width n
	SIGNAL AddSub_cout, Shifter_cout : std_logic;		---- Single bit lines
	SIGNAL Vflag_Add_temp, Vflag_Sub_temp, Vflag_middle_temp : std_logic;   ---- Temporary variables used
------------- component decleration --------------
	component Logic is
	PORT (
        Y_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);
        Logic_o: out std_logic_vector(n-1 DOWNTO 0)
    );
	end component;

	component AddSub is 
	PORT (
		Y_AddSub_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_AddSub_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);
        AddSub_o: out std_logic_vector(n-1 DOWNTO 0);
		AddSub_cout: out std_logic
       
    );
	end component;


	component Shifter is
	PORT (
        Y_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);
        Shifter_o: out std_logic_vector(n-1 DOWNTO 0);
		Shifter_cout: out std_logic
    );
	end component;

BEGIN
	
	--------- Initializeing components inputs -------------
	with ALUFN_i (m downto k) select  --- ALUFN[4:3] 
	
	Y_AddSub_i <= Y_i when "01",	--- Adder/Subtructor selected
				(others => '0') when "others";
	X_AddSub_i <= X_i when "01",
				(others => '0') when "others";

	Y_Logic_i <= Y_i when "11",		--- Logic selected
				(others => '0') when "others";
	X_Logic_i <= X_i when "11",
				(others => '0') when "others";

	Y_Shifter_i <= Y_i when "10",	--- Shifter selected
				(others => '0') when "others";
	X_Shifter_i <= X_i when "10",
				(others => '0') when "others";



	------------ ALU output -----------

	with ALUFN_i (m downto k) select  --- ALUFN[4:3] 
	ALUout_o <= (others => '0') when "00",	-- Illigal OPCODE
				AddSub_o when "01",		-- ALUout_o = ADD/SUB output
				Logic_o when "10",		-- ALUout_o = LOGIC output
				Shifter_o when "others";	-- ALUout_o = Shifter output
	
	--- Nflag_o flag ---
	with ALUout_o(n-1) select 
	Nflag_o <= '1' when '1',   -- when MSB is '1' set negative bit
				'0' when "others"; -- when MSB is '0' reset negative bit

	--- Zflag_o flag ---
	with ALUout_o select
	Zflag_o <= '1' when (others => '0'),  -- when vector is "0" set zero bit
			'0' when "others";			-- else reset zero bit

	--- Cflag_o flag ---
	with ALUFN_i (m downto k) select  --- ALUFN[4:3] 
	Cflag_o <= AddSub_cout when "01",  -- when Adder/Subtructior was activated take its carry
				Shifter_cout when "10",	-- when Shifter was activated take its carry
				'0' when "others";			-- else reset


	--- Vflag_o flag ---
		Vflag_Add_temp <= ((not (X_i(n-1))) and (not (Y_i(n-1))) and AddSub_o(n-1)) or
							((X_i(n-1)) and (Y_i(n-1)) and (not (AddSub_o(n-1))));  		--- When Addition applied Overflow is this boolean expression
		
		Vflag_Sub_temp <= ((not (X_i(n-1))) and (Y_i(n-1)) and AddSub_o(n-1)) or
							((X_i(n-1)) and (not(Y_i(n-1))) and (not (AddSub_o(n-1))));  		--- When Subtruction applied Overflow is this boolean expression

		with ALUFN_i (k-1 downto 0) select
				Vflag_middle_temp <= Vflag_Add_temp when "000",  --- When Add selcted
									Vflag_Sub_temp when "001",	--- When Sub selected
									'0' when "others";

		with ALUFN_i (m downto k) select  --- ALUFN[4:3] 
			Vflag_o <= Vflag_middle_temp when "01", 	--- When Adder/Subtructor comp. selected
						'0' when "others";			-- else reset V bit

-------------------------- Port Map ----------------------------
	
Logic1: Logic generic map (
    n => n, k => k, m => m
) port map (
    Y_Logic_i => Y_Logic_i,
    X_Logic_i => X_Logic_i,
    ALUFN => ALUFN_i(k-1 downto 0),
    Logic_o => Logic_o
);

AddSub1: AddSub generic map (
    n => n, k => k, m => m
) port map (
    Y_AddSub_i => Y_AddSub_i,
    X_AddSub_i => X_AddSub_i,
    ALUFN => ALUFN_i(k-1 downto 0),
    AddSub_o => AddSub_o,
    AddSub_cout => AddSub_cout
);

Shifter1: Shifter generic map (
    n => n, k => k, m => m
) port map (
    Y_Shifter_i => Y_Shifter_i,
    X_Shifter_i => X_Shifter_i,
    ALUFN => ALUFN_i(k-1 downto 0),
    Shifter_o => Shifter_o,
    Shifter_cout => Shifter_cout
);
	
			 
END struct;

