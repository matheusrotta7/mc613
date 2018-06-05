library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity populate_minefield is
	
	port
	(
			clock : in std_logic;
			reset : in std_logic;
			bs    : out std_logic_vector(5 downto 0);
			kg    : out std_logic
	);
end populate_minefield;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture behavior of populate_minefield is

component random is
Port ( 
		 clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       en : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (7 downto 0);
       check: out STD_LOGIC);

end component random;

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


--signal count : integer range 0 to 9;
signal rand_vector : std_logic_vector (7 downto 0);
signal bomb_site : integer range 0 to 63;
signal keep_going : std_logic;
signal go : std_logic;

begin

count0: populate_minefield_count port map (reset, clock, keep_going);

go <= clock and keep_going;

random0: random port map (go, '0', '1', rand_vector, open);
bomb_site <= to_integer(unsigned(rand_vector(7 downto 2)));

memory0: memory port map (go, bomb_site, "0100000", open, '1');

bs <= rand_vector(7 downto 2);
kg <= keep_going;

end behavior;
