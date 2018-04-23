library ieee;
use ieee.std_logic_1164.all;

entity latch_sr_nand is
  port (
    S_n : in std_logic;
    R_n : in std_logic;
    Qa  : out std_logic;
    Qb  : out std_logic
  );
end latch_sr_nand;

architecture behavioral of latch_sr_nand is 
begin
	process (S_n, R_n)
	begin
		if S_n = '1' and R_n = '0'
		then Qa <= '0';
			  Qb <= '1';
		elsif S_n = '0' and R_n = '1'
		then Qa <= '1';
			  Qb <= '0';
		elsif S_n = '1' and R_n = '1'
		then Qa <= '1';
			  Qb <= '1';
		end if;
	end process;
end behavioral;
	