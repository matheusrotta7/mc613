library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry is
  generic (
    N : integer := 4
  );
  port (
    x,y : in std_logic_vector(N-1 downto 0);
    r : out std_logic_vector(N-1 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    overflow : out std_logic
  );
end ripple_carry;

architecture rtl of ripple_carry is

component full_adder
  port (
    x, y : in std_logic;
    r : out std_logic;
    cin : in std_logic;
    cout : out std_logic
  );
end component full_adder;

signal c : STD_LOGIC_VECTOR (1 TO N) ;

begin
	stage0: full_adder PORT MAP (x(0), y(0), r(0), cin, c(1));
	laco:
	 for i in 1 to N-1 generate 
		stage: full_adder PORT MAP (x(i), y(i), r(i), c(i), c(i+1));
	end generate;
	overflow <= c(N-1) xor c(N);
	cout <= c(N);
end rtl;
