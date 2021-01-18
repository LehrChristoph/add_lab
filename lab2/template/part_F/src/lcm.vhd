----------------------------------------------------------------------------------
-- lcm Implementation
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity lcm is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port (
    A : in std_logic_vector ( DATA_WIDTH/2-1 downto 0 );
    B : in std_logic_vector ( DATA_WIDTH/2-1 downto 0 );
    RESULT : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
    rst : in std_logic;
    i_req:  in std_logic;
    i_ack:  out std_logic;
    o_req: out std_logic;
    o_ack: in std_logic
  );
end lcm;

architecture STRUCTURE of lcm is
  constant DATAPATH_WIDTH : natural := DATA_WIDTH*3;
  subtype A_RANGE is natural range DATAPATH_WIDTH-1              downto DATAPATH_WIDTH-DATA_WIDTH/2;
  subtype B_RANGE is natural range DATAPATH_WIDTH-DATA_WIDTH/2-1 downto DATAPATH_WIDTH-DATA_WIDTH;
  subtype ASUM_RANGE is natural range DATAPATH_WIDTH-DATA_WIDTH-1 downto DATAPATH_WIDTH-DATA_WIDTH*2;
  subtype BSUM_RANGE is natural range DATA_WIDTH-1 downto 0;



signal m1_dataA,  m1_dataB,  m1_dataC : std_logic_vector(DATAPATH_WIDTH-1 downto 0);
signal m1_reqA,   m1_reqB,   m1_reqC,
       m1_ackA,   m1_ackB,   m1_ackC,
       m1_reqSel, m1_ackSel, m1_dataSel : std_logic;


signal fr1_dataA,  fr1_dataB,  fr1_dataC : std_logic_vector(DATAPATH_WIDTH-1 downto 0);
signal fr1_reqA,   fr1_reqB,   fr1_reqC,
       fr1_ackA,   fr1_ackB,   fr1_ackC : std_logic;


signal cmp1_in_ack, cmp1_in_req, cmp1_out_req, cmp1_out_ack, cmp1_out_data : std_logic;
signal cmp1_in_data : std_logic_vector(2*DATA_WIDTH-1 downto 0);

signal de1_dataA,  de1_dataB,  de1_dataC : std_logic_vector(DATAPATH_WIDTH-1 downto 0);
signal de1_reqA,   de1_reqB,   de1_reqC,
       de1_ackA,   de1_ackB,   de1_ackC,
       de1_reqSel, de1_ackSel, de1_dataSel : std_logic;


signal add1_in_ack, add1_in_req, add1_out_ack, add1_out_req : std_logic;
signal add1_dataA, add1_dataB, add1_dataC : std_logic_vector(DATA_WIDTH-1 downto 0);


signal add2_in_ack, add2_in_req, add2_out_ack, add2_out_req : std_logic;
signal add2_dataA, add2_dataB, add2_dataC : std_logic_vector(DATA_WIDTH-1 downto 0);


signal mrg1_dataA,  mrg1_dataB,  mrg1_dataC : std_logic_vector(DATAPATH_WIDTH-1 downto 0);
signal mrg1_reqA,   mrg1_reqB,   mrg1_reqC,
       mrg1_ackA,   mrg1_ackB,   mrg1_ackC : std_logic;


signal fr2_dataA,  fr2_dataB,  fr2_dataC : std_logic_vector(DATAPATH_WIDTH-1 downto 0);
signal fr2_reqA,   fr2_reqB,   fr2_reqC,
       fr2_ackA,   fr2_ackB,   fr2_ackC : std_logic;


signal de2_dataA,  de2_dataB,  de2_dataC : std_logic_vector(DATAPATH_WIDTH-1 downto 0);
signal de2_reqA,   de2_reqB,   de2_reqC,
       de2_ackA,   de2_ackB,   de2_ackC,
       de2_reqSel, de2_ackSel, de2_dataSel : std_logic;


signal cmp2_in_ack, cmp2_in_req, cmp2_out_ack, cmp2_out_req, cmp2_out_data : std_logic;
signal cmp2_in_data : std_logic_vector(2*DATA_WIDTH-1 downto 0);


