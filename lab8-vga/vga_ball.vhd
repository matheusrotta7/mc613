-------------------------------------------------------------------------------
-- Title      : exemplo
-- Project    : 
-------------------------------------------------------------------------------
-- File       : exemplo.vhd
-- Author     : Rafael Auler
-- Company    : 
-- Created    : 2010-03-26
-- Last update: 2018-04-05
-- Platform   : 
-- Standard   : VHDL'2008
-------------------------------------------------------------------------------
-- Description: Fornece um exemplo de uso do módulo VGACON para a disciplina
--              MC613.
--              Este módulo possui uma máquina de estados simples que se ocupa
--              de escrever na memória de vídeo (atualizar o quadro atual) e,
--              em seguida, de atualizar a posição de uma "bola" que percorre
--              toda a tela, quicando pelos cantos.
-------------------------------------------------------------------------------
-- Copyright (c) 2010 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2010-03-26  1.0      Rafael Auler    Created
-- 2018-04-05  1.1      IBFelzmann      Adapted for DE1-SoC
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ball is
  port (    
	memo_word					: in std_logic_vector(6 downto 0);
	memo_address						: out integer range 0 to 63;
	sw								: in std_logic_vector(9 downto 0);
		ledr 	:		out	std_logic_vector (9 downto 0);		--	led red[9:0]
    CLOCK_50                  : in  std_logic;
    KEY                       : in  std_logic_vector(3 downto 0);
    VGA_R, VGA_G, VGA_B       : out std_logic_vector(7 downto 0);
    VGA_HS, VGA_VS            : out std_logic;
    VGA_BLANK_N, VGA_SYNC_N   : out std_logic;
    VGA_CLK                   : out std_logic;
	 ps2_dat 						:		inout	std_logic;	--	ps2 data
		ps2_clk						:		inout	std_logic		--	ps2 clock
    );
end vga_ball;

architecture comportamento of vga_ball is
  
  signal rstn : std_logic;              -- reset active low para nossos
                                        -- circuitos sequenciais.

  -- Interface com a memória de vídeo do controlador

  signal we : std_logic;                        -- write enable ('1' p/ escrita)
  signal addr : integer range 0 to 12287;       -- endereco mem. vga
  signal pixel : std_logic_vector(2 downto 0);  -- valor de cor do pixel
  signal pixel_bit : std_logic;                 -- um bit do vetor acima

  -- Sinais dos contadores de linhas e colunas utilizados para percorrer
  -- as posições da memória de vídeo (pixels) no momento de construir um quadro.
  
  signal line : integer range 0 to 95;  -- linha atual
  signal col : integer range 0 to 127;  -- coluna atual
  
  signal i	: integer range 0 to 8;
  signal j 	: integer range 0 to 8;

  signal col_rstn : std_logic;          -- reset do contador de colunas
  signal col_enable : std_logic;        -- enable do contador de colunas

  signal line_rstn : std_logic;          -- reset do contador de linhas
  signal line_enable : std_logic;        -- enable do contador de linhas

  signal fim_escrita : std_logic;       -- '1' quando um quadro terminou de ser
                                        -- escrito na memória de vídeo

  -- Sinais que armazem a posição de uma bola, que deverá ser desenhada
  -- na tela de acordo com sua posição.

  signal pos_x : integer range 0 to 127;  -- coluna atual da bola
  signal pos_y : integer range 0 to 95;   -- linha atual da bola

  signal atualiza_pos_x : std_logic;    -- se '1' = bola muda sua pos. no eixo x
  signal atualiza_pos_y : std_logic;    -- se '1' = bola muda sua pos. no eixo y

  -- Especificação dos tipos e sinais da máquina de estados de controle
  type estado_t is (show_splash, inicio, constroi_quadro, move_bola);
  signal estado: estado_t := show_splash;
  signal proximo_estado: estado_t := show_splash;

  -- Sinais para um contador utilizado para atrasar a atualização da
  -- posição da bola, a fim de evitar que a animação fique excessivamente
  -- veloz. Aqui utilizamos um contador de 0 a 1250000, de modo que quando
  -- alimentado com um clock de 50MHz, ele demore 25ms (40fps) para contar até o final.
  
  signal contador : integer range 0 to 1250000 - 1;  -- contador
  signal timer : std_logic;        -- vale '1' quando o contador chegar ao fim
  signal timer_rstn, timer_enable : std_logic;
  
  signal sync, blank: std_logic;
  
  signal color : std_logic_vector(2 downto 0);
  
  signal write_ram : std_logic;
  signal address 		: std_logic_vector (5 downto 0);
  signal datain		: std_logic_vector (7 downto 0);
  signal dataout		: std_logic_vector (7 downto 0);
  
	signal click : std_logic_vector (2 downto 0);
	signal new_mouse_data : std_logic_vector (15 downto 0);
	signal mouse_data : std_logic_vector (15 downto 0);
	
