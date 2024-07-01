library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity top is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4;
			 dept:   integer:=64;
			 m: integer:=16
			 );
	port(  
		-- Clock
		top_clk: in std_logic;

		-- Signals to control unit
       rst, ena: in std_logic;
	   
		done : out std_logic
		
		 ----- signals from the TB ------
             ----general----
		    ProgMem_Wr_En,DataMem_Wr_En,rst,TBactive:   in std_logic;
			  ----ITCM-----
		    ProgMem_Wr_Data:   in std_logic_vector(Dwidth-1 downto 0);
			ProgMem_Wr_Add:	 in std_logic_vector(Awidth-1 downto 0);

			  ----DTCM-----
			DataMem_Wr_Add,DataMem_Rd_Add:	
					in std_logic_vector(Dwidth-1 downto 0);
			DataMem_Wr_Data:	in std_logic_vector(Dwidth-1 downto 0);

		-- -- Test Bench
		-- TBdataInProgMem  : in std_logic_vector(m-1 downto 0);
		-- TBdataInDataMem  : in std_logic_vector(BusSize-1 downto 0);
		-- TBdataOutDataMem : out std_logic_vector(BusSize-1 downto 0);
		-- TBactive	   : in std_logic;
		-- TBWrEnProgMem, TBWrEnDataMem : in std_logic;
		-- TBWrAddrProgMem, TBWrAddrDataMem, TBRdAddrDataMem :	in std_logic_vector(Awidth-1 downto 0)


	);
end top;

----------------------------------------------------------------------------
architecture top_dataflow of top is
	
	

begin 










end top_dataflow;

