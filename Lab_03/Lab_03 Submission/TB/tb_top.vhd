library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
---------------------------------------------------------
entity tb_top is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4;
			 dept:   integer:=64;
			 Awidth_DTCM:   integer:=6);
 --Ofir:
			  constant dataMemResult:	 	string(1 to 45) :=
			 "C:\Users\USER\Desktop\CPU\CPU\DTCMcontent.txt";
	
			  constant dataMemLocation: 	string(1 to 42) :=
		     "C:\Users\USER\Desktop\CPU\CPU\DTCMinit.txt";
	
			  constant progMemLocation: 	string(1 to 42) :=
			 "C:\Users\USER\Desktop\CPU\CPU\ITCMinit.txt";

-- Itamar:
		--	constant dataMemResult:	 	string(1 to 39) :=
		--	"C:\Users\Itamar\Desktop\DTCMcontent.txt";
	
		--	constant dataMemLocation: 	string(1 to 36) :=
		--	"C:\Users\Itamar\Desktop\DTCMinit.txt";
	
		--	constant progMemLocation: 	string(1 to 36) :=
		--	"C:\Users\Itamar\Desktop\ITCMinit.txt";

end tb_top;
---------------------------------------------------------
architecture rtb of tb_top is


signal		done_FSM, TBactive, clk, en, rst : std_logic;
signal 		TBWrEnProgMem, TBWrEnDataMem : std_logic;
signal 		TBdataInDataMem    : std_logic_vector(Dwidth-1 downto 0);
signal 		TBdataInProgMem    : std_logic_vector(Dwidth-1 downto 0);

signal 		TBWrAddrProgMem : std_logic_vector(Awidth_DTCM-1 downto 0); 
signal      TBWrAddrDataMem, TBRdAddrDataMem : std_logic_vector(Awidth_DTCM-1 downto 0);
signal 		TBdataOutDataMem   : std_logic_vector(Dwidth-1 downto 0);
signal 	    donePmemIn, doneDmemIn:	 BOOLEAN;


	
begin


--------------Top instantiation --------------------

--port( done(out),
     --clk,memEn_ITCM,memEn_DTCM,rst,TBactive, en,
	--ITCM_Wr_Data
	--ITCM_Wr_Add
	--DTCM_Wr_Add,DTCM_Rd_Add
	--DTCM_Wr_data
	--DataOUT_DTCM

top0: top generic map (Dwidth, Awidth,dept,Awidth_DTCM) port map( 
	clk => clk,
	memEn_ITCM => TBWrEnProgMem,
	memEn_DTCM => TBWrEnDataMem,
	rst => rst,
	TBactive => TBactive,
	en => en,
	ITCM_Wr_Data => TBdataInProgMem,
	ITCM_Wr_Add => TBWrAddrProgMem,
	DTCM_Wr_Add => TBWrAddrDataMem,
	DTCM_Rd_Add => TBRdAddrDataMem,
	DTCM_Wr_data => TBdataInDataMem,
	DataOUT_DTCM => TBdataOutDataMem,
	done_Out => done_FSM
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
	variable	TempAddresses		: std_logic_vector(Awidth_DTCM-1 downto 0) ; 
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
	variable	TempAddresses		: std_logic_vector(Awidth_DTCM-1 downto 0) ; -- Awidth
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

en <= '1' when (doneDmemIn and donePmemIn) else '0';



	--------- Writing from Data memory to external text file, after the program ends (done_FSM = 1).
	
	WriteToDataMem:process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: STD_LOGIC_VECTOR(Dwidth-1 downto 0);
		variable	good				: BOOLEAN;
		variable 	L 					: LINE;
		variable	TempAddresses		: STD_LOGIC_VECTOR(Awidth_DTCM-1 downto 0) ; 
		variable 	counter				: INTEGER;
	begin 

		wait until done_FSM = '1';  
		TempAddresses := (others => '0');
		counter := 1;
		while counter < 64 loop	--15 lines in file
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
	