--	signal im	: integer range 0 to 7;
--	signal jm 	: integer range 0 to 7;
  
  component ps2_mouse_data is
		port
		(
			clock_50	: 	in	std_logic;											--	50 mhz
			key 	:		in	std_logic_vector (3 downto 0);		--	pushbutton[3:0]
			sw 	:		in	std_logic_vector (9 downto 0);			--	toggle switch[9:0]
			click	:		out std_logic_vector (2 downto 0);
			data	:		out std_logic_vector (15 downto 0);
			ledr 	:		out	std_logic_vector (9 downto 0);		--	led red[9:0]
			ps2_dat 	:		inout	std_logic;	--	ps2 data
			ps2_clk		:		inout	std_logic		--	ps2 clock
		);
	end component;
	component sync_ram is
	  port (
		 clock   : in  std_logic;
		 we      : in  std_logic;
		 address : in  std_logic_vector (5 downto 0);
		 datain  : in  std_logic_vector (7 downto 0);
		 dataout : out std_logic_vector (7 downto 0)
	  );
	end component;

begin  -- comportamento


  -- Aqui instanciamos o controlador de vídeo, 128 colunas por 96 linhas
  -- (aspect ratio 4:3). Os sinais que iremos utilizar para comunicar
  -- com a memória de vídeo (para alterar o brilho dos pixels) são
  -- write_clk (nosso clock), write_enable ('1' quando queremos escrever
  -- o valor de um pixel), write_addr (endereço do pixel a escrever)
  -- e data_in (valor do brilho do pixel RGB, 1 bit pra cada componente de cor)
  vga_controller: entity work.vgacon port map (
    clk50M       => CLOCK_50,
    rstn         => '1',
    red          => VGA_R,
    green        => VGA_G,
    blue         => VGA_B,
    hsync        => VGA_HS,
    vsync        => VGA_VS,
    write_clk    => CLOCK_50,
    write_enable => we,
    write_addr   => addr,
    data_in      => pixel,
    vga_clk      => VGA_CLK,
    sync         => sync,
    blank        => blank);
  VGA_SYNC_N <= NOT sync;
  VGA_BLANK_N <= NOT blank;

  -----------------------------------------------------------------------------
  -- Processos que controlam contadores de linhas e coluna para varrer
  -- todos os endereços da memória de vídeo, no momento de construir um quadro.
  -----------------------------------------------------------------------------

  -- purpose: Este processo conta o número da coluna atual, quando habilitado
  --          pelo sinal "col_enable".
  -- type   : sequential
  -- inputs : CLOCK_50, col_rstn
  -- outputs: col
  conta_coluna: process (CLOCK_50, col_rstn)
  begin  -- process conta_coluna
    if col_rstn = '0' then                  -- asynchronous reset (active low)
      col <= 0;
    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
      if col_enable = '1' then
        if col = 127 then               -- conta de 0 a 127 (128 colunas)
          col <= 0;
        else
          col <= col + 1;  
        end if;
      end if;
    end if;
	 j <= (col - 30) / 6;
  end process conta_coluna;
    
  -- purpose: Este processo conta o número da linha atual, quando habilitado
  --          pelo sinal "line_enable".
  -- type   : sequential
  -- inputs : CLOCK_50, line_rstn
  -- outputs: line
  conta_linha: process (CLOCK_50, line_rstn)
  begin  -- process conta_linha
    if line_rstn = '0' then                  -- asynchronous reset (active low)
      line <= 0;
    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
      -- o contador de linha só incrementa quando o contador de colunas
      -- chegou ao fim (valor 127)
      if line_enable = '1' and col = 127 then
        if line = 95 then               -- conta de 0 a 95 (96 linhas)
          line <= 0;
        else
          line <= line + 1;  
        end if;        
      end if;
    end if;
	 i <= (line -10) / 8;
  end process conta_linha;

  -- Este sinal é útil para informar nossa lógica de controle quando
  -- o quadro terminou de ser escrito na memória de vídeo, para que
  -- possamos avançar para o próximo estado.
  fim_escrita <= '1' when (line = 95) and (col = 127)
                 else '0'; 
					  
					  
					  
					  
					  
					  
					  
  -----------------------------------------------------------------------------
  -- Brilho do pixel
  -----------------------------------------------------------------------------
  -- O brilho do pixel é branco quando os contadores de linha e coluna, que
  -- indicam o endereço do pixel sendo escrito para o quadro atual, casam com a
  -- posição da bola (sinais pos_x e pos_y). Caso contrário,
  -- o pixel é preto.

