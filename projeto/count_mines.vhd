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

signal num_bombs : std_logic_vector (3 downto 0);
signal aux : std_logic_vector (6 downto 0);
signal is_bomb : std_logic;


architecture behavior of count_mines is

begin

aux <= read_data;
is_bomb <= read_data(5);


process (clock, clock64)
begin
	if (clock'event and clock = '1') then
		if (clock64 = '0') then
			num_bombs =< num_bombs + is_bomb;
		else
			aux (3 downto 0) <= num_bombs;
			new_data <= aux;
		end if;
	end if;
end behavior;
