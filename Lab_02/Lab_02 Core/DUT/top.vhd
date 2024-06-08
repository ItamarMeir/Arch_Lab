LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	signal x_j1, x_j2,detec_code,sum : std_logic_vector(n-1 downto 0);
	signal valid,carry :std_logic := '0';
	signal counter :integer range 0 to 256;
	
begin
------------- process 1 --------------
		
proce_1: process (clk,rst)		 -------  Two FF to create X[j-1], X[j-2]
		 begin 
			 if (rst = '1') then 
				x_j1 <= (others => '0');
				x_j2 <= (others => '0');
			elsif (clk'event and clk ='1') then 
				if (ena = '1') then 
					x_j1 <= x;
					x_j2 <= x_j1;
				end if ;
			end if;
		end process;
		
------------- process 2 --------------
		with DetectionCode select   -------     to recognize which detection rule to chek and convert him to n digit binary vector 
		detec_code <=         (others => '0') when 0,
					  (0=> '1', others => '0') when 1,
					  (1=> '1' ,others => '0') when 2,
					  (0=> '1',1=>'1' ,others => '0') when others;


adde_s : Adder generic map (n) port map( ------- use the adder entity to do sum = X[j-2] + condition (to add one to detection code)
				 a => detec_code,
				 b => x_j2,
				 cin => '1',
				 s => sum,
				 cout => carry
		);
				
			valid <=  '1' when (x_j1=sum) else '0'; ------- if X[j-2] = sum, The specified condition is fulfilled and the valid bit is set

		 
------------- process 3 --------------

		
proce_3: process (clk,rst)   -------  check if the valid are set and how long the valid series if it more than m the detector is set
		variable c :integer range 0 to 2**n;		
		begin
			c := counter;
			if (rst = '1') then 
				detector <= '0';
				counter <= 0;
			elsif (clk'event and clk ='1') then
				if (ena = '1') then 
					if (valid = '1')then 
						c := c +1;
						counter <= c;
						if (c >= m)then 
							detector <= '1';
						else 
							detector <= '0';
						end if;
					else 
						detector <= '0';
						counter <= 0;
					end if;

				end if;		
			end if;
			end process;
end arc_sys;







