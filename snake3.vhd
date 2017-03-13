
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use work.game_package.all;

entity snake3 is
	PORT(	clk: in std_logic;
			reset: in std_logic;
			left:in std_logic;
			right:in std_logic;
			up:in std_logic;
			down:in std_logic;
			r: out std_logic_vector(2 downto 0);
			g: out std_logic_vector(2 downto 0);
			b: out std_logic_vector(1 downto 0);
			main_vsync: out std_logic;
			main_hsync: out std_logic;
			rf: out integer range 0 to 639);
end snake3;

architecture Behavioral of snake3 is

COMPONENT vga
	PORT(	reset: in std_logic;
			vga_clk: in std_logic;
			board_out: in cell_type;
			vsync: out std_logic;
			hsync: out std_logic;
			red: out std_logic_vector(2 downto 0);
			green: out std_logic_vector(2 downto 0);
			blue: out std_logic_vector(1 downto 0);
			hor: out integer range 0 to 799;
			ver: out integer range 0 to 520);
end component;	
	
COMPONENT clock_divider
	PORT(	clk100:in std_logic;
			reset: in std_logic;
			clk25:out std_logic;
			clkdeb:out std_logic);
end component;

COMPONENT debouncer_circuit
	PORT( debouncer_clk:in std_logic;
			reset:in std_logic;
			p_left:in std_logic;
			p_right:in std_logic;
			p_up:in std_logic;
			p_down:in std_logic;
			direction:out std_logic_vector(1 downto 0));
end component;

COMPONENT game_logic
	PORT(	clk:in std_logic;
			reset:in std_logic;
			direction:in std_logic_vector(1 downto 0);
			random_food: in integer range 0 to 639;
			vsync:in std_logic;
			cell_out:out cell_type;
			hor: in integer range 0 to 799;
			ver: in integer range 0 to 520;
			game_over_reset:out std_logic;
			current_game_state: out game_state);
end component;

COMPONENT pseudo_random_generator
	PORT( clk:in std_logic;
			cur_game: in game_state;
			random:out integer range 0 to 639);
end component;

signal cell:cell_type;
signal clk25:std_logic;
signal dclk:std_logic;
signal dir:std_logic_vector(1 downto 0);
signal vs:std_logic;
signal hs:std_logic;
signal randomfood: integer range 0 to 639;
signal horizontal: integer range 0 to 799;
signal vertical: integer range 0 to 520;
signal endgame: std_logic;
signal totalreset: std_logic;
signal gamestate: game_state;

begin
totalreset <= endgame OR reset;
g1: clock_divider 
		PORT MAP(  	
						clk100 => clk,
						reset => totalreset,
						clk25 => clk25,
						clkdeb => dclk
				);
g3: game_logic 
		PORT MAP(	clk => clk25,
						reset => totalreset,
						direction => dir,
						random_food => randomfood,
						vsync => vs,
						cell_out => cell,
						hor => horizontal,
						ver => vertical,
						game_over_reset => endgame,
						current_game_state => gamestate
				);
g2: debouncer_circuit 
		PORT MAP(	debouncer_clk => dclk,
						reset => totalreset,
						p_left => left,
						p_right => right,
						p_up => up,
						p_down => down,
						direction => dir
				);
g4: pseudo_random_generator 
		PORT MAP(	clk => clk25,
						cur_game => gamestate,
						random => randomfood
				);
				
g5: vga 
		PORT MAP(	reset => totalreset,
						vga_clk => clk25,
						board_out => cell,
						vsync => vs,
						hsync => hs,
						red => r,
						green => g,
						blue => b,
						hor => horizontal,
						ver => vertical
				);
				
main_vsync<= vs;
main_hsync<= hs;
rf <= randomfood;
end Behavioral;

