
library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;

package game_package is
	
	type cell_type is (border,space,food,snake_tail);
	type snake is array(19 downto 0) of integer range 0 to 639;
	type game_state is (ready,directioncheck,check,move,generatefood,game_over,vga);
	
end game_package;

package body game_package is

 
end game_package;
