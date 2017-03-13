
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.game_package.all;

entity debouncer_circuit is
	PORT(	debouncer_clk:in std_logic;
			reset: in std_logic;
			p_left:in std_logic;
			p_right:in std_logic;
			p_up:in std_logic;
			p_down:in std_logic;
			direction:out std_logic_vector(1 downto 0));
end debouncer_circuit;

architecture Behavioral of debouncer_circuit is
signal dl,dr,du,dd: std_logic_vector(3 downto 0):= (others=>'0');
signal left,right,up,down: std_logic:='0';
signal temp_direction: std_logic_vector(1 downto 0):="11";
begin
	process(debouncer_clk,temp_direction,reset)
	begin
	if reset = '1' then
		dl <= (others=>'0');
		dr <= (others=>'0');
		du <= (others=>'0');
		dd <= (others=>'0');
		temp_direction <= "11";
	elsif rising_edge(debouncer_clk) then
		for i in 0 to 2 loop
			dl(i+1) <= dl(i);
			dr(i+1) <= dl(i);
			du(i+1) <= du(i);
			dd(i+1) <= dd(i);
		end loop;
		
		dl(0)<=p_left;
		du(0)<=p_up;
		dd(0)<=p_down;
		dr(0)<=p_right;
	
		left <= dl(0) and NOT(dl(1)) and NOT(dl(2)) and NOT(dl(3));
		up	<= du(0) and NOT(du(1)) and NOT(du(2)) and NOT(du(3));
		down <= dd(0) and NOT(dd(1)) and NOT(dd(2)) and NOT(dd(3));
		right <= dr(0) and NOT(dr(1)) and NOT(dr(2)) and NOT(dr(3));
	
		if up='1' then 			--priority for up
			temp_direction<="00";
		elsif down='1' then 
			temp_direction<="10";
		elsif left='1' then 
			temp_direction<="01";
		elsif right='1' then 
			temp_direction<="11";
		else temp_direction <= temp_direction;
		end if;
	end if;
	direction<=temp_direction;
	end process;
	
	
end Behavioral;

