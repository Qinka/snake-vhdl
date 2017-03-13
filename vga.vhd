
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE IEEE.NUMERIC_STD.all;
use work.game_package.all;

entity vga is
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
end vga;

architecture Behavioral of vga is
signal m: std_logic_vector(1 downto 0):="00";
signal h_enable,v_enable: std_logic :='1';
signal h: integer range 0 to 799;
signal v: integer range 0 to 520;

begin

	sync_h:process(vga_clk,reset)
	begin
	if rising_edge(vga_clk) then
		if reset='1' then
			h <= 799;
			hsync<='1';
		else	
			if h < 799 then
				h <= h+1;
			else h <= 0;
			end if;
			if h <= 750 and h >= 655 then
				hsync<='0';
			else hsync<='1';
			end if;
		end if;
	end if;
	end process;
	hor <= h;
	
	sync_v:process(vga_clk,reset)
	begin
	if rising_edge(vga_clk) then
		if reset='1' then
			v <= 520;
			vsync<='1';
		else
			if h= 799 then
				if v < 520 then
					v <= v+1;
				else v <= 0;
				end if;
				if v <= 490 and v>= 489 then
					vsync<='0';
				else vsync<='1';
				end if;
			end if;
		end if;
	end if;
	end process;
	ver <= v;
	
	enable_h:process(h)
	begin
	h_enable<='0';
	if h < 640 then
		h_enable<='1';
	end if;		
	end process;
	
	enable_v:process(v)
	begin
	v_enable<='0';
	if v < 480 then
		v_enable<='1';
	end if;	
	end process;
	
	color_generator:process(vga_clk,reset,v_enable,h_enable)
	begin
	if reset='1' then 
		red<=(others=>'0');
		green<=(others=>'0');
		blue<=(others=>'0');
	elsif rising_edge(vga_clk) then
		if h_enable='1' and v_enable='1' then
			if v/20 < 4 then
				case v/16 is
					when 0 => 
									case h/16 is 
										when 4 | 5 | 6 | 9 | 10 | 14 | 20 | 26 | 29 | 32 | 33 | 34 | 35 => red <= "111"; green <= "111"; blue <= "11";
										when others => red <= "000"; green <= "000"; blue <= "00";
									end case;
					when 1 =>	
									case h/16 is 
										when 4 | 9 | 11 | 14 | 19 | 21 | 26 | 28 | 32 => red <= "111"; green <= "111"; blue <= "11";
										when others => red <= "000"; green <= "000"; blue <= "00";
									end case;
					when 2 =>	
									case h/16 is 
										when 4 | 5 | 6 | 9 | 12 | 14 | 18 | 19 | 20 | 21 | 22 | 26 | 27 | 32 | 33 => red <= "111"; green <= "111"; blue <= "11";
										when others => red <= "000"; green <= "000"; blue <= "00";
									end case;
					when 3 =>	
									case h/16 is 
										when 6 | 9 | 13 | 14 | 17 | 23 | 26 | 28 | 32 => red <= "111"; green <= "111"; blue <= "11";
										when others => red <= "000"; green <= "000"; blue <= "00";
									end case;
					when others => 
									case h/16 is 
										when 4 | 5 | 6 | 9 | 14 | 17 | 23 | 26 | 29 | 32 | 33 | 34 | 35 => red <= "111"; green <= "111"; blue <= "11";
										when others => red <= "000"; green <= "000"; blue <= "00";
									end case;
				end case;
			else
				case board_out is
					when border => red <= "000"; green <= "000"; blue <= "11";
					when snake_tail => red <= "000"; green <= "111"; blue <= "00";
					when food => red <= "111"; green <= "111"; blue <= "00";
					when space => red <= "000"; green <= "000"; blue <= "00";
				end case;
			end if;
		end if;
	end if;
	end process;
	
end Behavioral;

