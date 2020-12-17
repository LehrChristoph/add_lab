
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity top is
  port(
    clk, res : in std_logic;
    error_led, heartbeat_led : out std_logic
    );
end entity;


architecture beh of top is

  component lcm is
    generic(
      DATA_WIDTH : INTEGER
    );
    port(
      clk : in STD_LOGIC;
      A, B : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
      ready : in STD_LOGIC;
      done : out STD_LOGIC;
      result : out STD_LOGIC_VECTOR(2*DATA_WIDTH-1 downto 0);
      valid : out STD_LOGIC;
      res_n : in STD_LOGIC
    );
  end component;
  
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
  signal res_n, clk_pll : std_logic;

  constant CLK_FREQ : natural := 125_000_000;  
begin
  
  A <= std_logic_vector(to_unsigned(50_171,DATA_WIDTH/2));
  B <= std_logic_vector(to_unsigned(59_299,DATA_WIDTH/2));
  res_n <= not res;


my_pll : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_pll,
   clk_out2 => open,
   -- Clock in ports
   clk_in1 => clk
 );


  lcm_inst: lcm
    generic map(
      DATA_WIDTH => DATA_WIDTH/2
    )
    port map(
      clk => clk_pll,
      A => A,
      B => B,
      ready => '1',
      done => open,
      result => result,
      valid => valid,
      res_n => res_n
    );

  check : process(res_n, clk_pll)
  begin
    if res_n= '0' then
      error_led <= '0';
    elsif rising_edge(clk_pll) then
          
      if valid = '1' then

        if (result /= x"B15445D1") then
          error_led <= '1';
        end if;
      end if;
    end if;
  end process;
  
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
  
end architecture;
