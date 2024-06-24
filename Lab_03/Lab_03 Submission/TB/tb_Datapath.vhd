library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
---------------------------------------------------------
entity tb_Datapath is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4;
			 dept:   integer:=64);

			 constant dataMemResult:	 	string(1 to 81) :=
				"D:\Arch_Lab\Lab_03\Lab_03 Submission\Code and binary memory files\DTCMcontent.txt";
	
			constant dataMemLocation: 	string(1 to 78) :=
			"D:\Arch_Lab\Lab_03\Lab_03 Submission\Code and binary memory files\DTCMinit.txt";
	
			constant progMemLocation: 	string(1 to 86) :=
			"D:\Arch_Lab\Lab_03\Lab_03 Submission\Code and binary memory files\ITCMinitDatapath.txt";
end tb_Datapath;
---------------------------------------------------------
architecture rtb of tb_Datapath is

	SIGNAL IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: std_logic;
	SIGNAL OPC: std_logic_vector(Dwidth-1 downto 0);
	SIGNAL Pcsel,RFaddr: std_logic_vector(1 downto 0);
	SIGNAL clk,memEn_ITCM,memEn_DTCM,rst,TBactive: std_logic;
	SIGNAL WmemData_ITCM: std_logic_vector(Dwidth-1 downto 0);
	SIGNAL WmemAddr_ITCM: std_logic_vector(Awidth-1 downto 0);
	SIGNAL WmemAddr_DTCM,RmemAddr_DTCM: std_logic_vector(Dwidth-1 downto 0);
	SIGNAL WmemData_DTCM: std_logic_vector(Dwidth-1 downto 0);
	SIGNAL add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: std_logic;
	SIGNAL DataOUT_DTCM: std_logic_vector(Dwidth-1 downto 0);


signal	done_FSM : std_logic;
signal 		TBWrEnProgMem, TBWrEnDataMem : std_logic;
signal 		TBdataInDataMem    : std_logic_vector(Dwidth-1 downto 0);
signal 		TBdataInProgMem    : std_logic_vector(Dwidth-1 downto 0);
signal 		TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem : std_logic_vector(Awidth-1 downto 0);
signal 		TBdataOutDataMem   : std_logic_vector(Dwidth-1 downto 0);
signal 	    donePmemIn, doneDmemIn:	 BOOLEAN;
signal 		DebugSignal		 : std_logic_vector(Dwidth-1 downto 0);


    --    ----- signals from the control unit ------
    --         IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: 
	-- 			   	      in std_logic;
	-- 		OPC:          in std_logic_vector(Dwidth-1 downto 0); 
	-- 		Pcsel,RFaddr: in std_logic_vector(1 downto 0); 

    --    ----- signals from the TB ------

    --          ----general----
	-- 	    clk,memEn_ITCM,memEn_DTCM,rst,TBactive:           in std_logic;
	-- 		  ----ITCM-----
	-- 	    WmemData_ITCM:   in std_logic_vector(Dwidth-1 downto 0);
	-- 		WmemAddr_ITCM:	 in std_logic_vector(Awidth-1 downto 0);

	-- 		  ----DTCM-----
	-- 		WmemAddr_DTCM,RmemAddr_DTCM:	
	-- 				in std_logic_vector(Dwidth-1 downto 0);
	-- 		WmemData_DTCM:	in std_logic_vector(Dwidth-1 downto 0);
    --    ----- signals to the control unit ------
	-- 	    add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: 
	-- 				      out std_logic;
	-- 		DataOUT_DTCM: out std_logic_vector(Dwidth-1 downto 0);
	
begin

