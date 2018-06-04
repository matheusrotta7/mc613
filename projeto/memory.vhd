library ieee;
use ieee.std_logic_1164.all;


-- Quartus Prime VHDL Template
-- Single port RAM with single read/write address 

library ieee;
use ieee.std_logic_1164.all;

entity memory is

	port 
	(
		Clock : in std_logic;
		Address : in integer range 0 to 63;
		Data : in std_logic_vector(6 downto 0);
		Q : out std_logic_vector(6 downto 0);
		WrEn : in std_logic
	);

end memory;

architecture direct of memory is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(6 downto 0);
	type memory_t is array(63 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

	-- Register to hold the address 
	signal addr_reg : integer range 0 to 63;
	
	signal read : std_logic_vector(6 downto 0);

begin

	process(Clock, Address)
	begin
	if(rising_edge(Clock)) then
		if(WrEn = '1') then
			ram(Address) <= Data;
		end if;
	end if;
	
	-- Register the address for reading
	addr_reg <= Address;
	end process;

	Q <= ram(addr_reg);

end direct;