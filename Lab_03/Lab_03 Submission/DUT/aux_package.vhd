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

----------------ALU---------------------------------------	

	component ALU IS
	GENERIC (Dwidth: integer:=16);
	PORT (A, B: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          OPC: IN STD_LOGIC_VECTOR (3 downto 0);

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
			 Awidth: integer:=4;
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
		generic( Dwidth: integer:=16 );
		port(   Dout_RF,Dout_C,Dout_imm1,D_out_imm2,Dout_DTCM: 	in 	std_logic_vector(Dwidth-1 downto 0);
				RFout,RFin,Cout,Imm1_in,Imm2_in,Mem_out:		in 	std_logic;
				Din:	out		std_logic_vector(Dwidth-1 downto 0);
				IOpin: 	inout 	std_logic_vector(Dwidth-1 downto 0)
		);
	end component;



--------------------control unit---------------------------------------
	component Control_Unit is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4);
	port(	rst,ena,clk: in std_logic;	---  signals from top
			add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: --- signals from data path
						  in std_logic;
			IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: --- signals to data path
						 out std_logic;
			OPC:  out std_logic_vector(Dwidth-1 downto 0); --- signals to data path
			Pcsel,RFaddr:		 out std_logic_vector(1 downto 0); --- signals to data path
			done_Out:    out std_logic	---  signal to top
	);
	end component;
	
--------------------Decoder---------------------------------------

	component Decoder is
		generic( Dwidth: integer:=16;
				 Awidth: integer:=4);
		port(   Din_Decoder:   in std_logic_vector(Awidth-1 downto 0);
				add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done:  out std_logic		
		);
	end component;
	

end aux_package;
