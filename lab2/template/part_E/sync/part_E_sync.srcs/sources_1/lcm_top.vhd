
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity top is
  port(
    clk, res : in std_logic;
    error_led, heartbeat_led, timer_led : out std_logic
    );
end entity;


architecture beh of top is

component clk_wiz_0
  port
   (-- Clock in ports
    -- Clock out ports
    clk_out1          : out    std_logic;
    clk_out2          : out    std_logic;
    clk_in1           : in     std_logic
   );
  end component;

  constant DATA_WIDTH: natural := 32;

  signal valid : std_logic;
  signal result : std_logic_vector ( DATA_WIDTH-1 downto 0 );
  signal A, B : std_logic_vector ( DATA_WIDTH/2-1 downto 0 );
  signal res_n, clk_pll, clk_pll2 : std_logic;
  signal syn_res_n, syn_res_hb_n : std_logic;
  constant CLK_FREQ : natural := 325_000_000;
  constant CLK_FREQ_HB : natural := 100_000_000;
  constant TIMER_S : natural := 5*60; -- 5 minutes
begin

  A <= std_logic_vector(to_unsigned(50_171,DATA_WIDTH/2));
  B <= std_logic_vector(to_unsigned(59_299,DATA_WIDTH/2));
  res_n <= not res;


my_pll : clk_wiz_0
   port map (
  -- Clock out ports
   clk_out1 => clk_pll,
   clk_out2 => clk_pll2,
   -- Clock in ports
   clk_in1 => clk
 );

  debounce : entity work.debounce
    port map(
      clk      => clk_pll,
      res_n    => res_n,
      data_in  => res_n,
      data_out => syn_res_n
    );

  debounce_hb : entity work.debounce
    port map(
      clk      => clk_pll2,
      res_n    => res_n,
      data_in  => res_n,
      data_out => syn_res_hb_n
    );


  lcm_inst: entity work.lcm
    generic map(
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      clk => clk_pll,
      A => A,
      B => B,
      ready => '1',
      done => open,
      result => result,
      valid => valid,
      res_n => syn_res_n
    );

  check : process(syn_res_n, clk_pll)
  begin
    if syn_res_n= '0' then
      error_led <= '0';
    elsif rising_edge(clk_pll) then

      if valid = '1' then

        if (result /= x"B15445D1") then
          error_led <= '1';
        end if;
      end if;
    end if;
  end process;

  heartbeat_proc : process (syn_res_hb_n, clk_pll2)
      variable heartbeat : natural range 0 to CLK_FREQ_HB ;
  begin
      if syn_res_hb_n= '0' then
        heartbeat_led <= '0';
        heartbeat := 0;
      elsif rising_edge(clk_pll2) then

        heartbeat := heartbeat +1;

        if heartbeat = CLK_FREQ_HB/2 then
          heartbeat_led <= '1';
        elsif heartbeat = CLK_FREQ_HB then
          heartbeat_led <= '0';
          heartbeat := 0;
        end if;

      end if;
    end process;

  timer_proc : process (syn_res_hb_n, clk_pll2)
    variable prescaler : natural range 0 to CLK_FREQ_HB ;
    variable timer : natural range 0 to TIMER_S;
  begin
    if syn_res_hb_n = '0' then
      timer_led <= '0';
      timer := 0;
      prescaler := 0;
    elsif rising_edge(clk_pll2) then
      prescaler := prescaler + 1;

      if prescaler = CLK_FREQ_HB then
        prescaler := 0;
        timer := timer + 1;
        if timer = TIMER_S then
          timer := 0;
          timer_led <= '1';
        end if;
      end if;
    end if;
  end process;



end architecture;
