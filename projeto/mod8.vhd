library ieee ;
use ieee.std_logic_1164.all ;
--use ieee.std_logic_unsigned.all ;

entity mod8 is
	port (clock		  : in std_logic;
			address_in    : in integer range 0 to 63;
			address_out : out integer range -1 to 63;
			clock_for_64		  : out std_logic
			);
end mod8;

architecture Behavior of mod8 is

signal Count : integer range 0 to 8;
signal clock_out : std_logic;
signal aux : integer range -9 to 72;


begin
	process (clock)
	begin
		if (clock'event and clock = '1') then
			Count <= Count + 1;
			if (Count = 8) then
				clock_for_64 <= '1';
				Count <= 0;
			else
				clock_for_64 <= '0';
			end if ;
			if (Count = 0) then
				aux <= address_in - 9;
			elsif (Count = 1) then
				aux <= address_in - 8;
			elsif (Count = 2) then
				aux <= address_in - 7;
			elsif (Count = 3) then
				aux <= address_in - 1;
			elsif (Count = 4) then
				aux <= address_in + 1;
			elsif (Count = 5) then
				aux <= address_in + 7;
			elsif (Count = 6) then
				aux <= address_in + 8;
			elsif (Count = 7) then
				aux <= address_in + 9;
			end if;
			if (aux < 0 or aux > 63) then
				address_out <= -1;
			else
				address_out <= aux;
			end if;
				
		end if;
	end process;
end Behavior;