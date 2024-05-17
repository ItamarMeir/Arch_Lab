library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	
end tb;
------------------------------------------------------------------------------
architecture rtb of tb is

   component Logic is
	PORT (
        Y_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);
        Logic_o: out std_logic_vector(n-1 DOWNTO 0)
    );
	end component;
	

	signal Y_Logic_i, X_Logic_i, Logic_o;
    signal ALUFN: std_logic_vector(k-1 DOWNTO 0);   
   
begin
	L0 : Logic generic map (n,k,m) port map(Y_Logic_i, X_Logic_i, ALUFN, Logic_o);
    
	--------- start of stimulus section ---------------------------------------		
        tb_x_y : process
        begin
            ------- NOT testing -------
        
		  X_Logic_i <= (others => '1');
		  Y_Logic_i <= (others => '1');
          
		  wait for 50 ns;   ---- Output: "00000000"
            Y_Logic_i <= (others => '0');
            wait for 50 ns; ---- Output: "11111111"
            Y_Logic_i <= ("10101010");
            wait for 50 ns; ---- Output: "01010101"
        end process;
		 
		
		tb_ALUFN : process
        begin
		  ALUFN <= "11000";
		  wait 150 ns
        end process;
  
end architecture rtb;
