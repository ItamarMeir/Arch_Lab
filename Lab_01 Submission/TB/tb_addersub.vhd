library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_addersub is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	
end tb_addersub;
-------------------------------------------------------------------------------
architecture rtl of tb_addersub is
	component AdderSub IS
		GENERIC (
			CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
    		CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
    		CONSTANT m : INTEGER := 4  -- 2^(k-1), here assumed to be 4
	);
	PORT (
		Y_AddSub_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_AddSub_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);

        AddSub_o: out std_logic_vector(n-1 DOWNTO 0);
		AddSub_cout: out std_logic
    );
	END component;

	SIGNAL x, y, Sout: std_logic_vector(n-1 DOWNTO 0);
	SIGNAL FN: std_logic_vector (k-1 DOWNTO 0);
	SIGNAL Cout: std_logic;
	
	begin
		tester: AdderSub generic map (n,k,m) port map(
			X_AddSub_i=>x, Y_AddSub_i=>y, ALUFN=>FN, AddSub_cout=>Cout, AddSub_o=>Sout); 


--------- start of stimulus section ----------------------------------------	
		testbench_x_y : process	
        begin
			x <= (others => '0');
			y <= (others => '1');
			for j in 0 to 5 loop
				for k in 0 to 3 loop
					wait for 50 ns;
					x <= x + 2;
					y <= y - 2;
				end loop;
			end loop;
		wait;

        end process testbench_x_y;

		testbench_FN : process		
        begin

		FN <= (others=>'0');
		for i in 0 to 5 loop
			wait for 200 ns;
			FN <= FN + 1;
		end loop;
		wait;

        end process testbench_FN;

---- tb: 1000 ns ----
		

		 
--------- END of stimulus section ----------------------------------------
end architecture rtl;
