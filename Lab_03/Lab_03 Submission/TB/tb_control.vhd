library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
end tb;
---------------------------------------------------------
architecture rtb of tb is
	SIGNAL rst,ena,clk : std_logic;
	SIGNAl add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: std_logic;
	SIGNAL IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr:  std_logic;
	SIGNAL OPC:       std_logic_vector(Dwidth-1 downto 0); 
	SIGNAL Pcsel,RFaddr:  std_logic_vector(1 downto 0); 
	SIGNAL  done_Out:      std_logic;
begin

L0 : Control_Unit generic map (16,4) port map(rst,ena,clk,add);
    
	------------ start of stimulus section --------------	
 gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
gen_rst : process
		begin
			rst <= '0';
			wait for 100 ns;
			rst <= not rst;
			 wait for 10000 ns;
        end process;
	
gen_ene : process
		begin
			ena <= '0';
			wait for 150 ns;
			ena <= not ena;
			 wait for 10000 ns;
        end process;
	
	 ------- state 0 200 ns ------- 
	 
	 ------- state 1 250 ns ------- 
	
	------- state 2/4/8/9 250 ns ------- 
	
gen_signals : process
	begin
		add <= '1';   --- add function - 4 clocks cycles
		sub <= '0';
		and_in <= '0';
		or_in <= '0';
		xor_in <= '0';
		jmp <= '0';
		jc <= '0';
		jnc <= '0';
		mov <= '0';
		ld <= '0';
		str <= '0';
		done <= '0';
		Nflag <= '0';
		Zflag <= '0';
		Cflag <= '0';
		wait;
       end process;
		
 ------- gen_states to check -------
end architecture rtb;
