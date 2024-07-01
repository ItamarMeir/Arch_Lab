library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity regMS is
	generic( width: integer:=16 );
	port(   Din:     	 in     std_logic_vector(width-1 downto 0);
			rst,en_in,en_out,clk: in     std_logic;		
			Dout:        out	std_logic_vector(width-1 downto 0)				
	);
end regMS;

architecture dataflow of regMS is
	signal reg_data :std_logic_vector(width-1 downto 0);	
---------------------------------------------------------------	
begin 			   
  process(clk,rst)
  begin
	if (rst='1') then
		reg_data <= (others=>'0');  ------- reg is const 0
	elsif (clk'event and clk='1' ) then
	    if (en_in='1') then    ----- if ena set do the register value update
			reg_data <= Din; 
	    end if;
	    if (en_out='1') then    ----- if ena set do the register value update
			Dout <= reg_data; 
	    end if;
	end if;
  end process;
end dataflow;

