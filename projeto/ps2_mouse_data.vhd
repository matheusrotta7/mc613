LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ps2_mouse_data is
	port
	(
		------------------------	Clock Input	 	------------------------
		CLOCK_50	: 	in	STD_LOGIC;											--	50 MHz
		
		------------------------	Push Button		------------------------
		KEY 	:		in	STD_LOGIC_VECTOR (3 downto 0);		--	Pushbutton[3:0]

		------------------------	DPDT Switch		------------------------
		SW 	:		in	STD_LOGIC_VECTOR (9 downto 0);			--	Toggle Switch[9:0]
		
		CLICK	:		out STD_LOGIC_VECTOR (2 downto 0);
		DATA	:		out STD_LOGIC_VECTOR (15 downto 0);
		
		LEDR 	:		out	STD_LOGIC_VECTOR (9 downto 0);		--	LED Red[9:0]
					
		------------------------	PS2		--------------------------------
		PS2_DAT 	:		inout	STD_LOGIC;	--	PS2 Data
		PS2_CLK		:		inout	STD_LOGIC		--	PS2 Clock
	);
end;

architecture struct of ps2_mouse_data is
	component bin2hex
		port(
			SW  : in std_logic_vector(3 downto 0);
			HEX0: out std_logic_vector(6 downto 0)
		);
	end component;

	component mouse_ctrl
		generic(
			clkfreq : integer
		);
		port(
			ps2_data	:	inout	std_logic;
			ps2_clk		:	inout	std_logic;
			clk				:	in 	std_logic;
			en				:	in 	std_logic;
			resetn		:	in 	std_logic;
			newdata		:	out	std_logic;
			bt_on			:	out	std_logic_vector(2 downto 0);
			ox, oy		:	out std_logic;
			dx, dy		:	out	std_logic_vector(8 downto 0);
			wheel			: out	std_logic_vector(3 downto 0)
		);
	end component;
	
	signal signewdata, resetn : std_logic;
	signal dx, dy : std_logic_vector(8 downto 0);
	signal x, y 	: std_logic_vector(7 downto 0);
	signal hexdata : std_logic_vector(15 downto 0);
	signal hexdata_aux : std_logic_vector(15 downto 0);
	signal click_aux	: std_logic_vector(2 downto 0);
	signal block_x : std_logic_vector(3 downto 0);
	signal block_y : std_logic_vector(3 downto 0);
	
	constant SENSIBILITY : integer := 32; -- Rise to decrease sensibility
begin 
	-- KEY(0) Reset
	resetn <= KEY(0);
	
	mousectrl : mouse_ctrl generic map (50000) port map(
		PS2_DAT, PS2_CLK, CLOCK_50, '1', KEY(0),
		signewdata, click_aux(2 downto 0), LEDR(9), LEDR(8), dx, dy, LEDR(3 downto 0)
	);
	
	
	-- Read new mouse data	
	process(signewdata, resetn)
		variable xacc, yacc : integer range -10000 to 10000;
		variable x_a, y_a : std_logic_vector(7 downto 0);
	begin
		if(rising_edge(signewdata)) then
			x_a := std_logic_vector(to_signed(to_integer(signed(x)) + ((xacc + to_integer(signed(dx))) / SENSIBILITY), 8));
--			
			if(to_integer(unsigned(x)) >= 127) then
				if(to_integer(unsigned(x_a)) <= 127) then
					x <= x_a;
				elsif(to_integer(unsigned(x_a)) < to_integer(unsigned(x))) then
					x <= std_logic_vector(to_unsigned(0, 8));
				else
					x <= std_logic_vector(to_unsigned(127, 8));
				end if;
			elsif(to_integer(unsigned(x)) = 0) then
				if(to_integer(unsigned(x_a)) > 0 and to_integer(unsigned(x_a)) < 127) then
					x <= x_a;
				else
					x <= std_logic_vector(to_unsigned(0, 8));
				end if;
			else
				x <= x_a;
			end if;
			
			
			y_a := std_logic_vector(to_signed(to_integer(signed(y)) + ((yacc - to_integer(signed(dy))) / SENSIBILITY), 8));
--			
			if(to_integer(unsigned(y)) >= 127) then	
				if(to_integer(unsigned(y_a)) <= 127) then
					y <= y_a;
				elsif(to_integer(unsigned(y_a)) < to_integer(unsigned(y))) then
					y <= std_logic_vector(to_unsigned(0, 8));
				else
					y <= std_logic_vector(to_unsigned(127, 8));
				end if;
			elsif(to_integer(unsigned(y)) = 0) then
				if(to_integer(unsigned(y_a)) > 0 and to_integer(unsigned(y_a)) < 127) then
					y <= y_a;
				else
					y <= std_logic_vector(to_unsigned(0, 8));
				end if;
			else
				y <= y_a;
			end if;
--			y <= std_logic_vector(to_signed(to_integer(signed(y)) + ((yacc + to_integer(signed(dy))) / SENSIBILITY), 8));
			
			xacc := ((xacc + to_integer(signed(dx))) rem SENSIBILITY);
			yacc := ((yacc + to_integer(signed(dy))) rem SENSIBILITY);					
		end if;
		if resetn = '0' then
			xacc := 0;
			yacc := 0;
			x <= (others => '0');
			y <= (others => '0');
		end if;
	end process;

--	hexdata_aux(7  downto  0) <= std_logic_vector(shift_right(unsigned(y), 5));
--	hexdata_aux(15 downto  8) <= std_logic_vector(shift_right(unsigned(x), 5));
	
	--	
--	with click_aux select
--			block_y <= "1111" when "000",
--							hexdata_aux(3 downto 0) when others;
--							
--	
--	with click_aux select
--			block_x <= "1111" when "000",
--							hexdata_aux(11 downto 8) when others;
		
	DATA(3  downto  0) <= y(3 downto 0);
	DATA(7  downto  4) <= y(7 downto 4);
	
	
	DATA(11 downto  8) <= x(3 downto 0);
	DATA(15 downto 12) <= x(7 downto 4);
	
	CLICK <= click_aux;
	
	
end struct;
