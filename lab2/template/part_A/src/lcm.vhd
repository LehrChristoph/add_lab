----------------------------------------------------------------------------------
-- lcm Implementation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity lcm is
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
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
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
	
	signal f0_AB_o_ack, f0_AB_o_req: std_logic;
	signal f0_sumAB_o_ack, f0_sumAB_o_req: std_logic;
  
	signal m0_AB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal m0_AB_o_ack, m0_AB_o_req: std_logic;
	
	signal fr0_AB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal fr0_AB_o_ack, fr0_AB_o_req: std_logic;
 
	signal m1_sumAB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal m1_sumAB_o_ack, m1_sumAB_o_req: std_logic;
	
	signal fr1_sumAB_select_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal fr1_sumAB_select_o_ack, fr1_sumAB_select_o_req: std_logic;
	
	signal fr1_sumAB_data,fr1_summand_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal fr1_sumAB_o_ack, fr1_sumAB_o_req, fr1_summand_o_ack, fr1_summand_o_req: std_logic;
	
	signal sel0_sumNotEq_data, sel0_sumNotEq_o_ack, sel0_sumNotEq_o_req: std_logic;
	
	signal f1_select_input_o_ack, f1_select_input_o_req, f1_select_output_o_ack, f1_select_output_o_req: std_logic;
	
	signal reg0_sumNotEq_data, reg0_sumNotEq_o_ack, reg0_sumNotEq_o_req: std_logic;
	signal reg1_sumNotEq_data, reg1_sumNotEq_o_ack, reg1_sumNotEq_o_req: std_logic;
	
	signal f2_select_input_AB_o_ack, f2_select_input_AB_o_req, f2_select_input_sumAB_o_ack, f2_select_input_sumAB_o_req: std_logic;
	
	signal de0_sumAB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal de0_sumAB_o_ack, de0_sumAB_o_req: std_logic;
	
	signal fr2_sumAB_data, fr2_sumAB_select_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal fr2_sumAB_o_ack, fr2_sumAB_o_req, fr2_sumAB_select_o_ack, fr2_sumAB_select_o_req: std_logic;
	
	signal sel1_sumAGreater_data, sel1_sumAGreater_o_ack, sel1_sumAGreater_o_req: std_logic;
	
	signal f3_select_sumA_o_ack, f3_select_sumA_o_req, f3_select_A_o_ack, f3_select_A_o_req: std_logic;
	
	signal reg3_AB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal reg3_AB_o_ack, reg3_AB_o_req: std_logic;
	
	signal de2_AsumA_data, de2_BsumB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal de2_AsumA_o_ack, de2_AsumA_o_req, de2_BsumB_o_ack, de2_BsumB_o_req: std_logic;
	
	signal de3_AsumA_data, de3_BsumB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal de3_AsumA_o_ack, de3_AsumA_o_req, de3_BsumB_o_ack, de3_BsumB_o_req: std_logic;
	
	signal j0_AsumA_o_ack, j0_AsumA_o_req, j1_BsumB_o_ack, j1_BsumB_o_req: std_logic;
	
	signal add0_AsumA_data, add1_BsumB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal add0_AsumA_o_ack, add0_AsumA_o_req, add1_BsumB_o_ack, add1_BsumB_o_req: std_logic;
	
	signal me0_sumAB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal me0_sumAB_o_ack, me0_sumAB_o_req: std_logic;
	
	signal reg4_sumAB_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal reg4_sumAB_o_ack, reg4_sumAB_o_req: std_logic;
  -------------------------------------------------------------------

begin

-- fork input AB to AB and sumA sumB
f0_fork_input: component fork
  port map(rst => rst,
    inA_req => i_req,
    inA_ack => i_ack,
    outB_req => f0_AB_o_req,
    outB_ack => f0_AB_o_ack,
    outC_req => f0_sumAB_o_req,
    outC_ack => f0_sumAB_o_ack
);
	 
-- Input Multiplexer AB, stored AB
m0_summand_select: component mux
   port map (
    inA_ack => f0_AB_o_req,
    inA_data => AB,
    inA_req => f0_AB_o_ack,
    inB_ack => fr0_AB_o_ack,
    inB_data => fr0_AB_data,
    inB_req => fr0_AB_o_req,
    outC_ack => m0_AB_o_ack,
    outC_data => m0_AB_data,
    outC_req => m0_AB_o_req,
    rst => rst,
    inSel_ack => f2_select_input_AB_o_ack,
    inSel_req => f2_select_input_AB_o_req,
    selector(0) => reg1_sumNotEq_data
  );
  
