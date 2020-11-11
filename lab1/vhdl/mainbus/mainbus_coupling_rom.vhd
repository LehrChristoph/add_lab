library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use work.mainbus_coupling_pkg.all;
use work.math_pkg.all;

entity mainbus_coupling_rom is
  generic
  (
    DATA_WIDTH : integer; --TODO: Hack for ISE
    BASE_ADDRESS : std_logic_vector(31 downto 0);
    VALUE : ROM_ARRAY
  );
  port
  (
    clk, res_n : in std_logic;

    bus_address : in std_logic_vector(31 downto 0);
    bus_data_sm  : out std_logic_vector(31 downto 0);
    bus_rd : in std_logic;
    bus_done : out std_logic
  );
end entity mainbus_coupling_rom;

architecture beh of mainbus_coupling_rom is
  constant ADDR_WIDTH : integer := integer(ceil(log(real(VALUE'length))/log(2.0)));
  --constant DATA_WIDTH : integer := VALUE(0)'length; --TODO: Hack for ISE

  constant SLICE_COUNT : integer := integer(ceil(real(DATA_WIDTH) / 32.0));
  constant SLICE_ADDRESS_WIDTH : integer := integer(ceil(log(real(SLICE_COUNT))/log(2.0)));
  
  type SLICE_TYPE is array (0 to 2 ** SLICE_ADDRESS_WIDTH - 1) of std_logic_vector(31 downto 0);
  type SLICE_ARRAY_TYPE is array (0 to 2 ** ADDR_WIDTH - 1) of SLICE_TYPE;
  
  function get_slices(data : in ROM_ARRAY) return SLICE_ARRAY_TYPE is
    variable i, j : integer;
    variable slices : SLICE_ARRAY_TYPE := (others => (others => (others => '0')));
  begin
    j := 0;
    while j < data'length loop
--TODO: Hack for ISE
--      if data(j)'ascending(1) then
--        i := 0;
--        while i <  2 ** SLICE_ADDRESS_WIDTH loop
--          slices(j)(i) := (others => '0');
--          if (i * 32) + 31 <= DATA_WIDTH - 1 then
--            slices(j)(i) := data(j)(DATA_WIDTH - (i * 32) - 32 to DATA_WIDTH - (i * 32) - 1);
--          else
--            slices(j)(i)(DATA_WIDTH - 1 - (i * 32) downto 0) := data(j)(0 to DATA_WIDTH - (i * 32) - 1);
--          end if;
--          i := i + 1;
--        end loop;
--      else
        i := 0;
        while i <  2 ** SLICE_ADDRESS_WIDTH loop
          slices(j)(i) := (others => '0');
          if (i * 32) + 31 <= DATA_WIDTH - 1 then
            slices(j)(i) := data(j)((i * 32) + 31 downto (i * 32));
          else
            slices(j)(i)(DATA_WIDTH - 1 - (i * 32) downto 0) := data(j)(DATA_WIDTH - 1 downto (i * 32));
          end if;
          i := i + 1;
        end loop;
--      end if; --TODO: Hack for ISE
      j := j + 1;
    end loop;
    return slices;
  end function;

  constant slices : SLICE_ARRAY_TYPE := get_slices(VALUE);
  type STATE_TYPE is (IDLE, RETURN_VALUE);
  signal state, state_next : STATE_TYPE;
begin
  process(state, bus_rd, bus_address)
  begin
    state_next <= state;
    
    case state is
      when IDLE =>
        if bus_rd = '1' and bus_address(31 downto ADDR_WIDTH + SLICE_ADDRESS_WIDTH) = BASE_ADDRESS(31 downto ADDR_WIDTH + SLICE_ADDRESS_WIDTH) then
          state_next <= RETURN_VALUE;          
        end if;
      when RETURN_VALUE =>
        state_next <= IDLE;
    end case;
  end process;
   
  process(state, bus_address)
  begin
    bus_done <= '0';
    bus_data_sm <= (others => '0');
    
    case state is
      when IDLE =>
        
      when RETURN_VALUE =>
        bus_done <= '1';
        if SLICE_ADDRESS_WIDTH = 0 then
          bus_data_sm <= slices(to_integer(unsigned(bus_address(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH))))(0);
        else
          bus_data_sm <= slices(to_integer(unsigned(bus_address(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH))))(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0))));
        end if;
    end case;    
  end process;
  
  process(clk, res_n)
  begin
    if res_n = '0' then
      state <= IDLE;
    elsif rising_edge(clk) then
      state <= state_next;
    end if;
  end process;
end architecture beh;
