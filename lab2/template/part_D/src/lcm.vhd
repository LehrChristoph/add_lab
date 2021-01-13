library IEEE;
	use IEEE.std_logic_1164.all;
	
	package defs is
	constant LCM_DATA_WIDTH : Integer := 48;
	constant LCM_OUT_DATA_WIDTH : Integer := 16;
	constant LCM_IN_DATA_WIDTH : Integer := 16;
	
end package;
architecture beh_se_1 of Selector is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 32 - 1 downto 16);
alias y      : std_logic_vector(16 - 1 downto 0)  is in_data( 48 - 1 downto 32);

  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, selector: signal is "true";
	
	--attribute keep : boolean;
	--attribute keep of  x, y, selector: signal is true;
  begin
  
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
      );
  
    in_ack <= out_ack;
    
    selector(0) <= '0' when unsigned(x) /= unsigned(y) else '1';


  end beh_se_1;
  architecture beh_b_0 of BlockC is
	signal r_0_o_req, r_0_o_ack : std_logic;signal r_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal cl_0_o_req, cl_0_o_ack : std_logic;signal cl_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal r_1_o_req, r_1_o_ack : std_logic;signal r_1_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal cl_1_o_req, cl_1_o_ack : std_logic;signal cl_1_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal r_2_o_req, r_2_o_ack : std_logic;signal r_2_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal if_0_o_req, if_0_o_ack : std_logic;signal if_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal r_5_o_req, r_5_o_ack : std_logic;signal r_5_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal lb_0_o_req, lb_0_o_ack : std_logic;signal lb_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= lb_0_o_req; 
lb_0_o_ack <= out_ack; 
out_data <= lb_0_data; 

R_0: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => DATA_WIDTH,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
  )
  port map (
    rst => rst,
    in_ack => in_ack,
    in_req => in_req,
    in_data => in_data,
    -- Output channel
    out_req => r_0_o_req,
    out_data => r_0_data,
    out_ack => r_0_o_ack
  );
  CL_0: entity work.funcBlock(beh_cl_0)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => r_0_o_req,
	  in_ack  => r_0_o_ack, 
	  in_data => r_0_data,
	  -- Output channel
	  out_req => cl_0_o_req,
	  out_ack => cl_0_o_ack,
	  out_data  => cl_0_data
	);
	R_1: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => DATA_WIDTH,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
  )
  port map (
    rst => rst,
    in_ack => cl_0_o_ack,
    in_req => cl_0_o_req,
    in_data => cl_0_data,
    -- Output channel
    out_req => r_1_o_req,
    out_data => r_1_data,
    out_ack => r_1_o_ack
  );
  CL_1: entity work.funcBlock(beh_cl_1)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => r_1_o_req,
	  in_ack  => r_1_o_ack, 
	  in_data => r_1_data,
	  -- Output channel
	  out_req => cl_1_o_req,
	  out_ack => cl_1_o_ack,
	  out_data  => cl_1_data
	);
	R_2: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => DATA_WIDTH,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
  )
  port map (
    rst => rst,
    in_ack => cl_1_o_ack,
    in_req => cl_1_o_req,
    in_data => cl_1_data,
    -- Output channel
    out_req => r_2_o_req,
    out_data => r_2_data,
    out_ack => r_2_o_ack
  );
  IF_0: entity work.IfBlock(beh_if_0)
  generic map(
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    rst => rst,
    in_ack => r_2_o_ack,
    in_req => r_2_o_req,
    in_data => r_2_data,
    -- Output channel
    out_req => if_0_o_req,
    out_data => if_0_data,
    out_ack => if_0_o_ack
  );
  R_5: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => DATA_WIDTH,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
  )
  port map (
    rst => rst,
    in_ack => if_0_o_ack,
    in_req => if_0_o_req,
    in_data => if_0_data,
    -- Output channel
    out_req => r_5_o_req,
    out_data => r_5_data,
    out_ack => r_5_o_ack
  );
  LB_0: entity work.LoopBlock(beh_lb_0)
  generic map(
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    rst => rst,
    in_ack => r_5_o_ack,
    in_req => r_5_o_req,
    in_data => r_5_data,
    -- Output channel
    out_req => lb_0_o_req,
    out_data => lb_0_data,
    out_ack => lb_0_o_ack
  );
  end beh_b_0;
	architecture beh_cl_0 of funcBlock is
	alias x      : std_logic_vector(8 - 1 downto 0)  is in_data( 8 - 1 downto 0);
