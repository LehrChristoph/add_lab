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
		AB_t 			: in std_logic_vector ( DATA_WIDTH-1 downto 0 );
		AB_f 			: in std_logic_vector ( DATA_WIDTH-1 downto 0 );
		RESULT_t 	: out std_logic_vector ( DATA_WIDTH-1 downto 0 );
		RESULT_f 	: out std_logic_vector ( DATA_WIDTH-1 downto 0 );
		rst   		: in std_logic;
		ack_result	: in std_logic;
		ack_input   : out std_logic
	);
end lcm;

architecture STRUCTURE of lcm is
	constant DATA_PATH_WIDTH : Integer := 3*DATA_WIDTH;
	constant SUM_WIDTH : Integer := DATA_WIDTH;
	constant SUMMAND_WIDTH : Integer := DATA_WIDTH/2;

	constant all_zeros_dpw : std_logic_vector(DATA_PATH_WIDTH-1 downto 0) := (others => '0');
	constant all_zeros_dw : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

	signal inAB_t, inAB_f  : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);

	signal m1_data_t, m1_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal m1_selector_ack, m1_inB_ack : std_logic;
	
	signal fr1_inA_ack : std_logic;
	signal fr1_addition_selector_data_t, fr1_addition_selector_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr1_addition_selector_sumAB_t, fr1_addition_selector_sumAB_f : std_logic_vector(2*SUM_WIDTH-1 downto 0);
	
	signal cmp1_ack, cmp1_a_larger_b_t, cmp1_a_larger_b_f : std_logic;
	signal de1_set_AsumA_BsumB_selector_ack : std_logic;
	
	signal fr1_data_t, fr1_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de1_inA_ack : std_logic;
	
	signal de1_AsumA_data_t, de1_AsumA_data_f, de1_A_data_t, de1_A_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal add1_A_sumA_ack : std_logic;
	signal add1_AsumA_data_t, add1_AsumA_data_f: std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	
	signal de1_BsumB_data_t, de1_BsumB_data_f, de1_B_data_t, de1_B_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal add2_B_sumB_ack : std_logic;
	signal add2_BsumB_data_t, add2_BsumB_data_f: std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	
	signal mrg1_AsumA_ack, mrg1_BsumB_ack : std_logic;
	signal mrg1_data_t, mrg1_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	
	signal fr2_outB_data_t, fr2_outB_data_f, fr2_outC_data_t, fr2_outC_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr2_sumA_not_sumB_t, fr2_sumA_not_sumB_f : std_logic_vector(2*SUM_WIDTH-1 downto 0);
	signal fr2_inA_ack : std_logic;
	
	signal cmp2_sumA_not_sumB_t, cmp2_sumA_not_sumB_f : std_logic;
	signal cmp2_ack : std_logic;
	
	signal de2_full_result_vector_t, de2_full_result_vector_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de2_outC_data_t, de2_outC_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de2_inA_ack, de2_selector_ack : std_logic;
	
	signal f1_ack : std_logic;
	
	signal r1_selector_sumA_not_sumB_t, r1_selector_sumA_not_sumB_f : std_logic ;
	signal r1_ack : std_logic;
	
	signal r2_data_t, r2_data_f : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal r2_ack : std_logic;
	
  -------------------------------------------------------------------

