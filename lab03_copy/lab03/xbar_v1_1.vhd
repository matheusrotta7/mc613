library ieee;
use ieee.std_logic_1164.all;

entity xbar_v1_1 is
  port(x1, x2, s: in std_logic;
       y1, y2: out std_logic);
end xbar_v1_1;

architecture rtl_1 of xbar_v1_1 is
	begin
		y2 <= x2 when s = '0' 
					else x1;
						
		y1 <= x1 when s = '0'
					else x2;
end rtl_1;

