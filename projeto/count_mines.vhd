library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_mines is
	
	port
	(
		clock : in std_logic;
		clock64 : in std_logic;
		read_data : in std_logic_vector (6 downto 0);
		new_data : out std_logic_vector (6 downto 0)
	);
	
end count_mines;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)



architecture behavior of count_mines is

--signal num_bombs : std_logic_vector (3 downto 0);
signal num_bombs : integer range 0 to 8;
signal aux : std_logic_vector (6 downto 0);
signal is_bomb : integer range 0 to 1;



begin


process (clock, clock64)
begin
	if (clock'event and clock = '1') then
		aux <= read_data;
		--is_bomb <= read_data(5);
		if read_data(5) = '1' then
			is_bomb <= 1;
		else 
			is_bomb <= 0;
		end if;

		if (clock64 = '0') then
			num_bombs <= num_bombs + is_bomb;
		else
			aux (3 downto 0) <= std_logic_vector(to_unsigned(num_bombs, 4));
			new_data <= aux;
			num_bombs <= 0;
		end if;
	end if;
end process;
end behavior;
