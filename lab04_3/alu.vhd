library ieee;
use ieee.std_logic_1164.all;

entity alu is
  port (
    a, b       : in std_logic_vector(3 downto 0);
    F          : out std_logic_vector(3 downto 0);
    s0, s1     : in std_logic;
    Z, C, V, N : out std_logic
  );
end alu;

architecture behavioral of alu is

component ripple_carry
	port (
    x,y      : in std_logic_vector(3 downto 0);
    r        : out std_logic_vector(3 downto 0);
    cin      : in std_logic;
    cout     : out std_logic;
    overflow : out std_logic
  );
end component ripple_carry;

signal soma_result : std_logic_vector (3 downto 0);
signal subt_result : std_logic_vector (3 downto 0);
signal and_result  : std_logic_vector (3 downto 0);
signal or_result   : std_logic_vector (3 downto 0);
signal C_soma      : std_logic;
signal V_soma      : std_logic;
signal C_subt      : std_logic;
signal V_subt      : std_logic;
signal s           : std_logic_vector (1 downto 0);
signal Z_soma      : std_logic;
signal Z_subt      : std_logic;
signal Z_and       : std_logic;
signal Z_or        : std_logic;


begin
	
			
	soma: ripple_carry PORT MAP (a, b, soma_result, '0', C_soma, V_soma);
	with soma_result select
		Z_soma <= '1' when "0000",
					 '0' when others;
	
	and_result <= a and b;
	with and_result select
		Z_and <= '1' when "0000",
					'0' when others;
	
	or_result <= a or b;
	with or_result select
		Z_or <= '1' when "0000",
				  '0' when others;
		
	subt: ripple_carry PORT MAP (a, not b, subt_result, '1', C_subt, V_subt); 
	with subt_result select
		Z_subt <= '1' when "0000",
		          '0' when others;
	
	s <= s0 & s1;
	
	with s select
		F <=  soma_result when "00",
				and_result  when "01",
				or_result   when "11",
				subt_result when "10";
				
	with s select
		Z <=  Z_soma      when "00",
				Z_and  when "01",
				Z_or   when "11",
				Z_subt when "10";
				
	with s select
		C <=  C_soma when "00",
				'0'    when "01",
				'0'    when "11",
				C_subt when "10";
				
	with s select
		V <=  V_soma when "00",
				'0'    when "01",
				'0'    when "11",
				V_subt when "10";
				
	with s select
		N <=  soma_result(3) when "00",
				'0'            when "01",
				'0'            when "11",
				subt_result(3) when "10";
				
	
		
	
	
				
				
				



  
end behavioral;
