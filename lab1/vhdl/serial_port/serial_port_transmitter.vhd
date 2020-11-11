library ieee;
use ieee.std_logic_1164.all;

entity serial_port_transmitter is
  generic
  (
    CLK_DIVISOR : integer
  );
  port
  (
    clk, res_n : in  std_logic;
    
    data_in   : in  std_logic_vector(7 downto 0);
    wr        : in  std_logic;
    free      : out std_logic;
            
    tx        : out std_logic
  );
end serial_port_transmitter;

architecture beh of serial_port_transmitter is
  type TRANSMITTER_STATE_TYPE is (TRANSMITTER_STATE_IDLE,
                                  TRANSMITTER_STATE_NEW_DATA,
                                  TRANSMITTER_STATE_SEND_START_BIT,
                                  TRANSMITTER_STATE_TRANSMIT_FIRST,
                                  TRANSMITTER_STATE_TRANSMIT_NEXT,
                                  TRANSMITTER_STATE_TRANSMIT,
                                  TRANSMITTER_STATE_TRANSMIT_STOP_NEXT,
                                  TRANSMITTER_STATE_TRANSMIT_STOP);
  signal transmitter_state, transmitter_state_next : TRANSMITTER_STATE_TYPE;
  signal bit_cnt, bit_cnt_next : integer range 0 to 8;
  signal clk_cnt, clk_cnt_next : integer range 0 to CLK_DIVISOR - 1;
  signal free_internal, free_next, tx_next : std_logic;
  signal transmit_data, transmit_data_next, buffered_data, buffered_data_next : std_logic_vector(7 downto 0);
begin

  transmitter_next_state : process(transmitter_state, clk_cnt, bit_cnt, free_internal)
  begin
    transmitter_state_next <= transmitter_state;

    case transmitter_state is
      when TRANSMITTER_STATE_IDLE =>
        if free_internal = '0' then
          transmitter_state_next <= TRANSMITTER_STATE_NEW_DATA;
        end if;
      when TRANSMITTER_STATE_NEW_DATA =>
        transmitter_state_next <= TRANSMITTER_STATE_SEND_START_BIT;
      when TRANSMITTER_STATE_SEND_START_BIT =>
        if clk_cnt = CLK_DIVISOR - 2 then
          transmitter_state_next <= TRANSMITTER_STATE_TRANSMIT_FIRST;
        end if;
      when TRANSMITTER_STATE_TRANSMIT_FIRST =>
        transmitter_state_next <= TRANSMITTER_STATE_TRANSMIT;
      when TRANSMITTER_STATE_TRANSMIT_NEXT =>
        transmitter_state_next <= TRANSMITTER_STATE_TRANSMIT;
      when TRANSMITTER_STATE_TRANSMIT =>
        if clk_cnt = CLK_DIVISOR - 2 then
          if bit_cnt = 7 then
            transmitter_state_next <= TRANSMITTER_STATE_TRANSMIT_STOP_NEXT;
          else
            transmitter_state_next <= TRANSMITTER_STATE_TRANSMIT_NEXT;
          end if;
        end if;
      when TRANSMITTER_STATE_TRANSMIT_STOP_NEXT =>
        transmitter_state_next <= TRANSMITTER_STATE_TRANSMIT_STOP;
      when TRANSMITTER_STATE_TRANSMIT_STOP =>
        if clk_cnt = CLK_DIVISOR - 2 then
          if free_internal = '0' then
            transmitter_state_next <= TRANSMITTER_STATE_NEW_DATA;            
          else          
            transmitter_state_next <= TRANSMITTER_STATE_IDLE;
          end if;
        end if;
    end case;
  end process transmitter_next_state;
  
  transmitter_output : process(transmitter_state, wr, free_internal, clk_cnt, bit_cnt, transmit_data_next, buffered_data, data_in, transmit_data)
  begin
    free_next <= free_internal;
    clk_cnt_next <= clk_cnt;
    bit_cnt_next <= bit_cnt;
    buffered_data_next <= buffered_data;
    transmit_data_next <= transmit_data;
    tx_next <= '1';
    
    if wr = '1' then
      free_next <= '0';
      buffered_data_next <= data_in;
    end if;
    
    case transmitter_state is
      when TRANSMITTER_STATE_IDLE =>
        null;
      when TRANSMITTER_STATE_NEW_DATA =>
        clk_cnt_next <= 0;
        free_next <= '1';
        transmit_data_next <= buffered_data;
      when TRANSMITTER_STATE_SEND_START_BIT =>
        clk_cnt_next <= clk_cnt + 1;
        tx_next <= '0';
      when TRANSMITTER_STATE_TRANSMIT_FIRST =>
        clk_cnt_next <= 0;
        bit_cnt_next <= 0;
        tx_next <= '0';
      when TRANSMITTER_STATE_TRANSMIT_NEXT =>
        clk_cnt_next <= 0;
        bit_cnt_next <= bit_cnt + 1;
        tx_next <= transmit_data(0);
        transmit_data_next(6 downto 0) <= transmit_data(7 downto 1);
      when TRANSMITTER_STATE_TRANSMIT =>
        clk_cnt_next <= clk_cnt + 1;
        tx_next <= transmit_data(0);
      when TRANSMITTER_STATE_TRANSMIT_STOP_NEXT =>
        clk_cnt_next <= 0;
        tx_next <= transmit_data(0);
      when TRANSMITTER_STATE_TRANSMIT_STOP =>
        clk_cnt_next <= clk_cnt + 1;
    end case;
  end process transmitter_output;
    
  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      transmitter_state <= TRANSMITTER_STATE_IDLE;
      free_internal <= '1';
      clk_cnt <= 0;
      buffered_data <= (others => '0');
      transmit_data <= (others => '0');
      bit_cnt <= 0;
      tx <= '1';
    elsif rising_edge(clk) then
      transmitter_state <= transmitter_state_next;
      free_internal <= free_next;
      clk_cnt <= clk_cnt_next;
      buffered_data <= buffered_data_next;
      transmit_data <= transmit_data_next;
      tx <= tx_next;
      bit_cnt <= bit_cnt_next;
    end if;
  end process sync;
  free <= free_internal;
end beh;