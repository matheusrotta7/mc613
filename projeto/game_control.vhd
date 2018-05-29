entity game_control is
	generic
	(
		<name>	: <type>  :=	<default_value>;
		...
		<name>	: <type>  :=	<default_value>
	);


	port
	(
		-- Input ports
		position_x	: in  integer;
		position_y	: in  integer;
		click_type	: in  std_logic_vector(2 downto 0); --closed_tile, open_tile (no_effect), restart (button)

		-- Inout ports
		
		-- Output ports
		status	: out <type>;
		field	: out <type> := <default_value>
	);
end game_control;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture behavior of game_control is

	-- Declarations (optional)

begin

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end behavior;
