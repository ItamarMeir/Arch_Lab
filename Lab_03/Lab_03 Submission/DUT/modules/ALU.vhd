LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;

--------------------------------------------------------
ENTITY ALU IS
  GENERIC (Dwidth: integer:=16);
  PORT (A, B: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          OPC: IN STD_LOGIC_VECTOR (3 downto 0);

          C: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          Cflag, Zflag, Nflag: OUT STD_LOGIC
          );

END ALU;
--------------------------------------------------------
-- OPCODES:
-- 0000: ADD
-- 0001: SUB
-- 0010: AND
-- 0011: OR
-- 0100: XOR


ARCHITECTURE ALU_arch OF ALU IS

COMPONENT Adder IS
  PORT (a, b: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          cin: IN STD_LOGIC;
          S: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          cout: OUT STD_LOGIC
          );
END COMPONENT Adder;

SIGNAL B_in, AdderSub_out, C_tmp : STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
SIGNAL cin_tmp, cout_tmp, tmp_Z : STD_LOGIC;


BEGIN
  cin_tmp <= '1' when OPC = "0001" else '0'; -- for subtraction


  gen: for i in 0 to Dwidth-1 generate
    --A_in(i) <= A(i);
    B_in(i) <= not B(i) when OPC = "0001" else B(i); -- for subtraction
  end generate gen;

L0: Adder port map(
    a => A,
    b => B_in,
    cin => cin_tmp,
    S => AdderSub_out,
    cout => cout_tmp
); 

C_tmp <= AdderSub_out when (OPC = "0000" or OPC = "0001") else
     A and B when OPC = "0010" else
     A or B when OPC = "0011" else
     A xor B when OPC = "0100" else
     (others => '0');

C <= C_tmp;

Cflag <= cout_tmp when OPC = "0000" or OPC = "0001" else
         unaffected;

 -- Process to calculate tmp_Z
  tmp_Z_Process: process(C_tmp)
  begin
    tmp_Z <= '1'; -- Assume all bits are '0' initially
    for i in C_tmp'range loop
      if C_tmp(i) = '1' then
        tmp_Z <= '0'; -- If any bit is '1', set tmp_Z to '0'
        exit; -- No need to check further
      end if;
    end loop;
  end process tmp_Z_Process;

  Zflag <= tmp_Z when (OPC = "0000" or OPC = "0001" or OPC = "0010" or OPC = "0011" or OPC = "0100") else unaffected;  -- Assign the result to Zflag

Nflag <= C_tmp(Dwidth-1) when (OPC = "0000" or OPC = "0001" or OPC = "0010" or OPC = "0011" or OPC = "0100") else unaffected;  -- Assign the result to Nflag
    

END ALU_arch;
