
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity populate_minefield_count is
	
	port
	(
		reset : in std_logic;
		clock : in std_logic;
		keep_going : out std_logic
	);
end populate_minefield_count;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture behavior of populate_minefield_count is

	-- Declarations (optional)
signal count : integer range 0 to 10;
--signal aux   : std_logic;


begin

	process (reset, clock)
	begin
		if (reset = '1') then
			count <= 0;
			keep_going <= '1';
		elsif (clock'event and clock = '1') then
			if (count > 9) then
				keep_going <= '0';
			else
				count <= count + 1;
			end if;
		end if;
	end process;
end behavior;
