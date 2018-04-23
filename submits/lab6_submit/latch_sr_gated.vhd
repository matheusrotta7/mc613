library ieee;
use ieee.std_logic_1164.all;

entity latch_sr_gated is
  port ( 
	 S   : in std_logic;
    R   : in std_logic;
	 Clk : in std_logic;
    Q   : out std_logic;
    Q_n : out std_logic
  );
end latch_sr_gated;

architecture behavioral of latch_sr_gated is 
begin
	process (S, R, Clk)
	begin
		if S = '1' and R = '0' and Clk = '1'
		then Q <= '0';
			  Q_n <= '1';
		elsif S = '0' and R = '1' and Clk = '1'
		then Q <= '1';
			  Q_n <= '0';
		end if;
	end process;
end behavioral;
	