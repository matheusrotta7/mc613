library ieee;
use ieee.std_logic_1164.all;

entity alu is
  port (
    a, b : in std_logic_vector(3 downto 0);
    F : out std_logic_vector(3 downto 0);
    s0, s1 : in std_logic;
    Z, C, V, N : out std_logic
  );
end alu;

architecture behavioral of alu is

component ripple_carry
	port (
    x,y : in std_logic_vector(3 downto 0);
    r : out std_logic_vector(3 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    overflow : out std_logic
  );
end component ripple_carry;

signal result : std_logic_vector (3 downto 0);
signal melancia: std_logic_vector (3 downto 0);
begin
	process (a, b, s0, s1)
		begin
			if s0 = '0' and s1 = '0' then
				soma: ripple_carry PORT MAP (a, b, result, '0', C, V);
				F <= result;
				if result(3) = '1' then
					N <= 1;
				else 
					N <= 0;
				end if;	
					
				if result = "0000" then
					Z <= '0';
				else 
					Z <= '1';
				end if;	
					
				
			else if s0 = '0' and s1 = '1' then
				result <= a and b;
				C <= '0';
				V <= '0';
				N <= '0';
				F <= result;
				if result = "0000" then
					Z <= '0';
				else 
					Z <= '1';
				end if;
				
			else if s0 = '1' and s1 = '0' then
				melancia <= not A;
				stage0: ripple_carry PORT MAP (melancia, "0001", result, '0', C, V);
				melancia <= result;
				stage1: ripple_carry PORT MAP (a, melancia, result, '0', C, V);
				F <= result;
				if result(3) = '1' then
					N <= 1;
				else 
					N <= 0;
				end if;	
					
				if result = "0000" then
					Z <= '0';
				else 
					Z <= '1';
				end if;	
	
			else if s0 = '1' and s1 = '1' then
				result <= a or b;
				C <= '0';
				V <= '0';
				N <= '0';
				F <= result;
				if result = "0000" then
					Z <= '0';
				else 
					Z <= '1';
				end if;
			
			end if;
		end process;



  
end behavioral;
