library ieee;
use ieee.std_logic_1164.all;

COMPONENT xbar_v1_2
		port(x1, x2, s: in std_logic;
				  y1, y2: out std_logic);
END COMPONENT ;


entity xbar_v1_gen is
	generic (n: integer := 5);
		port(x1, x2, s: in std_logic;
			     y1, y2: out std_logic);
end xbar_v1_gen;





architecture gen of xbar_v1_gen is
	begin
		generate_label:
			for i in 0 to n-1 generate
				stage: xbar_v1_2 PORT MAP (x1, x2, s, y1, y2);
			end generate;

end gen;