signal r1_in_ack, r1_in_req, r1_in_data, r1_out_ack, r1_out_req, r1_out_data : std_logic;


signal f1_reqA, f1_ackA, f1_reqB, f1_ackB, f1_reqC, f1_ackC : std_logic;

attribute keep : boolean;
attribute keep of
  m1_dataA,  m1_dataB,  m1_dataC,
  m1_reqA,   m1_reqB,   m1_reqC,
  m1_ackA,   m1_ackB,   m1_ackC,
  m1_reqSel, m1_ackSel, m1_dataSel,
  fr1_dataA,  fr1_dataB,  fr1_dataC,
  fr1_reqA,   fr1_reqB,   fr1_reqC,
  fr1_ackA,   fr1_ackB,   fr1_ackC,
  cmp1_in_ack, cmp1_in_req, cmp1_out_req, cmp1_out_ack, cmp1_out_data,
  cmp1_in_data,
  de1_dataA,  de1_dataB,  de1_dataC,
  de1_reqA,   de1_reqB,   de1_reqC,
  de1_ackA,   de1_ackB,   de1_ackC,
  de1_reqSel, de1_ackSel, de1_dataSel,
  add1_in_ack, add1_in_req, add1_out_ack, add1_out_req,
  add1_dataA, add1_dataB, add1_dataC,
  add2_in_ack, add2_in_req, add2_out_ack, add2_out_req,
  add2_dataA, add2_dataB, add2_dataC,
  mrg1_dataA,  mrg1_dataB,  mrg1_dataC,
  mrg1_reqA,   mrg1_reqB,   mrg1_reqC,
  mrg1_ackA,   mrg1_ackB,   mrg1_ackC,
  fr2_dataA,  fr2_dataB,  fr2_dataC,
  fr2_reqA,   fr2_reqB,   fr2_reqC,
  fr2_ackA,   fr2_ackB,   fr2_ackC,
  de2_dataA,  de2_dataB,  de2_dataC,
  de2_reqA,   de2_reqB,   de2_reqC,
  de2_ackA,   de2_ackB,   de2_ackC,
  de2_reqSel, de2_ackSel, de2_dataSel,
  cmp2_in_ack, cmp2_in_req, cmp2_out_ack, cmp2_out_req, cmp2_out_data,
  cmp2_in_data,
  r1_in_ack, r1_in_req, r1_in_data, r1_out_ack, r1_out_req, r1_out_data,
  f1_reqA, f1_ackA, f1_reqB, f1_ackB, f1_reqC, f1_ackC
: signal is true;


