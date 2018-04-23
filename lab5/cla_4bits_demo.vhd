-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_4bits_demo is
  port(
		SW : in std_logic_vector (8 downto 0);
		LEDR: out std_logic_vector (4 downto 0)
  );
end cla_4bits_demo;

architecture rtl of cla_4bits_demo is

component cla_4bits 
  port(
    x    : in  std_logic_vector(3 downto 0);
    y    : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(3 downto 0);
    cout : out std_logic
  );
end component cla_4bits;

component full_adder 
  port (
    x, y : in std_logic;
    r : out std_logic;
    cin : in std_logic;
    cout : out std_logic
  );
end component full_adder;



begin
	
	only_stage: cla_4bits PORT MAP (SW(3 downto 0), SW(7 downto 4), SW(8), LEDR(3 downto 0), LEDR(4));
	

	
end rtl;

