
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity clock_divider is
	PORT(	clk100:in std_logic;
			reset: in std_logic;
			clk25:out std_logic;
			clkdeb:out std_logic);
end clock_divider;

architecture Behavioral of clock_divider is
signal m: std_logic_vector(1 downto 0):="00";
signal counter: std_logic_vector(19 downto 0) := (others=>'0');
begin
	process(clk100,reset,m,counter)
	begin
	if reset='1' then
		m<="00";
		counter<= (others=>'0');
	elsif rising_edge(clk100) then
		m <= m + "01";
		counter <= counter + 1 ;
	end if;
	clk25 <= m(1);
	clkdeb <= counter(19);
	end process;
	
end Behavioral;

