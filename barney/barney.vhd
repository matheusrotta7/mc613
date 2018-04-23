LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity barney is
	port (
		SW: in std_logic_vector(5 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX3: out std_logic_vector(6 downto 0);
		HEX4: out std_logic_vector(6 downto 0);
		HEX5: out std_logic_vector(6 downto 0)
	);
end barney;

ARCHITECTURE behavior OF barney	IS
	BEGIN
		with SW select
			HEX0 <=	"0000011" when "000001",
						"0001000" when "000011",
						"0101111" when "000111",
						"0101011" when "001111",
						"0000110" when "011111",
						"0010001" when "111111",
						"1111111" when others;
						
		
		with SW select				
			HEX1 <=	"0000011" when "000011",
						"0001000" when "000111",
						"0101111" when "001111",
						"0101011" when "011111",
						"0000110" when "111111",
						"1111111" when others;
						
		with SW select				
			HEX2 <=	"0000011" when "000111",
						"0001000" when "001111",
						"0101111" when "011111",
						"0101011" when "111111",
						"1111111" when others;
		
		with SW select
			HEX3 <=	"0000011" when "001111",
						"0001000" when "011111",
						"0101111" when "111111",
						"1111111" when others;
						
		with SW select				
			HEX4 <=	"0000011" when "011111",
						"0001000" when "111111",
						"1111111" when others;
						
		with SW select				
			HEX5 <=	"0000011" when "111111",
						"1111111" when others;
						
	END behavior;