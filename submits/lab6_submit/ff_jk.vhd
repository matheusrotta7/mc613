LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ff_jk  is 
	port (
    J      : in std_logic;
    K      : in std_logic;
    Clk    : in std_logic;
    Q      : out std_logic;
    Q_n    : out std_logic; 
    Preset : in std_logic;
    Clear  : in std_logic
  );
end ff_jk;

architecture behavioral of ff_jk is 
begin
	process 
		variable temp: std_logic;
	begin
		wait until Clk'event and Clk = '1';
		
		if Clear = '1'
		then temp := '0';
			  
		elsif Preset = '1'
		then temp := '1';
		
		else
		
			if J = '0' and K = '1'
			then temp := '0';
			elsif J = '1' and K = '0'
			then temp := '1';
			elsif J = '1' and K = '1'
			then temp := not (temp);
		   end if;
			
		end if;
		Q <= temp;
		Q_n <= not (temp);
	end process;
end behavioral;