library ieee;
use ieee.std_logic_1164.all;

entity clk_div_demo is
  port (
		CLOCK_50 : in std_logic;
		LEDR: out std_logic_vector(0 downto 0)
  );
end clk_div_demo;

architecture behavioral of clk_div_demo is
component clk_div 
  port (
    clk : in std_logic;
    clk_hz : out std_logic
  );
end component clk_div;
begin
 
 stage: clk_div port map (CLOCK_50, LEDR(0));

end behavioral;
