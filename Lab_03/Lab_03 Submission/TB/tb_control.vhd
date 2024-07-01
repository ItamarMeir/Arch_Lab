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
			wait for 100 ns;
			rst <= not rst;
			 wait;
        end process;
	
gen_ene : process
		begin
			ena <= '0';
			wait for 100 ns;
			ena <= not ena;
			 wait;
        end process;
	
	
add_sig : process
        begin
        add <='0','1' after 300 ns, '0' after 700 ns;  ---4 CLKCYCLES
		 wait;
        end process;
		
sub_sig : process
        begin
        sub <='0','1' after 700 ns, '0' after 1100 ns; 
		 wait;
        end process;
	
and_in_sig : process
        begin
        and_in <='0','1' after 1100 ns, '0' after 1500 ns; 
		 wait;
        end process;	

or_in_sig : process
        begin
        or_in <='0','1' after 1500 ns, '0' after 1900 ns; 
		 wait;
        end process;
		
xor_in_sig : process
        begin
        xor_in <='0','1' after 1900 ns, '0' after 2300 ns; 
		 wait;
        end process;

jmp_sig   : process
        begin
        jmp <='0','1' after 2300 ns, '0' after 2600 ns; 
		 wait;
       
	   end process;
	   
		
jc_sig  : process
        begin
        jc <='0','1' after 2600 ns, '0' after 3100 ns; 

		 wait;
        end process;	
	
jnc_sig  : process
        begin
        jnc <='0','1' after 3100 ns, '0' after 3600 ns; 
		 wait;
        end process;	

mov_sig   : process
        begin
        mov <='0','1' after 3600 ns, '0' after 3900 ns; 
		 wait;
        end process	;

ld_sig : process
        begin
        ld <='0','1' after 3900 ns, '0' after 4400 ns; 
		 wait;
        end process;	
	

str_sig : process
        begin
        str <='0','1' after 4400 ns, '0' after 4900 ns; 
		 wait;
        end process;		
	
done_sig : process
        begin
        done <='0','1' after 4900 ns, '0' after 5100 ns; 
		wait;
        end process;		
	
Cflag_sig  : process
        begin
		Cflag <= '0','1' after 2600 ns, '0' after 2800 ns, '1' after 3300 ns, '0' after 3600 ns;
		 wait;
        end process;	
	
Zflag_sig  : process
        begin
		Zflag <= '0','1' after 2000 ns, '0' after 3500 ns;
		 wait;
        end process;	

Nflag_sig  : process
        begin
		Nflag <= '0','1' after 1500 ns, '0' after 2900 ns;
		 wait;
        end process;
		
		
	
state_sig : process
        begin
		state <=10, 0 after 200 ns,1 after 300 ns, 2 after 400 ns, 3 after 500 ns, 0 after 600 ns,   --- add
					1 after 700 ns, 2 after 800 ns, 3 after 900 ns, 0 after 1000 ns,  --- sub
					1 after 1100 ns, 2 after 1200 ns, 3 after 1300 ns, 0 after 1400 ns,  ---- and
					1 after 1500 ns, 2 after 1600 ns, 3 after 1700 ns, 0 after 1800 ns,  ---- or
					1 after 1900 ns, 2 after 2000 ns, 3 after 2100 ns, 0 after 2200 ns,  ---- xor
					1 after 2300 ns, 9 after 2400 ns, 0 after 2500 ns, ---- jmp
					1 after 2600 ns, 9 after 2700 ns, 0 after 2800 ns,  ---- jc  c=1
					1 after 2900 ns, 0 after 3000 ns,  ---- jc  c=0
					1 after 3100 ns, 9 after 3200 ns, 0 after 3300 ns,  ---- jnc  c=0
					1 after 3400 ns, 0 after 3500 ns,  ---- jnc  c=1
					1 after 3600 ns, 8 after 3700 ns, 0 after 3800 ns,  ---- mov
					1 after 3900 ns, 4 after 4000 ns, 5 after 4100 ns, 6 after 4200 ns, 0 after 4300 ns,  ---- ld
					1 after 4400 ns, 4 after 4500 ns, 5 after 4600 ns,7 after 4700 ns, 0 after 4800 ns,  ---- str
					1 after 4900 ns, 10 after 5000 ns;  ---- done
		wait;
        end process;
		
end architecture rtb;
