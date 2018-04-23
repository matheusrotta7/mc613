library ieee;
use ieee.std_logic_1164.all;

entity xbar_stage_5 is
generic (N : Integer := 5);
  port(SW  : in std_logic_vector (4 downto 0);
       LEDR: out std_logic_vector(0 downto 0));
end xbar_stage_5;

architecture rtl of xbar_stage_5 is
component xbar_gen
	port(s: in std_logic_vector (N-1 downto 0);
       y1, y2: out std_logic);
end component xbar_gen;

signal y1_aux : std_logic;
signal y2_aux : std_logic;
begin

	instance:
		xbar_gen GENERIC MAP (N => 5)
						 PORT MAP (s => SW, y1 => LEDR(0));
							 
						 

  -- add your code
end rtl;