D0: Datapath generic map (Dwidth, Awidth, dept) port map(
	IRin => IRin,
	Pcin => Pcin,
	RFout => RFout,
	RFin => RFin,
	Ain => Ain,
	Cin => Cin,
	Cout => Cout,
	Imm1_in => Imm1_in,
	Imm2_in => Imm2_in,
	Mem_in => Mem_in,
	Mem_out => Mem_out,
	Mem_wr => Mem_wr,
	OPC => OPC,
	Pcsel => Pcsel,
	RFaddr => RFaddr,
	clk => clk,
	memEn_ITCM => memEn_ITCM,
	memEn_DTCM => memEn_DTCM,
	rst => rst,
	TBactive => TBactive,
	WmemData_ITCM => WmemData_ITCM,
	WmemAddr_ITCM => WmemAddr_ITCM,
	WmemAddr_DTCM => WmemAddr_DTCM,
	RmemAddr_DTCM => RmemAddr_DTCM,
	WmemData_DTCM => WmemData_DTCM,
	add => add,
	sub => sub,
	and_in => and_in,
	or_in => or_in,
	xor_in => xor_in,
	jmp => jmp,
	jc => jc,
	jnc => jnc,
	mov => mov,
	ld => ld,
	str => str,
	done => done,
	Nflag => Nflag,
	Zflag => Zflag,
	Cflag => Cflag,
	DataOUT_DTCM => DataOUT_DTCM
	);



--------- Clock
gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;

--------- Rst
gen_rst : process
        begin
		  rst <='1','0' after 100 ns;
		  wait;
        end process;	
--------- TB
gen_TB : process
	begin
	 TBactive <= '1';
	 wait until donePmemIn and doneDmemIn;  
	 TBactive <= '0';
	 wait until done_FSM = '1';  
	 TBactive <= '1';	
	end process;	
	
	
--------- Reading from text file and initializing the data memory data--------------
LoadDataMem:process 
	file inDmemfile : text open read_mode is dataMemLocation;
	variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
	variable	good				: boolean;
	variable 	L 					: line;
	variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; 
begin 
	doneDmemIn <= false;
	TempAddresses := (others => '0');
	while not endfile(inDmemfile) loop
		readline(inDmemfile,L);
		hread(L,linetomem,good);
		next when not good;
		TBWrEnDataMem <= '1';
		TBWrAddrDataMem <= TempAddresses;
		TBdataInDataMem <= linetomem;
		wait until rising_edge(clk);
		TempAddresses := TempAddresses +1;
	end loop ;
	TBWrEnDataMem <= '0';
	doneDmemIn <= true;
	file_close(inDmemfile);
	wait;
end process;
	
	
--------- Reading from text file and initializing the program memory instructions	
LoadProgramMem:process 
	file inPmemfile : text open read_mode is progMemLocation;
	variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
	variable	good				: boolean;
	variable 	L 					: line;
	variable	TempAddresses		: std_logic_vector(Awidth-1 downto 0) ; -- Awidth
begin 
	donePmemIn <= false;
	TempAddresses := (others => '0');
	while not endfile(inPmemfile) loop
		readline(inPmemfile,L);
		hread(L,linetomem,good);
		next when not good;
		TBWrEnProgMem <= '1';	
		TBWrAddrProgMem <= TempAddresses;
		TBdataInProgMem <= linetomem;
		wait until rising_edge(clk);
		TempAddresses := TempAddresses +1;
	end loop ;
	TBWrEnProgMem <= '0';
	donePmemIn <= true;
	file_close(inPmemfile);
	wait;
end process;

--------- Tested code: ---------
-- data segment:
-- arr dc16 20,11,2,23,14,35,6,7,48,39,10,11,12,13
-- res ds16 1

-- code segment:	-- reset_state. state0 - fetch. state1 - decode.
-- ld  r1,4(r0)		-- state4, state5, state6 - execute ld
-- ld  r2,8(r0)		-- state0 - fetch. state1 - decode. state4, state5, state6 - execute ld.
-- mov r3,31		-- state0 - fetch. state1 - decode. state8 - execute mov.
-- mov r4,1			-- state0 - fetch. state1 - decode. state8 - execute mov.
-- and r1,r1,r3		-- state0 - fetch. state1 - decode. state2, state 3 - execute and.
-- and r2,r2,r3		-- state0 - fetch. state1 - decode. state2, state 3 - execute and.
-- sub r6,r2,r1     -- state0 - fetch. state1 - decode. state2, state 3 - execute sub.
-- jc  2			-- carry flag is off.
-- add r6,r1,r0		-- state0 - fetch. state1 - decode. state2, state 3 - execute add.
-- jmp 1			-- state0 - fetch. state1 - decode. state8 - execute jmp.
-- add r6,r0,r0    -- state0 - fetch. state1 - decode. state2, state 3 - execute add.
-- st  r6,14(r0)	-- state0 - fetch. state1 - decode. state4, state5, state7 - execute st.
-- done				
-- nop 
-- jmp -2			-- state0 - fetch. state1 - decode. state8 - execute jmp.

