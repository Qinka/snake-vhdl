
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use work.game_package.all;

entity pseudo_random_generator is
	PORT(	clk:in std_logic;
			cur_game: in game_state;
			random:out integer range 0 to 639);
end pseudo_random_generator;

architecture Behavioral of pseudo_random_generator is
begin
	process(clk)
	variable temp_v: std_logic_vector(9 downto 0):= ((9)=>'1',others=>'0');
	variable temp: std_logic:= '0';
	variable temp_u: integer range 0 to 639;
	begin
	if rising_edge(clk) then
		if cur_game = move or cur_game = generatefood then
			temp:= temp_v(9) xor temp_v(2);
			temp_v(9 downto 1):=temp_v(8 downto 0);
			temp_v(0):=temp;
			temp_u:= to_integer(unsigned(temp_v));
			random <= temp_u mod 540;
		end if;
	end if;
	end process;
	
end Behavioral;

