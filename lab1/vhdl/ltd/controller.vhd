library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mainbus_pkg.all;
use work.math_pkg.all;

entity controller is
	generic (
		CLK_FREQ : integer;
		BAUD_RATE : integer;
		SYNC_STAGES : integer;
		CNT_WIDTH : integer;
		CAPTURE_SOURCES : integer;
		BOARD : string;
		VERSION : string;
		CONTR_FREQ : std_logic_vector(31 downto 0);
		UUT_FREQ : std_logic_vector(31 downto 0);
		MIN_STEP : std_logic_vector(31 downto 0);
		MAX_STEP : std_logic_vector(31 downto 0);
		MIN_DUTY : std_logic_vector(31 downto 0);
		MAX_DUTY : std_logic_vector(31 downto 0);
		STEP_SIZE_N : std_logic_vector(31 downto 0);
		STEP_SIZE_D : std_logic_vector(63 downto 0)
	);
	port (
		clk_in, res_n_in : in std_logic;
		cnt : in std_logic_vector(CNT_WIDTH - 1 downto 0);
		mtbf_stack : in std_logic_vector(CNT_WIDTH - 1 downto 0);
		mtbf_stack_addr : out std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0);
		mtbf_stack_rd : out std_logic;
		mtbf_stack_busy : in std_logic;
		mtbf_stack_empty : in std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
		mtbf_stack_overflowed : in std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
		res_n : out std_logic;
		cnt_en : out std_logic;
		heart_beat : in std_logic;
		ps_in_progress_pulse	: in std_logic;
		ps_inc_pulse : out std_logic;
		ps_dec_pulse : out std_logic;
		ps_value_pulse : in std_logic_vector(31 downto 0);
		ps_value_det	: in std_logic_vector(31 downto 0);
		ps_inc_det : out std_logic;
		ps_dec_det : out std_logic;
		ps_in_progress_det	: in std_logic;
		cal : out std_logic;
		rx : in std_logic;
		tx : out std_logic
	);
end entity;

architecture mixed of controller is
	type STATE_TYPE is (IDLE, MEASUREMENT_RESET, MEASUREMENT_RESET_WAIT,
		MEASUREMENT_START, MEASUREMENT_RUNNING, MEASUREMENT_FINISHED);
	signal state, state_next : STATE_TYPE;
	signal timeout_cnt, timeout_cnt_next : std_logic_vector(63 downto 0);
	
	signal opcode : std_logic_vector(31 downto 0);
	signal res_cnt : std_logic_vector(63 downto 0);
	signal mes_cnt : std_logic_vector(63 downto 0);
	signal busy : std_logic;
	signal res_n_ext, cnt_en_ext : std_logic;
	signal cnt_en_next, res_n_next, busy_next : std_logic;
	signal heart_beat_changed, heart_beat_clear, heart_beat_old : std_logic;
