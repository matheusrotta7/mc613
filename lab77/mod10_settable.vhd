library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity mod10_settable is
	port (clk_hz		  : in std_logic;
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			clk1 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
end mod10_settable;

architecture Behavior of mod10_settable is

component set_dec 
	port (
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			result     : out std_logic_vector (3 downto 0)
			);
end component set_dec;

component mod10 
	port (count_memory: in std_logic_vector (3 downto 0);
			Clock		  : in std_logic;
			set        : in std_logic;
			unity      : in std_logic_vector (3 downto 0);
			Q 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
	end component mod10;

signal mod10_result : std_logic_vector (3 downto 0);
signal set_result   : std_logic_vector (3 downto 0);
signal count_memory : std_logic_vector (3 downto 0);


begin

	mod10_logic: mod10 port map (count_memory, clk_hz, '0', "0000", clk1, mod10_result);
	set_logic: set_dec port map (set, unity, set_result);
	
	with set select
		count_memory <= set_result when '1',
							 count_memory when others;
	
	with set select
		result <= mod10_result when '0',
					 set_result when others;
					 
	
	
end Behavior ;