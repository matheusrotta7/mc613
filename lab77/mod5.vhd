library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;


entity mod5 is
	port (Clock: in std_logic;
			Q : out std_logic
			);
end mod5;

architecture Behavior of mod5 is
signal Count : std_logic_vector (2 downto 0);
signal clock_out : std_logic;

begin
	process (Clock)
	begin
		if (Clock'event and Clock = '1') then
			Count <= Count + 1;
			if (Count = 4) then
				clock_out <= '1';
				Count <= "000";
			else
				clock_out <= '0';
			end if ;
		end if;
	end process;
	Q <= clock_out;
end Behavior ;