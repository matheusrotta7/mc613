library ieee;
use ieee.std_logic_1164.all;

entity fsm_table is 
	port (Clock, Resetn, w : in std_logic;
			z 					  : out std_logic);
end fsm_table;

architecture behavior of fsm_table is
	type state_type is (a, b, c, d);
	
	signal y : state_type;
begin
	process (Resetn, Clock)
	begin
		if Resetn = '0' then
			y <= a;
		elsif (Clock'event and clock = '1') then 
			case y is
				when a =>
					if w = '0'
						then y <= c;
						else y <= b;
					end if;
				when b =>
					if w = '0'
						then y <= d;
						else y <= c;
					end if;
				when c =>
					if w = '0'
						then y <= b;
						else y <= c;
					end if;
				when d =>
					if w = '0'
						then y <= a;
						else y <= c;
					end if;
			end case;
		end if;
	end process;
	
	process (y, w) 
	begin 
		case y is 
			when a =>
				z <= '1';
			when b =>
				z <= not w;
			when c =>
				z <= '0';
			when d =>
				z <= w;
		end case;
	end process;
end behavior;