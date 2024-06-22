library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity Control_Unit is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	rst,ena,clk: in std_logic;	---  signals from top
		add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: --- signals from data path
					  in std_logic;
		IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: --- signals to data path
				   	 out std_logic;
		OPC:  out std_logic_vector(Dwidth-1 downto 0); --- signals to data path
		Pcsel,RFaddr:		 out std_logic_vector(1 downto 0); --- signals to data path
	    done_Out:    out std_logic	---  signal to top
);
end Control_Unit;
--------------------------------------------------------------
architecture behav of Control_Unit is

-------- TwoHot encoding states   -----------
	subtype state is std_logic_vector(5 downto 0); ----- 6 bit represent 15 states we take it becase to save the option to add states
	constant reset_state  : state := "000000";
	constant state0 : state := "000011";	
	constant state1 : state := "000101";
	constant state2 : state := "001001";
	constant state3 : state := "010001";
	constant state4 : state := "100001";
	constant state5 : state := "000110";
	constant state6 : state := "001010";
	constant state7 : state := "010010";
	constant state8 : state := "100010";
	constant state9 : state := "001100";
--	constant state10: state := "010100"; ----- not in use
--	constant state11: state := "100100"; ----- not in use	
--	constant state12: state := "011000"; ----- not in use
	signal pr_state, nx_state: state;
	
-----------------  temp signals to for stored output------------------
	signal temp_IRin,temp_Pcin,temp_RFout,temp_RFin,temp_Ain,temp_Cin,temp_Cout,temp_Imm1_in,temp_Imm2_in,
	temp_Mem_in,temp_Mem_out,temp_Mem_wr,temp_done_Out : std_logic; 
	signal temp_OPC : std_logic_vector(Dwidth-1 downto 0);
	signal temp_Pcsel,temp_RFaddr  :std_logic_vector(1 downto 0);	
	
----------------  end encoding states --------------------	
begin			 
--------- FSM Mealy Synchronized - Stored Output -------------
------- Lower section(Synchronized)-------------------------- 
  process(clk,rst)
  begin
	if (rst='1') then
		pr_state <= reset_state;   ------ reset
	elsif (clk'event and clk='1' and ena = '1') then
	------- signals out -----------
		IRin <= temp_IRin;
		Pcin <= temp_Pcin;
		RFout <= temp_RFout;
		RFin <= temp_RFin;
		Ain <= temp_Ain;
		Cin <= temp_Cin;
		Cout <= temp_Cout;
		Imm1_in <= temp_Imm1_in;
		Imm2_in <= temp_Imm2_in;
		Mem_in <= temp_Mem_in;
		Mem_out <= temp_Mem_out;
		Mem_wr <= temp_Mem_wr;
		RFaddr <= temp_RFaddr;
		Pcsel <=temp_RFaddr;
		OPC <=temp_OPC;
		done_Out <= temp_done_Out;
		
		------- nx to pr state  ----------
		pr_state <= nx_state;
	 end if;
  end process;
	
------- Lower section (Logic) -------------------------------- 
  process(add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done, pr_state)
  begin
	case pr_state is
-------------reset --------------------------		
		when reset_state =>	 
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "00";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
				
			nx_state <= state0;
-------------state 0 (FETCH) --------------------------			
		when state0 =>	
			temp_IRin <= '1';
			temp_Pcin <= '1';
			temp_RFout <= '0';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "00";
			temp_Pcsel <= "10";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
			
			nx_state <= state1; ------ state 0 always go to state 1 

-------------state 1 (decode) --------------------------	
		when state1 =>
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '1';
			temp_RFin <= '0';
			temp_Ain <= '1';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "10";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			
			if (add ='1' or sub = '1' or and_in = '1' or or_in = '1' or xor_in = '1' ) then --- Rtype
				nx_state <= state2;
			elsif (ld ='1' or str = '1') then --- Itype ld,st
				nx_state <= state4;
			elsif (mov ='1') then --- Itype mov
				nx_state <= state8;
			elsif ((jc ='1' and Cflag = '1') or (jnc ='1' and Cflag ='0')or jmp ='1') then --- Jtype mov
				nx_state <= state9;
			elsif (done ='1') then 
				temp_done_Out <= '1';
				nx_state <= state0;
				
			else 
				nx_state <= state0;  --- else Jtype
			end if;	
				
-------------state 2 (Rtype) --------------------------				
		when state2 =>	
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '1';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "01";
			temp_Pcsel <= "00";
			temp_done_Out <= '0';

			if(sub ='1') then --- add opretion	
				temp_OPC <= "0001";
			elsif (and_in ='1') then --- and opretion	
				temp_OPC <= "0010";
			elsif (or_in ='1') then --- or opretion	
				temp_OPC <= "0011";
			elsif (xor_in ='1') then --- xor opretion	
				temp_OPC <= "0100";
			else                   --- add opretion	
				temp_OPC <= "0000";
				
			nx_state <= state3; ------ state 2 always go to state 3	
			end if;
			
-------------state 3 (Rtype) --------------------------				
		when state3 =>	
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '1';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '1';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "11";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
			
			nx_state <= state0; ------ state 3 always go to state 0	

-------------state 4 (Itype) --------------------------	
		when state4 =>	
			temp_IRin <= '0';
			temp_Pcin <= '1';
			temp_RFout <= '0';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '1';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "00";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
			
			nx_state <= state5; ------ state 4 always go to state 5	
			
-------------state 5 (Itype) --------------------------	
		when state5 =>	 
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '1';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '1';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "00";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
				
			if (ld = '1') then --- ld function
				nx_state <= state6;
			else 
				nx_state <= state7; --- st function
			end if;	

-------------state 6 (Itype - ld) --------------------------	
		when state6 =>
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '1';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '1';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "11";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
				
			nx_state <= state0; ------ state 6 always go to state 0
			
			
			
-------------state 7 (Itype - st) --------------------------				
		when state7 =>	 
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '1';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '1';
			temp_RFaddr <= "11";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
				
			nx_state <= state0; ----- state 7 always go to state 0
			
-------------state 8 (Itype - mov) --------------------------	
		when state8 =>	 
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '1';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '1';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "11";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
				
			nx_state <= state0;----- state 8 always go to state 0
			
-------------state 9 (Jtype - mov) --------------------------	
		when state9 =>	 
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "00";
			temp_Pcsel <= "01";
			temp_OPC <= "0000";
			temp_done_Out <= '0';
				
			nx_state <= state0;----- state 9 always go to state 0
		when others =>
		
			temp_IRin <= '0';
			temp_Pcin <= '0';
			temp_RFout <= '0';
			temp_RFin <= '0';
			temp_Ain <= '0';
			temp_Cin <='0';
			temp_Cout <= '0';
			temp_Imm1_in <= '0';
			temp_Imm2_in <= '0';
			temp_Mem_in <= '0';
			temp_Mem_out <= '0';
			temp_Mem_wr <= '0';
			temp_RFaddr <= "00";
			temp_Pcsel <= "00";
			temp_OPC <= "0000";
			temp_done_Out <= '0';

		
		 end case;
	  end process;
end behav;