begin
	process(state, opcode, timeout_cnt)
	begin
		state_next <= state;
		
		case state is
			when IDLE =>
				if opcode = x"00000001" then
					state_next <= MEASUREMENT_RESET;
				end if;
			when MEASUREMENT_RESET =>
				state_next <= MEASUREMENT_RESET_WAIT;
			when MEASUREMENT_RESET_WAIT =>
				if unsigned(timeout_cnt) = to_unsigned(1, 32) then
					state_next <= MEASUREMENT_START;
				end if;
			when MEASUREMENT_START =>
				state_next <= MEASUREMENT_RUNNING;
			when MEASUREMENT_RUNNING =>
				if unsigned(timeout_cnt) = to_unsigned(1, 32) then
					state_next <= MEASUREMENT_FINISHED;
				end if;
			when MEASUREMENT_FINISHED =>
				if opcode /= x"00000001" then
					state_next <= IDLE;
				end if;
		end case;
	end process;
	
	process(state, timeout_cnt, res_cnt, mes_cnt, res_n_ext, cnt_en_ext)
	begin
		res_n_next <= '0';
		busy_next <= '1';
		cnt_en_next <= '0';
		timeout_cnt_next <= timeout_cnt;

		case state is
			when IDLE =>
				res_n_next <= res_n_ext;
				busy_next <= '0';
				cnt_en_next <= cnt_en_ext;
			when MEASUREMENT_RESET =>
				res_n_next <= '0';
				cnt_en_next <= '1';
				busy_next <= '1';
				timeout_cnt_next <= res_cnt;
			when MEASUREMENT_RESET_WAIT =>
				timeout_cnt_next <= std_logic_vector(unsigned(timeout_cnt) - 1);
				res_n_next <= '0';
				cnt_en_next <= '1';
				busy_next <= '1';
			when MEASUREMENT_START =>
				res_n_next <= '1';
				timeout_cnt_next <= mes_cnt;
				busy_next <= '1';
				cnt_en_next <= '1';
			when MEASUREMENT_RUNNING =>
				res_n_next <= '1';
				timeout_cnt_next <= std_logic_vector(unsigned(timeout_cnt) - 1);
				busy_next <= '1';
				cnt_en_next <= '1';
			when MEASUREMENT_FINISHED =>
				cnt_en_next <= '0';
				busy_next <= '0';
				res_n_next <= '1';
		end case;
	end process;
	
	process(clk_in, res_n_in)
	begin
		if res_n_in = '0' then
			timeout_cnt <= (others => '0');
			state <= IDLE;
			res_n <= '0';
			busy <= '1';
			cnt_en <= '0';
		elsif rising_edge(clk_in) then
			timeout_cnt <= timeout_cnt_next;
			state <= state_next;
			res_n <= res_n_next;
			busy <= busy_next;
			cnt_en <= cnt_en_next;
		end if;
	end process;
	
	mainbus_inst : mainbus
	generic map (
		CLK_FREQ => CLK_FREQ,
		BAUD_RATE => BAUD_RATE,
		SYNC_STAGES => SYNC_STAGES,
		BOARD => BOARD,
		VERSION => VERSION,
		CONTR_FREQ => CONTR_FREQ,
		UUT_FREQ => UUT_FREQ,
		MIN_STEP => MIN_STEP,
		MAX_STEP => MAX_STEP,
		MIN_DUTY => MIN_DUTY,
		MAX_DUTY =>MAX_DUTY,
		STEP_SIZE_N => STEP_SIZE_N,
		STEP_SIZE_D => STEP_SIZE_D
	)
	port map (
		clk => clk_in,
		res_n => res_n_in,
		cnt => cnt,
		mtbf_stack => mtbf_stack,
		mtbf_stack_addr => mtbf_stack_addr,
		mtbf_stack_rd => mtbf_stack_rd,
		mtbf_stack_busy => mtbf_stack_busy,
		mtbf_stack_empty => mtbf_stack_empty,
		mtbf_stack_overflowed => mtbf_stack_overflowed,
		res_n_ext => res_n_ext,
		cnt_en_ext => cnt_en_ext,
		opcode => opcode,
		res_cnt => res_cnt,
		mes_cnt => mes_cnt,
		busy => busy,
		heart_beat_changed => heart_beat_changed,
		heart_beat_clear => heart_beat_clear,
		ps_in_progress_pulse => ps_in_progress_pulse,
		ps_inc_pulse => ps_inc_pulse,
		ps_dec_pulse => ps_dec_pulse,
		ps_value_pulse => ps_value_pulse,
		ps_value_det => ps_value_det,
		ps_inc_det => ps_inc_det,
		ps_dec_det => ps_dec_det,
		ps_in_progress_det => ps_in_progress_det,
		cal => cal,
		rx => rx,
		tx => tx
	);

	process(clk_in, res_n_in)
	begin
		if res_n_in = '0' then
			heart_beat_changed <= '0';
			heart_beat_old <= '0';
		elsif rising_edge(clk_in) then
			heart_beat_old <= heart_beat;
			if heart_beat_clear = '1' then
				heart_beat_changed <= '0';
			elsif heart_beat /= heart_beat_old then
				heart_beat_changed <= '1';
			end if;
		end if;
	end process;
end architecture;
