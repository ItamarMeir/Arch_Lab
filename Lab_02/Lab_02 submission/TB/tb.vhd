library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 16;
end tb;
---------------------------------------------------------
architecture rtb of tb is
	SIGNAL rst,ena,clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;
begin
	L0 : top generic map (16,15,4) port map(rst,ena,clk,x,DetectionCode,detector);
    
	------------ start of stimulus section --------------	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 25 ns;
		  clk <= not clk;
		  wait for 25 ns;
        end process;
		
		gen_x : process
			variable j : integer := 0;
        begin
		  x <= (others => '0');
		  DetectionCode <= j;
		  for i in 0 to 24 loop
			wait for 50 ns;
			x <= x+j+1;
		  end loop;
		  j := j+1;
        end process;
		  
		gen_rst : process
        begin
		  rst <='1','0' after 50 ns;
		  wait;
        end process; 
		
		gen_ena : process
        begin
			ena <='0','1' after 200 ns,'0' after 1250 ns,'1' after 1500 ns;
		  wait;
        end process;
  
end architecture rtb;