fr0_fork_register_summand: entity work.reg_fork
   generic map(PHASE_INIT_A => '0',
    PHASE_INIT_B =>'0',
    PHASE_INIT_C => '0')
   port map (
    inA_ack => m0_AB_o_ack,
    inA_data => m0_AB_data,
    inA_req => m0_AB_o_req,
    outB_ack => fr1_summand_o_ack,
    outB_data => fr1_summand_data,
    outB_req => fr1_summand_o_req,
    outC_ack => fr0_AB_o_ack,
    outC_data=> fr0_AB_data,
    outC_req => fr0_AB_o_req,
    rst => rst
  );
  
-- store value for following calculations
reg3_register_input_select_1: entity work.decoupled_hs_reg
   port map (
    rst => rst,
    in_ack => fr1_summand_o_ack,
    in_req => fr1_summand_o_req,
    in_data=> fr1_summand_data,
    -- Output channel
    out_req => reg3_AB_o_req,
    out_data=> reg3_AB_data,
    out_ack => reg3_AB_o_ack
  );
  
-- Input Multiplexer AB, sumAB
m1_sum_select: component mux
   port map (
    inA_ack => f0_sumAB_o_req,
    inA_data => AB,
    inA_req => f0_sumAB_o_ack,
    inB_ack => reg4_sumAB_o_ack,
    inB_data => reg4_sumAB_data,
    inB_req => reg4_sumAB_o_req,
    outC_ack => m1_sumAB_o_ack,
    outC_data => m1_sumAB_data,
    outC_req => m1_sumAB_o_req,
    rst => rst,
    inSel_ack => f2_select_input_sumAB_o_ack,
    inSel_req => f2_select_input_sumAB_o_req,
    selector(0) => reg1_sumNotEq_data
  );
	 
fr1_fork_register_sum: entity work.reg_fork
   generic map(PHASE_INIT_A => '0',
    PHASE_INIT_B =>'0',
    PHASE_INIT_C => '0')
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
  
sel0_select_in_output: component sel_a_not_b
   port map (
    in_ack => fr1_sumAB_select_o_ack,
    in_data => fr1_sumAB_select_data,
    in_req => fr1_sumAB_select_o_req,
    out_ack => sel0_sumNotEq_o_ack,
    out_req => sel0_sumNotEq_o_req,
    selector => sel0_sumNotEq_data 
  );
  
-- fork input output selector signal
f1_fork_select_in_output: component fork
  port map(rst => rst,
    inA_req => sel0_sumNotEq_o_ack,
    inA_ack => sel0_sumNotEq_o_req,
    outB_req => f1_select_input_o_req,
    outB_ack => f1_select_input_o_ack,
    outC_req => f1_select_output_o_req,
    outC_ack => f1_select_output_o_ack
);