begin
  -- Interface connections
  RESULT <= de2_dataB(ASUM_RANGE);
  i_ack <= m1_ackA;
  o_req <= de2_reqB;

  m1_dataA(A_RANGE) <= A;
  m1_dataA(B_RANGE) <= B;
  m1_dataA(ASUM_RANGE) <= std_logic_vector(resize(unsigned(A), DATA_WIDTH));
  m1_dataA(BSUM_RANGE) <= std_logic_vector(resize(unsigned(B), DATA_WIDTH));
  m1_reqA <= i_req;
  de2_ackB <= o_ack;


  --m1 to fr1
  fr1_dataA <= m1_dataC;
  fr1_reqA <= m1_reqC;
  m1_ackC <= fr1_ackA;


  --fr1 to cmp1
  cmp1_in_data <= fr1_dataB(ASUM_RANGE) & fr1_dataB(BSUM_RANGE);
  cmp1_in_req <= fr1_reqB;
  fr1_ackB <= cmp1_in_ack;

  --fr1 to de1
  de1_dataA <= fr1_dataC;
  de1_reqA <= fr1_reqC;
  fr1_ackC <= de1_ackA;

  --cmp1 to de1
  de1_dataSel <= cmp1_out_data;
  de1_reqSel <= cmp1_out_req;
  cmp1_out_ack <= de1_ackSel;

  --de1 to add1
  add1_dataA <= de1_dataC(ASUM_RANGE);
  add1_dataB <= std_logic_vector(resize(unsigned(de1_dataC(A_RANGE)), DATA_WIDTH));
  add1_in_req <= de1_reqC;
  de1_ackC <= add1_in_ack;

  --de1 to add2
  add2_dataA <= de1_dataB(BSUM_RANGE);
  add2_dataB <= std_logic_vector(resize(unsigned(de1_dataB(B_RANGE)), DATA_WIDTH));
  add2_in_req <= de1_reqB;
  de1_ackB <= add2_in_ack;

  --add1 to mrg1
  mrg1_dataA(ASUM_RANGE) <= add1_dataC;
  mrg1_reqA <= add1_out_req;
  add1_out_ack <= mrg1_ackA;

  --add2 to mrg1
  mrg1_dataB(BSUM_RANGE) <= add2_dataC;
  mrg1_reqB <= add2_out_req;
  add2_out_ack <= mrg1_ackB;

  --de1 to mrg1
  mrg1_dataA(BSUM_RANGE) <= de1_dataC(BSUM_RANGE);
  mrg1_dataA(A_RANGE) <= de1_dataC(A_RANGE);
  mrg1_dataA(B_RANGE) <= de1_dataC(B_RANGE);
  mrg1_dataB(ASUM_RANGE) <= de1_dataB(ASUM_RANGE);
  mrg1_dataB(A_RANGE) <= de1_dataB(A_RANGE);
  mrg1_dataB(B_RANGE) <= de1_dataB(B_RANGE);

  --mrg1 to fr2
  fr2_dataA <= mrg1_dataC;
  fr2_reqA <= mrg1_reqC;
  mrg1_ackC <= fr2_ackA;

  --fr2 to cmp2
  cmp2_in_data <= fr2_dataB(ASUM_RANGE) & fr2_dataB(BSUM_RANGE);
  cmp2_in_req <= fr2_reqB;
  fr2_ackB <= cmp2_in_ack;

  --cmp2 to f1
  f1_reqA <= cmp2_out_req;
  cmp2_out_ack <= f1_ackA;


  --fr2 to de2
  de2_dataA <= fr2_dataC;
  de2_reqA <= fr2_reqC;
  fr2_ackC <= de2_ackA;

  --cmp2 to de2
  de2_dataSel <= cmp2_out_data;

  --cmp2 to r1
  r1_in_data <= cmp2_out_data;

  --f1 to r1
  r1_in_req <= f1_reqB;
  f1_ackB <= r1_in_ack;

  --f1 to de2
  de2_reqSel <= f1_reqC;
  f1_ackC <= de2_ackSel;

  --r1 to m1
  m1_dataSel <= r1_out_data;
  m1_reqSel <= r1_out_req;
  r1_out_ack <= m1_ackSel;

  --de2 to m1
  m1_dataB <= de2_dataC;
  m1_reqB <= de2_reqC;
  de2_ackC <= m1_ackB;

  m1_select_input: entity work.mux
  generic map(
    DATA_WIDTH => DATAPATH_WIDTH
  )
   port map (
    rst => rst,
    inA_req => m1_reqA,
    inA_ack => m1_ackA,
    inA_data => m1_dataA,
    inB_req => m1_reqB,
    inB_ack => m1_ackB,
    inB_data => m1_dataB,
    outC_req => m1_reqC,
    outC_ack => m1_ackC,
    outC_data => m1_dataC,
    inSel_req => m1_reqSel,
    inSel_ack => m1_ackSel,
    selector(0) => m1_dataSel
  );

  fr1_fork_reg: entity work.reg_fork
  generic map(
    DATA_WIDTH => DATAPATH_WIDTH
  )
   port map (
    rst => rst,
    inA_req => fr1_reqA,
    inA_ack => fr1_ackA,
    inA_data => fr1_dataA,
    outB_req => fr1_reqB,
    outB_ack => fr1_ackB,
    outB_data => fr1_dataB,
    outC_req => fr1_reqC,
    outC_ack => fr1_ackC,
    outC_data => fr1_dataC
  );

  cmp1_sA_g_sB : entity work.sel_a_larger_b
  generic map(
    DATA_WIDTH => 2*DATA_WIDTH
  )
  port map (
    in_req => cmp1_in_req,
    in_ack => cmp1_in_ack,
    in_data => cmp1_in_data,
    out_req => cmp1_out_req,
    out_ack => cmp1_out_ack,
    selector => cmp1_out_data
  );

  de1_choose_sum : entity work.demux
  generic map(
    DATA_WIDTH => DATAPATH_WIDTH
  )
   port map (
    rst => rst,
    inA_req => de1_reqA,
    inA_ack => de1_ackA,
    inA_data => de1_dataA,
    outB_req => de1_reqB,
    outB_ack => de1_ackB,
    outB_data => de1_dataB,
    outC_req => de1_reqC,
    outC_ack => de1_ackC,
    outC_data => de1_dataC,
    inSel_req => de1_reqSel,
    inSel_ack => de1_ackSel,
    selector => de1_dataSel
  );

  -- sumA = sumA + A
  add1_A_sumA: entity work.add_block
  generic map(
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    in_req => add1_in_req,
    in_ack => add1_in_ack,
    out_req => add1_out_req,
    out_ack  => add1_out_ack,
    inA_data => add1_dataA,
    inB_data => add1_dataB,
    outC_data => add1_dataC
  );

   -- sumB = sumB + B
  add2_B_sumB: entity work.add_block
  generic map(
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    in_req => add2_in_req,
    in_ack => add2_in_ack,
    out_req => add2_out_req,
    out_ack  => add2_out_ack,
    inA_data => add2_dataA,
    inB_data => add2_dataB,
    outC_data => add2_dataC
  );

  mrg1_merge_sums: entity work.merge
  generic map(
      DATA_WIDTH => DATAPATH_WIDTH
  )
  port map (
    rst => rst,
    inA_req => mrg1_reqA,
    inA_ack => mrg1_ackA,
    inA_data => mrg1_dataA,
    inB_req => mrg1_reqB,
    inB_ack => mrg1_ackB,
    inB_data => mrg1_dataB,
    outC_req => mrg1_reqC,
    outC_ack => mrg1_ackC,
    outC_data => mrg1_dataC
  );

  fr2_fork_reg: entity work.reg_fork
  generic map(
    DATA_WIDTH => DATAPATH_WIDTH
  )
   port map (
    rst => rst,
    inA_req => fr2_reqA,
    inA_ack => fr2_ackA,
    inA_data => fr2_dataA,
    outB_req => fr2_reqB,
    outB_ack => fr2_ackB,
    outB_data => fr2_dataB,
    outC_req => fr2_reqC,
    outC_ack => fr2_ackC,
    outC_data => fr2_dataC
  );

  cmp2_sA_ne_sB : entity work.sel_a_not_b
  generic map(
    DATA_WIDTH => 2*DATA_WIDTH
  )
   port map (
    in_req => cmp2_in_req,
    in_ack => cmp2_in_ack,
    in_data => cmp2_in_data,
    out_req => cmp2_out_req,
    out_ack => cmp2_out_ack,
    selector => cmp2_out_data
  );

  de2_choose_result : entity work.demux
  generic map(
    DATA_WIDTH => DATAPATH_WIDTH
  )
   port map (
    rst => rst,
    inA_req => de2_reqA,
    inA_ack => de2_ackA,
    inA_data => de2_dataA,
    outB_req => de2_reqB,
    outB_ack => de2_ackB,
    outB_data => de2_dataB,
    outC_req => de2_reqC,
    outC_ack => de2_ackC,
    outC_data => de2_dataC,
    inSel_req => de2_reqSel,
    inSel_ack => de2_ackSel,
    selector => de2_dataSel
  );

  r1_buffer_input_sel: entity work.decoupled_hs_reg
  generic map(
   DATA_WIDTH=> 1,
   VALUE => 1,
   INIT_REQUEST => '1'
  )
  port map (
   rst => rst,
   in_req =>    r1_in_req,
   in_ack =>    r1_in_ack,
   in_data(0)=> r1_in_data,
   out_req =>    r1_out_req,
   out_ack =>    r1_out_ack,
   out_data(0)=> r1_out_data
 );

f1_fork_select_in_output: entity work.fork
  port map(rst => rst,
    inA_req => f1_reqA,
    inA_ack => f1_ackA,
    outB_req => f1_reqB,
    outB_ack => f1_ackB,
    outC_req => f1_reqC,
    outC_ack => f1_ackC
);

end STRUCTURE;
