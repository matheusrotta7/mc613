library ieee;
use ieee.std_logic_1164.all;


entity fsm_seq is
port (clock, reset, w : in std_logic;
z : out std_logic );
end fsm_seq;

architecture behavior of fsm_seq is
	type state_type is (a, b, c, d, e); -- tipo enumerado para
	
	signal y : state_type;
	
	begin
	
	process ( resetn, clock )
		begin
		if resetn = '0' then -- a é o estado inicial
				y <= a;
			elsif (clock'event and clock = '1') then
			case y is
				when a =>	
					if w = '0'
						then y <= b;
						else y <= a;
					end if;
				when b =>
					if w = '0'
						then y <= a;
						else y <= c;
					end if;
				when c =>
					if w = '0'
						then y <= d;
						else y <= a;
					end if;
				when d =>
					if w = '0'
						then y <= b;
						else y <= e;
					end if;
				when e =>
					if w = '0'
						then y <= d;
						else y <= a;
					end if;
			end case;	
		end if;
	end process;
	
	z <= '1' when y = e else '0';
end behavior;