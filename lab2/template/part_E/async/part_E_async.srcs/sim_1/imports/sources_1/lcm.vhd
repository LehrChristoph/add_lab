----------------------------------------------------------------------------------
-- LCM Implementation
----------------------------------------------------------------------------------
-- TODO: the first mandatory iteration is missing still!
-- i.e. LCM(8,8) = 8 but should be 16

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity LCM is
  generic(
    DATA_WIDTH_IF : natural := 8
  );
  port (
    A : in std_logic_vector ( DATA_WIDTH_IF/2-1 downto 0 );
    B : in std_logic_vector ( DATA_WIDTH_IF/2-1 downto 0 );
    result : out std_logic_vector ( DATA_WIDTH_IF-1 downto 0 );
    rst : in std_logic;
    i_req:  in std_logic;
    i_ack:  out std_logic;
    o_req: out std_logic;
    o_ack: in std_logic
  );
end LCM;

architecture STRUCTURE of LCM is

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
  
  component sel_a_smaller_b is
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
  end component sel_a_smaller_b;
  
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

  component addA is
  generic (
    DATA_WIDTH  : natural := DATA_WIDTH
  );
  Port (-- Input channel
    in_req      : in std_logic;
    in_ack      : out std_logic;
    data: in std_logic_vector(DATA_WIDTH - 1 downto 0);
    -- Output channel
    out_req     : out std_logic;
    out_ack     : in std_logic;
    result      : out std_logic_vector(DATA_WIDTH - 1 downto 0));
  end component addA;
  
  component addB is
  generic (
    DATA_WIDTH  : natural := DATA_WIDTH
  );
  Port (-- Input channel
    in_req      : in std_logic;
    in_ack      : out std_logic;
    data: in std_logic_vector(DATA_WIDTH - 1 downto 0);
    -- Output channel
    out_req     : out std_logic;
    out_ack     : in std_logic;
    result      : out std_logic_vector(DATA_WIDTH - 1 downto 0));
  end component addB;  

  signal sa_sb_ab : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal result_int : std_logic_vector(DATA_WIDTH-1 downto 0);
  
  signal r0_o_ack, r0_o_req, r0_data: std_logic;
  signal mx0_data, me0_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal mx0_o_ack, mx0_o_req: std_logic;
  signal me0_o_ack, me0_o_req: std_logic;
  signal cl2_o_ack, cl2_o_req: std_logic;
  signal cl3_o_ack, cl3_o_req: std_logic;
  signal cl3_data, cl2_data, dx1_b_data, dx1_c_data, rf1_b_data, rf1_c_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal dx1_b_o_ack, dx1_b_o_req, dx1_c_o_ack, dx1_c_o_req: std_logic;
  signal rf1_b_o_ack, rf1_b_o_req, rf1_c_o_ack, rf1_c_o_req: std_logic;
  signal dx0_c_data, rf0_b_data, rf0_c_data, cl0_in_data, cl1_in_data : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal cl1_o_req, cl1_o_ack, cl1_data: std_logic;
  signal dx0_c_o_ack, dx0_c_o_req: std_logic;
  signal f0_b_o_ack, f0_b_o_req, f0_c_o_ack, f0_c_o_req: std_logic;
  signal cl0_o_req, cl0_o_ack, cl0_data: std_logic;
  signal rf0_b_o_req, rf0_b_o_ack, rf0_c_o_req, rf0_c_o_ack: std_logic;
  
  -------------------------------------------------------------------

begin

sa_sb_ab(DATA_WIDTH-1 downto DATA_WIDTH*2/3+DATA_WIDTH_IF/2) <= (others => '0');
sa_sb_ab(DATA_WIDTH*2/3+DATA_WIDTH_IF/2-1 downto DATA_WIDTH*2/3) <= A;
sa_sb_ab(DATA_WIDTH*2/3-1 downto DATA_WIDTH*1/3+DATA_WIDTH_IF/2) <= (others => '0');
sa_sb_ab(DATA_WIDTH*1/3+DATA_WIDTH_IF/2-1 downto DATA_WIDTH*1/3) <= B;
sa_sb_ab(DATA_WIDTH_IF-1 downto 0) <= A & B;

result <= result_int(DATA_WIDTH-1 downto DATA_WIDTH*2/3);

MX_0: component mux
   port map (
    inA_ack => i_ack,
    inA_data => sa_sb_ab,
    inA_req => i_req,
    inB_ack => me0_o_ack,
    inB_data => me0_data,
    inB_req => me0_o_req,
    outC_ack => mx0_o_ack,
    outC_data => mx0_data,
    outC_req => mx0_o_req,
    rst => rst,
    inSel_ack => r0_o_ack,
    inSel_req => r0_o_req,
    selector(0) => r0_data
  );
    
CL_2: component addA
  port map(-- Input channel
    in_req => dx1_b_o_req,
    in_ack => dx1_b_o_ack,
    data => dx1_b_data,
    -- Output channel
    out_req => cl2_o_req,
    out_ack => cl2_o_ack,
    result  => cl2_data);
  