begin
	
	set_input : process(rst, AB_t, AB_f)
		variable phase_f : std_logic := '0';
	begin
		if (rst = '1' ) then
			inAB_t <= (others => '0');
			inAB_f <= (others => '0');
		else	
			phase_f := AB_t(0) or AB_f(0);
			
			inAB_t(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB_t;
			inAB_t(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '0');
			inAB_t(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB_t(DATA_WIDTH-1 downto SUMMAND_WIDTH);
			inAB_t(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
			inAB_t(SUMMAND_WIDTH -1 downto 0) <= AB_t(SUMMAND_WIDTH-1 downto 0);
			
			inAB_f(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB_f;
			inAB_f(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => phase_f);
			inAB_f(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB_f(DATA_WIDTH-1 downto SUMMAND_WIDTH);
			inAB_f(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => phase_f);
			inAB_f(SUMMAND_WIDTH -1 downto 0) <= AB_f(SUMMAND_WIDTH-1 downto 0);
				
--			if all_zeros_dw = AB_t and all_zeros_dw = AB_f then
--				inAB_t <= (others => '0');
--				inAB_f <= (others => '0');
--			else
--				inAB_t(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB_t;
--				inAB_t(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '0');
--				inAB_t(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB_t(DATA_WIDTH-1 downto SUMMAND_WIDTH);
--				inAB_t(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
--				inAB_t(SUMMAND_WIDTH -1 downto 0) <= AB_t(SUMMAND_WIDTH-1 downto 0);
--				
--				inAB_f(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB_f;
--				inAB_f(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '1');
--				inAB_f(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB_f(DATA_WIDTH-1 downto SUMMAND_WIDTH);
--				inAB_f(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '1');
--				inAB_f(SUMMAND_WIDTH -1 downto 0) <= AB_f(SUMMAND_WIDTH-1 downto 0);
--			end if;
		end if;
	end process set_input;
	
-- Input Multiplexer AB, sumAB
	m1_state_select: entity work.mux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst             => rst,
		-- Input from channel 1
		inA_data_t      => inAB_t,
		inA_data_f      => inAB_f,
		inA_ack         => ack_input,
		-- Input from channel 2
		inB_data_t      => r2_data_t,
		inB_data_f      => r2_data_f,
		inB_ack         => m1_inB_ack,
		-- Output port 
		outC_data_t     => m1_data_t,
		outC_data_f     => m1_data_f,
		outC_ack        => fr1_inA_ack,
		-- Select port
		inSel_ack       => m1_selector_ack,
		selector_t      => r1_selector_sumA_not_sumB_t,
		selector_f      => r1_selector_sumA_not_sumB_f
	);

	fr1_fork_register_current_state: entity work.reg_fork
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst 			=> rst,
		--Input channel
		inA_data_t  => m1_data_t,
		inA_data_f  => m1_data_f,
		inA_ack     => fr1_inA_ack,
		--Output channel 1
		outB_data_t => fr1_addition_selector_data_t,
		outB_data_f => fr1_addition_selector_data_f,
		outB_ack    => cmp1_ack,
		--Output channel 2
		outC_data_t => fr1_data_t,
		outC_data_f => fr1_data_f,
		outC_ack    => de1_inA_ack
	);

	fr1_addition_selector_sumAB_t <= fr1_addition_selector_data_t(2*SUM_WIDTH-1 downto 0);
	fr1_addition_selector_sumAB_f <= fr1_addition_selector_data_f(2*SUM_WIDTH-1 downto 0);

	cmp1_sum_select_cond: entity work.sel_a_larger_b
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
	port map (
		-- Flags
		rst				=> rst,
		ack_in			=> de1_set_AsumA_BsumB_selector_ack,
		ack_out			=> cmp1_ack,
		-- Input channel
		in_data_t      => fr1_addition_selector_sumAB_t,
		in_data_f      => fr1_addition_selector_sumAB_f,
		-- Output channel
		selector_t     => cmp1_a_larger_b_t,
		selector_f     => cmp1_a_larger_b_f
	);

	-- switch between sumA + A and sumB +B
	de1_set_AsumA_BsumB: entity work.demux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst           => rst,
		-- Input port
		inA_data_t    => fr1_data_t,
		inA_data_f    => fr1_data_f,
		inA_ack       => de1_inA_ack,
		-- Select port 
		inSel_ack     => de1_set_AsumA_BsumB_selector_ack,
		selector_t    => cmp1_a_larger_b_t,
		selector_f    => cmp1_a_larger_b_f,
		-- Output channel 1
		outB_data_t   => de1_AsumA_data_t,
		outB_data_f   => de1_AsumA_data_f,
		outB_ack      => add1_A_sumA_ack,
		-- Output channel 2
		outC_data_t   => de1_BsumB_data_t,
		outC_data_f   => de1_BsumB_data_f,
		outC_ack      => add2_B_sumB_ack
		);

-- sumA + A	
	add0_prepare : process(rst,de1_AsumA_data_t, de1_AsumA_data_f)
		variable phase_f : std_logic := '0';
	begin
		if (rst = '1' ) then
			 de1_A_data_t <= (others => '0');
			 de1_A_data_f <= (others => '0');
		else	
			phase_f := de1_AsumA_data_t(0) or de1_AsumA_data_f(0);
			
			de1_A_data_t(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '0');
			de1_A_data_t(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de1_AsumA_data_t(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
			de1_A_data_t(SUM_WIDTH - 1 downto 0) <= (others => '0');
			
			de1_A_data_f(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => phase_f);
			de1_A_data_f(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de1_AsumA_data_f(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
			de1_A_data_f(SUM_WIDTH - 1 downto 0) <= (others => phase_f);
			
--			if all_zeros_dpw = de1_AsumA_data_t and de1_AsumA_data_f = all_zeros_dpw then
--				de1_A_data_t <= (others => '0');
--				de1_A_data_f <= (others => '0');
--			else
--				de1_A_data_t(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '0');
--				de1_A_data_t(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de1_AsumA_data_t(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
--				de1_A_data_t(SUM_WIDTH - 1 downto 0) <= (others => '0');
--				
--				de1_A_data_f(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '1');
--				de1_A_data_f(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de1_AsumA_data_f(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
--				de1_A_data_f(SUM_WIDTH - 1 downto 0) <= (others => '1');
--			end if;
		end if;
	end process add0_prepare;
	
	add1_A_sumA: entity work.add_block
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		-- flags
		rst			=> rst,
		ack_in    	=> mrg1_AsumA_ack,
		ack_out		=> add1_A_sumA_ack,
		-- Input channel
		inA_data_t  => de1_AsumA_data_t,
		inA_data_f  => de1_AsumA_data_f,
		inB_data_t  => de1_A_data_t,
		inB_data_f  => de1_A_data_f,
		-- Output channel
		outC_data_t => add1_AsumA_data_t,
		outC_data_f => add1_AsumA_data_f
	);

	
-- sumB + B
	add1_prepare : process(rst,de1_BsumB_data_t, de1_BsumB_data_f)
		variable phase_f : std_logic := '0';
	begin
		if (rst = '1' ) then
			 de1_B_data_t <= (others => '0');
			 de1_B_data_f<= (others => '0');
		else	
			phase_f := de1_BsumB_data_t(0) or de1_BsumB_data_f(0);
			
			de1_B_data_t(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
			de1_B_data_t(SUMMAND_WIDTH -1 downto 0) <= de1_BsumB_data_t(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);
			
			de1_B_data_f(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => phase_f);
			de1_B_data_f(SUMMAND_WIDTH -1 downto 0) <= de1_BsumB_data_f(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);
				
--			if all_zeros_dpw = de1_BsumB_data_t and all_zeros_dpw = de1_BsumB_data_f then
--				de1_B_data_t <= (others => '0');
--				de1_B_data_f <= (others => '0');
--			else
--				de1_B_data_t(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
--				de1_B_data_t(SUMMAND_WIDTH -1 downto 0) <= de1_BsumB_data_t(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);
--				
--				de1_B_data_f(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '1');
--				de1_B_data_f(SUMMAND_WIDTH -1 downto 0) <= de1_BsumB_data_f(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);
--			end if;
		end if;
	end process add1_prepare;
	
	add1_B_sumB: entity work.add_block
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		-- flags
		rst			=> rst,
		ack_in    	=> mrg1_BsumB_ack,
		ack_out		=> add2_B_sumB_ack,
		-- Input channel
		inA_data_t  => de1_BsumB_data_t,
		inA_data_f  => de1_BsumB_data_f,
		inB_data_t  => de1_B_data_t,
		inB_data_f  => de1_B_data_f,
		-- Output channel
		outC_data_t => add2_BsumB_data_t,
		outC_data_f => add2_BsumB_data_f
	);
	
-- merge sumA sumB again
	mrg1_merge_sums: entity work.reg_merge
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst   		=> rst,
		--Input channel 1
		inA_ack   	=> mrg1_AsumA_ack,
		inA_data_t	=> add1_AsumA_data_t,
		inA_data_f	=> add1_AsumA_data_f,
		-- Input channel 2
		inB_ack   	=> mrg1_BsumB_ack,
		inB_data_t	=> add2_BsumB_data_t,
		inB_data_f  => add2_BsumB_data_f,
		-- Output channel
		outC_ack  	=> fr2_inA_ack,
		outC_data_t => mrg1_data_t,
		outC_data_f => mrg1_data_f
	);
	
	-- fork input output selector signal
	fr2_fork_add_result: entity work.reg_fork
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map(
		rst   		=> rst,
		--Input channel
		inA_data_t  => mrg1_data_t,
		inA_data_f  => mrg1_data_f,
		inA_ack     => fr2_inA_ack,
		--Output channel 1
		outB_data_t => fr2_outB_data_t,
		outB_data_f => fr2_outB_data_f,
		outB_ack    => cmp2_ack,
		--Output channel 2
		outC_data_t => fr2_outC_data_t,
		outC_data_f => fr2_outC_data_f,
		outC_ack    => de2_inA_ack
	);
	
	
	fr2_sumA_not_sumB_t <= fr2_outB_data_t(2*SUM_WIDTH-1 downto 0);
	fr2_sumA_not_sumB_f <= fr2_outB_data_f(2*SUM_WIDTH-1 downto 0);

	cmp2_select_in_output: entity work.sel_a_not_b
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
	port map (
		-- Flags
		rst				=> rst,
		ack_in			=> f1_ack,
		ack_out			=> cmp2_ack,
		-- Input channel
		in_data_t     	=> fr2_sumA_not_sumB_t,
		in_data_f     	=> fr2_sumA_not_sumB_f,
		-- Output channel
		selector_t    	=> cmp2_sumA_not_sumB_t,
		selector_f    	=> cmp2_sumA_not_sumB_f
	);

	-- fork input output selector signal
	f1_fork_select_in_output: entity work.fork
	port map(
		-- Input channel
		inA_ack      => f1_ack,
		-- Output channel 1
		outB_ack     => r1_ack,
		-- Output channel 2
		outC_ack     => de2_selector_ack
	);

	r1_register_input_select_1: entity work.wchb_ncl
	generic map(
		INIT_PHASE	=> '0',
		INIT_VALUE	=> 0,
		DATA_WIDTH	=> 1
	)
	port map (
		-- flags
		rst       => rst,
		ack_in    => m1_selector_ack,
		ack_out   => r1_ack,
		-- Input channel
		in_t(0)   => cmp2_sumA_not_sumB_t,
		in_f(0)   => cmp2_sumA_not_sumB_f,
		-- Output channel
		out_t(0)  => r1_selector_sumA_not_sumB_t,
		out_f(0)  => r1_selector_sumA_not_sumB_f
	);

	-- switch between forward data to calculation or set as result
	de2_set_result: entity work.demux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		rst           => rst,
		-- Input port
		inA_data_t    => fr2_outC_data_t,
		inA_data_f    => fr2_outC_data_f,
		inA_ack       => de2_inA_ack,
		-- Select port 
		inSel_ack     => de2_selector_ack,
		selector_t    => cmp2_sumA_not_sumB_t,
		selector_f    => cmp2_sumA_not_sumB_f,
		-- Output channel 1
		outB_data_t   => de2_full_result_vector_t,
		outB_data_f   => de2_full_result_vector_f,
		outB_ack      => ack_result,
		-- Output channel 2
		outC_data_t   => de2_outC_data_t,
		outC_data_f   => de2_outC_data_f,
		outC_ack      => r2_ack
	);

	RESULT_t <= de2_full_result_vector_t(DATA_WIDTH-1 downto 0);
	RESULT_f <= de2_full_result_vector_f(DATA_WIDTH-1 downto 0);
	
	r2_register_input_select_1: entity work.wchb_ncl
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		-- flags
		rst       => rst,
		ack_in    => m1_inB_ack,
		ack_out   => r2_ack,
		-- Input channel
		in_t      => de2_outC_data_t,
		in_f      => de2_outC_data_f,
		-- Output channel
		out_t     => r2_data_t,
		out_f     => r2_data_f
	);


	

end STRUCTURE;
