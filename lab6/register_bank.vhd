library ieee;
use ieee.std_logic_1164.all;

entity register_bank is
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(3 downto 0);
    data_out : out std_logic_vector(3 downto 0);
    reg_rd : in std_logic_vector(2 downto 0);
    reg_wr : in std_logic_vector(2 downto 0);
    we : in std_logic;
    clear : in std_logic
  );
end register_bank;

architecture structural of register_bank is

component dec3_to_8 
	port (
		panda : out std_logic_vector (7 downto 0);
		q		: in std_logic_vector (2 downto 0)
		);
end component dec3_to_8;

component zbuffer 
	generic ( N : INTEGER := 4 ) ;
	port (X : in STD_LOGIC_VECTOR(N-1 downto 0) ;
			E : in STD_LOGIC ;
			F : out STD_LOGIC_VECTOR(N-1 downto 0) ) ;
end component zbuffer ;

component reg 
  generic (
    N : integer := 4
  );
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(N-1 downto 0);
    data_out : out std_logic_vector(N-1 downto 0);
    load : in std_logic; -- Write enable
    clear : in std_logic
  );
end component reg;


signal  d2r : std_logic_vector (7 downto 0);
signal  r2d : std_logic_vector (7 downto 0);
signal temp : std_logic_vector (3 downto 0);
begin
  -- Your code here!
  
  -- choose register to write data
  stage0: dec3_to_8 PORT MAP (d2r, reg_wr);
  
  -- write data
  reg0: reg PORT MAP (clk, data_in, temp, d2r(0), clear);
  reg1: reg PORT MAP (clk, data_in, temp, d2r(1), clear);
  reg2: reg PORT MAP (clk, data_in, temp, d2r(2), clear);
  reg3: reg PORT MAP (clk, data_in, temp, d2r(3), clear);
  reg4: reg PORT MAP (clk, data_in, temp, d2r(4), clear);
  reg5: reg PORT MAP (clk, data_in, temp, d2r(5), clear);
  reg6: reg PORT MAP (clk, data_in, temp, d2r(6), clear);
  reg7: reg PORT MAP (clk, data_in, temp, d2r(7), clear);
  
  -- choose register to throw data into data_out
  decode1: dec3_to_8 PORT MAP (r2d, reg_rd);
  
  -- throw data to data_out
  zbuffer: zbuffer PORT MAP (temp, r2d(0), data_out);
  zbuffer1: zbuffer PORT MAP (temp, r2d(1), data_out);
  zbuffer2: zbuffer PORT MAP (temp, r2d(2), data_out);
  zbuffer3: zbuffer PORT MAP (temp, r2d(3), data_out);
  zbuffer4: zbuffer PORT MAP (temp, r2d(4), data_out);
  zbuffer5: zbuffer PORT MAP (temp, r2d(5), data_out);
  zbuffer6: zbuffer PORT MAP (temp, r2d(6), data_out);
  statanas7: zbuffer PORT MAP (temp, r2d(7), data_out);
  
  
end structural;
