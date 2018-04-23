library ieee;
use ieee.std_logic_1164.all;

entity alu_board is
  port (
    SW : in std_logic_vector(9 downto 0);
    HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(3 downto 0)
  );
end alu_board;



architecture behavioral of alu_board is
component alu
	port (
    a, b       : in std_logic_vector(3 downto 0);
    F          : out std_logic_vector(3 downto 0);
    s0, s1     : in std_logic;
    Z, C, V, N : out std_logic
  );
end component alu;

component bin2hex
	port (
		SW: in std_logic_vector(3 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);
end component bin2hex;

component two_comp_to_7seg is
  port (
    bin : in std_logic_vector(3 downto 0);
    segs : out std_logic_vector(6 downto 0);
    neg : out std_logic
  );
end component two_comp_to_7seg;

signal F_aux: std_logic_vector (3 downto 0);
signal a : std_logic;
signal b : std_logic;
signal c : std_logic;

signal entrada_logic_a			: std_logic_vector (6 downto 0);
signal entrada_aritmethic_a	: std_logic_vector (6 downto 0);
signal entrada_logic_b			: std_logic_vector (6 downto 0);
signal entrada_aritmethic_b	: std_logic_vector (6 downto 0);

signal saida_logic : std_logic_vector (6 downto 0);
signal saida_aritmethic: std_logic_vector (6 downto 0);

signal a_composed: std_logic_vector (1 downto 0);
signal b_composed: std_logic_vector (1 downto 0);
signal c_composed: std_logic_vector (1 downto 0);

begin
stage0: alu PORT MAP  (SW(7 downto 4), 
							  SW (3 downto 0), F_aux, 
							  SW(9), SW(8), 
							  LEDR(3), LEDR(2), 
							  LEDR(1), LEDR(0));
							 

stage2: two_comp_to_7seg PORT MAP (SW(7 downto 4), entrada_aritmethic_a, b);
stage3: two_comp_to_7seg PORT MAP (SW(3 downto 0), entrada_aritmethic_b, c);

and_time: bin2hex PORT MAP (SW(7 downto 4), entrada_logic_a);
or_time:  bin2hex PORT MAP (SW(3 downto 0), entrada_logic_b);


stage5: two_comp_to_7seg PORT MAP (F_aux, saida_aritmethic, a);
stage6: bin2hex PORT MAP (F_aux, saida_logic);

a_composed <= a & SW(8);
b_composed <= b & SW(8);
c_composed <= c & SW(8);


with a_composed select
		HEX1 <= "0111111" when "10",
			     "1111111" when others;
				  
with b_composed select
		HEX5 <= "0111111" when "10",
			     "1111111" when others;
				  
with c_composed select
		HEX3 <= "0111111" when "10",
			     "1111111" when others;
				  
with SW(8) select
		HEX0 <= saida_logic when '1',
				  saida_aritmethic when others;
				  
with SW(8) select
		HEX4 <= entrada_logic_a when '1',
				  entrada_aritmethic_a when others;
				  
with SW(8) select
		HEX2 <= entrada_logic_b when '1',
				  entrada_aritmethic_b when others;
				  
			
				  
		
			  
			  
		
end behavioral;