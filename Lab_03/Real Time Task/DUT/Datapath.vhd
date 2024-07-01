library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
use ieee.std_logic_textio.all; -- For text I/O operations, if needed for report
use std.textio.all;
use ieee.numeric_std.all;
-----------------------------------------------------------------
entity Datapath is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4;
			 dept:   integer:=64;
			 Awidth_DTCM:   integer:=6);
	port(  
       ----- signals from the control unit ------
            IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: 
				   	      in std_logic;
			OPC:          in std_logic_vector(Awidth-1 downto 0); 
			Pcsel,RFaddr: in std_logic_vector(1 downto 0); 

       ----- signals from the TB ------

             ----general----
		    clk,memEn_ITCM,memEn_DTCM,rst,TBactive:           in std_logic;
			  ----ITCM-----
		    ITCM_Wr_Data:   in std_logic_vector(Dwidth-1 downto 0);
			ITCM_Wr_Add:	 in std_logic_vector(Awidth_DTCM-1 downto 0);

			  ----DTCM-----
			DTCM_Wr_Add,DTCM_Rd_Add:	
					in std_logic_vector(Awidth_DTCM-1 downto 0);
			DTCM_Wr_data:	in std_logic_vector(Dwidth-1 downto 0);
       ----- signals to the control unit ------
		    add,sub,and_in,or_in,xor_in,shl,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: 
					      out std_logic;
			DataOUT_DTCM: out std_logic_vector(Dwidth-1 downto 0)
	);
end Datapath;

----------------------------------------------------------------------------
architecture dataflow of Datapath is
	signal BUS_Datapath: std_logic_vector(Dwidth-1 downto 0); ------ BUS
	signal ITCM_to_IR: std_logic_vector(Dwidth-1 downto 0); ------ the data drom ITCM to IR
	signal IR_data: std_logic_vector(Dwidth-1 downto 0); ------ the data in IR
	signal RFadder_out: std_logic_vector(Awidth-1 downto 0); ------ the data from RFadder
	signal Dout_RF: std_logic_vector(Dwidth-1 downto 0); ------ the data from RFadder
	signal A_to_ALU: std_logic_vector(Dwidth-1 downto 0); ------ A ==> ALU	
	signal ALU_to_C: std_logic_vector(Dwidth-1 downto 0); ------ ALU ==> C		
	signal Dout_C: std_logic_vector(Dwidth-1 downto 0); ------ C => BUS	
	signal Dout_imm1: std_logic_vector(Dwidth-1 downto 0); ------ imm1 => BUS	
	signal Dout_imm2: std_logic_vector(Dwidth-1 downto 0); ------ imm2 => BUS	
	signal Dout_PCreg: std_logic_vector(Dwidth-1 downto 0); ------ PC adress	
	signal Dout_Csel: std_logic_vector(Dwidth-1 downto 0); ------ PC next adress	
	signal Dout_DTCM: std_logic_vector(Dwidth-1 downto 0); ------ data memory out to the bus	
    signal Din_adrr_DTCM: STD_logic_vector(Dwidth-1 downto 0); ------ data ADRESS FROM THE BUS TO FF
	signal PC_sel_in: STD_logic_vector(Dwidth-1 downto 0); ------ Dout_pc_REG => Din pcSEL 
	signal BUS_to_B: STD_logic_vector(Dwidth-1 downto 0):= (OTHERS =>'0');  --- bus => B 
	signal BUS_to_DTCM: STD_logic_vector(Dwidth-1 downto 0);  --- bus => DTCM
	signal BUS_to_RF: STD_logic_vector(Dwidth-1 downto 0);  --- bus => RF



           --------DATA MEMORY SIGNALS FOR MUX
	signal readAddr_DTCM: std_logic_vector(Awidth_DTCM -1 downto 0); ------ data memory out to the bus	
	signal writAddr_DTCM: std_logic_vector(Awidth_DTCM -1 downto 0); ------ data memory out to the bus	
	signal datain_DTCM: std_logic_vector(Dwidth-1 downto 0); ------ data memory out to the bus
	signal wre_DTCM: std_logic; ------ data memory out to the bus

	

begin 
DataOUT_DTCM <= Dout_DTCM; -- Default initialization

--process(clk)
  --  begin
--	-	if (rising_edge(clk) and clk ='1') then
---			report " PC: " & to_string(Dout_PCreg) & 
--			
--			       " IR: " & to_string(IR_data) & 
--			       " DourRF: " & to_string(RFadder_out) & 
--			       " BUS_Datapath: " & to_string(BUS_Datapath)&
--				   " read_Adrees _DTCM: " & to_string(readAddr_DTCM)&
--				   " A : " & to_string(A_to_ALU)&
--				   " B: " & to_string(BUS_to_B)&
--				   " ALU RSULT : " & to_string(ALU_to_C)&
--			        " C TO BUS : " & to_string(Dout_C)&
--				    " BUS to DTCM : " & to_string(BUS_to_DTCM)&   
--					"                  BUS_to_RF : " & to_string(BUS_to_RF)
	               
				   
--		    severity NOTE;

