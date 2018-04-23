library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity mod24_settable is
	port (Clock		       : in std_logic;
			set             : in std_logic;
			unity           : in std_logic_vector (3 downto 0);
			decimal         : in std_logic_vector (3 downto 0);
			hour_un_result  : out std_logic_vector (3 downto 0);
			hour_dec_result : out std_logic_vector (3 downto 0)
			);
end mod24_settable;

architecture Behavior of mod24_settable is

component set_dec 
	port (
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			result     : out std_logic_vector (3 downto 0)
			);
end component set_dec;


component mod24 
	port (Clock		       : in std_logic;
			set             : in std_logic;
			unity           : in std_logic_vector (3 downto 0);
			decimal         : in std_logic_vector (3 downto 0);
			hour_un_result  : out std_logic_vector (3 downto 0);
			hour_dec_result : out std_logic_vector (3 downto 0)
			);
	end component mod24;

signal mod24_un_result  : std_logic_vector (3 downto 0);
signal mod24_dec_result : std_logic_vector (3 downto 0);
signal set_un_result    : std_logic_vector (3 downto 0);
signal set_dec_result   : std_logic_vector (3 downto 0);


begin
										  
	mod24_logic: mod24 port map (Clock, '0', "0000", "0000", mod24_un_result, mod24_dec_result);
	set_logic_un: set_dec port map (set, unity, set_un_result);
	set_logic_dec: set_dec port map (set, decimal, set_dec_result);
	
	
	with set select
		hour_un_result <= mod24_un_result when '0',
					         set_un_result when others;
								
	with set select
		hour_dec_result <= mod24_dec_result when '0',
					         set_dec_result when others;
	
end Behavior ;