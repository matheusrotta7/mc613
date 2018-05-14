library ieee;
use ieee.std_logic_1164.all;


entity bank is
  GENERIC (
			WORDSIZE : NATURAL := 32
		);
		PORT (
			WR_EN, RD_EN,
			clear,
			clock		: IN 	STD_LOGIC;
			WR_ADDR,
			RD_ADDR1,
			RD_ADDR2	: IN	STD_LOGIC_VECTOR (4 DOWNTO 0);
			DATA_IN		: IN	STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0);
			DATA_OUT1,
			DATA_OUT2	: OUT	STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0)
		);
end bank;

architecture structural of bank is

component dec5_to_32 
	port (
		panda : out std_logic_vector (31 downto 0);
		q		: in std_logic_vector (4 downto 0)
		);
end component dec5_to_32;

component zbuffer 
	generic ( N : INTEGER := 32 ) ;
	port (X : in STD_LOGIC_VECTOR(N-1 downto 0) ;
			E : in STD_LOGIC ;
			F : out STD_LOGIC_VECTOR(N-1 downto 0) ) ;
end component zbuffer ;

component reg IS
	GENERIC (
		WORDSIZE	: NATURAL := 32
	);
	PORT (
		clock,
		load,
		clear	: IN	STD_LOGIC;
		datain	: IN	STD_LOGIC_VECTOR(WORDSIZE-1 DOWNTO 0);
		dataout : OUT	STD_LOGIC_VECTOR(WORDSIZE-1 DOWNTO 0)
	);
END component reg;

signal  d2r : std_logic_vector (31 downto 0);
signal  r2d_1 : std_logic_vector (31 downto 0);
signal  r2d_2 : std_logic_vector (31 downto 0);
signal temp : std_logic_vector (31 downto 0);
begin
  -- Your code here!
  
  -- choose register to write data
  stage0: dec5_to_32 PORT MAP (d2r, WR_ADDR);
  
  -- write data
  reg0: reg GENERIC MAP (32) PORT MAP (clock, '0', clear, DATA_IN, temp);
  GEN_REG: 
   for i in 1 to 31 generate
      regx : reg port map (clock, d2r(i) and WR_EN, clear, DATA_IN, temp);
   end generate GEN_REG;
  
  -- choose register to read data into data_out
  decode1: dec5_to_32 PORT MAP (r2d_1, RD_ADDR1);
  decode2: dec5_to_32 PORT MAP (r2d_2, RD_ADDR2);
  
  -- throw data to data_out1
  zbuff0: zbuffer PORT MAP ("00000000000000000000000000000000", r2d_1(0) and RD_EN,  DATA_OUT1);
  GEN_ZBUFF: 
   for i in 1 to 31 generate
      zbuffx : zbuffer PORT MAP (temp, r2d_1(i) and RD_EN,  DATA_OUT1);
   end generate GEN_ZBUFF;
  
  -- throw data to data_out
  zbuff8: zbuffer PORT MAP ("00000000000000000000000000000000", r2d_2(0) and RD_EN,  DATA_OUT2);
  GEN_ZBUFF_again: 
   for i in 1 to 31 generate
      zbuffy : zbuffer PORT MAP (temp, r2d_1(i) and RD_EN,  DATA_OUT2);
   end generate GEN_ZBUFF_again;
  
  
  
  
end structural;