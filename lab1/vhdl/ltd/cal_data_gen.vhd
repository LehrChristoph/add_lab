library ieee;
use ieee.std_logic_1164.all;

entity cal_data_gen is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		data : out std_logic
	);
end entity;


architecture beh of cal_data_gen is
	signal data_int : std_logic;
begin
	process(clk, res_n)
	begin
		if res_n = '0' then
			data_int <= '0';
		elsif rising_edge(clk) then
			data_int <= not data_int;
		end if;
	end process;
	data <= data_int;
end architecture;
