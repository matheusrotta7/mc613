library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity mod10 is
	port (count_memory: in std_logic_vector (3 downto 0);
			Clock		  : in std_logic;
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			Q 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
end mod10;

architecture Behavior of mod10 is
signal Count : std_logic_vector (3 downto 0);
signal clock_out : std_logic;

begin
	process (Clock)
	begin
		if (Clock'event and Clock = '1') then
			
			Count <= count_memory + 1;
			if (Count = 9) then
				clock_out <= '1';
				Count <= "0000";
			else
				clock_out <= '0';
			end if ;
		end if;
	end process;
	Q <= clock_out;
	result (3 downto 0) <= Count;
end Behavior ;