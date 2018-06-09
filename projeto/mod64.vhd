library ieee ;
use ieee.std_logic_1164.all ;
--use ieee.std_logic_unsigned.all ;

entity mod64 is
	port (clock		  : in std_logic;
			address    : out integer range 0 to 63;
			done		  : out std_logic
			);
end mod64;

architecture Behavior of mod64 is

signal Count : integer range 0 to 64;
signal clock_out : std_logic;

begin
	process (clock)
	begin
		if (clock'event and clock = '1') then
			Count <= Count + 1;
			if (Count = 64) then
				done <= '1';
				Count <= 0;
			else
				done <= '0';
			end if ;
		end if;
	end process;
	address <= Count;
end Behavior ;