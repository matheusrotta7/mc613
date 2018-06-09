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
signal 

architecture behavior of count_mines is

begin



process (clock, clock64)
begin
	if (clock'event and clock = '1') then
		
				
	end if;


	

end behavior;
