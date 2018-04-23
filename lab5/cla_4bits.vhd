-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_4bits is
  port(
    x    : in  std_logic_vector(3 downto 0);
    y    : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(3 downto 0);
    cout : out std_logic
  );
end cla_4bits;

architecture rtl of cla_4bits is

component full_adder 
  port (
    x, y : in std_logic;
    r : out std_logic;
    cin : in std_logic;
    cout : out std_logic
  );
end component full_adder;

signal c1 : std_logic;
signal c2 : std_logic;
signal c3 : std_logic;
signal c4 : std_logic;

signal p0 : std_logic;
signal p1 : std_logic;
signal p2 : std_logic;
signal p3 : std_logic;

signal g0 : std_logic;
signal g1 : std_logic;
signal g2 : std_logic;
signal g3 : std_logic;


begin
	
	g0 <= x(0) and y(0);
	g1 <= x(1) and y(1);
	g2 <= x(2) and y(2);
	g3 <= x(3) and y(3);
	
	p0 <= x(0) or y(0);
	p1 <= x(1) or y(1);
	p2 <= x(2) or y(2);
	p3 <= x(3) or y(3);
	
	c1 <= g0 or (p0 and cin);
	
	c2 <= g1 or (p1 and g0) or 
		  (p1 and p0 and cin);
		  
	c3 <= g2 or (p2 and g1) or 
		  (p2 and p1 and g0) or 
		  (p2 and p1 and p0 and cin);
	
	cout <= g3 or 
			 (p3 and g2) or
			 (p3 and p2 and g1) or
			 (p3 and p2 and p1 and g0) or
			 (p3 and p2 and p1 and p0 and cin);
	
	sum(0) <= (x(0) xor y(0) xor cin);
	sum(1) <= (x(1) xor y(1) xor c1);
	sum(2) <= (x(2) xor y(2) xor c2);
	sum(3) <= (x(3) xor y(3) xor c3);
	
	

	
end rtl;

