library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ram_pkg.all;
use work.math_pkg.all;

entity fast_cnt_capture is
	generic (
		CNT_WIDTH : integer range 4 to integer'high;
		MIN_DEPTH : integer range 4 to integer'high;
		SYNC_STAGES : integer;
		CAPTURE_SOURCES : integer range 1 to integer'high
	);
	port (
		clk : in std_logic;
		res_n : in std_logic;
		cnt_en  : in std_logic;
		cnt_out : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		capture : in std_logic_vector(CAPTURE_SOURCES - 1 downto 0);

		clk_contr : in std_logic;
		res_contr_n : in std_logic;
		cnt_stack_source : in std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0);
		cnt_stack_data : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		cnt_stack_rd : in std_logic;
		cnt_stack_busy : out std_logic;
		cnt_stack_empty : out std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
		cnt_stack_overflowed : out std_logic_vector(CAPTURE_SOURCES - 1 downto 0)
	);
end entity;

architecture beh of fast_cnt_capture is
	signal cnt, cnt_last : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal overflow : std_logic_vector(0 to CNT_WIDTH / 4 - 2);
	type cnt_array_type is array(0 to 2 * CNT_WIDTH / 4 - 2) of std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal cnt_sync : cnt_array_type;
	signal cnt_int : std_logic_vector(CNT_WIDTH - 1 downto 0);  
	signal cnt_stack_ack_int, cnt_stack_rd_int, cnt_stack_empty_int : std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
	signal cnt_stack_source_int, cnt_stack_source_int_next : std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0) := (others => '0');
	type STATE_TYPE is (IDLE, READ, WAIT_ACK, RELEASE_RD, WAIT_ACK_RELEASE_RD);
	signal state, state_next : STATE_TYPE;
	type CNT_STACK_DATA_ARRAY is array(0 to CAPTURE_SOURCES - 1) of std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal cnt_stack_data_int : CNT_STACK_DATA_ARRAY;
begin 
	cnt_proc : process(clk, res_n)
	begin
		if res_n = '0' then
			cnt <= (others => '0');
			cnt_last <= (others => '0');
			overflow <= (others => '0');
			for i in 0 to 2 * CNT_WIDTH / 4 - 2 loop
				cnt_sync(i) <= (others => '0');
			end loop;
			cnt_int <= (others => '0');
		elsif rising_edge(clk) then
			cnt_last <= cnt;
			cnt_int <= cnt_sync(2 * CNT_WIDTH / 4 - 2);

			if cnt_en = '1' then
				cnt(3 downto 0) <= std_logic_vector(unsigned(cnt(3 downto 0)) + 1);
			end if;
			cnt_sync(0) <= cnt;

			for i in 2 to CNT_WIDTH / 4 loop
				if cnt_last((i - 1) * 4 - 1 downto (i - 2) * 4) = x"F" and cnt((i - 1) * 4 - 1 downto (i - 2) * 4) = x"0" then
					overflow(i - 2) <= '1';
				else
					overflow(i - 2) <= '0';
				end if;
				cnt_sync(2 * (i - 1) - 1) <= cnt_sync(2 * (i - 1) - 2);
				if overflow(i - 2) = '1' then
					cnt(i * 4 - 1 downto (i - 1) * 4) <= std_logic_vector(unsigned(cnt(i * 4 - 1 downto (i - 1) * 4)) + 1);
				end if;
				cnt_sync(2 * (i - 1)) <= cnt_sync(2 * (i - 1) - 1);
				cnt_sync(2 * (i - 1))(i * 4 - 1 downto (i - 1) * 4) <= cnt(i * 4 - 1 downto (i - 1) * 4);
			end loop;
		end if;
	end process;

	cnt_out <= cnt_int;

	process(state, cnt_stack_rd, cnt_stack_ack_int, cnt_stack_empty_int, cnt_stack_source_int, cnt_stack_source)
	begin
		state_next <= state;

		case state is
			when IDLE =>
				if cnt_stack_rd = '1' and to_integer(unsigned(cnt_stack_source)) < CAPTURE_SOURCES and cnt_stack_empty_int(to_integer(unsigned(cnt_stack_source))) = '0' then
					state_next <= READ;
			end if;
			when READ => 
				state_next <= WAIT_ACK;
			when WAIT_ACK => 
				if cnt_stack_ack_int(to_integer(unsigned(cnt_stack_source_int))) = '1' then
					state_next <= RELEASE_RD;
				end if;
			when RELEASE_RD =>
				state_next <= WAIT_ACK_RELEASE_RD;
			when WAIT_ACK_RELEASE_RD => 
				if cnt_stack_ack_int(to_integer(unsigned(cnt_stack_source_int))) = '0' then
					state_next <= IDLE;
				end if;
		end case;
	end process;

	process(state, cnt_stack_source_int, cnt_stack_source)
	begin
		cnt_stack_source_int_next <= cnt_stack_source_int;
		cnt_stack_rd_int <= (others => '0');
		cnt_stack_busy <= '0';

		case state is
			when IDLE =>
				cnt_stack_source_int_next <= cnt_stack_source;
			when READ => 
				cnt_stack_rd_int(to_integer(unsigned(cnt_stack_source_int))) <= '1';
				cnt_stack_busy <= '1';
			when WAIT_ACK => 
				cnt_stack_rd_int(to_integer(unsigned(cnt_stack_source_int))) <= '1';
				cnt_stack_busy <= '1';
			when RELEASE_RD =>
				cnt_stack_busy <= '1';
			when WAIT_ACK_RELEASE_RD => 
				cnt_stack_busy <= '1';
		end case;
	end process;

	process(clk_contr, res_contr_n)
	begin
		if res_contr_n = '0' then
			cnt_stack_source_int <= (others => '0');
			state <= IDLE;
		elsif rising_edge(clk_contr) then
			cnt_stack_source_int <= cnt_stack_source_int_next;
			state <= state_next;
		end if;
	end process;


	-- There is only one FIFO present! Generate one FIFO for every case (capture source)!
	-- The number of capture sources is given in the generic "CAPTURE_SOURCES"!
	fifo_inst : fifo_2c1r1w
	generic map (
		MIN_DEPTH => MIN_DEPTH,
		DATA_WIDTH => CNT_WIDTH,
		SYNC_STAGES => SYNC_STAGES
	)
	port map (
		clk1 => clk_contr,
		res1_n => res_contr_n,
		rd1 => cnt_stack_rd_int(0),
		ack1 => cnt_stack_ack_int(0),
		data_out1 => cnt_stack_data_int(0),
		empty1 => cnt_stack_empty_int(0),
		full1 => open,
		overflowed1 => cnt_stack_overflowed(0),

		clk2 => clk,
		res2_n => res_n,
		data_in2 => cnt_int,
		wr2 => capture(0),
		empty2 => open,
		full2 => open,
		overflowed2 => open
	);

	cnt_stack_empty <= cnt_stack_empty_int;
	cnt_stack_data <= cnt_stack_data_int(to_integer(unsigned(cnt_stack_source)));
end architecture;
