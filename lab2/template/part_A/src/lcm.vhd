----------------------------------------------------------------------------------
-- lcm Implementation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity lcm is
	generic ( DATA_WIDTH : natural := DATA_WIDTH);
	port (
		AB : in std_logic_vector ( DATA_WIDTH-1 downto 0 );
		RESULT : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
		rst : in std_logic;
		i_req:  in std_logic;
		i_ack:  out std_logic;
		o_req: out std_logic;
		o_ack: in std_logic
	);
end lcm;

architecture STRUCTURE of lcm is

  component fork is 
  port(
    rst          : in std_logic;
    -- Input channel
    inA_req      : in std_logic;
    inA_ack      : out std_logic;
    -- Output channel 1
    outB_req     : out std_logic;
    outB_ack     : in std_logic;
    -- Output channel 2
    outC_req     : out std_logic;
    outC_ack     : in std_logic
  );
  end component fork;
  
  component mux is
  generic(DATA_WIDTH      : natural := DATA_WIDTH;
     PHASE_INIT_C : std_logic := '0';
     PHASE_INIT_A   : std_logic := '0';
     PHASE_INIT_B   : std_logic := '0';
     PHASE_INIT_SEL : std_logic := '0');
  port (
    rst : in STD_LOGIC;
    inA_req : in STD_LOGIC;
    inA_data : in STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    inA_ack : out STD_LOGIC;
    inB_req : in STD_LOGIC;
    inB_data : in STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    inB_ack : out STD_LOGIC;
    outC_req : out STD_LOGIC;
    outC_data : out STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outC_ack : in STD_LOGIC;
    inSel_req : in STD_LOGIC;
    inSel_ack : out STD_LOGIC;
    selector : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component mux;

  component reg_fork is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port (
    rst : in STD_LOGIC;
    inA_req : in STD_LOGIC;
    inA_data : in STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    inA_ack : out STD_LOGIC;
    outB_req : out STD_LOGIC;
    outB_data : out STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outB_ack : in STD_LOGIC;
    outC_req : out STD_LOGIC;
    outC_data : out STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outC_ack : in STD_LOGIC
  );
  end component reg_fork;
  
  component sel_a_larger_b is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port(
    -- Data
    in_data       : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    in_req        : in  std_logic;
    in_ack        : out std_logic;
    -- Selector
    selector      : out std_logic;
    out_req       : out std_logic;
    out_ack       : in  std_logic
  );
  end component sel_a_larger_b;
  
  component sel_a_not_b is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port(
    -- Input channel
    in_data     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    in_req      : in  std_logic;
    in_ack      : out std_logic;
    -- Output channel
    selector    : out std_logic;
    out_req     : out std_logic;
    out_ack     : in  std_logic
    );
  end component sel_a_not_b;
  
  component demux is
  generic(
		DATA_WIDTH    : natural := DATA_WIDTH;
		PHASE_INIT_A  : std_logic := '0';
		PHASE_INIT_B  : std_logic := '0';
		PHASE_INIT_C  : std_logic := '0'
	);
  port (
    rst : in STD_LOGIC;
    inA_req : in STD_LOGIC;
    inA_data : in STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    inA_ack : out STD_LOGIC;
    inSel_req : in STD_LOGIC;
    inSel_ack : out STD_LOGIC;
    selector : in STD_LOGIC;
    outB_req : out STD_LOGIC;
    outB_data : out STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outB_ack : in STD_LOGIC;
    outC_req : out STD_LOGIC;
    outC_data : out STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outC_ack : in STD_LOGIC
  );
  end component demux;
  
  component merge is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port (
    rst : in STD_LOGIC;
    inA_req : in STD_LOGIC;
    inA_ack : out STD_LOGIC;
    inA_data : in STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    inB_req : in STD_LOGIC;
    inB_ack : out STD_LOGIC;
    inB_data : in STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outC_req : out STD_LOGIC;
    outC_data : out STD_LOGIC_VECTOR ( DATA_WIDTH-1 downto 0 );
    outC_ack : in STD_LOGIC
  );
  end component merge;
  
	component reg_merge is
		generic(
			DATA_WIDTH : natural := DATA_WIDTH;
			PHASE_INIT_C  : std_logic := '0';
			PHASE_INIT_A        : std_logic := '0';
			PHASE_INIT_B        : std_logic := '0');
		port (rst   : in std_logic;
			--Input channel 1
			inA_req   : in std_logic;
			inA_ack   : out std_logic;
			inA_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
			-- Input channel 2
			inB_req   : in std_logic;
			inB_ack   : out std_logic;
			inB_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
			-- Output channel
			outC_req  : out std_logic;
			outC_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
			outC_ack  : in std_logic
	  );
	end component reg_merge;

  component add_block is
	  generic ( 
			DATA_WIDTH: natural := DATA_WIDTH);
	  port (-- Input channel
		 in_req    : in std_logic;
		 in_ack    : out std_logic;
		 -- Output channel
		 out_req   : out std_logic;
		 out_ack   : in std_logic;
		 inA_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		 inB_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		 outC_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
		 );
	end component add_block;
	
	component join is
	  port (
		 rst         : in std_logic;
		 --UPSTREAM channels
		 inA_req     : in std_logic;
		 inA_ack     : out std_logic;
		 inB_req     : in std_logic;
		 inB_ack     : out std_logic;
		 --DOWNSTREAM channel
		 outC_req    : out std_logic;
		 outC_ack    : in std_logic);
	end component join;
	
	constant DATA_PATH_WIDTH : Integer := 3*DATA_WIDTH;
	constant SUM_WIDTH : Integer := DATA_WIDTH;
	constant SUMMAND_WIDTH : Integer := DATA_WIDTH/2;
	
	signal inAB  : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
 
	signal m1_sumAB_data : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal m1_sumAB_o_ack, m1_sumAB_o_req: std_logic;
	
	signal fr1_sumAB_select_data : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr1_sumAB_select_data_masked : std_logic_vector(2*SUM_WIDTH-1 downto 0);
	signal fr1_sumAB_select_o_ack, fr1_sumAB_select_o_req: std_logic;
	
	signal fr1_sumAB_data : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr1_sumAB_o_ack, fr1_sumAB_o_req: std_logic;
	
	signal sel0_sumNotEq_data, sel0_sumNotEq_o_ack, sel0_sumNotEq_o_req: std_logic;
	
	signal f1_select_input_o_ack, f1_select_input_o_req, f1_select_output_o_ack, f1_select_output_o_req: std_logic;
	
	signal reg0_sumNotEq_data, reg0_sumNotEq_o_ack, reg0_sumNotEq_o_req: std_logic;
	signal reg1_sumNotEq_data, reg1_sumNotEq_o_ack, reg1_sumNotEq_o_req: std_logic;
	
	signal de0_sumAB_data, de0_full_result_vector : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de0_sumAB_o_ack, de0_sumAB_o_req: std_logic;
	
	signal fr2_sumAB_data, fr2_sumAB_select_data : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal fr2_sumAB_select_data_masked : std_logic_vector(2*SUM_WIDTH-1 downto 0); 
	signal fr2_sumAB_o_ack, fr2_sumAB_o_req, fr2_sumAB_select_o_ack, fr2_sumAB_select_o_req: std_logic;
	
	signal sel1_sumAGreaterSumB_data, sel1_sumAGreaterSumB_o_ack, sel1_sumAGreaterSumB_o_req: std_logic;
	
	signal de2_sumA_data, de2_sumB_data,de2_sumA_data_masked, de2_sumB_data_masked : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal de2_sumA_o_ack, de2_sumA_o_req, de2_sumB_o_ack, de2_sumB_o_req: std_logic;
	
	signal add0_AsumA_data, add1_BsumB_data : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal add0_AsumA_o_ack, add0_AsumA_o_req, add1_BsumB_o_ack, add1_BsumB_o_req: std_logic;
	
	signal mr0_sumAB_data : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal mr0_sumAB_o_ack, mr0_sumAB_o_req: std_logic;
	
	
  -------------------------------------------------------------------

begin

inAB(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= AB;
inAB(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '0');
inAB(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= AB(DATA_WIDTH-1 downto SUMMAND_WIDTH);
inAB(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
inAB(SUMMAND_WIDTH -1 downto 0) <= AB(SUMMAND_WIDTH-1 downto 0);

-- Input Multiplexer AB, sumAB
m1_sum_select: component mux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH,
		PHASE_INIT_SEL => '0'
	)
   port map (
    inA_ack => i_ack,
    inA_data => inAB,
    inA_req => i_req,
    inB_ack => mr0_sumAB_o_ack,
    inB_data => mr0_sumAB_data,
    inB_req => mr0_sumAB_o_req,
    outC_ack => m1_sumAB_o_ack,
    outC_data => m1_sumAB_data,
    outC_req => m1_sumAB_o_req,
    rst => rst,
    inSel_ack => reg1_sumNotEq_o_ack,
    inSel_req => reg1_sumNotEq_o_req,
    selector(0) => reg1_sumNotEq_data
  );
	 
fr1_fork_register_sum: entity work.reg_fork
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH,
		PHASE_INIT_A => '0',
		PHASE_INIT_B =>'0',
		PHASE_INIT_C => '0'
	)
   port map (
    inA_ack => m1_sumAB_o_ack,
    inA_data => m1_sumAB_data,
    inA_req => m1_sumAB_o_req,
    outB_ack => fr1_sumAB_o_ack,
    outB_data => fr1_sumAB_data,
    outB_req => fr1_sumAB_o_req,
    outC_ack => fr1_sumAB_select_o_ack,
    outC_data=> fr1_sumAB_select_data,
    outC_req => fr1_sumAB_select_o_req,
    rst => rst
  ); 
  
fr1_sumAB_select_data_masked <= fr1_sumAB_select_data(2*SUM_WIDTH-1 downto 0);

sel0_select_in_output: component sel_a_not_b
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
   port map (
    in_ack => fr1_sumAB_select_o_ack,
    in_data => fr1_sumAB_select_data_masked,
    in_req => fr1_sumAB_select_o_req,
    out_ack => sel0_sumNotEq_o_ack,
    out_req => sel0_sumNotEq_o_req,
    selector => sel0_sumNotEq_data 
  );
  
-- fork input output selector signal
f1_fork_select_in_output: component fork
  port map(rst => rst,
    inA_req => sel0_sumNotEq_o_req,
    inA_ack => sel0_sumNotEq_o_ack,
    outB_req => f1_select_input_o_req,
    outB_ack => f1_select_input_o_ack,
    outC_req => f1_select_output_o_req,
    outC_ack => f1_select_output_o_ack
);

reg0_register_input_select_1: entity work.decoupled_hs_reg
   generic map(
    DATA_WIDTH=> 1,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
   )
   port map (
    rst => rst,
    in_ack => f1_select_input_o_ack,
    in_req => f1_select_input_o_req,
    in_data(0)=> sel0_sumNotEq_data,
    -- Output channel
    out_req => reg0_sumNotEq_o_req,
    out_data(0)=> reg0_sumNotEq_data,
    out_ack => reg0_sumNotEq_o_ack
  );

reg1_register_input_select_2: entity work.decoupled_hs_reg
   generic map(
    DATA_WIDTH=> 1,
    VALUE => 1,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '1'
   )
   port map (
    rst => rst,
    in_ack => reg0_sumNotEq_o_ack,
    in_req => reg0_sumNotEq_o_req,
    in_data(0)=> reg0_sumNotEq_data,
    -- Output channel
    out_req => reg1_sumNotEq_o_req,
    out_data(0)=> reg1_sumNotEq_data,
    out_ack => reg1_sumNotEq_o_ack
  );
   
-- switch between forward data to calculation or set as result
de0_set_result: component demux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map (
    inA_ack => fr1_sumAB_o_ack,
    inA_data => fr1_sumAB_data,
    inA_req => fr1_sumAB_o_req,
    outB_ack => o_ack,
    outB_data => de0_full_result_vector,
    outB_req => o_req,
    outC_ack => de0_sumAB_o_ack,
    outC_data => de0_sumAB_data,
    outC_req => de0_sumAB_o_req,
    rst => rst,
    inSel_ack => f1_select_output_o_ack,
    inSel_req => f1_select_output_o_req,
    selector => sel0_sumNotEq_data
);

RESULT <= de0_full_result_vector(DATA_WIDTH-1 downto 0);

-- fork sumAB for calculation
fr2_fork_register_calculation_sumAB: entity work.reg_fork
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH,
		PHASE_INIT_A => '0',
		PHASE_INIT_B =>'0',
		PHASE_INIT_C => '0'
	)
	port map (
		inA_ack => de0_sumAB_o_ack,
		inA_data => de0_sumAB_data,
		inA_req => de0_sumAB_o_req,
		outB_ack => fr2_sumAB_o_ack,
		outB_data => fr2_sumAB_data,
		outB_req => fr2_sumAB_o_req,
		outC_ack => fr2_sumAB_select_o_ack,
		outC_data=> fr2_sumAB_select_data,
		outC_req => fr2_sumAB_select_o_req,
		rst => rst
	); 

fr2_sumAB_select_data_masked <= fr2_sumAB_select_data(2*SUM_WIDTH-1 downto 0);

sel1_sum_select_cond: component sel_a_larger_b
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
   port map (
    in_ack => fr2_sumAB_select_o_ack,
    in_data=> fr2_sumAB_select_data_masked,
    in_req => fr2_sumAB_select_o_req,
    out_ack => sel1_sumAGreaterSumB_o_ack,
    out_req => sel1_sumAGreaterSumB_o_req,
    selector => sel1_sumAGreaterSumB_data
  );
  
-- switch between sumA + A and sumB +B
de2_set_sumA: component demux
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map (
    inA_ack => fr2_sumAB_o_ack,
    inA_data => fr2_sumAB_data,
    inA_req => fr2_sumAB_o_req,
    outB_ack => de2_sumA_o_ack,
    outB_data => de2_sumA_data,
    outB_req => de2_sumA_o_req,
    outC_ack => de2_sumB_o_ack,
    outC_data => de2_sumB_data,
    outC_req => de2_sumB_o_req,
    rst => rst,
    inSel_ack => sel1_sumAGreaterSumB_o_ack,
    inSel_req => sel1_sumAGreaterSumB_o_req,
    selector => not sel1_sumAGreaterSumB_data
);

-- sumA + A 
de2_sumA_data_masked(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '0');
de2_sumA_data_masked(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de2_sumA_data(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
de2_sumA_data_masked(SUM_WIDTH - 1 downto 0) <= (others => '0');

add0_A_sumA: component add_block 
	  generic map(
			DATA_WIDTH => DATA_PATH_WIDTH
	  )
	  port map (
	    -- Input channel
		 in_req => de2_sumA_o_req,
		 in_ack => de2_sumA_o_ack,
		 inA_data  => de2_sumA_data,
		 inB_data => de2_sumA_data_masked,
		 -- Output channel
		 out_req => add0_AsumA_o_req,
		 out_ack  => add0_AsumA_o_ack,
		 outC_data  => add0_AsumA_data
		 );

-- sumB + B
de2_sumB_data_masked(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
de2_sumB_data_masked(SUMMAND_WIDTH -1 downto 0) <= de2_sumB_data(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);

add1_B_sumB: component add_block 
		generic map(
			DATA_WIDTH => DATA_PATH_WIDTH
		)
		port map (
			-- Input channel
			in_req => de2_sumB_o_req,
			in_ack => de2_sumB_o_ack,
			inA_data => de2_sumB_data,
			inB_data => de2_sumB_data_masked,
			-- Output channel
			out_req => add1_BsumB_o_req,
			out_ack  => add1_BsumB_o_ack,
			outC_data  => add1_BsumB_data
		);

-- merge sumA sumB again
mr0_merge_sums: component reg_merge
	generic map(
			DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map (
    inA_ack => add0_AsumA_o_ack,
    inA_data=> add0_AsumA_data,
    inA_req => add0_AsumA_o_req,
    inB_ack => add1_BsumB_o_ack,
    inB_data => add1_BsumB_data,
    inB_req => add1_BsumB_o_req,
    outC_ack => mr0_sumAB_o_ack,
    outC_data => mr0_sumAB_data,
    outC_req => mr0_sumAB_o_req,
    rst => rst
  );

end STRUCTURE;
