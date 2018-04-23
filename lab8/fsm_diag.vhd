library ieee;
use ieee.std_logic_1164.all;

entity fsm_diag is
    port (
      clock : in  std_logic;
      reset : in  std_logic;
      w     : in  std_logic;
      z     : out std_logic
    );
  end fsm_diag;

architecture behavior of fsm_diag is
	type state_type is (a, b, c, d); -- tipo enumerado para
	
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
						then y <= a;
						else y <= b;
					end if;
				when b =>
					if w = '0'
						then y <= c;
						else y <= b;
					end if;
				when c =>
					if w = '0'
						then y <= c;
						else y <= d;
					end if;
				when d =>
					if w = '0'
					then y <= a;
					else y <= d;
				end if;
			end case;	
		end if;
	end process;
	
	z <= '1' when y = b else '0';
end behavior;