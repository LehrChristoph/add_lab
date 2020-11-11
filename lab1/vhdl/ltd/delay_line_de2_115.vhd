library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sync_pkg.all;

entity delay_line is
	generic (
		SYNC_STAGES : integer;
		PS_VALUE_MIN : signed(31 downto 0);
		PS_VALUE_MAX : signed(31 downto 0);
		PS_VALUE_PULSE_MIN : signed(31 downto 0);
		PS_VALUE_PULSE_MAX : signed(31 downto 0)
	);
	port (
		clk_in, res_n_in : in std_logic;
		clk_uut : out std_logic;
		clk_contr : out std_logic;
		res_contr_n : out std_logic;
		ps_value_det : out std_logic_vector(31 downto 0);
		ps_value_pulse : out std_logic_vector(31 downto 0);
		ps_inc_det, ps_dec_det : in std_logic;
		ps_inc_pulse, ps_dec_pulse : in std_logic;
		ps_in_progress_det, ps_in_progress_pulse : out std_logic;
		clk_det : out std_logic;
		clk_ref : out std_logic;
		res_n_ref : out std_logic;
		cal_sync, cal_data, ff_data_in : in std_logic;
		ff_data : out std_logic
	);
end entity;

architecture struct of delay_line is

	component clk_mul2 is
		port (
			areset : in std_logic;
			configupdate : in std_logic;
			inclk0 : in std_logic;
			phasecounterselect : in std_logic_vector(2 downto 0);
			phasestep : in std_logic;
			phaseupdown : in std_logic;
			scanclk : in std_logic;
			scanclkena : in std_logic;
			scandata : in std_logic;
			c0 : out std_logic;
			c1 : out std_logic;
			c2 : out std_logic;
			locked : out std_logic;
			phasedone : out std_logic;
			scandataout : out std_logic ;
			scandone : out std_logic 
		);
	end component;

	component clk_mul_reconf_pllrcfg_7641 is
		port (
			busy : out std_logic;
			clock : in std_logic;
			counter_param : in std_logic_vector (2 downto 0);
			counter_type : in std_logic_vector (3 downto 0);
			data_in : in std_logic_vector (8 downto 0);
			data_out : out std_logic_vector (8 downto 0);
			pll_areset : out std_logic;
			pll_areset_in : in std_logic;
			pll_configupdate : out std_logic;
			pll_scanclk : out std_logic;
			pll_scanclkena : out std_logic;
			pll_scandata : out std_logic;
			pll_scandataout : in std_logic;
			pll_scandone : in std_logic;
			read_param : in std_logic;
			reconfig : in std_logic;
			reset : in std_logic;
			write_param : in std_logic
		);
	end component;

	component data_mul IS
		port (
			areset : IN STD_LOGIC := '0';
			inclk0 : IN STD_LOGIC := '0';
			c0 : OUT STD_LOGIC ;
			locked : OUT STD_LOGIC 
		);
	end component;

	constant COUNTER_C2 : std_logic_vector(3 downto 0) := "0110";
	
	constant HIGH_COUNT_PARAM : std_logic_vector(2 downto 0) := "000"; -- High gets the higher value if sum is odd
	constant LOW_COUNT_PARAM : std_logic_vector(2 downto 0) := "001";
	constant EVEN_ODD_MODE_PARAM : std_logic_vector(2 downto 0) := "101"; --1-> H-=0,5cyc, L+=0.5cyc
	
	signal pll_res, pll_configupdate, pll_scanclk, pll_scanclkena, pll_scandata_pc, pll_scandata_cp, pll_scandone : std_logic;
	
	signal busy, read_param, write_param, reconfig : std_logic;
	signal counter_param : std_logic_vector (2 downto 0);
	signal counter_type : std_logic_vector (3 downto 0);
	signal data_in, data_out : std_logic_vector (8 downto 0);
	
	type STATE_TYPE is (IDLE, INCREMENT1_1, INCREMENT1_2, INCREMENT1_3, DECREMENT0_1, DECREMENT0_2, DECREMENT0_3, DECREMENT1_1, DECREMENT1_2, DECREMENT1_3, INCREMENT0_1, INCREMENT0_2, INCREMENT0_3, WAIT_DONE, WAIT_DEASSERT);
	signal state, state_next : STATE_TYPE;
	
	signal ps_en, ps_inc_dec : std_logic;
	signal ps_in_progress : std_logic;
	signal clk_ref_int, clk_mul_sig, clk_det_sig : std_logic;
	signal res_in, res_ref, res_ref_unsync : std_logic;
	signal ps_value, ps_value_next : std_logic_vector(31 downto 0);
	signal ps_done : std_logic;
	signal locked_mul : std_logic;
	signal clk_uut_int : std_logic;
	signal clk_ref_int1, clk_ref_int2 : std_logic;
	signal ps_cnt_select : std_logic_vector(2 downto 0);
	
	type STATE_PULSE_TYPE is (STATE_PULSE_IDLE, STATE_PULSE_READ_HIGH_COUNT, STATE_PULSE_READ_HIGH_COUNT_WAIT,
		STATE_PULSE_READ_HIGH_COUNT_FINISHED, STATE_PULSE_READ_LOW_COUNT, STATE_PULSE_READ_LOW_COUNT_WAIT,
		STATE_PULSE_READ_LOW_COUNT_FINISHED, STATE_PULSE_READ_EVEN_ODD_MODE, STATE_PULSE_READ_EVEN_ODD_MODE_WAIT,
		STATE_PULSE_READ_EVEN_ODD_MODE_FINISHED, STATE_PULSE_REDUCE_PULSE_WIDTH1, STATE_PULSE_INCREASE_PULSE_WIDTH1,
		STATE_PULSE_REDUCE_PULSE_WIDTH2, STATE_PULSE_INCREASE_PULSE_WIDTH2, STATE_PULSE_SET_EVEN_ODD_MODE,
		STATE_PULSE_RESET_EVEN_ODD_MODE, STATE_PULSE_WRITE_HIGH_COUNT, STATE_PULSE_WRITE_HIGH_COUNT_WAIT,
		STATE_PULSE_WRITE_LOW_COUNT, STATE_PULSE_WRITE_LOW_COUNT_WAIT, STATE_PULSE_WRITE_EVEN_ODD,
		STATE_PULSE_WRITE_EVEN_ODD_WAIT, STATE_PULSE_RECONFIGURE, STATE_PULSE_RECONFIGURE_WAIT, STATE_PULSE_WAIT_RELEASE);
	signal state_pulse, state_pulse_next : STATE_PULSE_TYPE;
	signal ps_inc_pulse_latched, ps_dec_pulse_latched, ps_inc_pulse_latched_next, ps_dec_pulse_latched_next : std_logic;
	signal high_count, low_count, high_count_next, low_count_next : std_logic_vector(7 downto 0);
	signal even_odd_mode, even_odd_mode_next : std_logic;
	signal ff_data_int : std_logic;
	signal res_data : std_logic;
	
	attribute KEEP : string;
	attribute KEEP of clk_uut_int : signal is "TRUE";
	attribute KEEP of clk_ref_int1 : signal is "TRUE";
	attribute KEEP of clk_ref_int2 : signal is "TRUE";