CL_3: component addB
  port map(-- Input channel
    in_req => dx1_c_o_req,
    in_ack => dx1_c_o_ack,
    data => dx1_c_data,
    -- Output channel
    out_req => cl3_o_req,
    out_ack => cl3_o_ack,
    result  => cl3_data);
    
R_0: entity work.decoupled_hs_reg
   generic map(
    DATA_WIDTH=> 1,
    VALUE => 1,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '1'
   )
   port map (
    rst => rst,
    in_ack => f0_b_o_ack,
    in_req => f0_b_o_req,
    in_data(0)=> cl0_data,
    -- Output channel
    out_req => r0_o_req,
    out_data(0)=> r0_data,
    out_ack => r0_o_ack
  );
    
F_0: component fork
  port map(rst => rst,
    inA_req => cl0_o_req,
    inA_ack => cl0_o_ack,
    outB_req => f0_b_o_req,
    outB_ack => f0_b_o_ack,
    outC_req => f0_c_o_req,
    outC_ack => f0_c_o_ack);
        
DX_0: component demux
   port map (
    inA_ack => rf0_c_o_ack,
    inA_data => rf0_c_data,
    inA_req => rf0_c_o_req,
    outB_ack => o_ack,
    outB_data => result_int,
    outB_req => o_req,
    outC_ack => dx0_c_o_ack,
    outC_data => dx0_c_data,
    outC_req => dx0_c_o_req,
    rst => rst,
    inSel_ack => f0_c_o_ack,
    inSel_req => f0_c_o_req,
    selector => cl0_data);
    
DX_1: component demux
   port map (
    inA_ack => rf1_c_o_ack,
    inA_data => rf1_c_data,
    inA_req => rf1_c_o_req,
    outB_ack => dx1_b_o_ack,
    outB_data => dx1_b_data,
    outB_req => dx1_b_o_req,
    outC_ack => dx1_c_o_ack,
    outC_data => dx1_c_data,
    outC_req => dx1_c_o_req,
    rst => rst,
    inSel_ack => cl1_o_ack,
    inSel_req => cl1_o_req,
    selector => cl1_data
  );
    
RF_0: entity work.reg_fork
   generic map(PHASE_INIT_A => '0',
    PHASE_INIT_B =>'0',
    PHASE_INIT_C => '0')
   port map (
    inA_ack => mx0_o_ack,
    inA_data => mx0_data,
    inA_req => mx0_o_req,
    outB_ack => rf0_b_o_ack,
    outB_data => rf0_b_data,
    outB_req => rf0_b_o_req,
    outC_ack => rf0_c_o_ack,
    outC_data=> rf0_c_data,
    outC_req => rf0_c_o_req,
    rst => rst
  );
    
RF_1: entity work.reg_fork
   generic map(PHASE_INIT_A => '0',
     PHASE_INIT_B =>'0',
     PHASE_INIT_C => '0')
   port map (
    inA_ack => dx0_c_o_ack,
    inA_data => dx0_c_data,
    inA_req => dx0_c_o_req,
    outB_ack => rf1_b_o_ack,
    outB_data => rf1_b_data,
    outB_req => rf1_b_o_req,
    outC_ack => rf1_c_o_ack,
    outC_data => rf1_c_data,
    outC_req => rf1_c_o_req,
    rst => rst
  );
    
ME_0: component merge
   port map (
    inA_ack => cl2_o_ack,
    inA_data=> cl2_data,
    inA_req => cl2_o_req,
    inB_ack => cl3_o_ack,
    inB_data => cl3_data,
    inB_req => cl3_o_req,
    outC_ack => me0_o_ack,
    outC_data => me0_data,
    outC_req => me0_o_req,
    rst => rst
  );

  process(rf1_b_data)
  begin
    cl1_in_data <= (others => '0');
    cl1_in_data(DATA_WIDTH/2 + DATA_WIDTH/3 -1 downto DATA_WIDTH/2) <= rf1_b_data(DATA_WIDTH-1 downto DATA_WIDTH*2/3);
    cl1_in_data(DATA_WIDTH/3 -1 downto 0) <= rf1_b_data(DATA_WIDTH*2/3-1 downto DATA_WIDTH/3);
  end process;

CL_1: component sel_a_smaller_b
   port map (
    in_ack => rf1_b_o_ack,
    in_data=> cl1_in_data,
    in_req => rf1_b_o_req,
    out_ack => cl1_o_ack,
    out_req => cl1_o_req,
    selector => cl1_data
  );
    
  process(rf0_b_data)
  begin
    cl0_in_data <= (others => '0');
    cl0_in_data(DATA_WIDTH/2 + DATA_WIDTH/3 -1 downto DATA_WIDTH/2) <= rf0_b_data(DATA_WIDTH-1 downto DATA_WIDTH*2/3);
    cl0_in_data(DATA_WIDTH/3 -1 downto 0) <= rf0_b_data(DATA_WIDTH*2/3-1 downto DATA_WIDTH*1/3);
  end process;
    
CL_0: component sel_a_not_b
   port map (
    in_ack => rf0_b_o_ack,
    in_data => cl0_in_data,
    in_req => rf0_b_o_req,
    out_ack => cl0_o_ack,
    out_req => cl0_o_req,
    selector => cl0_data
  );
    
end STRUCTURE;
