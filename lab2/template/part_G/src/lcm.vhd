----------------------------------------------------------------------------------
-- lcm Implementation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity lcm is
	generic ( 
		DATA_WIDTH : natural := DATA_WIDTH);
	port (
		AB_t 		: in std_logic_vector ( DATA_WIDTH-1 downto 0 );
		AB_f 		: in std_logic_vector ( DATA_WIDTH-1 downto 0 );
		RESULT_t : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
		RESULT_f : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
		rst   	: in std_logic;
		ack_in	: in std_logic;
		ack_out	: out std_logic
	);
end lcm;

architecture STRUCTURE of lcm is
	constant DATA_PATH_WIDTH : Integer := 3*DATA_WIDTH;
	constant SUM_WIDTH : Integer := DATA_WIDTH;
	constant SUMMAND_WIDTH : Integer := DATA_WIDTH/2;

	signal input_complete : std_logic;
	signal inAB_t, inAB_f  : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);

	signal m0_sumAB_data_t, m0_sumAB_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal m0_sum_select_inA_ack : std_logic;

	signal fr0_fork_register_sum_ack : std_logic;
	signal fr0_data_t, fr0_data_f, fr0_sumAB_data_t, fr0_sumAB_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr0_sumAB_data_t_masked, fr0_sumAB_data_f_masked : std_logic_vector(2*SUM_WIDTH-1 downto 0);

	signal sel0_select_in_output_t, sel0_select_in_output_f, sel0_select_in_output_ack : std_logic;

	signal f0_fork_select_in_output_ack : std_logic;

	signal reg0_select_in_output_ack : std_logic;
	signal reg0_select_in_output_t, reg0_select_in_output_f, reg1_select_in_output_ack: std_logic;
	signal reg1_select_in_output_t, reg1_select_in_output_f, m0_inSel_ack : std_logic;

	signal de0_inA_ack : std_logic;
	signal de0_set_result_ack, de0_data_ack : std_logic;
	signal de0_full_result_vector_t, de0_full_result_vector_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de0_data_t, de0_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);

	signal fr1_sumAB_data_t, fr1_sumAB_data_f: std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr1_sumAB_data_masked_t, fr1_sumAB_data_masked_f: std_logic_vector(2*SUM_WIDTH-1 downto 0);
	signal fr1_data_t, fr1_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);

	signal sel1_sum_select_cond_t, sel1_sum_select_cond_f, sel1_sum_select_cond_ack: std_logic;

	signal de2_select_AsumA_BsumB, de2_data_in_ack, de2_A_data_complete, de2_B_data_complete : std_logic;
	signal de2_AsumA_data_t, de2_AsumA_data_f, de2_BsumB_data_t, de2_BsumB_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de2_A_data_t, de2_A_data_f, de2_B_data_t, de2_B_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	
	signal add0_AsumA_ack, add1_BsumB_ack : std_logic;
	signal add0_AsumA_data_t, add0_AsumA_data_f, add1_BsumB_data_t, add1_BsumB_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);

	signal mr0_AsumA_ack, mr0_BsumB_ack : std_logic;
	signal mr0_data_t, mr0_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
  
  -------------------------------------------------------------------

