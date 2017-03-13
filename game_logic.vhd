
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use work.game_package.all;

entity game_logic is
PORT(	clk:in std_logic;
		reset:in std_logic;
		direction: in std_logic_vector(1 downto 0);
		random_food: in integer range 0 to 639;
		vsync:in std_logic;
		cell_out:out cell_type;
		hor: in integer range 0 to 799;
		ver: in integer range 0 to 520;
		game_over_reset:out std_logic;
		current_game_state: out game_state);
end game_logic;

architecture Behavioral of game_logic is
	
	type state_type is (a,b);
	signal state: state_type:= a;
	signal temp_cell: cell_type:= border;
	signal game: game_state := ready;
	signal current_direction:std_logic_vector(1 downto 0):="11";
	signal direction_out: std_logic_vector(1 downto 0):="11";
	signal tick: std_logic:='0';
	signal logic_tick: std_logic:='0';
	signal snake: snake:= ((0)=>577,(1)=>578,(2)=>579,(3)=>580,others=>0);
	signal snake_length: integer range 0 to 23:=3;
	shared variable next_cell: integer range 0 to 639;
	signal currentfood: integer range 0 to 639:=100;
	signal count:integer range 0 to 63:=0;
	signal temp: std_logic:='0';
	signal tick_time: integer range 0 to 40 := 40;
	
	begin
	
	snake_timer:process(vsync,reset,clk)
	begin
	if reset = '1' then
		count<= 0;
		temp <= '0';
		logic_tick <= '0';
	elsif rising_edge(clk) then
		tick <= temp and not(vsync);
		temp <= vsync;
		if tick = '1' then
			count <= count + 1;
			if count= tick_time then
				logic_tick <= '1';
				count<=0;
			end if;
			tick <= '0';
		end if;
		if logic_tick = '1' then
			logic_tick <= '0';
		end if;
	end if;
	end process snake_timer;
	
	all_game:process(clk,game,reset)
	variable crashed: std_logic:='0';
	begin
	if reset = '1' then
		game <= ready;
		snake_length <= 3;
		snake <= ((0)=>577,(1)=>578,(2)=>579,(3)=>580,others=>0);
		current_direction <= "11";
		direction_out <= "11";
		state <= a;
		crashed:= '0';
		currentfood <= 100;
		game_over_reset <= '0';
		tick_time <= 40;
	elsif rising_edge(clk) then
		if game = ready then
			if logic_tick = '1' then
				game <= directioncheck;
			elsif hor = 799 and ver = 520 then
				game <= vga;
			end if;
		elsif game = directioncheck then
			if direction=current_direction+"10" then
				direction_out<=current_direction;
				game <= check;
			else direction_out<=direction;
				  game <= check;
			end if;
		elsif game = check then
			current_direction <= direction_out;
			if direction_out="00" then
				next_cell:= snake(snake_length)-32;
				for i in 1 to 19 loop
					if next_cell = snake(i) then
						crashed:='1';
					end if;
				end loop;
				if next_cell < 32 then 
					crashed:= '1';
				end if;
			elsif direction_out="10" then
				next_cell:= snake(snake_length)+32;
				for i in 1 to 19 loop
					if next_cell = snake(i) then
						crashed:='1';
					end if;
				end loop;
				if next_cell > 607 then
					crashed:='1';
				end if;
			elsif direction_out="01" then
				next_cell:= snake(snake_length)-1;
				for i in 1 to 19 loop
					if next_cell = snake(i) then
						crashed:='1';
					end if;
				end loop;
				if next_cell mod 32 = 0 then 
						crashed:= '1';
				end if;
			elsif direction_out="11" then
				next_cell:= snake(snake_length)+1;
				for i in 1 to 19 loop
					if next_cell = snake(i) then
						crashed:='1';
					end if;
				end loop;
				if next_cell mod 32 = 31 then 
					crashed:= '1';
				end if;
			end if;
			if crashed='1' then
				game <= game_over;
			else game <= move;
			end if;
		elsif game = move then
			if next_cell = currentfood and snake_length /= 19 then
				if state = a then
					snake(snake_length+1)<=next_cell;
					state <= b;
				elsif state = b then
					snake_length<=snake_length+1;
					game <= generatefood;
					state <= a;
				end if;
			else 
				if state = a then
					snake(0)<= snake(1);
					snake(1)<= snake(2);
					snake(2)<= snake(3);
					snake(3)<= snake(4);
					snake(4)<= snake(5);
					snake(5)<= snake(6);
					snake(6)<= snake(7);
					snake(7)<= snake(8);
					snake(8)<= snake(9);
					snake(9)<= snake(10);
					snake(10)<= snake(11);
					snake(11)<= snake(12);
					snake(12)<= snake(13);
					snake(13)<= snake(14);
					snake(14)<= snake(15);
					snake(15)<= snake(16);
					snake(16)<= snake(17);
					snake(17)<= snake(18);
					snake(18)<= snake(19);
					state <= b;
				elsif state = b then
					snake(snake_length)<=next_cell;
					if snake_length = 19 then
						game <= generatefood;
					else game <= ready;
					end if;
					state <= a;
				end if;
			end if;
		elsif game = generatefood then
			if tick_time /= 2 then
				tick_time <= tick_time - 2;
			end if;
			currentfood <= (random_food/30) * 32 + 32 + random_food mod 30 + 1;
			game <= ready;
		elsif game = vga then
			temp_cell <= space;
			if ver/20 = 4 or ver/20 = 23 or hor/20 mod 32 = 0 or hor/20 mod 32 = 31 then
				temp_cell <= border;
			end if;
			for i in 0 to 19 loop
				if hor/20 = snake(i) mod 32 and ver/20 = (snake(i)/32 + 4) then
					if snake(i) /= 0 then
						temp_cell<= snake_tail;
					end if;
				end if;
			end loop;
			if hor/20 = currentfood mod 32 and ver/20 = (currentfood/32 + 4) then
				temp_cell <= food;
			end if;
			if hor = 639 and ver = 479 then
				game <= ready;
			end if;
		elsif game = game_over then
			game_over_reset <= '1';
		end if;
	end if;
	end process;
	cell_out <= temp_cell;
	current_game_state <= game;
end Behavioral;

