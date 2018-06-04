entity populate_minefield is
	
	port
	(
		
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
		Address : in integer range 0 to 99;
		Data : in std_logic_vector(5 downto 0);
		Q : out std_logic_vector(5 downto 0);
		WrEn : in std_logic
	);

end component memory;


subtype word_t is std_logic_vector(7 downto 0);
type table is array(19 downto 0) of word_t;
type rand_ints is array(19 downto 0) of integer range 0 to 99;

		
signal aux : table;



begin

	stage0: memory

	GEN_RANDOM:	
	for i in 0 to 19 generate
      randomx : random port map(clk, '0', '1', aux(i), open);
		rand_ints(i) <= integer(aux(7 downto 1)) mod 100;
		
   end generate GEN_RANDOM;
	
	
	
	

	

end behavior;
