library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_tb_Shifter is
end tb_Shifter;
-------------------------------------------------------------------------------
architecture rtl of tb_Shifter is
	component Shifter IS
		generic ( n : integer :=8;
				  k : integer :=3);
		PORT (	x, y: IN std_logic_vector (n-1 DOWNTO 0);
				FN: IN std_logic_vector (2 DOWNTO 0); 
				res: OUT std_logic_vector (n-1 DOWNTO 0);
				Cout: OUT std_logic);
	END component;
	SIGNAL x, y, res: std_logic_vector(7 DOWNTO 0);
	SIGNAL FN: std_logic_vector (2 DOWNTO 0);
	SIGNAL Cout: std_logic;

begin
		tester: Shifter port map(
		x=>x,y=>y, FN=>FN, Cout=>Cout,res=>res);  


begin
	L0 : top generic map (n,k,m) port map(Y,X,ALUFN,ALUout,Nflag,Cflag,Zflag,Vflag);
    
	--------- start of stimulus section ----------------------------------------		
        tb_x_y : process
        begin
		  x <= (others => '1');
		  y <= (others => '1');
		  wait for 50 ns;
		  for i in 0 to 40 loop
			x <= x-10;
			y <= y-1;
			wait for 50 ns;
		  end loop;
		  wait;
        end proces

end architecture rtl;
