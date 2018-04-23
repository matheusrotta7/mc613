LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity bin2hex is
	port (
		SW: in std_logic_vector(5 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX3: out std_logic_vector(6 downto 0);
		HEX4: out std_logic_vector(6 downto 0);
		HEX5: out std_logic_vector(6 downto 0);
	);
end bin2hex;

ARCHITECTURE behavior OF bin2hex	IS
	BEGIN
		with SW select
			HEX0 <=	"0000011" when "000001",
						"0001000" when "000011",
						"0101111" when "000111",
						"0101011" when "001111",
						"0000110" when "011111",
						"0010001" when "111111",
						"1111111" when others;
						
			HEX1 <=	"0000011" when "000011",
						"0001000" when "000111",
						"0101111" when "001111",
						"0101011" when "011111",
						"0000110" when "111111",
						"1111111" when others;
						
			HEX0 <=	"0100100" when "000111",
						"0110000" when "001111",
						"0011001" when "011111",
						"0010010" when "111111",
						"1111111" when others;
						
			HEX0 <=	"1000000" when "000001",
						"1111001" when "000011",
						"0100100" when "000111",
						"0110000" when "001111",
						"0011001" when "011111",
						"0010010" when "111111",
						"1111111" when others;
						
			HEX0 <=	"1000000" when "000001",
						"1111001" when "000011",
						"0100100" when "000111",
						"0110000" when "001111",
						"0011001" when "011111",
						"0010010" when "111111",
						"1111111" when others;
						
			HEX0 <=	"1000000" when "000001",
						"1111001" when "000011",
						"0100100" when "000111",
						"0110000" when "001111",
						"0011001" when "011111",
						"0010010" when "111111",
						"1111111" when others;
						
	END behavior;