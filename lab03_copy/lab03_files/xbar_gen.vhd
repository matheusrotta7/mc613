library ieee;
use ieee.std_logic_1164.all;

entity xbar_gen is
generic (N : Integer := 10);
  port(s: in std_logic_vector (N-1 downto 0);
       y1, y2: out std_logic);
end xbar_gen;

architecture rtl of xbar_gen is
component xbar_v2
  port(x1, x2, s: in std_logic;
	  y1, y2: out std_logic);
end component xbar_v2;

signal x1 : std_logic_vector(0 to N-1);
signal x2 : std_logic_vector(0 to N-1);
begin
	x1(0) <= '1';
	x2(0) <= '0';
	gen_label:
   for i in 0 to N-2 generate 
		stage: xbar_v2 PORT MAP (x1(i), x2(i), s(i), x1(i+1), x2(i+1));
	end generate;
					
	y1 <= x1(N-1);
	y2 <= x2(N-1);
  -- add your code
end rtl;

