-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_8bits is
  port(
    x    : in  std_logic_vector(7 downto 0);
    y    : in  std_logic_vector(7 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(7 downto 0);
    cout : out std_logic
  );
end cla_8bits;

architecture rtl of cla_8bits is
signal c1 : std_logic;
signal c2 : std_logic;
signal c3 : std_logic;
signal c4 : std_logic;
signal c5 : std_logic;
signal c6 : std_logic;
signal c7 : std_logic;

signal p0 : std_logic;
signal p1 : std_logic;
signal p2 : std_logic;
signal p3 : std_logic;
signal p4 : std_logic;
signal p5 : std_logic;
signal p6 : std_logic;
signal p7 : std_logic;

signal g0 : std_logic;
signal g1 : std_logic;
signal g2 : std_logic;
signal g3 : std_logic;
signal g4 : std_logic;
signal g5 : std_logic;
signal g6 : std_logic;
signal g7 : std_logic;


begin
	g0 <= x(0) and y(0);
	g1 <= x(1) and y(1);
	g2 <= x(2) and y(2);
	g3 <= x(3) and y(3);
	g4 <= x(4) and y(4);
	g5 <= x(5) and y(5);
	g6 <= x(6) and y(6);
	g7 <= x(7) and y(7);
	
	p0 <= x(0) or y(0);
	p1 <= x(1) or y(1);
	p2 <= x(2) or y(2);
	p3 <= x(3) or y(3);
	p4 <= x(4) or y(4);
	p5 <= x(5) or y(5);
	p6 <= x(6) or y(6);
	p7 <= x(7) or y(7);
	
	c1 <= g0 or 
			(p0 and cin);
	
	c2 <= g1 or 
			(p1 and g0) or 
		   (p1 and p0 and cin);
		  
	c3 <= g2 or 
			(p2 and g1) or 
		   (p2 and p1 and g0) or 
		   (p2 and p1 and p0 and cin);
	
	c4 <= g3 or 
			 (p3 and g2) or
			 (p3 and p2 and g1) or
			 (p3 and p2 and p1 and g0) or
			 (p3 and p2 and p1 and p0 and cin);
			 
	c5 <= g4 or
			(p4 and g3) or 
			(p4 and p3 and g2) or
			(p4 and p3 and p2 and g1) or
			(p4 and p3 and p2 and p1 and g0) or
			(p4 and p3 and p2 and p1 and p0 and cin);
	
	c6 <= g5 or 
			(p5 and g4) or 
			(p5 and p4 and g3) or 
			(p5 and p4 and p3 and g2) or
			(p5 and p4 and p3 and p2 and g1) or
			(p5 and p4 and p3 and p2 and p1 and g0) or
			(p5 and p4 and p3 and p2 and p1 and p0 and cin);
	
	c7 <= g6 or
			(p6 and g5) or 
			(p6 and p5 and g4) or 
			(p6 and p5 and p4 and g3) or 
			(p6 and p5 and p4 and p3 and g2) or
			(p6 and p5 and p4 and p3 and p2 and g1) or
			(p6 and p5 and p4 and p3 and p2 and p1 and g0) or
			(p6 and p5 and p4 and p3 and p2 and p1 and p0 and cin);
			
	cout <= g7 or
			(p7 and g6) or
			(p7 and p6 and g5) or 
			(p7 and p6 and p5 and g4) or 
			(p7 and p6 and p5 and p4 and g3) or 
			(p7 and p6 and p5 and p4 and p3 and g2) or
			(p7 and p6 and p5 and p4 and p3 and p2 and g1) or
			(p7 and p6 and p5 and p4 and p3 and p2 and p1 and g0) or
			(p7 and p6 and p5 and p4 and p3 and p2 and p1 and p0 and cin);
	
	sum(0) <= (x(0) xor y(0) xor cin);
	sum(1) <= (x(1) xor y(1) xor c1);
	sum(2) <= (x(2) xor y(2) xor c2);
	sum(3) <= (x(3) xor y(3) xor c3);
	sum(4) <= (x(4) xor y(4) xor c4);
	sum(5) <= (x(5) xor y(5) xor c5);
	sum(6) <= (x(6) xor y(6) xor c6);
	sum(7) <= (x(7) xor y(7) xor c7);
	
	
end rtl;