alias result : std_logic_vector(16 - 1 downto 0)  is out_data( 32 - 1 downto 16);

	  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, result: signal is "true";
	  
    --attribute keep : boolean;
	--attribute keep of  x, y, result: signal is true;
  begin
    in_ack <= out_ack;
    
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
	  );
	  

	  calc: process(all)
	variable offset: integer range 0 to out_data'length;
	begin
	out_data <= in_data; 
	result <= std_logic_vector(resize(unsigned(x)  , result'length)) ;

	end process;
  end beh_cl_0;
  architecture beh_cl_2 of funcBlock is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 32 - 1 downto 16);
alias y      : std_logic_vector(8 - 1 downto 0)  is in_data( 8 - 1 downto 0);
alias result : std_logic_vector(16 - 1 downto 0)  is out_data( 32 - 1 downto 16);

	  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, result: signal is "true";
	  
    --attribute keep : boolean;
	--attribute keep of  x, y, result: signal is true;
  begin
    in_ack <= out_ack;
    
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
	  );
	  

	  calc: process(all)
	variable offset: integer range 0 to out_data'length;
	begin
	out_data <= in_data; 
	result <= std_logic_vector(resize(unsigned(x) + unsigned(y), result'length))  after ADDER_DELAY;

	end process;
  end beh_cl_2;
  architecture beh_se_0 of Selector is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 32 - 1 downto 16);
alias y      : std_logic_vector(16 - 1 downto 0)  is in_data( 48 - 1 downto 32);

  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, selector: signal is "true";
	
	--attribute keep : boolean;
	--attribute keep of  x, y, selector: signal is true;
  begin
  
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
      );
  
    in_ack <= out_ack;
    
    selector(0) <= '1' when unsigned(x) < unsigned(y) else '0';


  end beh_se_0;
  architecture beh_if_0 of IfBlock is
	signal f_0_b_o_req, f_0_b_o_ack : std_logic;signal f_0_b_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal f_0_c_o_req, f_0_c_o_ack : std_logic;signal f_0_c_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal dx_0_b_o_req, dx_0_b_o_ack : std_logic;signal dx_0_b_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal dx_0_c_o_req, dx_0_c_o_ack : std_logic;signal dx_0_c_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal cl_2_o_req, cl_2_o_ack : std_logic;signal cl_2_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal cl_4_o_req, cl_4_o_ack : std_logic;signal cl_4_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal if_0_o_req, if_0_o_ack : std_logic;signal if_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal se_0_o_req, se_0_o_ack : std_logic;signal se_0_select : std_logic_vector(0 downto 0);

begin
out_req <= if_0_o_req; 
if_0_o_ack <= out_ack; 
out_data <= if_0_data; 

F_0: entity work.fork
  generic map(
    DATA_WIDTH => DATA_WIDTH,
    PHASE_INIT => '0'
  )
  port map(
    inA_ack => in_ack,
    inA_req => in_req,
    inA_data => in_data,
    -- Output Channel
    outB_ack => f_0_b_o_ack,
    outB_req => f_0_b_o_req,
    outB_data => f_0_b_data,
    outC_ack => f_0_c_o_ack,
    outC_req => f_0_c_o_req,
    outC_data => f_0_c_data,
    rst => rst
  );
    
SE_0: entity work.Selector(beh_se_0)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => f_0_b_o_req,
	  in_ack  => f_0_b_o_ack, 
	  in_data => f_0_b_data,
	  -- Output channel
	  out_req => se_0_o_req,
	  out_ack => se_0_o_ack,
	  selector  => se_0_select
	);
DX_0: entity work.demux
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    inA_ack => f_0_c_o_ack,
    inA_data => f_0_c_data,
    inA_req => f_0_c_o_req,
    outB_ack => dx_0_b_o_ack,
    outB_data => dx_0_b_data,
    outB_req => dx_0_b_o_req,
    outC_ack => dx_0_c_o_ack,
    outC_data => dx_0_c_data,
    outC_req => dx_0_c_o_req,
    rst => rst,
    inSel_ack => se_0_o_ack,
    inSel_req => se_0_o_req,
    selector => se_0_select
  );
   
B_1: entity work.BlockC(beh_b_1)
  generic map(
   DATA_WIDTH => DATA_WIDTH
  )
  port map (
   rst => rst,
   in_ack => dx_0_b_o_ack,
   in_req => dx_0_b_o_req,
   in_data => dx_0_b_data,
   -- Output channel
   out_req => cl_2_o_req,
   out_data => cl_2_data,
   out_ack => cl_2_o_ack
  );
  
