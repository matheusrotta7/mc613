library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity mod2 is
	port (Clock: in std_logic;
			Q : out std_logic
			);
end mod2 ;

architecture Behavior of mod2 is
signal Count : std_logic;
begin
	process (Clock)
	begin
		if (Clock'event and Clock = '1') then
			Count <= not Count;
		end if;
	end process;
	Q <= Count ;
END Behavior ;