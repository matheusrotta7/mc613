LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity latch_d_gated  is 
	port (
	 D   : in std_logic;
    Clk : in std_logic;
    Q   : out std_logic;
    Q_n : out std_logic
	);
end latch_d_gated;

architecture behavioral of latch_d_gated is 
begin
	process (D, Clk) 
	begin
		if Clk = '1' then
			Q <= D;
			Q_n <= not(D);
		end if;
	end process;
end behavioral;