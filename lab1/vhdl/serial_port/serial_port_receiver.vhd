library ieee;
use ieee.std_logic_1164.all;

entity serial_port_receiver is
  generic
  (
    CLK_DIVISOR : integer
  );
  port
  (
    clk, res_n : in  std_logic;
        
    data_out  : out std_logic_vector(7 downto 0);
    new_data  : out std_logic;
        
    rx        : in std_logic
  );
end serial_port_receiver;

architecture beh of serial_port_receiver is
  type RECEIVER_STATE_TYPE is (RECEIVER_STATE_IDLE, 
                               RECEIVER_STATE_WAIT_START_BIT,
                               RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT,
                               RECEIVER_STATE_MIDDLE_OF_START_BIT,
                               RECEIVER_STATE_WAIT_DATA_BIT,
                               RECEIVER_STATE_MIDDLE_OF_DATA_BIT,
                               RECEIVER_STATE_WAIT_STOP_BIT,
                               RECEIVER_STATE_MIDDLE_OF_STOP_BIT);
  signal receiver_state, receiver_state_next : RECEIVER_STATE_TYPE;
  signal data, data_next, data_out_internal, data_out_next : std_logic_vector(7 downto 0);
  signal new_data_next : std_logic;
  signal clk_cnt, clk_cnt_next : integer range 0 to CLK_DIVISOR - 1;
  signal bit_cnt, bit_cnt_next : integer range 0 to 8;
begin
  data_out <= data_out_internal;
  
  receiver_next_state : process(receiver_state, rx, clk_cnt, bit_cnt)
  begin
    receiver_state_next <= receiver_state;

    case receiver_state is
      when RECEIVER_STATE_IDLE =>
        if rx = '1' then
          receiver_state_next <= RECEIVER_STATE_WAIT_START_BIT;
        end if;
      when RECEIVER_STATE_WAIT_START_BIT =>
        if rx = '0' then
          receiver_state_next <= RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT;
        end if;
      when RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT =>
        if clk_cnt = CLK_DIVISOR / 2 - 2 then
          receiver_state_next <= RECEIVER_STATE_MIDDLE_OF_START_BIT;
        end if;
      when RECEIVER_STATE_MIDDLE_OF_START_BIT =>
        receiver_state_next <= RECEIVER_STATE_WAIT_DATA_BIT;
      when RECEIVER_STATE_WAIT_DATA_BIT =>
        if clk_cnt = CLK_DIVISOR - 2 then
          receiver_state_next <= RECEIVER_STATE_MIDDLE_OF_DATA_BIT;
        end if;
      when RECEIVER_STATE_MIDDLE_OF_DATA_BIT =>
        if bit_cnt = 7 then
          receiver_state_next <= RECEIVER_STATE_WAIT_STOP_BIT;
        else
          receiver_state_next <= RECEIVER_STATE_WAIT_DATA_BIT;
        end if;
      when RECEIVER_STATE_WAIT_STOP_BIT =>
        if clk_cnt = CLK_DIVISOR - 2 then
          receiver_state_next <= RECEIVER_STATE_MIDDLE_OF_STOP_BIT;
        end if;
      when RECEIVER_STATE_MIDDLE_OF_STOP_BIT =>
        receiver_state_next <= RECEIVER_STATE_WAIT_START_BIT;
      when others =>
        receiver_state_next <= RECEIVER_STATE_IDLE;
    end case;
  end process receiver_next_state;
  
  receiver_output : process(receiver_state, clk_cnt, bit_cnt, data, data_out_internal, rx)
  begin
    clk_cnt_next <= clk_cnt;
    bit_cnt_next <= bit_cnt;
    data_next <= data;
    new_data_next <= '0';
    data_out_next <= data_out_internal;
    
    case receiver_state is
      when RECEIVER_STATE_IDLE =>
      when RECEIVER_STATE_WAIT_START_BIT =>
        bit_cnt_next <= 0;
        clk_cnt_next <= 0;
      when RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT =>
        clk_cnt_next <= clk_cnt + 1;
      when RECEIVER_STATE_MIDDLE_OF_START_BIT =>
        clk_cnt_next <= 0;
      when RECEIVER_STATE_WAIT_DATA_BIT =>
        clk_cnt_next <= clk_cnt + 1;
      when RECEIVER_STATE_MIDDLE_OF_DATA_BIT =>
        clk_cnt_next <= 0;
        bit_cnt_next <= bit_cnt + 1;
        data_next <= rx & data(7 downto 1);
      when RECEIVER_STATE_WAIT_STOP_BIT =>
        clk_cnt_next <= clk_cnt + 1;
      when RECEIVER_STATE_MIDDLE_OF_STOP_BIT =>
        new_data_next <= '1';
        data_out_next <= data;
    end case;
  end process receiver_output;
  
  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      clk_cnt <= 0;
      bit_cnt <= 0;
      data <= (others => '0');
      receiver_state <= RECEIVER_STATE_IDLE;
      new_data <= '0';
      data_out_internal <= (others => '0');
    elsif rising_edge(clk) then
      clk_cnt <= clk_cnt_next;
      bit_cnt <= bit_cnt_next;
      data <= data_next;
      receiver_state <= receiver_state_next;
      new_data <= new_data_next;
      data_out_internal <= data_out_next;
    end if;
  end process sync;
  
end beh;

