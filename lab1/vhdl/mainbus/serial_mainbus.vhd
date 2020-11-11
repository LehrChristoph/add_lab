library ieee;
use ieee.std_logic_1164.all;

entity serial_mainbus is
  generic
  (
    CLK_FREQ : integer
  );
  port
  (
    clk, res_n       : in    std_logic;

    serial_data_out : out   std_logic_vector(7 downto 0);
    serial_data_in  : in    std_logic_vector(7 downto 0);
    serial_new_data : in    std_logic;
    serial_free     : in    std_logic;
    serial_wr       : out   std_logic;

    bus_data_out    : out   std_logic_vector(31 downto 0);
    bus_data_in     : in    std_logic_vector(31 downto 0);
    bus_address     : out   std_logic_vector(31 downto 0);
    bus_rd          : out   std_logic;
    bus_wr          : out   std_logic;
    bus_done        : in    std_logic
  );
end entity serial_mainbus;


architecture beh of serial_mainbus is
  constant TIME_OUT_CNT_MAX : integer := CLK_FREQ / 10000;

  type CONTROLLER_STATE_TYPE is (STATE_IDLE, STATE_UNKNOWN_REQUEST_WAIT, STATE_UNKNOWN_REQUEST_WRITE,
                                 STATE_TIMEOUT_WAIT, STATE_TIMEOUT_WRITE,

                                 STATE_READ_DWORD_ADDR_WAIT_0, STATE_READ_DWORD_ADDR_READ_0,
                                 STATE_READ_DWORD_ADDR_WAIT_1, STATE_READ_DWORD_ADDR_READ_1,
                                 STATE_READ_DWORD_ADDR_WAIT_2, STATE_READ_DWORD_ADDR_READ_2,
                                 STATE_READ_DWORD_ADDR_WAIT_3, STATE_READ_DWORD_ADDR_READ_3,
                                 STATE_READ_DWORD_EXECUTE_ASSERT_RD, STATE_READ_DWORD_EXECUTE_WAIT_DATA_VALID,
                                 STATE_READ_DWORD_WAIT_WRITE_OK, STATE_READ_DWORD_WRITE_OK,
                                 STATE_READ_DWORD_WAIT_WRITE_VALUE_0, STATE_READ_DWORD_WRITE_VALUE_0,
                                 STATE_READ_DWORD_WAIT_WRITE_VALUE_1, STATE_READ_DWORD_WRITE_VALUE_1,
                                 STATE_READ_DWORD_WAIT_WRITE_VALUE_2, STATE_READ_DWORD_WRITE_VALUE_2,
                                 STATE_READ_DWORD_WAIT_WRITE_VALUE_3, STATE_READ_DWORD_WRITE_VALUE_3,

                                 STATE_WRITE_DWORD_ADDR_WAIT_0, STATE_WRITE_DWORD_ADDR_READ_0,
                                 STATE_WRITE_DWORD_ADDR_WAIT_1, STATE_WRITE_DWORD_ADDR_READ_1,
                                 STATE_WRITE_DWORD_ADDR_WAIT_2, STATE_WRITE_DWORD_ADDR_READ_2,
                                 STATE_WRITE_DWORD_ADDR_WAIT_3, STATE_WRITE_DWORD_ADDR_READ_3,
                                 STATE_WRITE_DWORD_VALUE_WAIT_0, STATE_WRITE_DWORD_VALUE_0,
                                 STATE_WRITE_DWORD_VALUE_WAIT_1, STATE_WRITE_DWORD_VALUE_1,
                                 STATE_WRITE_DWORD_VALUE_WAIT_2, STATE_WRITE_DWORD_VALUE_2,
                                 STATE_WRITE_DWORD_VALUE_WAIT_3, STATE_WRITE_DWORD_VALUE_3,
                                 STATE_WRITE_DWORD_EXECUTE_ASSERT_WR, STATE_WRITE_DWORD_EXECUTE_WAIT_FINISHED,
                                 STATE_WRITE_DWORD_WAIT_WRITE_OK, STATE_WRITE_DWORD_WRITE_OK
                                 );

  signal controller_state, controller_state_next : CONTROLLER_STATE_TYPE;

  signal serial_data_out_next, serial_data_out_internal : std_logic_vector(7 downto 0);

  signal bus_data_latched : std_logic_vector(31 downto 0);
  signal bus_data_internal, bus_data_next : std_logic_vector(31 downto 0);
  signal bus_address_next, bus_address_internal : std_logic_vector(31 downto 0);
  signal bus_wr_internal : std_logic;
  signal time_out_cnt, time_out_cnt_next : integer range 0 to TIME_OUT_CNT_MAX;
