library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity PC is
	generic( Dwidth: integer:=16;
	         Awidth: integer:=4);
	port(  
			Din_PCsel: in std_logic_vector(Dwidth-1 downto 0);  ---- last PC value
			IRdata: in std_logic_vector(7 downto 0);
			PCsel: in std_logic_vector (1 downto 0);	---- signal from control
			Dout_PCsel:     out	std_logic_vector(Dwidth-1 downto 0) ------ the new valuefrom register pc to the ITCM			
	);
end PC;

architecture dataflow of PC is
	signal Din_PCsel_internal:   std_logic_vector(Dwidth-1 downto 0); --- the value of pc from registe PC
	signal vecor_zeroes :std_logic_vector(Dwidth-1 downto 0);	 -------- vector with of zeroes
	signal vecor_extand :std_logic_vector(Dwidth-1 downto 0);	 -------- vector IR EXTENDED
	signal PC_plus1 :std_logic_vector(Dwidth-1 downto 0);	 -------- PC+1
	signal PC_PLUS_IR :std_logic_vector(Dwidth-1 downto 0);	 -------- PC+1+IR<7..0>


---------------------------------------------------------------	
begin
    Din_PCsel_internal <= Din_PCsel;
	vecor_zeroes <= ( others => '0'); -------- vector zeroes
	vecor_extand <= (IRdata(7)&IRdata(7)&IRdata(7)&IRdata(7)&IRdata(7)&IRdata(7)&IRdata(7)&IRdata(7)&IRdata);
	pc_plus_one: Adder generic map(Dwidth) port map(Din_PCsel_internal,vecor_zeroes,'1',PC_plus1); --- PC+1
    pc_ADD_IR: Adder generic map(Dwidth) port map(Din_PCsel_internal,vecor_extand,'1',PC_PLUS_IR); --- PC+1+IR<7..0>	 


  -- Select the next value of PC based on PCsel--

	Dout_PCsel <= vecor_zeroes when PCsel = "00" else  ------ PC = 0..0
		          PC_plus1 when (PCsel = "01") else----- PC+1+IR<7..0>
		          PC_PLUS_IR when PCsel = "10" else------- PC+1
		          (others =>'0');   ----- option to another pcsel



end dataflow;

