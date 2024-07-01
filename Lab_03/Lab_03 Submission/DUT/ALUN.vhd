LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; -- Useful for arithmetic operations
USE work.aux_package.all;

ENTITY ALU IS
  GENERIC (Dwidth: integer := 16);
  PORT (
    A, B: IN STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
    OPC: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	rst: IN STD_LOGIC;
    C: OUT STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
    Cflag,Zflag,Nflag: OUT STD_LOGIC);

END ALU;
-----------------------------------------------------------------------
ARCHITECTURE ALU_arch OF ALU IS

  SIGNAL B_in, AdderSub_out, C_TEMP,C_TEMP_shl : STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
  SIGNAL cout_tmp,cout_tmp_shl : STD_LOGIC;
  SIGNAL C_and, C_or, C_xor: STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
  SIGNAL  Cflag_temp, Zflag_temp, Nflag_temp : STD_LOGIC := '0';
  SIGNAL vector_zeros: STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0) := (others => '0');

BEGIN


gen: for i in 0 to Dwidth-1 generate
	 B_in(i) <= NOT B(i) WHEN OPC = "0001" ELSE B(i); -- for subtraction
     end generate gen;


  L0: Adder port map(
    a => A,
    b => B_in,
    cin => OPC(0), ----- 0000 + , 0001 - 
    S => AdderSub_out,
    cout => cout_tmp
  );

  


---Y_Shifter_i,X_Shifter_i,ALUFN,Shifter_o,Shifter_cout
   shiftl: Shifter generic map(Dwidth,4,15) port map(
    Y_Shifter_i => A,
    X_Shifter_i => B,
    ALUFN => "000" , ----- 0SHL
    Shifter_o => C_TEMP_shl,
    Shifter_cout => cout_tmp_shl
  );
  
   C_and <= A and B;
   C_or <= A OR B;
   C_xor <= A XOR B;
------------------------------------------------------------------------------------------
	


	C  <= AdderSub_out when (OPC = "0000" or OPC = "0001" OR  OPC = "1110") else 
	        C_and when (OPC = "0010" ) else   --AND
            C_or when ( OPC = "0011") else  ---or
	         C_xor when ( OPC = "0100") else -- xor
			 C_TEMP_shl when  (OPC = "0101") else -- shl
			  unaffected;  ---else
			 
			 
	CFlag <= '0' when RST ='1' else
	         cout_tmp when ((OPC = "0000") or (OPC = "0001" )) else 
	         cout_tmp_shl when (OPC = "0101" ) else unaffected; -- Get carry of the last FA ;
			 
			 
			 
			 
	Nflag <= '0' when RST ='1' else
	         AdderSub_out(Dwidth-1) when (OPC = "0000" ) else 
	         C_and(Dwidth-1) when (OPC = "0010" ) else 
			 C_or(Dwidth-1) when (OPC = "0011" ) else 
			 C_xor(Dwidth-1) when (OPC = "0100" ) else
			 C_TEMP_shl(Dwidth-1) when (OPC = "0101" ) else unaffected;



	process(A,B,OPC)
	begin
		
		if (OPC = "0000" or OPC = "0010")  then
		    if AdderSub_out = vector_zeros then
				Zflag <= '1';
			ELSE
				Zflag <= '0';
			END IF;
			
		elsif (rst ='1') then 	
		   		Zflag <= '0';

		
		elsif (OPC = "0010") then 
		    if (C_and = vector_zeros) then	
		   		Zflag <= '1';
			ELSE
				Zflag <= '0';
			END IF;
			
		elsif (OPC = "0011") then 
		    if (C_or) = vector_zeros THEN 
		   		Zflag <= '1';
		    ELSE
				Zflag <= '0';
			END IF;
			
		elsif (OPC = "0100") then 
		    if (C_xor) = vector_zeros then
		   		Zflag <= '1';
		    ELSE
				Zflag <= '0';
		    END IF;
		elsif (OPC = "0101") then 
		    if C_TEMP_shl = vector_zeros then
		   		Zflag <= '1';
			ELSE
				Zflag <= '0';
			END IF;
		
		end IF;
	end process;	







END ALU_arch;