begin
	
	input_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => AB_t,
		data_f => AB_f,
		complete => input_complete
	);
	
	set_input : process(input_complete, rst)
		variable prev_out : std_logic := '0';
	begin
		if (rst = '1' ) then
			inAB_t <= (others => '0');
			inAB_f <= (others => '0');
		else	
			if input_complete = '1' then
				inAB_t(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB_t;
				inAB_t(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '0');
				inAB_t(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB_t(DATA_WIDTH-1 downto SUMMAND_WIDTH);
				inAB_t(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
				inAB_t(SUMMAND_WIDTH -1 downto 0) <= AB_t(SUMMAND_WIDTH-1 downto 0);
				
				inAB_f(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB_f;
				inAB_f(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '1');
				inAB_f(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB_f(DATA_WIDTH-1 downto SUMMAND_WIDTH);
				inAB_f(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '1');
				inAB_f(SUMMAND_WIDTH -1 downto 0) <= AB_f(SUMMAND_WIDTH-1 downto 0);
			else
				inAB_t <= (others => '0');
				inAB_f <= (others => '0');
			end if;
		end if;
	end process set_input;
	
-- Input Multiplexer AB, sumAB
	m0_sum_select: entity work.mux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst             => rst,
		-- Input from channel 1
		inA_data_t      => inAB_t,
		inA_data_f      => inAB_f,
		inA_ack         => ack_out,
		-- Input from channel 2
		inB_data_t      => mr0_data_t,
		inB_data_f      => mr0_data_f,
		inB_ack         => m0_sum_select_inA_ack,
		-- Output port 
		outC_data_t     => m0_sumAB_data_t,
		outC_data_f     => m0_sumAB_data_f,
		outC_ack        => fr0_fork_register_sum_ack,
		-- Select port
		inSel_ack       => m0_inSel_ack,
		selector_t      => reg1_select_in_output_t,
		selector_f      => reg1_select_in_output_f
	);

	fr0_fork_register_sum: entity work.reg_fork
	generic map(
--		INIT_VALUE => 0,
--		INIT_PHASE => '0',
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst 			=> rst,
		--Input channel
		inA_data_t  => m0_sumAB_data_t,
		inA_data_f  => m0_sumAB_data_f,
		inA_ack     => fr0_fork_register_sum_ack,
		--Output channel 1
		outB_data_t => fr0_sumAB_data_t,
		outB_data_f => fr0_sumAB_data_f,
		outB_ack    => sel0_select_in_output_ack,
		--Output channel 2
		outC_data_t => fr0_data_t,
		outC_data_f => fr0_data_f,
		outC_ack    => de0_inA_ack
	);

	fr0_sumAB_data_t_masked <= fr0_sumAB_data_t(2*SUM_WIDTH-1 downto 0);
	fr0_sumAB_data_f_masked <= fr0_sumAB_data_f(2*SUM_WIDTH-1 downto 0);

	sel0_select_in_output: entity work.sel_a_not_b
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
	port map (
		-- Flags
		rst				=> rst,
		ack_in			=> f0_fork_select_in_output_ack,
		ack_out			=> sel0_select_in_output_ack,
		-- Input channel
		in_data_t     	=> fr0_sumAB_data_t_masked,
		in_data_f     	=> fr0_sumAB_data_f_masked,
		-- Output channel
		selector_t    	=> sel0_select_in_output_t,
		selector_f    	=> sel0_select_in_output_f
	);

	-- fork input output selector signal
	f0_fork_select_in_output: entity work.fork
	port map(
		-- Input channel
		inA_ack      => f0_fork_select_in_output_ack,
		-- Output channel 1
		outB_ack     => reg0_select_in_output_ack,
		-- Output channel 2
		outC_ack     => de0_set_result_ack
	);

	reg0_register_input_select_1: entity work.wchb_ncl
	generic map(
		INIT_PHASE	=> '0',
		INIT_VALUE	=> 0,
		DATA_WIDTH	=> 1
	)
	port map (
		-- flags
		rst       => rst,
		ack_in    => reg1_select_in_output_ack,
		ack_out   => reg0_select_in_output_ack,
		-- Input channel
		in_t(0)   => sel0_select_in_output_t,
		in_f(0)   => sel0_select_in_output_f,
		-- Output channel
		out_t(0)  => reg0_select_in_output_t,
		out_f(0)  => reg0_select_in_output_f
	);

	reg1_register_input_select_1: entity work.wchb_ncl
	generic map(
		DATA_WIDTH => 1
	)
	port map (
		-- flags
		rst       => rst,
		ack_in    => m0_inSel_ack,
		ack_out   => reg1_select_in_output_ack,
		-- Input channel
		in_t(0)   => reg0_select_in_output_t,
		in_f(0)   => reg0_select_in_output_f,
		-- Output channel
		out_t(0)  => reg1_select_in_output_t,
		out_f(0)  => reg1_select_in_output_f
	);

	-- switch between forward data to calculation or set as result
	de0_set_result: entity work.demux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst           => rst,
		-- Input port
		inA_data_t    => fr0_data_t,
		inA_data_f    => fr0_data_f,
		inA_ack       => de0_inA_ack,
		-- Select port 
		inSel_ack     => de0_set_result_ack,
		selector_t    => sel0_select_in_output_t,
		selector_f    => sel0_select_in_output_f,
		-- Output channel 1
		outB_data_t   => de0_full_result_vector_t,
		outB_data_f   => de0_full_result_vector_f,
		outB_ack      => ack_in,
		-- Output channel 2
		outC_data_t   => de0_data_t,
		outC_data_f   => de0_data_f,
		outC_ack      => de0_data_ack
	);

	RESULT_t <= de0_full_result_vector_t(DATA_WIDTH-1 downto 0);
	RESULT_f <= de0_full_result_vector_f(DATA_WIDTH-1 downto 0);

	-- fork sumAB for calculation
	fr1_fork_register_calculation_sumAB: entity work.reg_fork
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst 			=> rst,
		--Input channel
		inA_data_t  => de0_data_t,
		inA_data_f  => de0_data_f,
		inA_ack     => de0_data_ack,
		--Output channel 1
		outB_data_t => fr1_sumAB_data_t,
		outB_data_f => fr1_sumAB_data_f,
		outB_ack    => sel1_sum_select_cond_ack,
		--Output channel 2
		outC_data_t => fr1_data_t,
		outC_data_f => fr1_data_f,
		outC_ack    => de2_data_in_ack
	);

	fr1_sumAB_data_masked_t <= fr1_sumAB_data_t(2*SUM_WIDTH-1 downto 0);
	fr1_sumAB_data_masked_f <= fr1_sumAB_data_f(2*SUM_WIDTH-1 downto 0);

	sel1_sum_select_cond: entity work.sel_a_larger_b
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
	port map (
		-- Flags
		rst				=> rst,
		ack_in			=> de2_select_AsumA_BsumB,
		ack_out			=> sel1_sum_select_cond_ack,
		-- Input channel
		in_data_t      => fr1_sumAB_data_masked_t,
		in_data_f      => fr1_sumAB_data_masked_f,
		-- Output channel
		selector_t     => sel1_sum_select_cond_t,
		selector_f     => sel1_sum_select_cond_f
	);

	-- switch between sumA + A and sumB +B
	de2_set_AsumA_BsumB: entity work.demux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst           => rst,
		-- Input port
		inA_data_t    => fr1_data_t,
		inA_data_f    => fr1_data_f,
		inA_ack       => de2_data_in_ack,
		-- Select port 
		inSel_ack     => de2_select_AsumA_BsumB,
		selector_t    => sel1_sum_select_cond_t,
		selector_f    => sel1_sum_select_cond_f,
		-- Output channel 1
		outB_data_t   => de2_AsumA_data_t,
		outB_data_f   => de2_AsumA_data_f,
		outB_ack      => add0_AsumA_ack,
		-- Output channel 2
		outC_data_t   => de2_BsumB_data_t,
		outC_data_f   => de2_BsumB_data_f,
		outC_ack      => add1_BsumB_ack
		);

-- sumA + A
	de2_A_data_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map(
		rst => rst,
		data_t => de2_AsumA_data_t,
		data_f => de2_AsumA_data_f,
		complete => de2_A_data_complete
	);
	
	add0_prepare : process(de2_A_data_complete, rst)
		variable prev_out : std_logic := '0';
	begin
		if (rst = '1' ) then
			de2_A_data_t <= (others => '0');
			de2_A_data_f <= (others => '0');
		else	
			if de2_A_data_complete = '1' then
				de2_A_data_t(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '0');
				de2_A_data_t(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de2_AsumA_data_t(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
				de2_A_data_t(SUM_WIDTH - 1 downto 0) <= (others => '0');
				
				de2_A_data_f(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '1');
				de2_A_data_f(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de2_AsumA_data_f(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
				de2_A_data_f(SUM_WIDTH - 1 downto 0) <= (others => '1');
			else
				de2_A_data_t <= (others => '0');
				de2_A_data_f <= (others => '0');
			end if;
		end if;
	end process add0_prepare;
	
	add0_A_sumA: entity work.add_block
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		-- flags
		rst			=> rst,
		ack_in    	=> mr0_AsumA_ack,
		ack_out		=> add0_AsumA_ack,
		-- Input channel
		inA_data_t  => de2_AsumA_data_t,
		inA_data_f  => de2_AsumA_data_f,
		inB_data_t  => de2_A_data_t,
		inB_data_f  => de2_A_data_f,
		-- Output channel
		outC_data_t => add0_AsumA_data_t,
		outC_data_f => add0_AsumA_data_f
	);

-- sumB + B
	
	de2_B_data_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map(
		rst => rst,
		data_t => de2_BsumB_data_t,
		data_f => de2_BsumB_data_f,
		complete => de2_B_data_complete
	);
	
	add1_prepare : process(de2_B_data_complete, rst)
		variable prev_out : std_logic := '0';
	begin
		if (rst = '1' ) then
			de2_B_data_t <= (others => '0');
			de2_B_data_f <= (others => '0');
		else	
			if de2_B_data_complete = '1' then
				
				de2_B_data_t(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
				de2_B_data_t(SUMMAND_WIDTH -1 downto 0) <= de2_BsumB_data_t(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);
				
				de2_B_data_f(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '1');
				de2_B_data_f(SUMMAND_WIDTH -1 downto 0) <= de2_BsumB_data_f(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);
			else
				de2_B_data_t <= (others => '0');
				de2_B_data_f <= (others => '0');
			end if;
		end if;
	end process add1_prepare;
	
	add1_B_sumB: entity work.add_block
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		-- flags
		rst			=> rst,
		ack_in    	=> mr0_BsumB_ack,
		ack_out		=> add1_BsumB_ack,
		-- Input channel
		inA_data_t  => de2_BsumB_data_t,
		inA_data_f  => de2_BsumB_data_f,
		inB_data_t  => de2_B_data_t,
		inB_data_f  => de2_B_data_f,
		-- Output channel
		outC_data_t => add1_BsumB_data_t,
		outC_data_f => add1_BsumB_data_f
	);
	
-- merge sumA sumB again
	mr0_merge_sums: entity work.reg_merge
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst   		=> rst,
		--Input channel 1
		inA_ack   	=> mr0_AsumA_ack,
		inA_data_t	=> add0_AsumA_data_t,
		inA_data_f	=> add0_AsumA_data_f,
		-- Input channel 2
		inB_ack   	=> mr0_BsumB_ack,
		inB_data_t	=> add1_BsumB_data_t,
		inB_data_f  => add1_BsumB_data_f,
		-- Output channel
		outC_ack  	=> m0_sum_select_inA_ack,
		outC_data_t => mr0_data_t,
		outC_data_f => mr0_data_f
	);

end STRUCTURE;
