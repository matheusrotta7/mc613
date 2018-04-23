library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity set_dec is
	port (
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			result     : out std_logic_vector (3 downto 0)
			);
end set_dec;

architecture Behavior of set_dec is

signal set_res : std_logic_vector (3 downto 0);


begin
	process (set)
	begin
		if (set = '1') then
			set_res <= unity;
		end if;
	end process;
	
	result <= set_res;
	
			
	
end Behavior ;