library ieee;
use ieee.std_logic_1164.all;

entity banana is
port(x1, x2, s: in std_logic;
		  y1, y2: out std_logic);
end entity banana;



architecture casca of banana is
begin
		process (x1, x2, s)
		begin
			if s = '0' then
				y1 <= x1;
				y2 <= x2;
			else 
				y1 <= x2;
				y2 <= x1;
			end if;
		end process;
end architecture casca;


library ieee;
use ieee.std_logic_1164.all;

entity caixo_de_bananas is
generic (N : Integer := 4);
port(x1_in, x2_in	 : in std_logic;
	  y1_out, y2_out: out std_logic;
	  s     		 	 : in std_logic_vector(0 to N-1));
end entity caixo_de_bananas;



architecture BEH of caixo_de_bananas is

component banana
  port(x1, x2, s: in std_logic;
	  y1, y2: out std_logic);
end component banana;

signal x1 : std_logic_vector(0 to N-1);
signal x2 : std_logic_vector(0 to N-1);
begin
	x1(0) <= x1_in;
	x2(0) <= x2_in;
	gen_label:
   for i in 0 to N-2 generate 
		stage: banana PORT MAP (x1(i), x2(i), s(i), x1(i+1), x2(i+1));
	end generate;
					
	y1_out <= x1(N-1);
	y2_out <= x2(N-1);
      
end BEH;



--s <= s(i);
--		
--		
--		if s = '0'
--			y1(i) <= x1(i);
--			y2(i) <= x2(i);
--		elsif s = '1'
--			y1(i) <= x2(i);
--			y2(i) <= x1(i);