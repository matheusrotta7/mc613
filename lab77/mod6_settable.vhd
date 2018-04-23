library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity mod6_settable is
	port (clk_hz		  : in std_logic;
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			clk1 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
end mod6_settable;

architecture Behavior of mod6_settable is

component set_dec 
	port (
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			result     : out std_logic_vector (3 downto 0)
			);
end component set_dec;


component mod6 
	port (Clock		  : in std_logic;
			set        : in std_logic;
			decimal    : in std_logic_vector (3 downto 0);
			Q 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
	end component mod6;

signal mod6_result : std_logic_vector (3 downto 0);
signal set_result   : std_logic_vector (3 downto 0);


begin

	mod6_logic: mod6 port map (clk_hz, '0', "0000", clk1, mod6_result);
	set_logic: set_dec port map (set, unity, set_result);
	
	with set select
		result <= mod6_result when '0',
					 set_result when others;
	
end Behavior ;