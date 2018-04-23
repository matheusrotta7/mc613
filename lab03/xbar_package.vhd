library ieee;
use ieee.std_logic_1164.all;


PACKAGE xbar_package IS
	
END xbar_package ;



architecture behavior of xbar is

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
					
end behavior;

