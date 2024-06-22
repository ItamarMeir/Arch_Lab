LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE aux_package.all;

--------------------------------------------------------
ENTITY ALU IS
  GENERIC (Dwidth: integer:=16);
  PORT (A, B: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          OPC: IN STD_LOGIC_VECTOR (3 downto 0);

          C: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          Cflag, Zflag, Nflag: OUT STD_LOGIC;)

END ALU;
--------------------------------------------------------
-- OPCODES:
-- 0000: ADD
-- 0001: SUB
-- 0010: AND
-- 0011: OR
-- 0100: XOR


ARCHITECTURE ALU_arch OF ALU IS
SIGNAL A_in, B_in, AdderSub_out, C_tmp : STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
SIGNAL cin, cout : STD_LOGIC;


BEGIN
  cin <= '1' when OPC = '0001' else '0'; -- for subtraction


  gen: for i in 0 to Dwidth-1 generate
    A_in(i) <= A(i);
    B_in(i) <= not B(i) when OPC = '0001' else B(i); -- for subtraction
  end generate gen;

Adder: Adder port map(A_in, B_in, cin, AdderSub_out, cout);  

C_tmp <= AdderSub_out when OPC = "0000" or OPC = "0001" else
     A and B when OPC = "0010" else
     A or B when OPC = "0011" else
     A xor B when OPC = "0100" else
     (others => '0');

C <= C_tmp;

Cflag <= cout when OPC = "0000" or OPC = "0001" else
         '0';
Zflag <= '1' when C_tmp = (others => '0') else
         '0';
Nflag <= C_tmp(Dwidth-1);
    

END ALU_arch;
