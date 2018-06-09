library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_control is
	
	port
	(
		clock : std_logic;
		reset : std_logic
	);
end game_control;




architecture behavior of game_control is

TYPE State_type IS (A, B, C, D, E); 
--A: gera_campo
--B: wait_for_input (in game)
--C: perdeu 
--D: ganhou
--E: contando_as_minas
signal y : State_type;
signal acabou_gera_campo : std_logic;
signal pm_enable : std_logic;
signal game_over : std_logic;
signal won : std_logic;
signal restart : std_logic;
signal write_data : std_logic_vector (6 downto 0);
signal rand_vector : std_logic_vector (7 downto 0);
signal bomb_site : integer range 0 to 63;
signal keep_going : std_logic;
signal go : std_logic;
signal read_data : std_logic_vector (6 downto 0);
signal write_on_memory : std_logic;
signal current_bomb : integer range 0 to 63;
signal current_visit : integer range -1 to 63;
signal clock_64 : std_logic;
signal done_counting : std_logic;
signal new_data : std_logic_vector (6 downto 0);

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

component random is
Port ( 
		 clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       en : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (7 downto 0);
       check: out STD_LOGIC);

end component random;

component mod8 is
	port (clock		  : in std_logic;
			address_in    : in integer range 0 to 63;
			address_out : out integer range -1 to 63;
			clock_for_64		  : out std_logic
			);
end component mod8;

component mod64 is
	port (clock		  : in std_logic;
			address    : out integer range 0 to 63;
			done		  : out std_logic
			);
end component mod64;

component count_mines is
	
	port
	(
		clock : in std_logic;
		clock64 : in std_logic;
		read_data : in std_logic_vector (6 downto 0);
		new_data : out std_logic_vector (6 downto 0)
	);
	
end component count_mines;


	
	

begin
	
	go <= clock and keep_going;
	count0: populate_minefield_count port map (reset, go, keep_going);
	acabou_gera_campo <= not keep_going;
	random0: random port map (go, '0', '1', rand_vector, open);
	
	memory0: memory port map (clock, bomb_site, write_data, read_data, write_on_memory);

	md8: mod8 port map (clock, current_bomb, current_visit, clock_64);
	
	md64: mod64 port map (clock_64, current_bomb, done_counting);
	
	cm: count_mines port map (clock, clock_64, read_data, new_data);
	
	
	
	state_machine:
	process (reset, clock)
	begin
		if reset = '1' then
			y <= A;
		elsif (clock'event and clock = '1') then
			case y is
				when A =>
					bomb_site <= to_integer(unsigned(rand_vector(7 downto 2)));
					pm_enable <= '1';
					write_data <= "0100000";
					write_on_memory <= '1';
					if acabou_gera_campo = '0' then
						y <= A;
					else
						y <= E; --contar_minas
					end if;
				when B =>
					pm_enable <= '0';
					if game_over = '0' then
						y <= B;
					elsif  game_over = '1' and won = '0' then
						y <= C;
					elsif game_over = '1' and won = '1' then
						y <= D;
					end if;
				when C =>
					pm_enable <= '0';
					if restart = '0' then
						y <= C;
					else 
						y <= A;
					end if;
				when D =>
					pm_enable <= '0';
					if restart = '0' then
						y <= D;
					else 
						y <= A;
					end if;
				when E => 
					bomb_site <= current_visit;
					if clock_64 = '1' then
						write_data <= new_data; --atualizada com o número de bombas
						write_on_memory <= '1';
					else
						write_on_memory <= '0';
					end if;
					if done_counting = '0' then
						y <= B;
					else
						y <= E;
					end if;
			end case;
		end if;
	end process;
	
	
	
						
end behavior;

