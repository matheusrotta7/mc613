entity game_control is
	
	port
	(
		clock : std_logic;
		reset : std_logic;
	);
end game_control;




architecture behavior of game_control is

TYPE State_type IS (A, B, C, D); 
--A: gera_campo
--B: wait_for_input (in game)
--C: perdeu 
--D: ganhou
signal y : State_type;
signal acabou_gera_campo : std_logic;
signal pm_enable : std_logic;
signal game_over : std_logic;
signal won : std_logic;
signal restart : std_logic;
signal write_data : std_logic (6 downto 0);
signal rand_vector : std_logic_vector (7 downto 0);
signal bomb_site : integer range 0 to 63;
signal keep_going : std_logic;
signal go : std_logic;
signal read_data : std_logic_vector (6 downto 0);
signal write_on_memory : std_logic;

component memory is

	port 
	(
		Clock : in std_logic;
		Address : in integer range 0 to 63;
		Data : in std_logic_vector(6 downto 0);
		Q : out std_logic_vector(6 downto 0);
		WrEn : in std_logic
	);

end component memory;

component populate_minefield_count is
	
	port
	(
		reset : in std_logic;
		clock : in std_logic;
		keep_going : out std_logic
	);
end component populate_minefield_count;
	
	

begin
	
	count0: populate_minefield_count port map (reset, clock, keep_going);
	go <= clock and keep_going;
	acabou_gera_campo <= not keep_going;
	random0: random port map (go, '0', '1', rand_vector, open);
	bomb_site <= to_integer(unsigned(rand_vector(7 downto 2)));
	memory0: memory port map (go, bomb_site, write_data, read_data, write_on_memory);

	
	
	state_machine:
	process (reset, clock)
		if reset = '1' then
			y <= A;
		elsif (clock'event and clock = '1') then
			case y is
				when A =>
					pm_enable <= '1';
					write_data <= "0100000";
					write_on_memory <= '1';
					if acabou_gera_campo = '0' then
						y <= A;
					else
						y <= B;
					end if;
				when B =>
					pm_enable <= '0';
					if game_over = '0' then
						y <= B;
					else if game_over = '1' and won = '0' then
						y <= C;
					else if game_over = '1' and won = '1' then
						y <= D;
					end if;
				when C =>
					pm_enable <= '0';
					if restart = '0' then
						y <= C;
					else 
						y <= A;
				when D =>
					pm_enable <= '0';
					if restart = '0' then
						y <= D;
					else 
						y <= A;
			end case;
		end if;
	end process;
	
	
	
						
end behavior;

