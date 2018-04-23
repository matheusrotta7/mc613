library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity mod24 is
	port (Clock		       : in std_logic;
			set             : in std_logic;
			unity           : in std_logic_vector (3 downto 0);
			decimal         : in std_logic_vector (3 downto 0);
			hour_un_result  : out std_logic_vector (3 downto 0);
			hour_dec_result : out std_logic_vector (3 downto 0)
			);
end mod24;

architecture Behavior of mod24 is
signal Count : std_logic_vector (4 downto 0);
signal clock_out : std_logic;

begin
	process (Clock)
	begin
		if (Clock'event and Clock = '1') then
			Count <= Count + 1;
			if (Count = 23) then
				clock_out <= '1';
				Count <= "00000";
			else
				clock_out <= '0';
			end if ;
		end if;
	end process;
	
	with Count select
		hour_dec_result <= "0000" when "00000",
								"0000" when "00001",
								"0000" when "00010",
								"0000" when "00011",
								"0000" when "00100",
								"0000" when "00101",
								"0000" when "00110",
								"0000" when "00111",
								"0000" when "01000",
								"0000" when "01001",
								"0001" when "01010",
								"0001" when "01011",
								"0001" when "01100",
								"0001" when "01101",
								"0001" when "01110",
								"0001" when "01111",
								"0001" when "10000",
								"0001" when "10001",
								"0001" when "10010",
								"0001" when "10011",
								"0010" when "10100",
								"0010" when "10101",
								"0010" when "10110",
								"0010" when "10111",
								"0000" when others;
								
	with Count select
		hour_un_result <= "0000" when "00000",
								"0001" when "00001",
								"0010" when "00010",
								"0011" when "00011",
								"0100" when "00100",
								"0101" when "00101",
								"0110" when "00110",
								"0111" when "00111",
								"1000" when "01000",
								"1001" when "01001",
								"0000" when "01010",
								"0001" when "01011",
								"0010" when "01100",
								"0011" when "01101",
								"0100" when "01110",
								"0101" when "01111",
								"0110" when "10000",
								"0111" when "10001",
								"1000" when "10010",
								"1001" when "10011",
								"0000" when "10100",
								"0001" when "10101",
								"0010" when "10110",
								"0011" when "10111",
								"0000" when others;
							
end Behavior;