library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_ALU is
   
       CONSTANT Dwidth: integer:=16;
 
end tb_ALU;
------------------------------------------------------------------------------
architecture rtb of tb_ALU is

   component ALU is
	GENERIC (
        Dwidth: integer:=16
    );
    PORT (
         A, B: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          OPC: IN STD_LOGIC_VECTOR (3 downto 0);

          C: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          Cflag, Zflag, Nflag: OUT STD_LOGIC
    );
	end component;
	
	signal A, B, C: std_logic_vector(Dwidth-1 DOWNTO 0);
    signal OPC: std_logic_vector(3 DOWNTO 0);    
    signal Cflag, Zflag, Nflag: std_logic;

    begin
	L0: ALU PORT MAP (A, B, OPC, C, Cflag, Zflag, Nflag);
    
	--------- start of stimulus section ---------------------------------------		
        tb_A_B : process
        begin
         -- Changing A, B values every 50 ns
        A <= (others => '0');
        B <= (others => '0');
        for i in 0 to 6 loop
        wait for 50 ns;
            A <= A + 1;
            B <= B - 1;
        end loop;
        wait;
        end process;
		 
		
		tb_OPC : process
        begin
        -- Changing OPC values every 100 ns
        OPC <= "0000";
        wait for 100 ns;
        for i in 0 to 6 loop
            wait for 100 ns;
           OPC <= OPC + 1;
        end loop;
      
        end process;
  
  -- Overall simulation time is 2.5 us
end architecture rtb;
