library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fast_cnt is
	generic (
		CNT_WIDTH : integer
	);
	port (
		clk, res_n : in std_logic;
		cnt_en  : in std_logic;
		cnt_out : out std_logic_vector(CNT_WIDTH - 1 downto 0)
	);
end entity;

architecture beh of fast_cnt is
	signal cnt : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal cnt_last : std_logic_vector(CNT_WIDTH - 5 downto 0);
	signal overflow : std_logic_vector(0 to CNT_WIDTH / 4 - 2);
begin 
	cnt_proc : process(clk, res_n)
	begin
		if res_n = '0' then
			cnt <= (others => '0');
			cnt_last <= (others => '0');
			overflow <= (others => '0');
		elsif rising_edge(clk) then
			cnt_last <= cnt(CNT_WIDTH - 5 downto 0);

			if cnt_en = '1' then
				cnt(3 downto 0) <= std_logic_vector(unsigned(cnt(3 downto 0)) + 1);
			end if;

			for i in 2 to (CNT_WIDTH / 4) loop
				if cnt_last((i - 1) * 4 - 1 downto (i - 2) * 4) = x"F" and cnt((i - 1) * 4 - 1 downto (i - 2) * 4) = x"0" then
					overflow(i - 2) <= '1';
				else
					overflow(i - 2) <= '0';
				end if;
				if overflow(i - 2) = '1' then
					cnt(i * 4 - 1 downto (i - 1) * 4) <= std_logic_vector(unsigned(cnt(i * 4 - 1 downto (i - 1) * 4)) + 1);
				end if;
			end loop;
		end if;
	end process;
	cnt_out <= cnt;
end architecture;
