LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ff_t  is 
	port (
    T      : in std_logic;
    Clk    : in std_logic;
    Q      : out std_logic;
    Q_n    : out std_logic; 
    Preset : in std_logic;
    Clear  : in std_logic
  );
end ff_t;

architecture behavioral of ff_t is 
begin
	process 
		variable temp: std_logic;
	begin
		wait until Clk'event and Clk = '1';
		
		if Clear = '1'
		then temp := '0';
			  
		elsif Preset = '1'
		then temp := '1';
		
		elsif T = '1'
		then
			temp := not (temp);
		end if;
		Q <= temp;
		Q_n <= not (temp);
	end process;
end behavioral;