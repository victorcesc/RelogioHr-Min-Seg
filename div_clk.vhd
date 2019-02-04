library ieee;
use ieee.std_logic_1164.all;

entity div_clk is
	generic (fclk2 : natural := 25);       -- frequecia para simulacao
	port (
		clk : in std_logic;
		rst :in std_logic;
		clk_out : out std_logic
	);
end entity;

architecture div_clk of div_clk is

 signal clk_1seg_temp: std_logic := '1';
 begin
 process(clk,rst)
 variable temp: INTEGER range 0 to fclk2;
 
 begin
 
 if(rst='0') then
		clk_1seg_temp<='1';
				
	elsif (clk'event AND clk='1') then
		temp := temp + 1;
	if (temp=fclk2) then
	temp:=0;
	clk_1seg_temp<= not clk_1seg_temp;
	end if;
 
	end if;

 
 end process;
 
 clk_out <= clk_1seg_temp;
 

 



end architecture;