library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity count00_99 is
	generic (D : natural := 6; 	U : natural := 0);
	port (
		clk : in std_logic;
		rst: in std_logic;
		clk_out:out std_logic;
		bcd_U : out std_logic_vector(3 downto 0);
		bcd_D : out std_logic_vector(3 downto 0)
	);
end entity;

architecture count00_99 of count00_99 is

component div_clk is
		generic (fclk2 : natural := 50);       -- frequecia para simulacao
		port (
			clk : in std_logic;
			rst: in std_logic;
			clk_out : out std_logic
		);
	end component;



begin

	U1: div_clk 
		 generic map (fclk2=>30) -- contar ate 60 pelo clk
		 port map(
					 clk=>clk,  --clk de entrada do contador
					 rst=>rst,  --rst do contador
					 clk_out=>clk_out -- clk de saida do contador
					 );


P1:  PROCESS(clk,rst)
    VARIABLE tempU: natural RANGE 0 TO 10;
    VARIABLE tempD: natural range 0 to D+1;
    BEGIN
	 if (RST='0') then
	 tempD := 0;
    tempU := 0;
	 
    elsIF (rising_edge(clk)) THEN
        if(tempD = D and tempU = U) then
            tempD := 0;
            tempU := 0;
        else
            tempU := tempU + 1;
            if (tempU > 9) then
                tempU := 0;
                tempD := tempD + 1;
            end if;
        end if;
    END IF;
    bcd_d <= std_logic_vector(to_unsigned(tempD,4));
    bcd_u <= std_logic_vector(to_unsigned(tempU,4));
  end process;




end architecture;