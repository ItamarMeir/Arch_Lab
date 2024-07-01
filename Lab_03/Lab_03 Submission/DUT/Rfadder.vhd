library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity RFadder is
    generic( Dwidth: integer:=16;
		     Awidth: integer:=4);
	port(   Din_RFadder_a,Din_RFadder_b,Din_RFadder_c:   in std_logic_vector(Awidth-1 downto 0);
			RFaddr: 						             in  std_logic_vector(1 downto 0);
			Dout_RFadder:                                out std_logic_vector(Awidth-1 downto 0)				
	);
end RFadder;

architecture dataflow of RFadder is
	signal reg_data :std_logic_vector(Awidth-1 downto 0);	
---------------------------------------------------------------	
begin 			   
	Dout_RFadder <= Din_RFadder_c when RFaddr = "00" else	--- if 00 so R_C
			        Din_RFadder_b when RFaddr = "01" else	--- if 00 so R_B
			        Din_RFadder_a when RFaddr = "10" else	--- if 00 so R_A
				    (others => '0') ;	
end dataflow;

