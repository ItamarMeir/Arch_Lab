library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_Logic is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	
end tb_Logic;
------------------------------------------------------------------------------
architecture rtb of tb_Logic is

   component Logic is
	GENERIC (
        CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
        CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
        CONSTANT m : INTEGER := 4   -- 2^(k-1), here assumed to be 4
    );
    PORT (
        Y_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);            --- ALUFN[2:0]
        Logic_o: out std_logic_vector(n-1 DOWNTO 0)
    );
	end component;
	
	

	signal Y_Logic_i, X_Logic_i, Logic_o: std_logic_vector(n-1 DOWNTO 0);
    signal ALUFN: std_logic_vector(k-1 DOWNTO 0);      
begin
	L0 : Logic generic map (n,k,m) port map(Y_Logic_i, X_Logic_i, ALUFN, Logic_o);
    
	--------- start of stimulus section ---------------------------------------		
        tb_x_y : process
        begin
            ------- NOT testing -------
        
		  X_Logic_i <= (others => '0');
		  Y_Logic_i <= (others => '1');
          for j in 0 to 7 loop
            for k in 0 to 3 loop
		        wait for 50 ns;   ---- Output: "00000000"
                 Y_Logic_i <= Y_Logic_i + 3;
                 X_Logic_i <= X_Logic_i + 2;
                end loop;
          end loop;      
        wait;

        end process;
		 
		
		tb_ALUFN : process
        begin

        ALUFN <= (others => '0');
        for i in 0 to 7 loop
        wait for 200 ns;
         ALUFN <= ALUFN + 1;
         end loop;
         wait;
        -- wait for 150 ns;
        -- ALUFN <= "001";
        -- wait for 150 ns;
        -- ALUFN <= "010";
        -- wait for 150 ns;
        --  ALUFN <= "011";
        -- wait for 150 ns;
        --  ALUFN <= "100";
        -- wait for 150 ns;
        --  ALUFN <= "101";
        -- wait for 150 ns;
        --  ALUFN <= "110";
        -- wait for 150 ns;
        --  ALUFN <= "111";
        -- wait for 150 ns;

        

        end process;
  
end architecture rtb;
