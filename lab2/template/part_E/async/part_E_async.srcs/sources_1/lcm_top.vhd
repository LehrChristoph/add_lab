
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;
use work.defs.all;

entity top is
  generic(
    valA : natural := 50_171;
    valB : natural := 59_299
    );
  port(
    clk, res, rx : in std_logic;
    error_led, heartbeat_led : out std_logic;
    tx : out std_logic
    );
end entity;


architecture beh of top is

  component lcm is
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
  end component;
  
  component delay_element  is
    generic(
      size  : natural range 1 to 30 := 10); -- Delay  size
    port (
      d     : in std_logic; -- Data  in
      z     : out std_logic);
  end  component;  

    component control_port is
        generic(
            CLK_FREQ      : integer;
            BAUD_RATE     : integer := 9600
        );
        port (
            clk   : in std_logic;
            res_n : in std_logic;
            rx    : in std_logic;
            tx    : out std_logic;
		proc_time : in std_logic_vector(15 downto 0);
		  result : in std_logic_vector(31 downto 0);
                  ctrl : in std_logic_vector(3 downto 0)           
        );
    end component;

  signal res_n, i_req, i_ack, i_ack_inv, i_ack_del, o_req, o_ack, o_ack_del : std_logic;
  signal result : std_logic_vector ( DATA_WIDTH_IF-1 downto 0 );
  signal A, B : std_logic_vector ( DATA_WIDTH_IF/2-1 downto 0 );
  signal result_out : std_logic_vector(31 downto 0);
  signal proc_time : std_logic_vector(15 downto 0);
  signal o_req_sync : std_logic_vector(2 downto 0);
  
  constant US_WIDTH : natural := 16;
  signal us_counter : unsigned (US_WIDTH-1 downto 0);
  
  constant CLK_FREQ : natural := 125_000_000;  
begin
  
  A <= std_logic_vector(to_unsigned(valA,DATA_WIDTH_IF/2));
  B <= std_logic_vector(to_unsigned(valB,DATA_WIDTH_IF/2));
  res_n <= not res;
  
  i_ack_inv <= not i_ack;
  i_req <= i_ack_del and res_n;
  
  ra_in : delay_element
  generic map (size=>25)
  port map (d => i_ack_inv, z => i_ack_del);
  
  lcm_inst: lcm
    port map(
      A => A,
      B => B,
      rst => res,
      i_req => i_req,
      i_ack => i_ack,
      result => result,
      o_req => o_req,
      o_ack => o_ack
    );

  measurement : process(res_n, clk)
    variable start_time  : unsigned (US_WIDTH-1 downto 0);
  begin
    if res_n= '0' then
      error_led <= '0';
      proc_time <= (others => '0');
      result_out <= (others => '0');
      start_time := (others => '0');
      o_req_sync <= (others => o_req); 
      
    elsif rising_edge(clk) then
      o_req_sync(2) <= o_req_sync(1);
      o_req_sync(1) <= o_req_sync(0);
      o_req_sync(0) <= o_req;   
    
      if o_req_sync(2) /= o_req_sync(1) then
      
        if (result /= x"B15445D1") then
            error_led <= '1';
            result_out <= result;
        end if;
             
        -- this should also deliver the correct result when us_counter overflowed     
        proc_time <= std_logic_vector(us_counter - start_time);
        
        start_time := us_counter;        

      end if;
           
    end if;
  end process;
  
  ra_out : delay_element
  generic map (size=>25)
  port map (d => o_req_sync(2), z => o_ack_del);
  
  o_ack <= o_ack_del and res_n;
  
 -------------------------------------------------
  
  
    timeMeas : process (res_n, clk)
        variable localCnt : natural := 0;
    begin
        if res_n = '0' then
          us_counter <= (others => '0');
          localCnt := 0;
        elsif rising_edge(clk) then
            
            -- clk frequency is 125MHz
            if localCnt = 125 then
                localCnt := 0;
                
                -- intentional overflow
                us_counter <= us_counter + 1;
            else
                localCnt := localCnt +1;
            end if;
        end if;
    end process;
    
 -------------------------------------------------
    
    heartbeat_proc : process (res_n, clk)
        variable heartbeat : natural ;
    begin
        if res_n= '0' then
          heartbeat_led <= '0';
          heartbeat := 0;
        elsif rising_edge(clk) then
  
          heartbeat := heartbeat +1;
  
          if heartbeat = CLK_FREQ/2 then
            heartbeat_led <= '1';
          elsif heartbeat = CLK_FREQ then
            heartbeat_led <= '0';
            heartbeat := 0;
          end if;
  
        end if;
      end process;

 -------------------------------------------------
            
  comm : control_port
  generic map (CLK_FREQ => CLK_FREQ, BAUD_RATE => 9600)
  port map (
      clk  => clk,
      res_n => res_n,
      rx  => rx,
      tx  => tx,
      proc_time => proc_time,
      result => result_out,
      ctrl => i_req & i_ack & o_req & o_ack
  );
  
end architecture;
