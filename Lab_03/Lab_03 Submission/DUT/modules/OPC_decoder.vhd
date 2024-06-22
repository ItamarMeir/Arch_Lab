library ieee;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-----------------------------------------------------------------
entity Decoder is
    generic( Dwidth: integer:=16;
		     Awidth: integer:=4);
	port(   Din_Decoder:   in std_logic_vector(Awidth-1 downto 0);
			add,sub,and_in,or_in,xor_in,jmp,jc,jnc,mov,ld,str,done:  out std_logic		
	);
end Decoder;

architecture dataflow of Decoder is
---------------------------------------------------------------	
begin 
		process(Din_Decoder)
		  variable decode :std_logic_vector(Dwidth-1 downto 0);
		BEGIN 
			if      (Din_Decoder = "0000") then decode := (0=>'1', others =>'0');  --- add/nop
			elsif 	(Din_Decoder = "0001") then decode := (2=>'1', others =>'0');	--- sub
			elsif 	(Din_Decoder = "0010") then decode := (2=>'1', others =>'0');	--- and
			elsif 	(Din_Decoder = "0011") then decode := (3=>'1', others =>'0');	--- or
			elsif 	(Din_Decoder = "0100") then decode := (4=>'1', others =>'0');	--- xor
		--	elsif 	(Din_Decoder = "0101") then decode := (5=>'1', others =>'0');	--- unused
		--	elsif 	(Din_Decoder = "0110") then decode := (6=>'1', others =>'0');	--- unused
			elsif 	(Din_Decoder = "0111") then decode := (7=>'1', others =>'0');	--- jmp
			elsif 	(Din_Decoder = "1000") then decode := (8=>'1', others =>'0');	--- jc
			elsif 	(Din_Decoder = "1001") then decode := (9=>'1', others =>'0');	--- jnc
		--	elsif 	(Din_Decoder = "1010") then decode := (10=>'1', others =>'0');	--- unused
		--	elsif 	(Din_Decoder = "1011") then decode := (11=>'1', others =>'0')	--- unused
			elsif 	(Din_Decoder = "1100") then decode := (12=>'1', others =>'0');	--- mov
			elsif 	(Din_Decoder = "1101") then decode := (13=>'1', others =>'0');	--- ld
			elsif 	(Din_Decoder = "1110") then decode := (14=>'1', others =>'0');	--- st
			elsif 	(Din_Decoder = "1111") then decode := (15=>'1', others =>'0');	--- done
			else 	decode := (others =>'0');
			end if;
			
			
			
			add <= decode(0);
			sub <= decode(1);
			and_in <= decode(2);
			or_in <= decode(3);
			xor_in <= decode(4);
	--		unused <= decode(5);
	--		unused <= decode(6);
			jmp <= decode(7);
			jc <= decode(8);
			jnc <= decode(9);
	--		unused <= decode(10);
	--		unused <= decode(11);
			mov <= decode(12);
			ld <= decode(13);
			str <= decode(14);
			done <= decode(15);
		end process;
	
end dataflow;