--  pixel_bit <= '1' when (col = pos_x) and (line = pos_y) else '0';
--  pixel <= '1' when (col = pos_x) and (line = pos_y) else '0';
  
	pixel <= color;
--  pixel <= color when (col = pos_x) and (line = pos_y) else "000";
--  we <= '1' when (col = pos_x) and (line = pos_y) and (estado = constroi_quadro) else '0';
--  pixel <= (others => pixel_bit);
  
  
  
  -- O endereço de memória pode ser construído com essa fórmula simples,
  -- a partir da linha e coluna atual
  
  mouse_action:
	ps2_mouse_data port map ( CLOCK_50, KEY(3 downto 0), sw, click, new_mouse_data, ledr, ps2_dat, ps2_clk );

--	im <=  (to_integer(unsigned(new_mouse_data(7 downto 0))) - 10 ) / 8;
--	jm <=  (to_integer(unsigned(new_mouse_data(15 downto 8))) - 30 ) / 6;
	
--	address <= std_logic_vector(to_unsigned(im*8 + jm ,6));
	
--	y_a := std_logic_vector(to_signed(to_integer(signed(y)) + ((yacc - to_integer(signed(dy))) / SENSIBILITY), 8));
	
--	ler_memo:
--	sync_ram port map ( click(0), write_ram, address, datain, dataout);
	
	
  tabuleiro: process (CLOCK_50)

  variable xaux, yaux : integer :=0;
  variable im, jm : integer := 0;
  variable u_x, u_y : integer := 0;
  
  
  
  begin
	if CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
      -- o contador de linha só incrementa quando o contador de colunas
      -- chegou ao fim (valor 127)
      if (col >= 30 and col <= 78 and line >= 10 and line <= 74) then
			if (line rem 8 = 2 or col rem 6 = 0 ) then
				