begin
  serial_data_out <= serial_data_out_internal;
  bus_address <= bus_address_internal;
  bus_data_out <= bus_data_internal;
  bus_wr <= bus_wr_internal;

  process(clk, res_n)
  begin
    if res_n = '0' then
      bus_data_latched <= (others => '0');
    elsif rising_edge(clk) then
      if bus_done = '1' then
        bus_data_latched <= bus_data_in;
      end if;
    end if;
  end process;

  controller_next_state : process(controller_state, serial_data_in, serial_new_data, serial_free, bus_done, time_out_cnt)
  begin
    controller_state_next <= controller_state;

    case controller_state is
      when STATE_IDLE =>
        if serial_new_data = '0' then
          null;
        elsif serial_data_in = x"A0" then
          controller_state_next <= STATE_READ_DWORD_ADDR_WAIT_0;
        elsif serial_data_in = x"B0" then
          controller_state_next <= STATE_WRITE_DWORD_ADDR_WAIT_0;
        else
          controller_state_next <= STATE_UNKNOWN_REQUEST_WAIT;
        end if;


      when STATE_READ_DWORD_ADDR_WAIT_0 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_READ_DWORD_ADDR_READ_0;
        end if;
      when STATE_READ_DWORD_ADDR_READ_0 =>
        controller_state_next <= STATE_READ_DWORD_ADDR_WAIT_1;
      when STATE_READ_DWORD_ADDR_WAIT_1 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_READ_DWORD_ADDR_READ_1;
        end if;
      when STATE_READ_DWORD_ADDR_READ_1 =>
        controller_state_next <= STATE_READ_DWORD_ADDR_WAIT_2;
      when STATE_READ_DWORD_ADDR_WAIT_2 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_READ_DWORD_ADDR_READ_2;
        end if;
      when STATE_READ_DWORD_ADDR_READ_2 =>
        controller_state_next <= STATE_READ_DWORD_ADDR_WAIT_3;
      when STATE_READ_DWORD_ADDR_WAIT_3 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_READ_DWORD_ADDR_READ_3;
        end if;
      when STATE_READ_DWORD_ADDR_READ_3 =>
        controller_state_next <= STATE_READ_DWORD_EXECUTE_ASSERT_RD;

      when STATE_READ_DWORD_EXECUTE_ASSERT_RD =>
        controller_state_next <= STATE_READ_DWORD_EXECUTE_WAIT_DATA_VALID;
      when STATE_READ_DWORD_EXECUTE_WAIT_DATA_VALID =>
        if bus_done = '1' then
          controller_state_next <= STATE_READ_DWORD_WAIT_WRITE_OK;
        end if;
        if time_out_cnt = TIME_OUT_CNT_MAX then
          controller_state_next <= STATE_TIMEOUT_WAIT;
        end if;
      when STATE_READ_DWORD_WAIT_WRITE_OK =>
        if serial_free = '1' then
          controller_state_next <= STATE_READ_DWORD_WRITE_OK;
        end if;
      when STATE_READ_DWORD_WRITE_OK =>
        controller_state_next <= STATE_READ_DWORD_WAIT_WRITE_VALUE_0;
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_0 =>
        if serial_free = '1' then
          controller_state_next <= STATE_READ_DWORD_WRITE_VALUE_0;
        end if;
      when STATE_READ_DWORD_WRITE_VALUE_0 =>
        controller_state_next <= STATE_READ_DWORD_WAIT_WRITE_VALUE_1;
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_1 =>
        if serial_free = '1' then
          controller_state_next <= STATE_READ_DWORD_WRITE_VALUE_1;
        end if;
      when STATE_READ_DWORD_WRITE_VALUE_1 =>
        controller_state_next <= STATE_READ_DWORD_WAIT_WRITE_VALUE_2;
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_2 =>
        if serial_free = '1' then
          controller_state_next <= STATE_READ_DWORD_WRITE_VALUE_2;
        end if;
      when STATE_READ_DWORD_WRITE_VALUE_2 =>
        controller_state_next <= STATE_READ_DWORD_WAIT_WRITE_VALUE_3;
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_3 =>
        if serial_free = '1' then
          controller_state_next <= STATE_READ_DWORD_WRITE_VALUE_3;
        end if;
      when STATE_READ_DWORD_WRITE_VALUE_3 =>
        controller_state_next <= STATE_IDLE;



      when STATE_WRITE_DWORD_ADDR_WAIT_0 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_ADDR_READ_0;
        end if;
      when STATE_WRITE_DWORD_ADDR_READ_0 =>
        controller_state_next <= STATE_WRITE_DWORD_ADDR_WAIT_1;
      when STATE_WRITE_DWORD_ADDR_WAIT_1 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_ADDR_READ_1;
        end if;
      when STATE_WRITE_DWORD_ADDR_READ_1 =>
        controller_state_next <= STATE_WRITE_DWORD_ADDR_WAIT_2;
      when STATE_WRITE_DWORD_ADDR_WAIT_2 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_ADDR_READ_2;
        end if;
      when STATE_WRITE_DWORD_ADDR_READ_2 =>
        controller_state_next <= STATE_WRITE_DWORD_ADDR_WAIT_3;
      when STATE_WRITE_DWORD_ADDR_WAIT_3 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_ADDR_READ_3;
        end if;
      when STATE_WRITE_DWORD_ADDR_READ_3 =>
        controller_state_next <= STATE_WRITE_DWORD_VALUE_WAIT_0;
      when STATE_WRITE_DWORD_VALUE_WAIT_0 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_VALUE_0;
        end if;
      when STATE_WRITE_DWORD_VALUE_0 =>
        controller_state_next <= STATE_WRITE_DWORD_VALUE_WAIT_1;
      when STATE_WRITE_DWORD_VALUE_WAIT_1 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_VALUE_1;
        end if;
      when STATE_WRITE_DWORD_VALUE_1 =>
        controller_state_next <= STATE_WRITE_DWORD_VALUE_WAIT_2;
      when STATE_WRITE_DWORD_VALUE_WAIT_2 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_VALUE_2;
        end if;
      when STATE_WRITE_DWORD_VALUE_2 =>
        controller_state_next <= STATE_WRITE_DWORD_VALUE_WAIT_3;
      when STATE_WRITE_DWORD_VALUE_WAIT_3 =>
        if serial_new_data = '1' then
          controller_state_next <= STATE_WRITE_DWORD_VALUE_3;
        end if;
      when STATE_WRITE_DWORD_VALUE_3 =>
        controller_state_next <= STATE_WRITE_DWORD_EXECUTE_ASSERT_WR;

      when STATE_WRITE_DWORD_EXECUTE_ASSERT_WR =>
        controller_state_next <= STATE_WRITE_DWORD_EXECUTE_WAIT_FINISHED;
      when STATE_WRITE_DWORD_EXECUTE_WAIT_FINISHED =>
        if bus_done = '1' then
          controller_state_next <= STATE_WRITE_DWORD_WAIT_WRITE_OK;
        end if;
        if time_out_cnt = TIME_OUT_CNT_MAX then
          controller_state_next <= STATE_TIMEOUT_WAIT;
        end if;

      when STATE_WRITE_DWORD_WAIT_WRITE_OK =>
        if serial_free = '1' then
          controller_state_next <= STATE_WRITE_DWORD_WRITE_OK;
        end if;
      when STATE_WRITE_DWORD_WRITE_OK =>
        controller_state_next <= STATE_IDLE;



      when STATE_UNKNOWN_REQUEST_WAIT =>
        if serial_free = '1' then
          controller_state_next <= STATE_UNKNOWN_REQUEST_WRITE;
        end if;
      when STATE_UNKNOWN_REQUEST_WRITE =>
        controller_state_next <= STATE_IDLE;
      when STATE_TIMEOUT_WAIT =>
        if serial_free = '1' then
          controller_state_next <= STATE_TIMEOUT_WRITE;
        end if;
      when STATE_TIMEOUT_WRITE =>
        controller_state_next <= STATE_IDLE;
      when others =>
        null;
    end case;
  end process controller_next_state;

  controller_output : process(controller_state, serial_data_out_internal, bus_data_latched, serial_data_in, bus_address_internal, bus_data_internal, time_out_cnt)
  begin
    serial_wr <= '0';
    serial_data_out_next <= serial_data_out_internal;

    bus_wr_internal <= '0';
    bus_rd <= '0';
    bus_address_next <= bus_address_internal;
    bus_data_next <= bus_data_internal;

    time_out_cnt_next <= time_out_cnt;

    case controller_state is
      when STATE_IDLE =>
        null;


      when STATE_READ_DWORD_ADDR_WAIT_0 =>
        null;
      when STATE_READ_DWORD_ADDR_READ_0 =>
        bus_address_next(7 downto 0) <= serial_data_in;
      when STATE_READ_DWORD_ADDR_WAIT_1 =>
        null;
      when STATE_READ_DWORD_ADDR_READ_1 =>
        bus_address_next(15 downto 8) <= serial_data_in;
      when STATE_READ_DWORD_ADDR_WAIT_2 =>
        null;
      when STATE_READ_DWORD_ADDR_READ_2 =>
        bus_address_next(23 downto 16) <= serial_data_in;
      when STATE_READ_DWORD_ADDR_WAIT_3 =>
        null;
      when STATE_READ_DWORD_ADDR_READ_3 =>
        bus_address_next(31 downto 24) <= serial_data_in;

      when STATE_READ_DWORD_EXECUTE_ASSERT_RD =>
        bus_rd <= '1';
        time_out_cnt_next <= 0;
      when STATE_READ_DWORD_EXECUTE_WAIT_DATA_VALID =>
        if time_out_cnt < TIME_OUT_CNT_MAX then
          time_out_cnt_next <= time_out_cnt + 1;
        end if;

      when STATE_READ_DWORD_WAIT_WRITE_OK =>
        serial_data_out_next <= x"00";
      when STATE_READ_DWORD_WRITE_OK =>
        serial_wr <= '1';
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_0 =>
        serial_data_out_next <= bus_data_latched(7 downto 0);
      when STATE_READ_DWORD_WRITE_VALUE_0 =>
        serial_wr <= '1';
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_1 =>
        serial_data_out_next <= bus_data_latched(15 downto 8);
      when STATE_READ_DWORD_WRITE_VALUE_1 =>
        serial_wr <= '1';
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_2 =>
        serial_data_out_next <= bus_data_latched(23 downto 16);
      when STATE_READ_DWORD_WRITE_VALUE_2 =>
        serial_wr <= '1';
      when STATE_READ_DWORD_WAIT_WRITE_VALUE_3 =>
        serial_data_out_next <= bus_data_latched(31 downto 24);
      when STATE_READ_DWORD_WRITE_VALUE_3 =>
        serial_wr <= '1';


      when STATE_WRITE_DWORD_ADDR_WAIT_0 =>
        null;
      when STATE_WRITE_DWORD_ADDR_READ_0 =>
        bus_address_next(7 downto 0) <= serial_data_in;
      when STATE_WRITE_DWORD_ADDR_WAIT_1 =>
        null;
      when STATE_WRITE_DWORD_ADDR_READ_1 =>
        bus_address_next(15 downto 8) <= serial_data_in;
      when STATE_WRITE_DWORD_ADDR_WAIT_2 =>
        null;
      when STATE_WRITE_DWORD_ADDR_READ_2 =>
        bus_address_next(23 downto 16) <= serial_data_in;
      when STATE_WRITE_DWORD_ADDR_WAIT_3 =>
        null;
      when STATE_WRITE_DWORD_ADDR_READ_3 =>
        bus_address_next(31 downto 24) <= serial_data_in;
      when STATE_WRITE_DWORD_VALUE_WAIT_0 =>
        null;
      when STATE_WRITE_DWORD_VALUE_0 =>
        bus_data_next(7 downto 0) <= serial_data_in;
      when STATE_WRITE_DWORD_VALUE_WAIT_1 =>
        null;
      when STATE_WRITE_DWORD_VALUE_1 =>
        bus_data_next(15 downto 8) <= serial_data_in;
      when STATE_WRITE_DWORD_VALUE_WAIT_2 =>
        null;
      when STATE_WRITE_DWORD_VALUE_2 =>
        bus_data_next(23 downto 16) <= serial_data_in;
      when STATE_WRITE_DWORD_VALUE_WAIT_3 =>
        null;
      when STATE_WRITE_DWORD_VALUE_3 =>
        bus_data_next(31 downto 24) <= serial_data_in;

      when STATE_WRITE_DWORD_EXECUTE_ASSERT_WR =>
        bus_wr_internal <= '1';
        time_out_cnt_next <= 0;
      when STATE_WRITE_DWORD_EXECUTE_WAIT_FINISHED =>
        if time_out_cnt < TIME_OUT_CNT_MAX then
          time_out_cnt_next <= time_out_cnt + 1;
        end if;

      when STATE_WRITE_DWORD_WAIT_WRITE_OK =>
        serial_data_out_next <= x"00";
      when STATE_WRITE_DWORD_WRITE_OK =>
        serial_wr <= '1';


      when STATE_UNKNOWN_REQUEST_WAIT =>
        serial_data_out_next <= x"01";
      when STATE_UNKNOWN_REQUEST_WRITE =>
        serial_wr <= '1';
      when STATE_TIMEOUT_WAIT =>
        serial_data_out_next <= x"03";
      when STATE_TIMEOUT_WRITE =>
        serial_wr <= '1';
    end case;
  end process controller_output;

  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      controller_state <= STATE_IDLE;
      serial_data_out_internal <= (others => '0');
      bus_address_internal <= (others => '0');
      bus_data_internal <= (others => '0');
      time_out_cnt <= 0;
    elsif rising_edge(clk) then
      controller_state <= controller_state_next;
      serial_data_out_internal <= serial_data_out_next;
      bus_address_internal <= bus_address_next;
      bus_data_internal <= bus_data_next;
      time_out_cnt <= time_out_cnt_next;
    end if;
  end process sync;

end architecture beh;