B_2: entity work.BlockC(beh_b_2)
  generic map(
   DATA_WIDTH => DATA_WIDTH
  )
  port map (
   rst => rst,
   in_ack => dx_0_c_o_ack,
   in_req => dx_0_c_o_req,
   in_data => dx_0_c_data,
   -- Output channel
   out_req => cl_4_o_req,
   out_data => cl_4_data,
   out_ack => cl_4_o_ack
  );
  
ME_0: entity work.merge
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    inA_ack => cl_2_o_ack,
    inA_data => cl_2_data,
    inA_req => cl_2_o_req,
    inB_ack => cl_4_o_ack,
    inB_data => cl_4_data,
    inB_req => cl_4_o_req,
    outC_ack => if_0_o_ack,
    outC_data => if_0_data,
    outC_req => if_0_o_req,
    rst => rst
   );
   
end beh_if_0;
	architecture beh_if_1 of IfBlock is
	signal f_1_b_o_req, f_1_b_o_ack : std_logic;signal f_1_b_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal f_1_c_o_req, f_1_c_o_ack : std_logic;signal f_1_c_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal dx_2_b_o_req, dx_2_b_o_ack : std_logic;signal dx_2_b_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal dx_2_c_o_req, dx_2_c_o_ack : std_logic;signal dx_2_c_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal cl_5_o_req, cl_5_o_ack : std_logic;signal cl_5_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal cl_7_o_req, cl_7_o_ack : std_logic;signal cl_7_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal if_1_o_req, if_1_o_ack : std_logic;signal if_1_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal se_2_o_req, se_2_o_ack : std_logic;signal se_2_select : std_logic_vector(0 downto 0);

begin
out_req <= if_1_o_req; 
if_1_o_ack <= out_ack; 
out_data <= if_1_data; 

F_1: entity work.fork
  generic map(
    DATA_WIDTH => DATA_WIDTH,
    PHASE_INIT => '0'
  )
  port map(
    inA_ack => in_ack,
    inA_req => in_req,
    inA_data => in_data,
    -- Output Channel
    outB_ack => f_1_b_o_ack,
    outB_req => f_1_b_o_req,
    outB_data => f_1_b_data,
    outC_ack => f_1_c_o_ack,
    outC_req => f_1_c_o_req,
    outC_data => f_1_c_data,
    rst => rst
  );
    
SE_2: entity work.Selector(beh_se_2)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => f_1_b_o_req,
	  in_ack  => f_1_b_o_ack, 
	  in_data => f_1_b_data,
	  -- Output channel
	  out_req => se_2_o_req,
	  out_ack => se_2_o_ack,
	  selector  => se_2_select
	);
DX_2: entity work.demux
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    inA_ack => f_1_c_o_ack,
    inA_data => f_1_c_data,
    inA_req => f_1_c_o_req,
    outB_ack => dx_2_b_o_ack,
    outB_data => dx_2_b_data,
    outB_req => dx_2_b_o_req,
    outC_ack => dx_2_c_o_ack,
    outC_data => dx_2_c_data,
    outC_req => dx_2_c_o_req,
    rst => rst,
    inSel_ack => se_2_o_ack,
    inSel_req => se_2_o_req,
    selector => se_2_select
  );
   
B_4: entity work.BlockC(beh_b_4)
  generic map(
   DATA_WIDTH => DATA_WIDTH
  )
  port map (
   rst => rst,
   in_ack => dx_2_b_o_ack,
   in_req => dx_2_b_o_req,
   in_data => dx_2_b_data,
   -- Output channel
   out_req => cl_5_o_req,
   out_data => cl_5_data,
   out_ack => cl_5_o_ack
  );
  
B_5: entity work.BlockC(beh_b_5)
  generic map(
   DATA_WIDTH => DATA_WIDTH
  )
  port map (
   rst => rst,
   in_ack => dx_2_c_o_ack,
   in_req => dx_2_c_o_req,
   in_data => dx_2_c_data,
   -- Output channel
   out_req => cl_7_o_req,
   out_data => cl_7_data,
   out_ack => cl_7_o_ack
  );
  
ME_2: entity work.merge
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    inA_ack => cl_5_o_ack,
    inA_data => cl_5_data,
    inA_req => cl_5_o_req,
    inB_ack => cl_7_o_ack,
    inB_data => cl_7_data,
    inB_req => cl_7_o_req,
    outC_ack => if_1_o_ack,
    outC_data => if_1_data,
    outC_req => if_1_o_req,
    rst => rst
   );
   
