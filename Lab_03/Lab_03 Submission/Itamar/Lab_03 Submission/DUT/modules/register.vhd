library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity reg is
	generic( Dwidth: integer:=16 );
	port(   Din:     	 in     std_logic_vector(Dwidth-1 downto 0);
			en,clk: in     std_logic;		
			Dout:        out	std_logic_vector(Dwidth-1 downto 0)				
	);
end reg;

architecture dataflow of reg is
	signal reg_data :std_logic_vector(Dwidth-1 downto 0);	
---------------------------------------------------------------	
begin 			   
  process(clk,rst)
  begin
	if (clk'event and clk='1' ) then
	    if (en='1') then    ----- if ena set do the register value update
			reg_data <= Din; 
	    end if;
	end if;
  end process;
  Dout <= reg_data;
end dataflow;