---

--------- Start Test Bench ---------------------
StartTb : process
	begin
	
		wait until donePmemIn and doneDmemIn;  

------------- Reset state ------------------------		
	 
		wait until clk'EVENT and clk='1';
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; -- ALU unaffected
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "00";   -- RF unaffected
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";  -- PC = zeros 
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

-----------------states of:	ld r1,4(r0)	-----------------------------

------------- state0: Fetch ------------------------
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
------------- state1: Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
-------------state4: Load  ------------------------

		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '1';
-------------state5: Load  ------------------------
		wait until clk'EVENT and clk='1'; 
		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		Mem_out	 <= '0';  
		RFin	 <= '0'; 
		RFout	 <= '0'; 
		Mem_wr	 <= '0';
		Mem_in	 <= '0';
------------- state6: Load ------------------------
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_wr	 <= '0'; 
		Mem_out	 <= '1';  
		RFin	 <= '1';
		RFout 	 <= '0';

--------------states of: ld  r2,8(r0)	---------------------	
------------- state0: Fetch ------------------------		
		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

-------------state1: Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				

-------------state4: Load  ------------------------

		wait until clk'EVENT and clk='1'; 
		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '1';
-------------state5: Load  ------------------------
		wait until clk'EVENT and clk='1'; 
		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		Mem_out	 <= '0';  
		RFin	 <= '0'; 
		RFout	 <= '0'; 
		Mem_wr	 <= '0';
		Mem_in	 <= '0';
-------------state6: Load  ------------------------

		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_wr	 <= '0'; 
		Mem_out	 <= '1';  
		RFin	 <= '1';
		RFout 	 <= '0';

---------------------- states for:  mov r3,31-----------------------------
------------- state0: Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

-------------state1: Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				

------------- Load  ------------------------
-- ItypeState0
		wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '1';
------------- Load  ------------------------
-- ItypeState1
		wait until clk'EVENT and clk='1'; 		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		Mem_out	 <= '0';  
		RFin	 <= '0'; 
		RFout	 <= '0'; 
		Mem_wr	 <= '0';
		Mem_in	 <= '0';
------------- Load  ------------------------
-- ItypeState2
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_wr	 <= '0'; 
		Mem_out	 <= '1';  
		RFin	 <= '1';
		RFout 	 <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Load - 9D0D-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				

------------- Load  ------------------------
-- ItypeState0
		wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '1';
------------- Load  ------------------------
-- ItypeState1
		wait until clk'EVENT and clk='1'; 		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		Mem_out	 <= '0';  
		RFin	 <= '0'; 
		RFout	 <= '0'; 
		Mem_wr	 <= '0';
		Mem_in	 <= '0';
------------- Load  ------------------------
-- ItypeState2
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_wr	 <= '0'; 
		Mem_out	 <= '1';  
		RFin	 <= '1';
		RFout 	 <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Mov - 8101-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode - Mov ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0'; 
		RFin	 <= '1';
		RFout	 <= '0';  
		RFaddr	 <= "10";  
		IRin 	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";				
		Imm1_in	 <= '1';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
-------------------------------------------------------------------------------
---------------------- Instruction For Add - 022D-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Add -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC <= "0000";
------------- Add -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Add - 0349-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Add -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC <= "0000";
------------- Add -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Add - 1623-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Sub -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC 	 <= "0001";
------------- Sub -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
-------------------------------------------------------------------------------
---------------------- Instruction For Add - 0610-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01";  
		IRin 	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";				
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				
------------- Add -----------------------------	
--RtypeState0
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
        Cout	 <= '0';
        Cin	 	 <= '1'; 
        Ain	 	 <= '0';
        RFin	 <= '0';
        RFout	 <= '1'; 
        RFaddr	 <= "00";
        IRin	 <= '0';
        PCin	 <= '0';
        PCsel	 <= "01";
        Imm1_in	 <= '0';
        Imm2_in	 <= '0';
        Mem_out	 <= '0';
        Mem_in	 <= '0';
        done_FSM  <= '0';
		OPC 	 <= "0000";