reg0_register_input_select_1: entity work.decoupled_hs_reg
   generic map(
    DATA_WIDTH=> 1,
    VALUE => 1,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '1'
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

reg2_register_input_select_2: entity work.decoupled_hs_reg
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
  
 -- fork input output selector signal
f2_fork_select_input: component fork
  port map(rst => rst,
    inA_req => reg1_sumNotEq_o_ack,
    inA_ack => reg1_sumNotEq_o_req,
    outB_req => f2_select_input_AB_o_req,
    outB_ack => f2_select_input_AB_o_ack,
    outC_req => f2_select_input_sumAB_o_req,
    outC_ack => f2_select_input_sumAB_o_ack
);
 
-- switch between forward data to calculation or set as result
de0_set_result: component demux
   port map (
    inA_ack => fr1_sumAB_o_ack,
    inA_data => fr1_sumAB_data,
    inA_req => fr1_sumAB_o_req,
    outB_ack => o_ack,
    outB_data => RESULT,
    outB_req => o_req,
    outC_ack => de0_sumAB_o_ack,
    outC_data => de0_sumAB_data,
    outC_req => de0_sumAB_o_req,
    rst => rst,
    inSel_ack => f1_select_output_o_ack,
    inSel_req => f1_select_output_o_req,
    selector => sel0_sumNotEq_data
);

-- fork sumAB for calculation
fr2_fork_register_calculation_sumAB: entity work.reg_fork
   generic map(PHASE_INIT_A => '0',
    PHASE_INIT_B =>'0',
    PHASE_INIT_C => '0')
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

sel1_sum_select_cond: component sel_a_larger_b
   port map (
    in_ack => fr2_sumAB_select_o_ack,
    in_data=> fr2_sumAB_select_data,
    in_req => fr2_sumAB_select_o_req,
    out_ack => sel1_sumAGreater_o_ack,
    out_req => sel1_sumAGreater_o_req,
    selector => sel1_sumAGreater_data
  );
  
-- fork input sumA > sumB
f3_fork_select_calculation: component fork
  port map(rst => rst,
    inA_req => sel1_sumAGreater_o_ack,
    inA_ack => sel1_sumAGreater_o_req,
    outB_req => f3_select_sumA_o_req,
    outB_ack => f3_select_sumA_o_ack,
    outC_req => f3_select_A_o_req,
    outC_ack => f3_select_A_o_ack
);

-- switch between sumA + A and sumB +B
de2_set_sumA: component demux
   port map (
    inA_ack => fr2_sumAB_o_ack,
    inA_data => fr2_sumAB_data,
    inA_req => fr2_sumAB_o_req,
    outB_ack => de2_AsumA_o_ack,
    outB_data => de2_AsumA_data,
    outB_req => de2_AsumA_o_req,
    outC_ack => de2_BsumB_o_ack,
    outC_data => de2_BsumB_data,
    outC_req => de2_BsumB_o_req,
    rst => rst,
    inSel_ack => f3_select_sumA_o_ack,
    inSel_req => f3_select_sumA_o_req,
    selector => sel1_sumAGreater_data
);
	
-- switch between sumA + A and sumB +B
de3_set_sumA: component demux
   port map (
    inA_ack => reg3_AB_o_ack,
    inA_data => reg3_AB_data,
    inA_req => reg3_AB_o_req,
    outB_ack => de3_AsumA_o_ack,
    outB_data => de3_AsumA_data,
    outB_req => de3_AsumA_o_req,
    outC_ack => de3_BsumB_o_ack,
    outC_data => de3_BsumB_data,
    outC_req => de3_BsumB_o_req,
    rst => rst,
    inSel_ack => f3_select_A_o_ack,
    inSel_req => f3_select_A_o_req,
    selector => sel1_sumAGreater_data
);

j0_sumA_plus_A: component join 
	  port map(
		 
		 --UPSTREAM channels
		 inA_req => de2_AsumA_o_req,
		 inA_ack => de2_AsumA_o_ack,
		 inB_req => de3_AsumA_o_req,
		 inB_ack => de3_AsumA_o_ack,
		 --DOWNSTREAM channel
		 outC_req => j0_AsumA_o_req,
		 outC_ack => j0_AsumA_o_ack,
		 rst => rst);
	
j1_sumB_plus_B: component join 
	  port map(
		 
		 --UPSTREAM channels
		 inA_req => de2_BsumB_o_req,
		 inA_ack => de2_BsumB_o_ack,
		 inB_req => de3_BsumB_o_req,
		 inB_ack => de3_BsumB_o_ack,
		 --DOWNSTREAM channel
		 outC_req => j1_BsumB_o_req,
		 outC_ack => j1_BsumB_o_ack,
		 rst => rst);

-- sumA + A 
add0_A_sumA: component add_block 
	  generic map(
			DATA_WIDTH => DATA_WIDTH/2
	  )
	  port map (
	    -- Input channel
		 in_req => j0_AsumA_o_req,
		 in_ack => j0_AsumA_o_ack,
		 inA_data  => de2_AsumA_data(DATA_WIDTH - 1 downto DATA_WIDTH/2),
		 inB_data  => de3_AsumA_data(DATA_WIDTH - 1 downto DATA_WIDTH/2),
		 -- Output channel
		 out_req => add0_AsumA_o_req,
		 out_ack  => add0_AsumA_o_ack,
		 outC_data  => add0_AsumA_data
		 );

-- sumB + B
add1_B_sumB: component add_block 
		generic map(
			DATA_WIDTH => DATA_WIDTH/2
		)
		port map (
			-- Input channel
			in_req => j1_BsumB_o_req,
			in_ack => j1_BsumB_o_ack,
			inA_data => de2_BsumB_data(DATA_WIDTH/2 - 1 downto 0),
			inB_data => de3_BsumB_data(DATA_WIDTH/2 - 1 downto 0),
			-- Output channel
			out_req => add1_BsumB_o_req,
			out_ack  => add1_BsumB_o_ack,
			outC_data  => add1_BsumB_data
		);

-- merge sumA sumB again
me0_merge_sums: component merge
   port map (
    inA_ack => add0_AsumA_o_ack,
    inA_data=> add0_AsumA_data,
    inA_req => add0_AsumA_o_req,
    inB_ack => add1_BsumB_o_ack,
    inB_data => add1_BsumB_data,
    inB_req => add1_BsumB_o_req,
    outC_ack => me0_sumAB_o_ack,
    outC_data => me0_sumAB_data,
    outC_req => me0_sumAB_o_req,
    rst => rst
  );

-- store sumAB
reg4_store_sumAB: entity work.decoupled_hs_reg
   port map (
    rst => rst,
    in_ack => me0_sumAB_o_ack,
    in_req => me0_sumAB_o_req,
    in_data=> me0_sumAB_data,
    -- Output channel
    out_req => reg4_sumAB_o_req,
    out_data=> reg4_sumAB_data,
    out_ack => reg4_sumAB_o_ack
  );


end STRUCTURE;
