library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
use ieee.std_logic_textio.all; -- For text I/O operations, if needed for report
use std.textio.all;
use ieee.numeric_std.all;
-----------------------------------------------------------------
entity top is
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
			ITCM_Wr_Add:	 in std_logic_vector(Awidth_DTCM-1 downto 0);

			  ----DTCM-----
			DTCM_Wr_Add,DTCM_Rd_Add: in std_logic_vector(Awidth_DTCM-1 downto 0);
			DTCM_Wr_data: in std_logic_vector(Dwidth-1 downto 0);
			DataOUT_DTCM: out std_logic_vector(Dwidth-1 downto 0);
			done_Out: out std_logic :='0'
	);
end top;

----------------------------------------------------------------------------
architecture dataflow of top is

------------- signals from control unit to datapath: ----------------
SIGNAL IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: std_logic;
SIGNAL OPC: std_logic_vector(Awidth-1 downto 0);
SIGNAL Pcsel,RFaddr: std_logic_vector(1 downto 0);
SIGNAL done_FSM: std_logic;


------------- signals from datapath to control unit: ----------------
SIGNAL add, sub, and_in, or_in, xor_in, jmp, jc, jnc, mov, ld, str, Nflag, Zflag, Cflag,shl: std_logic;




BEGIN 
----------------------Wireing CONTROL UNIT-----------------------------------------------
	--port(rst, ena, clk, add, sub, and_in, or_in, xor_in, jmp, jc, jnc,mov,ld,str,done,Nflag,Zflag,Cflag,
		--IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr
		--OPC, Pcsel,RFaddr, done_Out)
	cntrl_unit: Control_Unit generic map(Dwidth,Awidth) port map(rst, en, clk, add, sub, and_in, or_in, xor_in,shl, jmp, jc, jnc,mov,ld,str,done_FSM,Nflag,Zflag,Cflag,
		IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr,
		OPC,Pcsel,RFaddr,done_Out);

----------------------Wireing datapath-----------------------------------------------
	--port(IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr, 
		--OPC, Pcsel,RFaddr
		-- clk,memEn_ITCM,memEn_DTCM,rst,TBactive
		-- ITCM_Wr_Data, ITCM_Wr_Add
		--DTCM_Wr_Add,DTCM_Rd_Add		
			--DTCM_Wr_data
		    --add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: 
				--DataOUT_DTCM )

	data_path: Datapath generic map(Dwidth,Awidth,dept,Awidth_DTCM) port map(
		IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr, 
		OPC, Pcsel,RFaddr,
		clk,memEn_ITCM,memEn_DTCM,rst,TBactive,
		ITCM_Wr_Data, ITCM_Wr_Add,
		DTCM_Wr_Add,DTCM_Rd_Add,		
		DTCM_Wr_data,
		add,sub,and_in,or_in,xor_in,shl,jmp,jc,jnc,mov,ld,str,done_FSM,Nflag,Zflag,Cflag,
		DataOUT_DTCM
	);



end dataflow;

