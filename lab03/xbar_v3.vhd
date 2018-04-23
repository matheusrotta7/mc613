library ieee;
use ieee.std_logic_1164.all;

entity xbar_v1_2 is
  port(x1, x2, s: in std_logic;
       y1, y2: out std_logic);
end xbar_v1_2;

architecture rtl_1 of xbar_v1_2 is

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
					
end rtl_1;