end beh_if_1;
	architecture beh_cl_4 of funcBlock is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 48 - 1 downto 32);
alias y      : std_logic_vector(8 - 1 downto 0)  is in_data( 16 - 1 downto 8);
alias result : std_logic_vector(16 - 1 downto 0)  is out_data( 48 - 1 downto 32);

	  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, result: signal is "true";
	  
    --attribute keep : boolean;
	--attribute keep of  x, y, result: signal is true;
  begin
    in_ack <= out_ack;
    
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
	  );
	  

	  calc: process(all)
	variable offset: integer range 0 to out_data'length;
	begin
	out_data <= in_data; 
	result <= std_logic_vector(resize(unsigned(x) + unsigned(y), result'length))  after ADDER_DELAY;

	end process;
  end beh_cl_4;
  architecture beh_b_5 of BlockC is
	signal cl_7_o_req, cl_7_o_ack : std_logic;signal cl_7_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= cl_7_o_req; 
cl_7_o_ack <= out_ack; 
out_data <= cl_7_data; 

CL_7: entity work.funcBlock(beh_cl_7)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => in_req,
	  in_ack  => in_ack, 
	  in_data => in_data,
	  -- Output channel
	  out_req => cl_7_o_req,
	  out_ack => cl_7_o_ack,
	  out_data  => cl_7_data
	);
	end beh_b_5;
	architecture beh_b_3 of BlockC is
	signal if_1_o_req, if_1_o_ack : std_logic;signal if_1_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= if_1_o_req; 
if_1_o_ack <= out_ack; 
out_data <= if_1_data; 

IF_1: entity work.IfBlock(beh_if_1)
  generic map(
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    rst => rst,
    in_ack => in_ack,
    in_req => in_req,
    in_data => in_data,
    -- Output channel
    out_req => if_1_o_req,
    out_data => if_1_data,
    out_ack => if_1_o_ack
  );
  end beh_b_3;
	architecture beh_lb_0 of LoopBlock is
	signal if_1_o_req, if_1_o_ack : std_logic;signal if_1_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal mx_0_o_req, mx_0_o_ack : std_logic;signal mx_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal rf_0_b_o_req, rf_0_b_o_ack : std_logic;signal rf_0_b_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal rf_0_c_o_req, rf_0_c_o_ack : std_logic;signal rf_0_c_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal se_1_o_req, se_1_o_ack : std_logic;signal se_1_select: std_logic_vector(1-1 downto 0);
signal f_2_b_o_req, f_2_b_o_ack : std_logic;
signal f_2_c_o_req, f_2_c_o_ack : std_logic;
signal lb_0_o_req, lb_0_o_ack : std_logic;signal lb_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal dx_4_c_o_req, dx_4_c_o_ack : std_logic;signal dx_4_c_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal r_4_o_req, r_4_o_ack : std_logic;signal r_4_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal r_3_o_req, r_3_o_ack : std_logic;signal r_3_data : std_logic_vector(0 downto 0);

begin
out_req <= lb_0_o_req; 
lb_0_o_ack <= out_ack; 
out_data <= lb_0_data; 

MX_0: entity work.mux
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    inA_ack => in_ack,
    inA_data => in_data,
    inA_req => in_req,
    inB_ack => if_1_o_ack,
    inB_data => if_1_data,
    inB_req => if_1_o_req,
    outC_ack => mx_0_o_ack,
    outC_data => mx_0_data,
    outC_req => mx_0_o_req,
    rst => rst,
    inSel_ack => r_3_o_ack,
    inSel_req => r_3_o_req,
    selector => r_3_data
  );
  
RF_0: entity work.reg_fork
  generic map(
    DATA_WIDTH => DATA_WIDTH,
    PHASE_INIT_A => '0',
    PHASE_INIT_B =>'0',
    PHASE_INIT_C => '0')
  port map (
    inA_ack => mx_0_o_ack,
    inA_data => mx_0_data,
    inA_req => mx_0_o_req,
    outB_ack => rf_0_b_o_ack,
    outB_data => rf_0_b_data,
    outB_req => rf_0_b_o_req,
    outC_ack => rf_0_c_o_ack,
    outC_data=> rf_0_c_data,
    outC_req => rf_0_c_o_req,
    rst => rst
  );