------------- Add -----------------------------	
--RtypeState1
    	wait until clk'EVENT and clk='1'; 
		Mem_wr	 <= '0';
		Cout	 <= '1';  
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '1';
		RFout	 <= '0';
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

-------------------------------------------------------------------------------
---------------------- Instruction For Store - A60E-----------------------------
------------- Fetch ------------------------	
		wait until clk'EVENT and clk='1';		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "11";   
		IRin	 <= '1';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';

------------- Decode ------------------------	
    	wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '1'; 
		RFin	 <= '0';
		RFout	 <= '1';  
		RFaddr	 <= "01"; 
		PCsel	 <= "01";		
		IRin 	 <= '0';
		PCin	 <= '0';	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';				

------------- Store  ------------------------
-- ItypeState0
		wait until clk'EVENT and clk='1'; 		
		Mem_wr	 <= '0';
		Cout	 <= '0'; 
		Cin	 	 <= '1';
		OPC	 	 <= "0000"; 	
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "10";  		 
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '1';
		Mem_out	 <= '0';			
		done_FSM  <= '0';
		Mem_in	 <= '0';
------------- Store  ------------------------
-- ItypeState1
		wait until clk'EVENT and clk='1'; 		
		Cout	 <= '1'; 
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '0';
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';				
		done_FSM  <= '0';
		RFout	 <= '0'; 
		Mem_wr	 <= '0'; 
		RFin	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '1';  
------------- Store  ------------------------
-- ItypeState2
		wait until clk'EVENT and clk='1'; 
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; 
		Ain	 	 <= '0';				
		RFaddr	 <= "10";   
		IRin	 <= '0';
		PCin	 <= '1';	
		PCsel	 <= "01";	
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '0';
		Mem_out	 <= '0';	
		RFout	 <= '1'; 
		Mem_wr	 <= '1'; 
		RFin	 <= '0';

--******************************************************************

------------- End: go back to reset---------------------------------	
------------- Reset ------------------------		
		wait until clk'EVENT and clk='1';
		Mem_wr	 <= '0';
		Cout	 <= '0';
		Cin	 	 <= '0';
		OPC	 	 <= "1111"; -- ALU unaffected
		Ain	 	 <= '0';
		RFin	 <= '0';
		RFout	 <= '0';
		RFaddr	 <= "00";   -- RF unaffected
		IRin	 <= '0';
		PCin	 <= '1';
		PCsel	 <= "11";  -- PC = zeros 
		Imm1_in	 <= '0';
		Imm2_in	 <= '0';
		Mem_out	 <= '0';
		Mem_in	 <= '0';
		done_FSM  <= '1';
		wait;
		
	end process;	




	--------- Writing from Data memory to external text file, after the program ends (done_FSM = 1).
	
	WriteToDataMem:process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: STD_LOGIC_VECTOR(Dwidth-1 downto 0);
		variable	good				: BOOLEAN;
		variable 	L 					: LINE;
		variable	TempAddresses		: STD_LOGIC_VECTOR(Awidth-1 downto 0) ; 
		variable 	counter				: INTEGER;
	begin 

		wait until done_FSM = '1';  
		TempAddresses := (others => '0');
		counter := 1;
		while counter < 16 loop	--15 lines in file
			TBRdAddrDataMem <= TempAddresses;
			wait until rising_edge(clk);   -- 
			wait until rising_edge(clk); -- 
			linetomem := TBdataOutDataMem;   --
			hwrite(L,linetomem);
			writeline(outDmemfile,L);
			TempAddresses := TempAddresses +1;
			counter := counter +1;
		end loop ;
		file_close(outDmemfile);
		wait;
	end process;

end rtb;
	


