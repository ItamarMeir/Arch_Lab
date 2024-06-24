library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity BidirPin is
	generic( Dwidth: integer:=16 );
	port(   Dout_RF,Dout_C,Dout_imm1,D_out_imm2,Dout_DTCM: 	in 	std_logic_vector(Dwidth-1 downto 0);
			RFout,RFin,,Cout,Imm1_in,Imm2_in,Mem_out:		in 	std_logic;
			Din:	out		std_logic_vector(Dwidth-1 downto 0);
			IOpin: 	inout 	std_logic_vector(Dwidth-1 downto 0)
	);
end BidirPin;

architecture comb of BidirPin is
begin 

	Din  <= IOpin;
	IOpin <= Dout when(en='1') else (others => 'Z');
	
end comb;
