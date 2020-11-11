library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_fsm is
  generic
  (
    CLK_FREQ    : integer;
    TIMEOUT_US  : integer range 100 to 100000 := 1000;
    RESET_VALUE : std_logic
  );
  port
  (
    clk      : in  std_logic;
    res_n    : in  std_logic;
    
    i            : in  std_logic;
    o            : out std_logic
  );
end entity debounce_fsm;

architecture beh of debounce_fsm is
  constant CLK_PERIOD_NS : integer := 1E9 / CLK_FREQ;
  constant CNT_MAX    : integer := (TIMEOUT_US * 1000) / CLK_PERIOD_NS;
  type DEBOUNCE_FSM_STATE_TYPE is
    (IDLE0, TIMEOUT0, IDLE1, TIMEOUT1);
  signal debounce_fsm_state, debounce_fsm_state_next : DEBOUNCE_FSM_STATE_TYPE;
  signal cnt, cnt_next : integer range 0 to CNT_MAX;
begin

  next_state : process(debounce_fsm_state, i, cnt)
  begin
    debounce_fsm_state_next <= debounce_fsm_state;
    
    case debounce_fsm_state is
      when IDLE0 =>
        if i = '1' then
          debounce_fsm_state_next <= TIMEOUT0;
        end if;
      when TIMEOUT0 =>
        if i = '0' then
          debounce_fsm_state_next <= IDLE0;
        elsif cnt = CNT_MAX - 1 then
          debounce_fsm_state_next <= IDLE1;
        end if;
      when IDLE1 =>
        if i = '0' then
          debounce_fsm_state_next <= TIMEOUT1;
        end if;
      when TIMEOUT1 =>
        if i = '1' then
          debounce_fsm_state_next <= IDLE1;
        elsif cnt = CNT_MAX - 1 then
          debounce_fsm_state_next <= IDLE0;
        end if;
    end case;
  end process next_state;

  output : process(debounce_fsm_state, cnt)
  begin
    o <= RESET_VALUE;
    cnt_next <= 0;

    case debounce_fsm_state is
     when IDLE0 =>
        o <= '0';
      when TIMEOUT0 =>
        o <= '0';
        cnt_next <= cnt + 1;
      when IDLE1 =>
        o <= '1';
      when TIMEOUT1 =>
        o <= '1';
        cnt_next <= cnt + 1;
    end case;
    
  end process output;

  assert RESET_VALUE = '0' or RESET_VALUE = '1' report
    "RESET_VALUE may only be 0 or 1!" severity failure;

  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      if RESET_VALUE = '0' then
        debounce_fsm_state <= IDLE0;
      else
        debounce_fsm_state <= IDLE1;
      end if;
      cnt <= 0;
    elsif rising_edge(clk) then
      debounce_fsm_state <= debounce_fsm_state_next;
      cnt <= cnt_next;
    end if;
  end process sync;
end architecture beh;
