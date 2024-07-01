library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity Datapath is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4;
			 dept:   integer:=64);
	port(  
       ----- signals from the control unit ------
            IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: 
				   	      in std_logic;
			OPC:          in std_logic_vector(Dwidth-1 downto 0); 
			Pcsel,RFaddr: in std_logic_vector(1 downto 0); 

       ----- signals from the TB ------

             ----general----
		    clk,ProgMem_Wr_En,DataMem_Wr_En,rst,TBactive:           in std_logic;
			  ----ITCM-----
		    ProgMem_Wr_Data:   in std_logic_vector(Dwidth-1 downto 0);
			ProgMem_Wr_Add:	 in std_logic_vector(Awidth-1 downto 0);

			  ----DTCM-----
			DataMem_Wr_Add,DataMem_Rd_Add:	
					in std_logic_vector(Dwidth-1 downto 0);
			DataMem_Wr_Data:	in std_logic_vector(Dwidth-1 downto 0);
       ----- signals to the control unit ------
		    add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: 
					      out std_logic;
			DataMem_DataOut: out std_logic_vector(Dwidth-1 downto 0)
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
	
           --------DATA MEMORY SIGNALS FOR MUX
	signal readAddr_DTCM: std_logic_vector(5 downto 0); ------ data memory out to the bus	
	signal writAddr_DTCM: std_logic_vector(5 downto 0); ------ data memory out to the bus	
	signal datain_DTCM: std_logic_vector(5 downto 0); ------ data memory out to the bus
	signal wre_DTCM: std_logic; ------ data memory out to the bus
	

begin 
----------------------------------------------------------------------------
----------------------INTERNAL-----------------------------------------------

-----------------BUS CONECTION --------------------------------------------

----------------------------------------- BiDir Bus ------------------------------------------
-- -- BidirPin            - (Dout, en, Din, IOpin), DOUT input of buffer, DIN input of module
 --BusConnectionToRF: BidirPin			generic map(Dwidth)	port map(Dout_RF, RFout, WDataRF, BUS_Datapath);
-- BusConnectionToALU: BidirPin		generic map(Dwidth)	port map(CregOut, Cout, B, BUS_Datapath); 
-- BusConnectionToDataMem: BidirPin	generic map(Dwidth)	port map(dataOutDataMem, Mem_out, RdAddrDataMem, BUS_Datapath);
-- BusConnectionToImm1: BidirPin		generic map(Dwidth)	port map(Immidiate, Imm1_in, WDataRF, BUS_Datapath);
-- BusConnectionToImm2: BidirPin		generic map(Dwidth)	port map(Immidiate, Imm2_in, WDataRF, BUS_Datapath);

-- -- Immidiate Sign Extention 
-- Immidiate <= 	SXT(IR_Immid, Dwidth) when Imm1_in ='1' else
-- 				"000000000000" & IR_Immid(RegSize-1 downto 0)		when Imm2_in = '1' else
-- 				unaffected;


busRF: BidirPin generic map(Dwidth) port map(Dout_RF,Dout_C,Dout_imm1,Dout_imm2,Dout_DTCM,
                                             RFout,RFin,Cout,Imm1_in,Imm2_in,Mem_out,BUS_Datapath); 

----------------------IR -------------------------------------------------
IR: reg generic map(Dwidth) port map(ITCM_to_IR,IRin,clk,IR_data);  

----------------------RFadder -------------------------------------------------
RFadd: RFadder generic map(Dwidth,Awidth) port map(IR_data(11 downto 8),IR_data(7 downto 4),IR_data(3 downto 0),RFaddr,RFadder_out);  

----------------------RF -------------------------------------------------
RF_reg: RF generic map(Dwidth,Awidth) port map(clk,rst,RFin,BUS_Datapath,RFadder_out,RFadder_out,Dout_RF);  

----------------------REGISTER A -------------------------------------------------
regA: reg generic map(Dwidth) port map(BUS_Datapath,Ain,clk,A_to_ALU);  

----------------------ALU -------------------------------------------------
ALU0: ALU generic map(Dwidth) port map(A_to_ALU,BUS_Datapath,OPC,ALU_to_C,Cflag,Zflag,Nflag);  

----------------------REGISTER C -------------------------------------------------
regC: reg generic map(Dwidth) port map(ALU_to_C,Cin,clk,Dout_C);  

----------------------sign ext 1 -------------------------------------------------
Dout_imm1 <= (IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7)&IR_data(7 downto 0));   ---- extend IR<7..0> to 16 bit

----------------------sign ext 2 -------------------------------------------------
Dout_imm1 <= IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3)&IR_data(3 downto 0); --- extend IR<3..0> to 16 bit

-----------------------Decoder----------------------------------------------------
decod: Decoder generic map(Dwidth,Awidth) port map(IR_data(15 downto 11),add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done);  

-----------------------PC registet----------------------------------------------------
regPC: reg generic map(Dwidth) port map(Dout_Csel,PCin,clk,Dout_PCreg);  

-----------------------PC cel----------------------------------------------------
PCsl: PC generic map(Dwidth,Awidth) port map(Dout_PCreg,IR_data(7 downto 0),Pcsel,Dout_Csel);  

-----------------------progMEM - ITCM----------------------------------------------------
ProgM: ProgMem port map(clk,ProgMem_Wr_En,ProgMem_Wr_Data,Dout_Csel(3 downto 0),ITCM_to_IR); 
-----------------------dataMEM - DTCM----------------------------------------------------

	readAddr_DTCM <= DataMem_Wr_Add when TBactive = '1'  else  ------ adress from TB or BUS
		             BUS_Datapath ;

     ------ WRITE ADRESS -----
	process(clk)       --- synchronized
    begin
	 if (clk'event and clk='1') then
		Din_adrr_DTCM <= BUS_Datapath;
	 end if;
    end process;

  	writAddr_DTCM <= DataMem_Wr_Add when TBactive = '1'  else  ------ adress from TB or BUS
		             Din_adrr_DTCM ;

	datain_DTCM <= DataMem_Wr_Data when TBactive = '1'  else  ------ adress from TB or BUS
		            BUS_Datapath ;

    wre_DTCM    <= DataMem_Wr_En when TBactive = '1'  else  ------ adress from TB or BUS
		            Mem_wr ;


dataM: dataMEM  port map(clk,wre_DTCM,datain_DTCM,writAddr_DTCM(5 downto 0),readAddr_DTCM(5 downto 0),Dout_DTCM);  









end dataflow;

