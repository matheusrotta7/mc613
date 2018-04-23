library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_board is
  port (
    SW : in std_logic_vector(7 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(0 downto 0)
    );
end ripple_carry_board;

architecture rtl of ripple_carry_board is

	component full_adder
	port (
		x, y : in std_logic;
		r : out std_logic;
		cin : in std_logic;
		cout : out std_logic
	);
	end component full_adder;

	component bin2hex
	port (
		SW: in std_logic_vector(3 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);
	end component bin2hex;

signal c : STD_LOGIC_VECTOR (1 TO 4) ;
signal x : std_logic_vector (3 downto 0);
signal y : std_logic_vector (3 downto 0);
signal r : std_logic_vector (3 downto 0);

begin

	x <= SW(7 downto 4);
	y <= SW(3 downto 0);
	
	stage0: full_adder PORT MAP (x(0), y(0), r(0), '0', c(1));
	laco:
	 for i in 1 to 3 generate 
		stage: full_adder PORT MAP (x(i), y(i), r(i), c(i), c(i+1));
	end generate;
	
	aux_x: bin2hex PORT MAP (SW(7 downto 4), HEX4);
	aux_y: bin2hex PORT MAP (SW(3 downto 0), HEX2);
	aux_r: bin2hex PORT MAP (r, HEX0);
	
	LEDR(0) <= c(3) xor c(4);
--	LEDR <= SW;
	
	
end rtl;