--		end if;
--    end process;


----------------------------------------------------------------------------
----------------------INTERNAL-----------------------------------------------

-----------------BUS CONECTION --------------------------------------------
----: BidirPin generic map(Dwidth) port map(Dout,en,Din,IOpin);	
busRF: BidirPin generic map(Dwidth) port map(Dout_RF,RFout,BUS_to_RF,BUS_Datapath); 															
bus_imm_1: BidirPin generic map(Dwidth) port map(Dout_imm1,Imm1_in,BUS_to_RF,BUS_Datapath);																			
bus_imm_2: BidirPin generic map(Dwidth) port map(Dout_imm2,Imm2_in,BUS_to_RF,BUS_Datapath);																			
bus_Cout: BidirPin generic map(Dwidth) port map(Dout_C,Cout,BUS_to_B,BUS_Datapath);																			
DTCM_OUT: BidirPin generic map(Dwidth) port map(Dout_DTCM,Mem_out,BUS_to_DTCM,BUS_Datapath);	






----------------------IR -------------------------------------------------
IR: reg generic map(Dwidth) port map(ITCM_to_IR,IRin,clk,IR_data);  

----------------------RFadder -------------------------------------------------
RFadd: RFadder generic map(Dwidth,Awidth) port map(IR_data(11 downto 8),IR_data(7 downto 4),IR_data(3 downto 0),RFaddr,RFadder_out);  

----------------------RF -------------------------------------------------
RF_reg: RF generic map(Dwidth,Awidth) port map(clk,rst,RFin,BUS_to_RF,RFadder_out,RFadder_out,Dout_RF);  

----------------------REGISTER A -------------------------------------------------
regA: reg generic map(Dwidth) port map(BUS_Datapath,Ain,clk,A_to_ALU);  
----------------------ALU -------------------------------------------------
ALU0: ALU generic map(Dwidth) port map(A_to_ALU,BUS_to_B,OPC,rst,ALU_to_C,Cflag,Zflag,Nflag);  

----------------------REGISTER C -------------------------------------------------
regC: reg generic map(Dwidth) port map(ALU_to_C,Cin,clk,Dout_C);  

----------------------sign ext 1 -------------------------------------------------
Dout_imm1 <= (IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7 downto 0));   ---- extend IR<7..0> to 16 bit

----------------------sign ext 2 -------------------------------------------------
Dout_imm2 <= IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3 downto 0); --- extend IR<3..0> to 16 bit

-----------------------Decoder----------------------------------------------------
decod: Decoder generic map(Dwidth,Awidth) port map(IR_data(15 downto 12),add,sub,and_in,or_in,xor_in,shl,jmp,jc,jnc,mov,ld,str,done);  

-----------------------PC registet----------------------------------------------------
regPC: reg generic map(Dwidth) port map(Dout_Csel,PCin,clk,Dout_PCreg);  
PC_sel_in <= Dout_PCreg;

-----------------------PC cel----------------------------------------------------
---- Din_PCsel,IRdata,PCsel,Dout_PCsel
PCsl: PC generic map(Dwidth,Awidth) port map(PC_sel_in,IR_data(7 downto 0),Pcsel,Dout_Csel);  

-----------------------progMEM - ITCM----------------------------------------------------
--port(	clk, memEn, WmemData, WmemAddr, RmemAddr, RmemDat)	
ProgM: ProgMem port map(clk, memEn_ITCM, ITCM_Wr_Data,ITCM_Wr_Add, Dout_PCreg(Awidth_DTCM-1  downto 0), ITCM_to_IR); 


-----------------------dataMEM - DTCM----------------------------------------------------

	readAddr_DTCM <= DTCM_Rd_Add when (TBactive = '1')  else  ------ adress from TB or BUS
		             BUS_to_DTCM(Awidth_DTCM-1 DOWNTO 0);

     ------ WRITE ADRESS -----
	process(clk)       --- synchronized
    begin
	 if (clk'event and clk='1') then
		if 	(Mem_in ='1') then
		   Din_adrr_DTCM <= BUS_Datapath;
		end if;
	 end if;
    end process;

  	writAddr_DTCM <= DTCM_Wr_Add when TBactive = '1'  else  ------ adress from TB or BUS
		             Din_adrr_DTCM(Awidth_DTCM-1 DOWNTO 0) ;

	datain_DTCM <= DTCM_Wr_data when TBactive = '1'  else  ------ adress from TB or BUS
		            BUS_Datapath ;

    wre_DTCM    <= memEn_DTCM when TBactive = '1'  else  ------ adress from TB or BUS
		            Mem_wr ;


dataM: dataMEM  port map(clk,wre_DTCM,datain_DTCM,writAddr_DTCM,readAddr_DTCM,Dout_DTCM);  





end dataflow;