--				im :=  (to_integer(unsigned(new_mouse_data(7 downto 0))) - 10 ) / 8;
--				jm :=  (to_integer(unsigned(new_mouse_data(15 downto 8))) - 30 ) / 6;
				
				
				im :=  to_integer(unsigned(new_mouse_data(7 downto 0))) / 16;
				jm :=  to_integer(unsigned(new_mouse_data(15 downto 8))) / 16;
				
				
				if (im = i and jm = j) then
					-- mouse no msm quadradinho que o pixel
					if(click(0) = '1') then
							color <= "011"; -- cyan
						else 
							color <= "010"; -- verde
						end if;
					
				elsif ((im = i - 1 and jm = j) or (jm = j - 1 and im = i)) then
					xaux := jm * 6 + 35;
					yaux := im * 8 + 17;
					
					if(xaux = col-1 or yaux = line-1) then
						if(click(0) = '1') then
							color <= "011"; -- cyan
						else 
							color <= "010"; -- verde
						end if;
					else
						color <= "000";
					end if;
				else
					color <= "000";
				end if;
			else
				
				u_x := (col - j*6) mod 5;
				u_y := (line - i*8) mod 7;
				
				if (memo_word(6) = '1') then 
					color <= "110";
				elsif (memo_word(5) = '1') then
				-- bomba
					if (u_x = 0 or u_x = 4) then 
						if (u_y mod 2 = 0) then
							color <= "110"; -- amarelo
						else
							color <= "100"; -- vermelho
						end if;
					elsif (u_x = 1 or u_x = 3) then
						if (u_y = 0 or u_y =1 or u_y = 5 or u_y = 6) then
							color <= "110"; -- amarelo
						else
							color <= "100"; -- vermelho
						end if;
					else
						if (u_y = 0 or u_y = 6) then
							color <= "110"; -- amarelo
						else
							color <= "100"; -- vermelho
						end if;
					end if;
				elsif (memo_word(4) = '1') then
				
					if (u_x = 0 or u_x = 4) then 
						color <= "110"; -- amarelo
					
					elsif (u_x = 1) then
						if (u_y = 3) then
							color <= "000"; -- preto
						else
							color <= "110"; -- amarelo
						end if;
					
					elsif (u_x = 2) then
						if (u_y = 2 or u_y = 3) then
							color <= "000";
						else
							color <= "110";
						end if;
					else
						if (u_y = 0 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					end if;
				
				elsif (memo_word(3 downto 0) = "0000") then	
					color <= "110";
				elsif (memo_word(3 downto 0) = "0001") then
					if (u_x = 3) then 
						if (u_y = 0 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					else 
						color <= "110";
					end if;
				
				elsif (memo_word(3 downto 0) = "0010") then
					if (u_x = 0 or u_x = 4) then
						color <= "110";
					elsif (u_x = 1) then
						if (u_y = 0 or u_y = 2 or u_y = 6) then
							color <= "110";
						else 
							color<= "000";
						end if;
					elsif (u_x = 2) then
						if (u_y mod 2 = 0) then
							color <= "110";
						else
							color <= "000";
						end if;
					else 
						if (u_y = 0 or u_y = 4 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					end if;
				elsif (memo_word(3 downto 0) = "0011") then
					if (u_x = 0 or u_x = 4) then
						color <= "110";
					elsif (u_x = 1 or u_x = 2) then
						if (u_y mod 2 = 0) then
							color <= "110";
						else
							color <= "000";
						end if;
					else 
						if (u_y = 0 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					end if;
				elsif (memo_word(3 downto 0) = "0100") then
					if (u_x = 0 or u_x = 4) then
						color <= "110";
					elsif (u_x = 1) then
						if (u_y = 1 or u_y = 2 or u_y = 3) then
							color <= "000";
						else
							color <= "110";
						end if;
					elsif (u_x = 2) then
						if (u_x = 3) then
							color <= "000";
						else
							color <= "110";
						end if;
					else 
						if (u_y = 0 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					end if;
				
				elsif (memo_word(3 downto 0) = "0101") then
				
					if (u_x = 0 or u_x = 4) then
						color <= "110";
					elsif (u_x = 1) then
						if (u_y = 0 or u_y = 4 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					elsif (u_x = 2) then
						if (u_y mod 2 = 0) then
							color <= "110";
						else
							color <= "000";
						end if;
					else 
						if (u_y = 0 or u_y = 2 or u_y = 6) then
							color <= "110";
						else 
							color<= "000";
						end if;
					end if;
				
				elsif (memo_word(3 downto 0) = "0110") then
				
					if (u_x = 0 or u_x = 4) then
						color <= "110";
					elsif (u_x = 1) then
						if (u_y = 0 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					elsif (u_x = 2) then
						if (u_y mod 2 = 0) then
							color <= "110";
						else
							color <= "000";
						end if;
					else 
						if (u_y = 0 or u_y = 2 or u_y = 6) then
							color <= "110";
						else 
							color<= "000";
						end if;
					end if;
				elsif (memo_word(3 downto 0) = "0111") then
					if (u_x = 1 or u_x = 2) then
						if (u_y = 1) then
							color <= "000";
						else
							color <= "110";
						end if;
					elsif (u_x = 3) then 
						if (u_y = 0 or u_y = 6) then
							color <= "110";
						else
							color <= "000";
						end if;
					else 
						color <= "110";
					end if;
					
				else
					color <= "001";
				
				end if;
				
			end if;
		else
			color <= "000";
		end if;
    end if;
	 
	 
	
  
  end process tabuleiro;
  
  
  addr  <= col + (128 * line);
					  
					  
					  
					  
					  
					  
					  
					  
					  
--  muda_cor: process (CLOCK_50)
--    type direcao_h is (direita, esquerda);
--	 type direcao_v is (desce, sobe);
--    variable direcao_y : direcao_v := sobe;
--	 variable direcao_x : direcao_h := direita;
--	 variable cor : integer range 1 to 7;
--  begin  -- process p_atualiza_pos_x
--    if CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
--      if atualiza_pos_x = '1' then
--        if direcao_x = direita then         
--          if pos_x = 127 then
--				direcao_x := esquerda; 
--            cor := cor + 1;
--          end if;        
--        else
--          if pos_x = 0 then
--				direcao_x := direita;
--            cor := cor + 1;
--          end if;
--        end if;
--      elsif atualiza_pos_y = '1' then
--        if direcao_y = desce then         
--          if pos_y = 95 then
--				direcao_y := sobe;  
--            cor := cor + 1;
--          end if;        
--        else  -- se a direcao é para subir
--          if pos_y = 0 then
--				direcao_y := desce;
--            cor := cor + 1;
--          end if;
--        end if;
--      end if;
--    end if;
--		
--		color <= std_logic_vector(to_unsigned(cor,3));
--  end process muda_cor;
  -----------------------------------------------------------------------------
  -- Abaixo estão processos relacionados com a atualização da posição da
  -- bola. Todos são controlados por sinais de enable de modo que a posição
  -- só é de fato atualizada quando o controle (uma máquina de estados)
  -- solicitar.
  -----------------------------------------------------------------------------

  -- purpose: Este processo irá atualizar a coluna atual da bola,
  --          alterando sua posição no próximo quadro a ser desenhado.
  -- type   : sequential
  -- inputs : CLOCK_50, rstn
  -- outputs: pos_x
--  p_atualiza_pos_x: process (CLOCK_50, rstn)
--    type direcao_t is (direita, esquerda);
--    variable direcao : direcao_t := direita;
--  begin  -- process p_atualiza_pos_x
--    if rstn = '0' then                  -- asynchronous reset (active low)
--      pos_x <= 0;
--    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
--      if atualiza_pos_x = '1' then
--        if direcao = direita then         
--          if pos_x = 127 then
--            direcao := esquerda;  
--          else
--            pos_x <= pos_x + 1;
--          end if;        
--        else  -- se a direcao é esquerda
--          if pos_x = 0 then
--            direcao := direita;
--          else
--            pos_x <= pos_x - 1;
--          end if;
--        end if;
--      end if;
--    end if;
--  end process p_atualiza_pos_x;

  -- purpose: Este processo irá atualizar a linha atual da bola,
  --          alterando sua posição no próximo quadro a ser desenhado.
  -- type   : sequential
  -- inputs : CLOCK_50, rstn
--  -- outputs: pos_y
--  p_atualiza_pos_y: process (CLOCK_50, rstn)
--    type direcao_t is (desce, sobe);
--    variable direcao : direcao_t := desce;
--  begin  -- process p_atualiza_pos_x
--    if rstn = '0' then                  -- asynchronous reset (active low)
--      pos_y <= 0;
--    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
--      if atualiza_pos_y = '1' then
--        if direcao = desce then         
--          if pos_y = 95 then
--            direcao := sobe;  
--          else
--            pos_y <= pos_y + 1;
--          end if;        
--        else  -- se a direcao é para subir
--          if pos_y = 0 then
--            direcao := desce;
--          else
--            pos_y <= pos_y - 1;
--          end if;
--        end if;
--      end if;
--    end if;
--  end process p_atualiza_pos_y;
--  
  
    -- purpose: Este processo irá atualizar a coluna atual da bola,
  --          alterando sua posição no próximo quadro a ser desenhado.
  -- type   : sequential
  -- inputs : CLOCK_50, rstn
  -- outputs: pos_x


  -----------------------------------------------------------------------------
  -- Brilho do pixel
  -----------------------------------------------------------------------------
  -- O brilho do pixel é branco quando os contadores de linha e coluna, que
  -- indicam o endereço do pixel sendo escrito para o quadro atual, casam com a
  -- posição da bola (sinais pos_x e pos_y). Caso contrário,
  -- o pixel é preto.

--  pixel_bit <= '1' when (col = pos_x) and (line = pos_y) else '0';
--  pixel <= '1' when (col = pos_x) and (line = pos_y) else '0';
  
  
--  pixel <= color when (col = pos_x) and (line = pos_y) else "000";
--  we <= '1' when (col = pos_x) and (line = pos_y) and (estado = constroi_quadro) else '0';
--  pixel <= (others => pixel_bit);
  
  
  
  -- O endereço de memória pode ser construído com essa fórmula simples,
  -- a partir da linha e coluna atual
--  addr  <= col + (128 * line);

  -----------------------------------------------------------------------------
  -- Processos que definem a FSM (finite state machine), nossa máquina
  -- de estados de controle.
  -----------------------------------------------------------------------------

  -- purpose: Esta é a lógica combinacional que calcula sinais de saída a partir
  --          do estado atual e alguns sinais de entrada (Máquina de Mealy).
  -- type   : combinational
  -- inputs : estado, fim_escrita, timer
  -- outputs: proximo_estado, atualiza_pos_x, atualiza_pos_y, line_rstn,
  --          line_enable, col_rstn, col_enable, we, timer_enable, timer_rstn
  logica_mealy: process (estado, fim_escrita, timer)
  begin  -- process logica_mealy
    case estado is
      when inicio         => if timer = '1' then              
                               proximo_estado <= constroi_quadro;
                             else
                               proximo_estado <= inicio;
                             end if;
                             line_rstn      <= '0';  -- reset é active low!
                             line_enable    <= '0';
                             col_rstn       <= '0';  -- reset é active low!
                             col_enable     <= '0';
                             we             <= '0';
                             timer_rstn     <= '1';  -- reset é active low!
                             timer_enable   <= '1';

      when constroi_quadro=> if fim_escrita = '1' then
                               proximo_estado <= move_bola;
                             else
                               proximo_estado <= constroi_quadro;
                             end if;
                             line_rstn      <= '1';
                             line_enable    <= '1';
                             col_rstn       <= '1';
                             col_enable     <= '1';
                             we             <= '1';
                             timer_rstn     <= '0'; 
                             timer_enable   <= '0';

      when move_bola      => proximo_estado <= inicio;
                             line_rstn      <= '1';
                             line_enable    <= '0';
                             col_rstn       <= '1';
                             col_enable     <= '0';
                             we             <= '1';
                             timer_rstn     <= '0'; 
                             timer_enable   <= '0';

      when others         => proximo_estado <= inicio;
                             line_rstn      <= '1';
                             line_enable    <= '0';
                             col_rstn       <= '1';
                             col_enable     <= '0';
                             we             <= '0';
                             timer_rstn     <= '1'; 
                             timer_enable   <= '0';
      
    end case;
  end process logica_mealy;
  
  -- purpose: Avança a FSM para o próximo estado
  -- type   : sequential
  -- inputs : CLOCK_50, rstn, proximo_estado
  -- outputs: estado
  seq_fsm: process (CLOCK_50, rstn)
  begin  -- process seq_fsm
    if rstn = '0' then                  -- asynchronous reset (active low)
      estado <= inicio;
    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
      estado <= proximo_estado;
    end if;
  end process seq_fsm;

  -----------------------------------------------------------------------------
  -- Processos do contador utilizado para atrasar a animação (evitar
  -- que a atualização de quadros fique excessivamente veloz).
  -----------------------------------------------------------------------------
  -- purpose: Incrementa o contador a cada ciclo de clock
  -- type   : sequential
  -- inputs : CLOCK_50, timer_rstn
  -- outputs: contador, timer
  p_contador: process (CLOCK_50, timer_rstn)
  begin  -- process p_contador
    if timer_rstn = '0' then            -- asynchronous reset (active low)
      contador <= 0;
    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
      if timer_enable = '1' then       
        if contador = 1250000 - 1 then
          contador <= 0;
        else
          contador <=  contador + 1;        
        end if;
      end if;
    end if;
  end process p_contador;

  -- purpose: Calcula o sinal "timer" que indica quando o contador chegou ao
  --          final
  -- type   : combinational
  -- inputs : contador
  -- outputs: timer
  p_timer: process (contador)
  begin  -- process p_timer
    if contador = 1250000 - 1 then
      timer <= '1';
    else
      timer <= '0';
    end if;
  end process p_timer;

  -----------------------------------------------------------------------------
  -- Processos que sincronizam sinais assíncronos, de preferência com mais
  -- de 1 flipflop, para evitar metaestabilidade.
  -----------------------------------------------------------------------------
  
  -- purpose: Aqui sincronizamos nosso sinal de reset vindo do botão da DE1
  -- type   : sequential
  -- inputs : CLOCK_50
  -- outputs: rstn
  build_rstn: process (CLOCK_50)
    variable temp : std_logic;          -- flipflop intermediario
  begin  -- process build_rstn
    if CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
      rstn <= temp;
      temp := KEY(0);      
    end if;
  end process build_rstn;

  
end comportamento;
