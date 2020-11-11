library ieee;
use ieee.std_logic_1164.all;
use work.fast_cnt_pkg.all;
use work.d_ff_pkg.all;

entity counter_unit is
	generic (
		CNT_WIDTH : integer range 4 to integer'high
	);
	port (
		clk_in : in std_logic;
		clk_ref : in std_logic;
		res_n_ref : in std_logic;

		error : in std_logic;
		error010 : in std_logic;
		error01 : in std_logic;
		error10 : in std_logic;
		error101 : in std_logic;

		cnt_en_in : in std_logic;
		cnt : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		cnt010 : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		cnt01 : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		cnt10 : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		cnt101 : out std_logic_vector(CNT_WIDTH - 1 downto 0)
	);
end entity;

architecture mixed of counter_unit is
	signal cnt_en, cnt_en01, cnt_en10, cnt_en010, cnt_en101 : std_logic;
	signal cnt_en_reg, cnt_en01_reg, cnt_en10_reg, cnt_en010_reg, cnt_en101_reg : std_logic;
	signal cnt_int, cnt_int010, cnt_int01, cnt_int10, cnt_int101 : std_logic_vector(CNT_WIDTH - 1 downto 0);
begin
	cnt_en <= cnt_en_in and error;	
	cnt_en01 <= cnt_en_in and error01;
	cnt_en10 <= cnt_en_in and error10;
	cnt_en010 <= cnt_en_in and error010;
	cnt_en101 <= cnt_en_in and error101;
	
	process(clk_ref, res_n_ref)
	begin
		if res_n_ref = '0' then
			cnt_en_reg <= '0';
			cnt_en01_reg <= '0';
			cnt_en10_reg <= '0';
			cnt_en010_reg <= '0';
			cnt_en101_reg <= '0';
		elsif rising_edge(clk_ref) then
			cnt_en_reg <= cnt_en;
			cnt_en01_reg <= cnt_en01;
			cnt_en10_reg <= cnt_en10;
			cnt_en010_reg <= cnt_en010;
			cnt_en101_reg <= cnt_en101;
		end if;
	end process;
	
	cnt_inst : fast_cnt
	generic map (
		CNT_WIDTH => CNT_WIDTH
	)
	port map (
		clk => clk_ref,
		res_n => res_n_ref,
		cnt_en => cnt_en_reg,
		cnt_out => cnt_int
	);

	cnt01_inst : fast_cnt
	generic map (
		CNT_WIDTH => CNT_WIDTH
	)
	port map (
		clk => clk_ref,
		res_n => res_n_ref,
		cnt_en => cnt_en01_reg,
		cnt_out => cnt_int01
	);

	cnt10_inst : fast_cnt
	generic map (
		CNT_WIDTH => CNT_WIDTH
	)
	port map (
		clk => clk_ref,
		res_n => res_n_ref,
		cnt_en => cnt_en10_reg,
		cnt_out => cnt_int10
	);

	cnt010_inst : fast_cnt
	generic map (
		CNT_WIDTH => CNT_WIDTH
	)
	port map (
		clk => clk_ref,
		res_n => res_n_ref,
		cnt_en => cnt_en010_reg,
		cnt_out => cnt_int010
	);

	cnt101_inst : fast_cnt
	generic map (
		CNT_WIDTH => CNT_WIDTH
	)
	port map (
		clk => clk_ref,
		res_n => res_n_ref,
		cnt_en => cnt_en101_reg,
		cnt_out => cnt_int101
	);

	-- No real synchronizer but simplifies the creation of timing constraints.
	-- Cnt values are only allowed to be read if cnt_en = '0'!
	sync_cnt_generate : for i in 0 to CNT_WIDTH - 1 generate
		cnt_sync_inst : d_ff
		port map (
			clk => clk_in,
			res_n => '1',
			d => cnt_int(i),
			q => cnt(i)
		);
	end generate;
	sync_cnt01_generate : for i in 0 to CNT_WIDTH - 1 generate
		cnt01_sync_inst : d_ff
		port map (
			clk => clk_in,
			res_n => '1',
			d => cnt_int01(i),
			q => cnt01(i)
		);
	end generate;
	sync_cnt10_generate : for i in 0 to CNT_WIDTH - 1 generate
		cnt10_sync_inst : d_ff
		port map (
			clk => clk_in,
			res_n => '1',
			d => cnt_int10(i),
			q => cnt10(i)
		);
	end generate;
	sync_cnt010_generate : for i in 0 to CNT_WIDTH - 1 generate
		cnt010_sync_inst : d_ff
		port map (
			clk => clk_in,
			res_n => '1',
			d => cnt_int010(i),
			q => cnt010(i)
		);
	end generate;
	sync_cnt101_generate : for i in 0 to CNT_WIDTH - 1 generate
		cnt101_sync_inst : d_ff
		port map (
			clk => clk_in,
			res_n => '1',
			d => cnt_int101(i),
			q => cnt101(i)
		);
	end generate;
end architecture;