SE_1: entity work.Selector(beh_se_1)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => rf_0_b_o_req,
	  in_ack  => rf_0_b_o_ack, 
	  in_data => rf_0_b_data,
	  -- Output channel
	  out_req => se_1_o_req,
	  out_ack => se_1_o_ack,
	  selector  => se_1_select
	);
F_2: entity work.fork
  generic map(
    DATA_WIDTH => 1,
    PHASE_INIT => '0'
  )
  port map(
    inA_ack => se_1_o_ack,
    inA_req => se_1_o_req,
    inA_data => se_1_select,
    -- Output Channel
    outB_ack => f_2_b_o_ack,
    outB_req => f_2_b_o_req,
    outB_data => open,
    outC_ack => f_2_c_o_ack,
    outC_req => f_2_c_o_req,
    outC_data => open,
    rst => rst
  );
    
R_3: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => 1,
    VALUE => 1,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '1'
  )
  port map (
    rst => rst,
    in_ack => f_2_b_o_ack,
    in_req => f_2_b_o_req,
    in_data => se_1_select,
    -- Output channel
    out_req => r_3_o_req,
    out_data => r_3_data,
    out_ack => r_3_o_ack
  );
  
DX_4: entity work.demux
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    inA_ack => rf_0_c_o_ack,
    inA_data => rf_0_c_data,
    inA_req => rf_0_c_o_req,
    outB_ack => lb_0_o_ack,
    outB_data => lb_0_data,
    outB_req => lb_0_o_req,
    outC_ack => dx_4_c_o_ack,
    outC_data => dx_4_c_data,
    outC_req => dx_4_c_o_req,
    rst => rst,
    inSel_ack => f_2_c_o_ack,
    inSel_req => f_2_c_o_req,
    selector => se_1_select
  );
   
R_4: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => DATA_WIDTH,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
  )
  port map (
    rst => rst,
    in_ack => dx_4_c_o_ack,
    in_req => dx_4_c_o_req,
    in_data => dx_4_c_data,
    -- Output channel
    out_req => r_4_o_req,
    out_data => r_4_data,
    out_ack => r_4_o_ack
  );
  
B_3: entity work.BlockC(beh_b_3)
  generic map(
   DATA_WIDTH => DATA_WIDTH
  )
  port map (
   rst => rst,
   in_ack => r_4_o_ack,
   in_req => r_4_o_req,
   in_data => r_4_data,
   -- Output channel
   out_req => if_1_o_req,
   out_data => if_1_data,
   out_ack => if_1_o_ack
  );
  
end beh_lb_0;
	architecture beh_b_2 of BlockC is
	signal cl_4_o_req, cl_4_o_ack : std_logic;signal cl_4_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= cl_4_o_req; 
cl_4_o_ack <= out_ack; 
out_data <= cl_4_data; 

CL_4: entity work.funcBlock(beh_cl_4)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => in_req,
	  in_ack  => in_ack, 
	  in_data => in_data,
	  -- Output channel
	  out_req => cl_4_o_req,
	  out_ack => cl_4_o_ack,
	  out_data  => cl_4_data
	);
	end beh_b_2;
	architecture beh_cl_5 of funcBlock is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 32 - 1 downto 16);
