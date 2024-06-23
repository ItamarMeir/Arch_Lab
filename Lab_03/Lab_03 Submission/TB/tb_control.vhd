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
	SIGNAL OPC:       std_logic_vector(Awidth-1 downto 0); 
	SIGNAL Pcsel,RFaddr:  std_logic_vector(1 downto 0); 
	SIGNAL  done_Out:      std_logic;
	SIGNAL  state:         integer range 0 to 10;
begin

L0 : Control_Unit generic map (16,4) port map(rst,ena,clk,add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag,
	                             IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr,
								 OPC,Pcsel,RFaddr,done_Out);
    
	------------ start of stimulus section --------------	
 gen_clk : process
        begin
		  clk <= '1';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
gen_rst : process
		begin
			rst <= '1';
			state <= 10;
			wait for 100 ns;
			rst <= not rst;
			state <= 0;
			 wait;
        end process;
	
gen_ene : process
		begin
			ena <= '0';
			wait for 100 ns;
			ena <= not ena;
			 wait;
        end process;
	
	 ------- state 0 200 ns ------- 
	 
	 ------- state 1 250 ns ------- 
	
	------- state 2/4/8/9 250 ns ------- 
	
add_sig : process
        begin
        add <='0','1' after 100 ns, '0' after 600 ns;
		state <= 1 after 200 ns, 2 after 300 ns, 3 after 400 ns, 0 after 500 ns;
		 wait;
        end process;
	

end architecture rtb;
