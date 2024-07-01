library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity Control_Unit is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	rst,ena,clk: in std_logic;	---  signals from top
		add,sub,and_in,or_in,xor_in,shl,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag: --- signals from data path
					  in std_logic;
		IRin,Pcin,RFout,RFin,Ain,Cin,Cout,Imm1_in,Imm2_in,Mem_in,Mem_out,Mem_wr: --- signals to data path
				   	 out std_logic;
		OPC:  out std_logic_vector(Awidth-1 downto 0); --- signals to data path
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
	

	
----------------  end encoding states --------------------	
begin			 

--------- FSM Mealy Synchronized - Stored Output -------------
------- Lower section(Synchronized)-------------------------- 
  process(clk,rst)
  begin
	if (rst='1') then
		pr_state <= reset_state;   ------ reset
	elsif (clk'event and clk='1' and ena = '1') then
		pr_state <= nx_state;
	 end if;
  end process;
	
------- Lower section (Logic) -------------------------------- 
  process(add,sub,and_in,or_in,xor_in,shl,jmp,jc,jnc,mov,ld,str,done,Nflag,Zflag,Cflag,pr_state,ena,rst)
  begin
	case pr_state is
-------------reset --------------------------		
		when reset_state =>	 
			IRin <= '0';
			Pcin <= '1';
			RFout <= '0';
			RFin <= '0';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "00";
			Pcsel <= "11";
			OPC <= "1111";
			done_Out <= '0';
			if (ena = '1' AND done ='0') then	
				nx_state <= state0;
			else
			    nx_state <= reset_state;  
			end if;

			
-------------state 0 (FETCH) --------------------------			
		when state0 =>	
			IRin <= '1';
			Pcin <= '1';
			RFout <= '0';
			RFin <= '0';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "00";
			Pcsel <= "01";
			OPC <= "1111";
			done_Out <= '0';
			if (ena = '1') then	
				nx_state <= state1;
			else
			    nx_state <= state0; ------ state 0 always go to state 1 
			end if;

-------------state 1 (decode) --------------------------	
		when state1 =>
			IRin <= '0';
			Pcin <= '0';
			RFout <= '1';
			RFin <= '0';
			Ain <= '1';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "01";
			Pcsel <= "01";
			OPC <= "1111";
			
			if (add ='1' or sub = '1' or and_in = '1' or or_in = '1' or xor_in = '1' or shl = '1' ) then --- Rtype
				nx_state <= state2;
				done_Out <= '0';
			elsif (ld ='1' or str = '1') then --- Itype ld,st
				nx_state <= state4;
				done_Out <= '0';
			elsif (mov ='1') then --- Itype mov
				nx_state <= state8;
				done_Out <= '0';
			elsif (jmp ='1') then --- Jtype jmp
				nx_state <= state9;	
				done_Out <= '0';
				
				
			elsif (jc ='1') then   --- Jtype jc
			   if (Cflag = '1') then  
				  nx_state <= state9;
			   else 
				  nx_state <= state0;
			   end if;  
			   done_Out <= '0';
			   
			elsif (jnc ='1') then  --- Jtype jnc
			   if (Cflag = '0') then  
				  nx_state <= state9;
			   else 
				  nx_state <= state0;
			   end if;  
			    done_Out <= '0';
				
			elsif (done ='1') then 
				done_Out <= '1';
				nx_state <= reset_state;
				
			else 
				nx_state <= state0;  --- else Jtype
				done_Out <= '0';
			end if;	
				
-------------state 2 (Rtype) --------------------------				
		when state2 =>	
			IRin <= '0';
			Pcin <= '0';
			RFout <= '1';
			RFin <= '0';
			Ain <= '0';
			Cin <='1';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "00";
			Pcsel <= "00";
			done_Out <= '0';

			if(sub ='1') then --- add opretion	
				OPC <= "0001";
			elsif (and_in ='1') then --- and opretion	
				OPC <= "0010";
			elsif (or_in ='1') then --- or opretion	
				OPC <= "0011";
			elsif (xor_in ='1') then --- xor opretion	
				OPC <= "0100";
			elsif (shl ='1') then --- shl opretion	
				OPC <= "0101";
			else                   --- add opretion	
				OPC <= "0000";
			end if;	
			nx_state <= state3; ------ state 2 always go to state 3	
			
-------------state 3 (Rtype) --------------------------				
		when state3 =>	
			IRin <= '0';
			Pcin <= '0';
			RFout <= '0';
			RFin <= '1';
			Ain <= '0';
			Cin <='0';
			Cout <= '1';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "10";
			Pcsel <= "01";
			OPC <= "1111";
			done_Out <= '0';
			
			nx_state <= state0; ------ state 3 always go to state 0	

-------------state 4 (Itype) --------------------------	
		when state4 =>	
			IRin <= '0';
			Pcin <= '0';
			RFout <= '0';
			RFin <= '0';
			Ain <= '0';
			Cin <='1';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '1';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "10";
			Pcsel <= "01";
			OPC <= "1110";
			done_Out <= '0';
			
			nx_state <= state5; ------ state 4 always go to state 5	
			
-------------state 5 (Itype) --------------------------	
		when state5 =>	 
			IRin <= '0';
			Pcin <= '0';
			RFout <= '0';
			RFin <= '0';
			Ain <= '0';
			Cin <='0';
			Cout <= '1';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '1';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "10";
			Pcsel <= "01";
			OPC <= "1111";
			done_Out <= '0';
				
			if (ld = '1') then --- ld function
				nx_state <= state6;
			else 
				nx_state <= state7; --- st function
			end if;	

-------------state 6 (Itype - ld) --------------------------	
		when state6 =>
			IRin <= '0';
			Pcin <= '0';
			RFout <= '0';
			RFin <= '1';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '1';
			Mem_wr <= '0';
			RFaddr <= "10";
			Pcsel <= "01";
			OPC <= "1111";
			done_Out <= '0';
				
			nx_state <= state0; ------ state 6 always go to state 0
			
			
			
-------------state 7 (Itype - st) --------------------------				
		when state7 =>	 
			IRin <= '0';
			Pcin <= '0';
			RFout <= '1';
			RFin <= '0';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '1';
			RFaddr <= "10";
			Pcsel <= "00";
			OPC <= "1111";
			done_Out <= '0';
				
			nx_state <= state0; ----- state 7 always go to state 0
			
-------------state 8 (Itype - mov) --------------------------	
		when state8 =>	 
			IRin <= '0';
			Pcin <= '0';
			RFout <= '0';
			RFin <= '1';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '1';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "10";
			Pcsel <= "01";
			OPC <= "1111";
			done_Out <= '0';
				
			nx_state <= state0;----- state 8 always go to state 0
			
-------------state 9 (Jtype - mov) --------------------------	
		when state9 =>	 
			IRin <= '0';
			Pcin <= '1';
			RFout <= '0';
			RFin <= '0';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "00";
			Pcsel <= "10";
			OPC <= "1111";
			done_Out <= '0';
				
			nx_state <= state0;----- state 9 always go to state 0
		when others =>
		
			IRin <= '0';
			Pcin <= '0';
			RFout <= '0';
			RFin <= '0';
			Ain <= '0';
			Cin <='0';
			Cout <= '0';
			Imm1_in <= '0';
			Imm2_in <= '0';
			Mem_in <= '0';
			Mem_out <= '0';
			Mem_wr <= '0';
			RFaddr <= "00";
			Pcsel <= "11";
			OPC <= "1111";
			done_Out <= '0';
			nx_state <= reset_state;
		
		 end case;
	  end process;
end behav;