alias y      : std_logic_vector(8 - 1 downto 0)  is in_data( 8 - 1 downto 0);
alias result : std_logic_vector(16 - 1 downto 0)  is out_data( 32 - 1 downto 16);

	  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, result: signal is "true";
	  
    --attribute keep : boolean;
	--attribute keep of  x, y, result: signal is true;
  begin
    in_ack <= out_ack;
    
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
	  );
	  

	  calc: process(all)
	variable offset: integer range 0 to out_data'length;
	begin
	out_data <= in_data; 
	result <= std_logic_vector(resize(unsigned(x) + unsigned(y), result'length))  after ADDER_DELAY;

	end process;
  end beh_cl_5;
  architecture beh_cl_7 of funcBlock is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 48 - 1 downto 32);
alias y      : std_logic_vector(8 - 1 downto 0)  is in_data( 16 - 1 downto 8);
alias result : std_logic_vector(16 - 1 downto 0)  is out_data( 48 - 1 downto 32);

	  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, result: signal is "true";
	  
    --attribute keep : boolean;
	--attribute keep of  x, y, result: signal is true;
  begin
    in_ack <= out_ack;
    
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
	  );
	  

	  calc: process(all)
	variable offset: integer range 0 to out_data'length;
	begin
	out_data <= in_data; 
	result <= std_logic_vector(resize(unsigned(x) + unsigned(y), result'length))  after ADDER_DELAY;

	end process;
  end beh_cl_7;
  architecture beh_se_2 of Selector is
	alias x      : std_logic_vector(16 - 1 downto 0)  is in_data( 32 - 1 downto 16);
alias y      : std_logic_vector(16 - 1 downto 0)  is in_data( 48 - 1 downto 32);

  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, selector: signal is "true";
	
	--attribute keep : boolean;
	--attribute keep of  x, y, selector: signal is true;
  begin
  
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
      );
  
    in_ack <= out_ack;
    
    selector(0) <= '1' when unsigned(x) < unsigned(y) else '0';


  end beh_se_2;
  architecture beh_b_4 of BlockC is
	signal cl_5_o_req, cl_5_o_ack : std_logic;signal cl_5_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= cl_5_o_req; 
cl_5_o_ack <= out_ack; 
out_data <= cl_5_data; 

CL_5: entity work.funcBlock(beh_cl_5)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => in_req,
	  in_ack  => in_ack, 
	  in_data => in_data,
	  -- Output channel
	  out_req => cl_5_o_req,
	  out_ack => cl_5_o_ack,
	  out_data  => cl_5_data
	);
	end beh_b_4;
	architecture beh_cl_1 of funcBlock is
	alias x      : std_logic_vector(8 - 1 downto 0)  is in_data( 16 - 1 downto 8);
alias result : std_logic_vector(16 - 1 downto 0)  is out_data( 48 - 1 downto 32);

	  
    --attribute dont_touch : string;
	--attribute dont_touch of  x, y, result: signal is "true";
	  
    --attribute keep : boolean;
	--attribute keep of  x, y, result: signal is true;
  begin
    in_ack <= out_ack;
    
    delay_req: entity work.delay_element
      generic map(
        NUM_LCELLS => ADD_DELAY  -- Delay  size
      )
      port map (
        i => in_req,
        o => out_req
	  );
	  

	  calc: process(all)
	variable offset: integer range 0 to out_data'length;
	begin
	out_data <= in_data; 
	result <= std_logic_vector(resize(unsigned(x)  , result'length)) ;

	end process;
  end beh_cl_1;
  architecture beh_b_1 of BlockC is
	signal cl_2_o_req, cl_2_o_ack : std_logic;signal cl_2_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= cl_2_o_req; 
cl_2_o_ack <= out_ack; 
out_data <= cl_2_data; 

CL_2: entity work.funcBlock(beh_cl_2)
	generic map(
	  DATA_WIDTH => DATA_WIDTH
	)
	port map (
	  -- Input channel
	  in_req  => in_req,
	  in_ack  => in_ack, 
	  in_data => in_data,
	  -- Output channel
	  out_req => cl_2_o_req,
	  out_ack => cl_2_o_ack,
	  out_data  => cl_2_data
	);
	end beh_b_1;
	architecture LCM of Scope is
	signal lb_0_o_req, lb_0_o_ack : std_logic;signal lb_0_data: std_logic_vector(DATA_WIDTH -1 downto 0);
signal r_6_o_req, r_6_o_ack : std_logic;signal r_6_data: std_logic_vector(DATA_WIDTH -1 downto 0);

begin
out_req <= r_6_o_req; 
r_6_o_ack <= out_ack; 
out_data <= r_6_data(32 -1 downto 16);

B_0: entity work.BlockC(beh_b_0)
  generic map(
   DATA_WIDTH => DATA_WIDTH
  )
  port map (
   rst => rst,
   in_ack => in_ack,
   in_req => in_req,
   in_data => std_logic_vector(resize(unsigned(in_data), DATA_WIDTH)),
   -- Output channel
   out_req => lb_0_o_req,
   out_data => lb_0_data,
   out_ack => lb_0_o_ack
  );
  
R_6: entity work.decoupled_hs_reg(behavioural)
  generic map (
    DATA_WIDTH => DATA_WIDTH,
    VALUE => 0,
    PHASE_INIT_IN => '0',
    PHASE_INIT_OUT => '0'
  )
  port map (
    rst => rst,
    in_ack => lb_0_o_ack,
    in_req => lb_0_o_req,
    in_data => lb_0_data,
    -- Output channel
    out_req => r_6_o_req,
    out_data => r_6_data,
    out_ack => r_6_o_ack
  );
  
end LCM;
	