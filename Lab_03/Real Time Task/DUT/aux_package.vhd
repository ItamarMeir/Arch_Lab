library IEEE;
use ieee.std_logic_1164.all;
package aux_package is

---------------register---------------------------------
	component reg is
	generic( Dwidth: integer:=16 );
	port(   Din:    in     std_logic_vector(Dwidth-1 downto 0);
			en,clk: in     std_logic;		
			Dout:   out	std_logic_vector(Dwidth-1 downto 0)				
	);
	end component;


---------------registerMS---------------------------------

	component regMS is
		generic( width: integer:=16 );
		port(   Din:     	 in     std_logic_vector(width-1 downto 0);
				en_in,en_out,clk: in     std_logic;		
				Dout:        out	std_logic_vector(width-1 downto 0)				
		);
	end component;
----------------Adder---------------------------------------	
	component Adder is
	GENERIC (
        CONSTANT Dwidth: integer:=16
    );
    PORT (
        a, b: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          cin: IN STD_LOGIC;
            s: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
         cout: OUT STD_LOGIC );
	end component;
	
	----------------FA---------------------------------------	
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;

----------------ALU---------------------------------------	

	component ALU IS
	GENERIC (Dwidth: integer:=16);
	PORT (A, B: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          OPC: IN STD_LOGIC_VECTOR (3 downto 0);
		  rst: IN STD_LOGIC;

          C: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          Cflag, Zflag, Nflag: OUT STD_LOGIC);

	END component;





--------------------RFadder---------------------------------------

	component RFadder is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=4);
		port(   Din_RFadder_a,Din_RFadder_b,Din_RFadder_c:   in std_logic_vector(Awidth-1 downto 0);
				RFaddr: 						             in  std_logic_vector(1 downto 0);
				Dout_RFadder:                                out std_logic_vector(Awidth-1 downto 0)				
		);
	end component;
--------------------PC---------------------------------------
	component PC is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=4);
		port(  
				Din_PCsel: in std_logic_vector(Dwidth-1 downto 0);  ---- last PC value
				IRdata: in std_logic_vector(7 downto 0);
				PCsel: in std_logic_vector (1 downto 0);	---- signal from control
				Dout_PCsel:     out	std_logic_vector(Dwidth-1 downto 0) ------ the new valuefrom register pc to the ITCM			
		);
	end component;

--------------------RF---------------------------------------

	component RF is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4);
	port(	clk,rst,WregEn: in std_logic;	
			WregData:	in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RregData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;

--------------------progMEM - ITCM---------------------------------------
	component ProgMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;

--------------------dataMEM - DTCM---------------------------------------
	component dataMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;


--------------------BUS - BIDIRPIN---------------------------------------

	component BidirPin is
		generic( width: integer:=16 );
		port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
				en:		in 		std_logic;
				Din:	out		std_logic_vector(width-1 downto 0);
				IOpin: 	inout 	std_logic_vector(width-1 downto 0)
		);
	end component;



--------------------control unit---------------------------------------
	component Control_Unit is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4);
	port(	rst,ena,clk: in std_logic;	---  signals from top
			add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag,shl: --- signals from data path
						  in std_logic;
			IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: --- signals to data path
						 out std_logic;
			OPC:  out std_logic_vector(Awidth-1 downto 0); --- signals to data path
			Pcsel,RFaddr:		 out std_logic_vector(1 downto 0); --- signals to data path
			done_Out:    out std_logic	---  signal to top
	);
	end component;
	
--------------------Decoder---------------------------------------

	component Decoder is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=4);
		port(   Din_Decoder:   in std_logic_vector(Awidth-1 downto 0);
				add,sub,and_in,or_in,xor_in,shl,jmp,jc,jnc,mov,ld,str,done:  out std_logic		
		);
	end component;
	
--------------------Datapath---------------------------------------	
	component Datapath is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=4;
				 dept:   integer:=64;
				 Awidth_DTCM:   integer:=6);
		port(  
		   ----- signals from the control unit ------
				IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: 
							  in std_logic;
				OPC:          in std_logic_vector(Dwidth-1 downto 0); 
				Pcsel,RFaddr: in std_logic_vector(1 downto 0); 

		   ----- signals from the TB ------

				 ----general----
				clk,memEn_ITCM,memEn_DTCM,rst,TBactive:           in std_logic;
				  ----ITCM-----
				ITCM_Wr_Data:   in std_logic_vector(Dwidth-1 downto 0);
				ITCM_Wr_Add:	 in std_logic_vector(Awidth-1 downto 0);

				  ----DTCM-----
				DTCM_Wr_Add,DTCM_Rd_Add:	
						in std_logic_vector(Dwidth-1 downto 0);
				DTCM_Wr_data:	in std_logic_vector(Dwidth-1 downto 0);
		   ----- signals to the control unit ------
				add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag,shl: 
							  out std_logic;
				DataOUT_DTCM: out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
	-----------------top---------------------------------------
component top is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4;
			 dept:   integer:=64;
			 Awidth_DTCM:   integer:=6);
	port(  
			done: out std_logic;
       ----- signals from the TB ------

             ----general----
		    clk,memEn_ITCM,memEn_DTCM,rst,TBactive, en:           in std_logic;
			  ----ITCM-----
		    ITCM_Wr_Data:   in std_logic_vector(Dwidth-1 downto 0);
			ITCM_Wr_Add:	 in std_logic_vector(Awidth-1 downto 0);

			  ----DTCM-----
			DTCM_Wr_Add,DTCM_Rd_Add: in std_logic_vector(Awidth_DTCM-1 downto 0);
			DTCM_Wr_data: in std_logic_vector(Dwidth-1 downto 0);
			DataOUT_DTCM: out std_logic_vector(Dwidth-1 downto 0);
			done_Out: out std_logic
	);
end component;


	-----------------shifter---------------------------------------
component Shifter IS
	GENERIC (
			CONSTANT n : INTEGER := 16;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 4;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 15  -- 2^(k-1), here assumed to be 4
	);
	PORT (	
			Y_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0); -- Y input
        	X_Shifter_i: in  std_logic_vector(n-1 DOWNTO 0); -- X input
        	ALUFN: in STD_LOGIC_VECTOR (2 downto 0);		-- Shifter mode: for "000" shift left. for "001" shift right.
        	Shifter_o: out std_logic_vector(n-1 DOWNTO 0);	-- Shifter output
			Shifter_cout: out std_logic						-- Shifter carry output
		);
END component;
	
	
end aux_package;