begin
	res_in <= not res_n_in;

	clk_mul_inst : clk_mul2
	port map (
		areset => pll_res,
		configupdate => pll_configupdate,
		inclk0 => clk_in,
		phasecounterselect => ps_cnt_select,
		phasestep => ps_en,
		phaseupdown => ps_inc_dec,
		scanclk => pll_scanclk,
		scanclkena => pll_scanclkena,
		scandata => pll_scandata_cp,
		c0 => clk_mul_sig,
		c1 => clk_det_sig,
		c2 => clk_uut_int,
		locked => locked_mul,
		phasedone => ps_done,
		scandataout => pll_scandata_pc,
		scandone => pll_scandone
	);
	
	config_inst : entity work.clk_mul_reconf_pllrcfg_ig11
	port map (
		busy => busy,
		clock => clk_in,
		counter_param => counter_param, 
		counter_type => counter_type,
		data_in => data_in,
		data_out => data_out,
		pll_areset => pll_res,
		pll_areset_in => res_in,
		pll_configupdate => pll_configupdate,
		pll_scanclk => pll_scanclk,
		pll_scanclkena => pll_scanclkena,
		pll_scandata => pll_scandata_cp,
		pll_scandataout => pll_scandata_pc,
		pll_scandone => pll_scandone,
		read_param => read_param,
		reconfig => reconfig,
		reset => res_in,
		write_param => write_param
	); 

	res_ref_unsync <= not locked_mul;
	
	res_ref_sync_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk_ref_int,
		res_n => '1',
		data_in => res_ref_unsync,
		data_out => res_ref
	);

	clk_uut <= clk_uut_int;

	clk_ref_int1 <= clk_mul_sig;
	clk_ref_int2 <= clk_ref_int1;
	clk_ref_int <= clk_ref_int2;

	clk_det <= clk_det_sig;
	clk_ref <= clk_ref_int;
	res_n_ref <= not res_ref;
	
	clk_contr <= clk_in;
	res_contr_n <= res_n_in;

	process(state, ps_inc_det, ps_dec_det, ps_done, ps_value)
	begin
		state_next <= state;
		case state is
			when IDLE =>
				if ps_inc_det = '1' and signed(ps_value) >= 0 and signed(ps_value) < PS_VALUE_MAX then
					state_next <= INCREMENT1_1;
				elsif ps_inc_det = '1' and signed(ps_value) < 0 and signed(ps_value) < PS_VALUE_MAX then
					state_next <= DECREMENT0_1;
				elsif ps_dec_det = '1' and signed(ps_value) > 0 and signed(ps_value) > PS_VALUE_MIN then
					state_next <= DECREMENT1_1;
				elsif ps_dec_det = '1' and signed(ps_value) <= 0 and signed(ps_value) > PS_VALUE_MIN then
					state_next <= INCREMENT0_1;
				end if;
			when INCREMENT1_1 =>
				state_next <= INCREMENT1_2;
			when INCREMENT1_2 =>
				state_next <= INCREMENT1_3;
			when INCREMENT1_3 =>
				if ps_done = '1' then
					state_next <= WAIT_DEASSERT;
				else
					state_next <= WAIT_DONE;
				end if;
			when DECREMENT0_1 =>
				state_next <= DECREMENT0_2;
			when DECREMENT0_2 =>
				state_next <= DECREMENT0_3;
			when DECREMENT0_3 =>
				if ps_done = '1' then
					state_next <= WAIT_DEASSERT;
				else
					state_next <= WAIT_DONE;
				end if;
			when DECREMENT1_1 =>
				state_next <= DECREMENT1_2;
			when DECREMENT1_2 =>
				state_next <= DECREMENT1_3;
			when DECREMENT1_3 =>
				if ps_done = '1' then
					state_next <= WAIT_DEASSERT;
				else
					state_next <= WAIT_DONE;
				end if;
			when INCREMENT0_1 =>
				state_next <= INCREMENT0_2;
			when INCREMENT0_2 =>
				state_next <= INCREMENT0_3;
			when INCREMENT0_3 =>
				if ps_done = '1' then
					state_next <= WAIT_DEASSERT;
				else
					state_next <= WAIT_DONE;
				end if;
			when WAIT_DONE =>
				if ps_done = '1' then
					state_next <= WAIT_DEASSERT;
				end if;
			when WAIT_DEASSERT =>
				if ps_inc_det = '0' and ps_dec_det = '0' then
					state_next <= IDLE;
				end if;
		end case;
	end process;
	
	process(state, ps_value)
	begin
		ps_en <= '0';
		ps_inc_dec <= '0';
		ps_in_progress <= '0';
		ps_cnt_select <= "000";
		ps_value_next <= ps_value;
		ps_in_progress <= '1';
		
		case state is
			when IDLE =>
				ps_in_progress <= '0';
			when INCREMENT1_1 =>
				ps_en <= '1';
				ps_inc_dec <= '1';
				ps_value_next <= std_logic_vector(signed(ps_value) + 1);
				ps_cnt_select <= "011";
			when INCREMENT1_2 =>
				ps_en <= '1';
				ps_inc_dec <= '1';
				ps_cnt_select <= "011";
			when INCREMENT1_3 =>
				ps_en <= '1';
				ps_inc_dec <= '1';
				ps_cnt_select <= "011";
			when DECREMENT0_1 =>
				ps_en <= '1';
				ps_inc_dec <= '0';
				ps_value_next <= std_logic_vector(signed(ps_value) + 1);
				ps_cnt_select <= "010";
			when DECREMENT0_2 =>
				ps_en <= '1';
				ps_inc_dec <= '0';
				ps_cnt_select <= "010";
			when DECREMENT0_3 =>
				ps_en <= '1';
				ps_inc_dec <= '0';
				ps_cnt_select <= "010";
			when DECREMENT1_1 =>
				ps_en <= '1';
				ps_inc_dec <= '0';
				ps_value_next <= std_logic_vector(signed(ps_value) - 1);
				ps_cnt_select <= "011";
			when DECREMENT1_2 =>
				ps_en <= '1';
				ps_inc_dec <= '0';
				ps_cnt_select <= "011";
			when DECREMENT1_3 =>
				ps_en <= '1';
				ps_inc_dec <= '0';
				ps_cnt_select <= "011";
			when INCREMENT0_1 =>
				ps_en <= '1';
				ps_inc_dec <= '1';
				ps_value_next <= std_logic_vector(signed(ps_value) - 1);
				ps_cnt_select <= "010";
			when INCREMENT0_2 =>
				ps_en <= '1';
				ps_inc_dec <= '1';
				ps_cnt_select <= "010";
			when INCREMENT0_3 =>
				ps_en <= '1';
				ps_inc_dec <= '1';
				ps_cnt_select <= "010";
			when WAIT_DONE =>
				null;
			when WAIT_DEASSERT =>
				null;
		end case;
	end process;
	
	process(clk_in, pll_res)
	begin
		if pll_res = '1' then
			state <= IDLE;
			ps_value <= (others => '0');
		elsif rising_edge(clk_in) then
			state <= state_next;
			ps_value <= ps_value_next;
		end if;
	end process;
	
	ps_value_det <= ps_value;
	ps_in_progress_det <= ps_in_progress;

	process(state_pulse, ps_inc_pulse, ps_dec_pulse, ps_inc_pulse_latched, ps_dec_pulse_latched, busy, high_count, even_odd_mode, low_count)
	begin
		state_pulse_next <= state_pulse;
		
		case state_pulse is
			when STATE_PULSE_IDLE =>
				if ps_inc_pulse = '1' or ps_dec_pulse = '1' then
					state_pulse_next <= STATE_PULSE_READ_HIGH_COUNT;
				end if;
			when STATE_PULSE_READ_HIGH_COUNT =>
				state_pulse_next <= STATE_PULSE_READ_HIGH_COUNT_WAIT;
			when STATE_PULSE_READ_HIGH_COUNT_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_READ_HIGH_COUNT_FINISHED;
				end if;
			when STATE_PULSE_READ_HIGH_COUNT_FINISHED =>
				state_pulse_next <= STATE_PULSE_READ_LOW_COUNT;
			when STATE_PULSE_READ_LOW_COUNT =>
				state_pulse_next <= STATE_PULSE_READ_LOW_COUNT_WAIT;
			when STATE_PULSE_READ_LOW_COUNT_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_READ_LOW_COUNT_FINISHED;
				end if;
			when STATE_PULSE_READ_LOW_COUNT_FINISHED =>
				state_pulse_next <= STATE_PULSE_READ_EVEN_ODD_MODE;
			when STATE_PULSE_READ_EVEN_ODD_MODE =>
				state_pulse_next <= STATE_PULSE_READ_EVEN_ODD_MODE_WAIT;
			when STATE_PULSE_READ_EVEN_ODD_MODE_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_READ_EVEN_ODD_MODE_FINISHED;
				end if;
			when STATE_PULSE_READ_EVEN_ODD_MODE_FINISHED =>
				if ps_inc_pulse_latched = '1' then
					state_pulse_next <= STATE_PULSE_INCREASE_PULSE_WIDTH1;
				elsif ps_dec_pulse_latched = '1' then
					state_pulse_next <= STATE_PULSE_REDUCE_PULSE_WIDTH1;
				else
					state_pulse_next <= STATE_PULSE_WAIT_RELEASE;
				end if;
			when STATE_PULSE_REDUCE_PULSE_WIDTH1 =>
				if unsigned(high_count) > 1 then
					state_pulse_next <= STATE_PULSE_REDUCE_PULSE_WIDTH2;
				elsif even_odd_mode = '0' then
					state_pulse_next <= STATE_PULSE_SET_EVEN_ODD_MODE;
				else
					state_pulse_next <= STATE_PULSE_WAIT_RELEASE;
				end if;
			when STATE_PULSE_INCREASE_PULSE_WIDTH1 =>
				if even_odd_mode = '1' then
					state_pulse_next <= STATE_PULSE_RESET_EVEN_ODD_MODE;
				elsif unsigned(low_count) > unsigned(high_count) then
					state_pulse_next <= STATE_PULSE_INCREASE_PULSE_WIDTH2;
				else
					state_pulse_next <= STATE_PULSE_WAIT_RELEASE;
				end if;
			when STATE_PULSE_REDUCE_PULSE_WIDTH2 =>
				state_pulse_next <= STATE_PULSE_WRITE_HIGH_COUNT;
			when STATE_PULSE_INCREASE_PULSE_WIDTH2 =>
				state_pulse_next <= STATE_PULSE_WRITE_HIGH_COUNT;
			when STATE_PULSE_SET_EVEN_ODD_MODE =>
				state_pulse_next <= STATE_PULSE_WRITE_EVEN_ODD;
			when STATE_PULSE_RESET_EVEN_ODD_MODE =>
				state_pulse_next <= STATE_PULSE_WRITE_EVEN_ODD;
			when STATE_PULSE_WRITE_HIGH_COUNT =>
				state_pulse_next <= STATE_PULSE_WRITE_HIGH_COUNT_WAIT;
			when STATE_PULSE_WRITE_HIGH_COUNT_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_WRITE_LOW_COUNT;
				end if;
			when STATE_PULSE_WRITE_LOW_COUNT =>
				state_pulse_next <= STATE_PULSE_WRITE_LOW_COUNT_WAIT;
			when STATE_PULSE_WRITE_LOW_COUNT_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_RECONFIGURE;
				end if;
			when STATE_PULSE_WRITE_EVEN_ODD =>
				state_pulse_next <= STATE_PULSE_WRITE_EVEN_ODD_WAIT;
			when STATE_PULSE_WRITE_EVEN_ODD_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_RECONFIGURE;
				end if;
			when STATE_PULSE_RECONFIGURE =>
				state_pulse_next <= STATE_PULSE_RECONFIGURE_WAIT;
			when STATE_PULSE_RECONFIGURE_WAIT =>
				if busy = '0' then
					state_pulse_next <= STATE_PULSE_WAIT_RELEASE;
				end if;
			when STATE_PULSE_WAIT_RELEASE =>
				if ps_inc_pulse = '0' and ps_dec_pulse = '0' then
					state_pulse_next <= STATE_PULSE_IDLE;
				end if;
		end case;
	end process;
	
	process(state_pulse, high_count, low_count, data_out, even_odd_mode, ps_inc_pulse, ps_dec_pulse, ps_inc_pulse_latched, ps_dec_pulse_latched)
	begin
		counter_type <= (others => '0');
		counter_param <= (others => '0');
		data_in <= (others => '0');
		write_param	<= '0';
		read_param	<= '0';
		high_count_next <= high_count;
		low_count_next <= low_count;
		even_odd_mode_next <= even_odd_mode;
		reconfig <= '0';
		ps_in_progress_pulse <= '1';
		ps_inc_pulse_latched_next <= ps_inc_pulse_latched;
		ps_dec_pulse_latched_next <= ps_dec_pulse_latched;
				
		case state_pulse is
			when STATE_PULSE_IDLE =>
				ps_in_progress_pulse <= '0';
				ps_inc_pulse_latched_next <= ps_inc_pulse;
				ps_dec_pulse_latched_next <= ps_dec_pulse;
			when STATE_PULSE_READ_HIGH_COUNT =>
				counter_type <= COUNTER_C2;
				counter_param <= HIGH_COUNT_PARAM;
				read_param	<= '1';
			when STATE_PULSE_READ_HIGH_COUNT_WAIT =>
				null;			
			when STATE_PULSE_READ_HIGH_COUNT_FINISHED =>
				high_count_next <= data_out(7 downto 0);
			when STATE_PULSE_READ_LOW_COUNT =>
				counter_type <= COUNTER_C2;
				counter_param <= LOW_COUNT_PARAM;
				read_param	<= '1';
			when STATE_PULSE_READ_LOW_COUNT_WAIT =>
				null;			
			when STATE_PULSE_READ_LOW_COUNT_FINISHED =>
				low_count_next <= data_out(7 downto 0);
			when STATE_PULSE_READ_EVEN_ODD_MODE =>
				counter_type <= COUNTER_C2;
				counter_param <= EVEN_ODD_MODE_PARAM;
				read_param	<= '1';
			when STATE_PULSE_READ_EVEN_ODD_MODE_WAIT =>
				null;			
			when STATE_PULSE_READ_EVEN_ODD_MODE_FINISHED =>
				even_odd_mode_next <= data_out(0);
			when STATE_PULSE_REDUCE_PULSE_WIDTH1 =>
				null;
			when STATE_PULSE_INCREASE_PULSE_WIDTH1 =>
				null;
			when STATE_PULSE_REDUCE_PULSE_WIDTH2 =>
				high_count_next <= std_logic_vector(unsigned(high_count) - 1);
				low_count_next <= std_logic_vector(unsigned(low_count) + 1);
			when STATE_PULSE_INCREASE_PULSE_WIDTH2 =>
				high_count_next <= std_logic_vector(unsigned(high_count) + 1);
				low_count_next <= std_logic_vector(unsigned(low_count) - 1);
			when STATE_PULSE_SET_EVEN_ODD_MODE =>
				even_odd_mode_next <= '1';
			when STATE_PULSE_RESET_EVEN_ODD_MODE =>
				even_odd_mode_next <= '0';
			when STATE_PULSE_WRITE_HIGH_COUNT =>
				counter_type <= COUNTER_C2;
				counter_param <= HIGH_COUNT_PARAM;
				data_in <= "0" & high_count;
				write_param	<= '1';
			when STATE_PULSE_WRITE_HIGH_COUNT_WAIT =>
				null;
			when STATE_PULSE_WRITE_LOW_COUNT =>
				counter_type <= COUNTER_C2;
				counter_param <= LOW_COUNT_PARAM;
				data_in <= "0" & low_count;
				write_param	<= '1';
			when STATE_PULSE_WRITE_LOW_COUNT_WAIT =>
				null;
			when STATE_PULSE_WRITE_EVEN_ODD =>
				counter_type <= COUNTER_C2;
				counter_param <= EVEN_ODD_MODE_PARAM;
				data_in <= "00000000" & even_odd_mode;
				write_param	<= '1';
			when STATE_PULSE_WRITE_EVEN_ODD_WAIT =>
				null;
			when STATE_PULSE_RECONFIGURE =>
				reconfig <= '1';
			when STATE_PULSE_RECONFIGURE_WAIT =>
				null;
			when STATE_PULSE_WAIT_RELEASE =>
				null;
		end case;
	end process;
	
	process(clk_in, res_in)
	begin
		if res_in = '1' then
			state_pulse <= STATE_PULSE_IDLE;
			high_count <= (others => '0');
			low_count <= (others => '0');
			even_odd_mode <= '0';
			ps_inc_pulse_latched <= '0';
			ps_dec_pulse_latched <= '0';
		elsif rising_edge(clk_in) then
			state_pulse <= state_pulse_next;
			high_count <= high_count_next;
			low_count <= low_count_next;
			even_odd_mode <= even_odd_mode_next;
			ps_inc_pulse_latched <= ps_inc_pulse_latched_next;
			ps_dec_pulse_latched <= ps_dec_pulse_latched_next;
		end if;
	end process;
	
	ps_value_pulse <= std_logic_vector(to_signed(to_integer(signed(high_count & (not even_odd_mode))) - 7, 32));

	res_data_sync_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '1'
	)
	port map (
		clk => ff_data_in,
		res_n => '1',
		data_in => res_in,
		data_out => res_data
	);

	data_mul_inst : data_mul
	port map (
		areset => res_data,
		inclk0 => ff_data_in,
		c0 => ff_data_int,
		locked => open
	);

	cal_mux_inst : ff_data <= ff_data_int when cal_sync = '0' else cal_data;
end architecture;
