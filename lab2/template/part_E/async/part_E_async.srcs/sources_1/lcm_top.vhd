
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity top is
  generic(
    valA : natural := 50_171;
    valB : natural := 59_299;
    DATA_WIDTH_IF : natural := 32
    );
  port(
    clk, res, rx : in std_logic;
    start_switch : in std_logic;
    error_led, heartbeat_led : out std_logic;
    dbg_led1, dbg_led2 : out std_logic;
    tx : out std_logic
    );
end entity;


architecture beh of top is
  constant US_WIDTH : natural := 16;
  signal i_req, i_req_delayed, i_ack, i_ack_inv, i_ack_del, o_req, o_ack, o_ack_del : std_logic;
  signal res_n, res_syn, res_syn_n : std_logic; -- debounced reset
  signal result : std_logic_vector ( DATA_WIDTH_IF-1 downto 0 );
  signal A, B : std_logic_vector ( DATA_WIDTH_IF/2-1 downto 0 );
  signal result_out : std_logic_vector(31 downto 0);
  signal proc_time : std_logic_vector(US_WIDTH-1 downto 0);
  signal o_req_sync : std_logic_vector(2 downto 0);
  signal lcm_dbg : std_logic_vector(7 downto 0);
  signal start_switch_syn : std_logic;
  signal us_counter : unsigned (US_WIDTH-1 downto 0);
  signal last_btn : std_logic;
  signal start_signal : std_logic;

  constant CLK_FREQ : natural := 125_000_000;
begin
  res_n <= not res;

  dbg_led1 <= result(0);
  dbg_led2 <= result(1);

  debounce_inst : entity work.debounce
    port map(
      clk   => clk,
      res_n => '1',
      data_in => res_n,
      data_out => res_syn_n
    );

  debounce_start : entity work.debounce
    port map(
      clk   => clk,
      res_n => res_syn_n,
      data_in =>  start_switch,
      data_out => start_switch_syn
    );

  A <= std_logic_vector(to_unsigned(valA,DATA_WIDTH_IF/2));
  B <= std_logic_vector(to_unsigned(valB,DATA_WIDTH_IF/2));
  res_syn <= not res_syn_n;

  i_ack_inv <= not i_ack;
  i_req <= i_ack_del and res_syn_n and start_switch_syn;

  ireq_delay : entity work.delay_element
  generic map (size => 25)
  port map (d => i_req, z => i_req_delayed);

  ra_in : entity work.delay_element
  generic map (size=>25)
  port map (d => i_ack_inv, z => i_ack_del);

  lcm_inst: entity work.lcm
    generic map(
      DATA_WIDTH => DATA_WIDTH_IF
    )
    port map(
      A => A,
      B => B,
      rst => res_syn,
      i_req => i_req,
      i_ack => i_ack,
      result => result,
      o_req => o_req,
      o_ack => o_ack,
      lcm_dbg => lcm_dbg
    );

  measurement : process(res_syn_n, clk)
    variable start_time  : unsigned (US_WIDTH-1 downto 0);
  begin
    if res_syn_n= '0' then
      error_led <= '0';
      proc_time <= (others => '0');
      result_out <= (others => '0');
      start_time := (others => '0');
      o_req_sync <= (others => '0');
      last_btn <= '0';
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

  ra_out : entity work.delay_element
  generic map (size=>25)
  port map (d => o_req_sync(2), z => o_ack_del);

  o_ack <= o_ack_del and res_syn_n;

 -------------------------------------------------


    timeMeas : process (res_syn_n, clk)
        variable localCnt : natural := 0;
    begin
        if res_syn_n = '0' then
          us_counter <= (others => '0');
          localCnt := 0;
        elsif rising_edge(clk) then

            -- clk frequency is 125MHz
            if localCnt = CLK_FREQ/1_000_000 then
                localCnt := 0;

                -- intentional overflow
                us_counter <= us_counter + 1;
            else
                localCnt := localCnt +1;
            end if;
        end if;
    end process;

 -------------------------------------------------

    heartbeat_proc : process (res_syn_n, clk)
        variable heartbeat : natural ;
    begin
        if res_syn_n= '0' then
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

  comm : entity work.control_port
  generic map (CLK_FREQ => CLK_FREQ, BAUD_RATE => 9600)
  port map (
      clk  => clk,
      res_n => res_syn_n,
      rx  => rx,
      tx  => tx,
      proc_time => std_logic_vector(resize(unsigned(proc_time), 32)),
      result => result_out,
      int_result => result,
      dbg2 => std_logic_vector(resize(us_counter, 32)),
      ctrl => i_req & i_ack & o_req & o_ack,
      lcm_dbg => lcm_dbg
  );

  --ctrl : in std_logic_vector(3 downto 0);
  --dbg1 : in std_logic_vector(31 downto 0);
  --dbg2 : in std_logic_vector(31 downto 0);
  --input_stream_data : in std_logic_vector(7 downto 0);
  --input_stream_wr : in std_logic;
  --input_stream_full : out std_logic

end architecture;
