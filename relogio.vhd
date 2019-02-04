library ieee;
use ieee.std_logic_1164.all;

entity relogio IS 
	generic (fclk2_in : natural := 25000000; 
	D_in : natural := 5; 
	U_in : natural := 9;
	TipoDisplay: natural := 1;
	D_hr : natural := 2; 
	U_hr : natural := 3);
	port
	(
		clk50MHz :  in  STD_LOGIC;
		clk_1_seg: out std_LOGIC;
		clk_1_min: out std_LOGIC;
		clk_1_hr: out std_LOGIC;
		rst_in: in std_logic;
		ssd_D_seg :  out  STD_LOGIC_VECTOR(0 TO 6);
		ssd_U_seg :  out  STD_LOGIC_VECTOR(0 TO 6);
		ssd_D_min :  out  STD_LOGIC_VECTOR(0 TO 6);
		ssd_U_min :  out  STD_LOGIC_VECTOR(0 TO 6);
		ssd_D_hr :  out  STD_LOGIC_VECTOR(0 TO 6);
		ssd_U_hr :  out  STD_LOGIC_VECTOR(0 TO 6)
	);
end entity;

architecture relogio of relogio is

--declaracao dos componentes
	component div_clk is
		generic (fclk2 : natural := 50);       -- frequecia para simulacao
		port (
			clk : in std_logic;
			rst: in std_logic;
			clk_out : out std_logic
		);
	end component;
	
	component bin2ssd is
   generic (ac_ccn : natural := 1); -- Anodo comum
--	generic (ac_ccn : natural := 0); -- Catodo comum
	port (
		bin_in : in std_logic_vector(3 downto 0);
		ssd_out : out std_logic_vector(0 to 6)
	);
	end component;
	
	component count00_99 is
		generic (D : natural := 9; 	U : natural := 9);
		port (
			clk : in std_logic;
			clk_out:out std_logic;
			rst: in std_logic;
			bcd_U : out std_logic_vector(3 downto 0);
			bcd_D : out std_logic_vector(3 downto 0)
		);
	end component;
	
-- Declaracao de sinais internos	
signal clk_1_seg_tmp: std_logic;
signal clk_1_min_tmp: std_logic;
signal clk_1_hr_tmp: std_logic;
--segundo
signal bcd_U_seg: std_LOGIC_VECTOR(3 downto 0);
signal bcd_D_seg: std_LOGIC_VECTOR(3 downto 0);
--minuto
signal bcd_U_min: std_LOGIC_VECTOR(3 downto 0);
signal bcd_D_min: std_LOGIC_VECTOR(3 downto 0);
--hora
signal bcd_U_hr: std_LOGIC_VECTOR(3 downto 0);
signal bcd_D_hr: std_LOGIC_VECTOR(3 downto 0);


begin
-- conexoes de sinais em portas
	clk_1_seg <= clk_1_seg_tmp;
	clk_1_min <= clk_1_min_tmp;
	clk_1_hr <= clk_1_hr_tmp;
	
-- declaracao dos generic maps/instanciacao dos componentes

	U1: div_clk 
		 generic map (fclk2=>fclk2_in) -- 50mhz
		 port map(
					 clk=>clk50MHz,  --clk de entrada do primeiro bloco
					 rst=>rst_in,
					 clk_out=>clk_1_seg_tmp -- clk de saida do primeiro bloco
					 );

	U2_seg: count00_99
		 generic map (D=>D_in, U=>U_in)
		 port map(
					rst=>rst_in,
					clk=>clk_1_seg_tmp, --clk de entrada do segundo bloco
					clk_out=>clk_1_min_tmp, --clk de saida de 1 min
					bcd_U=>bcd_U_seg, -- bcd_U do contador recebe o sinal criado pra ligar os componentes
					bcd_D=>bcd_D_seg -- ''
		 
		 );
		 
   U2_min: count00_99
		 generic map (D=>D_in, U=>U_in)
		 port map(
					rst=>rst_in,
					clk=>clk_1_min_tmp, --clk de entrada do segundo bloco
					clk_out=>clk_1_hr_tmp, --clk de saida de 1 hora
					bcd_U=>bcd_U_min, -- bcd_U do contador recebe o sinal criado pra ligar os componentes
					bcd_D=>bcd_D_min -- ''
		 
		 );
		 
		 
	U2_hr: count00_99
		 generic map (D=>D_hr, U=>U_hr)
		 port map(
					rst=>rst_in,
					clk=>clk_1_hr_tmp, --clk de entrada do segundo bloco
					clk_out=>open, --clk de saida de 1 hora
					bcd_U=>bcd_U_hr, -- bcd_U do contador recebe o sinal criado pra ligar os componentes
					bcd_D=>bcd_D_hr -- ''
		 
		 );
		 
	--diplay segundos	 
	--display unidade	 
	U3_seg: bin2ssd
		generic map(ac_ccn=> TipoDisplay)
		port map(
					bin_in=>bcd_U_seg,
					ssd_out=>ssd_U_seg
		
		);
	-- display dezena	
	U4_seg: bin2ssd
		generic map(ac_ccn=> TipoDisplay)
		port map(
					bin_in=>bcd_D_seg,
					ssd_out=>ssd_D_seg
		
		);
	--display minutos	
	U3_min: bin2ssd
		generic map(ac_ccn=> TipoDisplay)
		port map(
					bin_in=>bcd_U_min,
					ssd_out=>ssd_U_min
		
		);
	-- display dezena	
	U4_min: bin2ssd
		generic map(ac_ccn=> TipoDisplay)
		port map(
					bin_in=>bcd_D_min,
					ssd_out=>ssd_D_min
		
		);
		
	--display horas	
	U3_hr: bin2ssd
		generic map(ac_ccn=> TipoDisplay)
		port map(
					bin_in=>bcd_U_hr,
					ssd_out=>ssd_U_hr
		
		);
	-- display dezena	
	U4_hr: bin2ssd
		generic map(ac_ccn=> TipoDisplay)
		port map(
					bin_in=>bcd_D_hr,
					ssd_out=>ssd_D_hr
		
		);
		
		
		
		
		
		

end architecture;