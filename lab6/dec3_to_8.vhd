LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity dec3_to_8 is
	port (
		panda : out std_logic_vector (7 downto 0);
		q		: in std_logic_vector (2 downto 0)
		);
end dec3_to_8;

architecture behavioral of dec3_to_8 is 

signal n : std_logic_vector (7 downto 0);
signal aux : std_logic_vector (7 downto 0);

begin
	
	with q select
			panda <=	"10000000" when "000",
						"01000000" when "001",
						"00100000" when "010",
						"00010000" when "011",
						"00001000" when "100",
						"00000100" when "101",
						"00000010" when "110",
						"00000001" when "111";
		
end behavioral;