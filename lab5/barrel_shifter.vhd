-- brief : lab05 - question 1

library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter is
  port(
    w : in  std_logic_vector (3 downto 0);
    s : in  std_logic_vector (1 downto 0);
    y : out std_logic_vector (3 downto 0)
  );
end barrel_shifter;



architecture rtl of barrel_shifter is

signal option_0 : std_logic_vector (3 downto 0);
signal option_1 : std_logic_vector (3 downto 0);
signal option_2 : std_logic_vector (3 downto 0);
signal option_3 : std_logic_vector (3 downto 0);

begin

	option_0 <= w;
	option_1 <= w(0) & w(3) & w(2) & w(1);
	option_2 <= w(1) & w(0) & w(3) & w(2);
	option_3 <= w(2) & w(1) & w(0) & w(3);

	with s select
		y <= option_0 when "00",
			  option_1 when "01",
			  option_2 when "10",
			  option_3 when "11";

end rtl;

