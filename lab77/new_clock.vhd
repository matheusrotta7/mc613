library ieee;
use ieee.std_logic_1164.all;

entity new_clock is
  port (
    clk : in std_logic;
    decimal : in std_logic_vector(3 downto 0);
    unity : in std_logic_vector(3 downto 0);
    set_hour : in std_logic;
    set_minute : in std_logic;
    set_second : in std_logic;
    hour_dec, hour_un : out std_logic_vector(6 downto 0);
    min_dec, min_un : out std_logic_vector(6 downto 0);
    sec_dec, sec_un : out std_logic_vector(6 downto 0)
  );
end new_clock;

architecture rtl of new_clock is

  component clk_div is
    port (
      clk : in std_logic;
      clk_hz : out std_logic
    );
  end component;
  
  component mod6_settable 
	port (clk_hz		  : in std_logic;
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			clk1 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
	end component mod6_settable;
	
	component mod10_settable 
	port (clk_hz		  : in std_logic;
			set : in std_logic;
			unity    : in std_logic_vector (3 downto 0);
			clk1 			  : out std_logic;
			result     : out std_logic_vector (3 downto 0)
			);
	end component mod10_settable;
	
	component mod24_settable 
	port (Clock		       : in std_logic;
			set             : in std_logic;
			unity           : in std_logic_vector (3 downto 0);
			decimal         : in std_logic_vector (3 downto 0);
			hour_un_result  : out std_logic_vector (3 downto 0);
			hour_dec_result : out std_logic_vector (3 downto 0)
			);
	end component mod24_settable;
	
	component bin2dec 
	port (
		SW: in std_logic_vector(3 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);
	end component bin2dec;



  
  signal clk_hz : std_logic;
  
  signal clk1 : std_logic;
  signal clk2 : std_logic;
  signal clk3 : std_logic;
  signal clk4 : std_logic;
  signal clk5 : std_logic;
  signal clk6 : std_logic;
  
  signal sec_un_result : std_logic_vector (3 downto 0);
  signal sec_dec_result: std_logic_vector (3 downto 0);
  signal min_un_result : std_logic_vector (3 downto 0);
  signal min_dec_result: std_logic_vector (3 downto 0);
  signal hour_un_result: std_logic_vector (3 downto 0);
  signal hour_dec_result: std_logic_vector (3 downto 0);

  
  
begin

  clock_divider : clk_div port map (clk, clk_hz);
  
  mod10_sec_un : mod10_settable port map (clk_hz, set_second, unity, clk1, sec_un_result);
  disp0: bin2dec port map (sec_un_result, sec_un);
  
  mod6_sec_dec : mod6_settable port map (clk1, set_second, decimal, clk2, sec_dec_result);
  disp1: bin2dec port map (sec_dec_result, sec_dec);
  
  mod10_min_un : mod10_settable port map (clk2, set_minute, unity, clk3, min_un_result);
  disp2: bin2dec port map (min_un_result, min_un);
  
  mod6_min_dec : mod6_settable port map (clk3, set_minute, decimal, clk4, min_dec_result);
  disp3: bin2dec port map (min_dec_result, min_dec);

  
  mod24_hour : mod24_settable port map (clk4, set_hour, unity, decimal, hour_un_result, hour_dec_result);
  disp4: bin2dec port map (hour_un_result, hour_un);
  disp5: bin2dec port map (hour_dec_result, hour_dec);
  
end rtl;