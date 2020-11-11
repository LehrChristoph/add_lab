library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity mainbus_coupling_readonly is
  generic
  (
    ADDR_WIDTH : integer;
    DATA_WIDTH : integer;
    BASE_ADDRESS : std_logic_vector(31 downto 0)
  );
  port
  (
    clk, res_n : in std_logic;

    bus_address : in std_logic_vector(31 downto 0);
    bus_data_sm  : out std_logic_vector(31 downto 0);
    bus_rd : in std_logic;
    bus_done : out std_logic;

    local_addr : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
    local_data_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    local_rd : out std_logic;
    local_busy : in std_logic
  );
end entity mainbus_coupling_readonly;

architecture beh of mainbus_coupling_readonly is
  constant SLICE_COUNT : integer := integer(ceil(real(DATA_WIDTH) / 32.0));
  constant SLICE_ADDRESS_WIDTH : integer := integer(ceil(log(real(SLICE_COUNT))/log(2.0)));
  
  type SLICE_TYPE is array (0 to 2 ** SLICE_ADDRESS_WIDTH - 1) of std_logic_vector(31 downto 0);
  signal slices, slices_next : SLICE_TYPE;
  
  function get_slices(data : in std_logic_vector(DATA_WIDTH - 1 downto 0)) return SLICE_TYPE is
    variable i : integer;
    variable slices : SLICE_TYPE;
  begin
    i := 0;
    while i <  2 ** SLICE_ADDRESS_WIDTH loop
      slices(i) := (others => '0');
      if (i * 32) + 31 <= DATA_WIDTH - 1 then
        slices(i) := data((i * 32) + 31 downto (i * 32));
      else
        slices(i)(DATA_WIDTH - 1 - (i * 32) downto 0) := data(DATA_WIDTH - 1 downto (i * 32));
      end if;
      i := i + 1;
    end loop;
    return slices;
  end function;
  
  type STATE_TYPE is (IDLE, READ, READ_WAIT, READ_FINISHED, RETURN_VALUE);
  signal state, state_next : STATE_TYPE;
  signal bus_address_active, bus_address_active_next : std_logic_vector(31 downto 0);
begin
  process(state, bus_rd, local_busy, bus_address, bus_address_active)
  begin
    state_next <= state;
    
    case state is
      when IDLE =>
        if bus_rd = '1' and bus_address(31 downto ADDR_WIDTH + SLICE_ADDRESS_WIDTH) = BASE_ADDRESS(31 downto ADDR_WIDTH + SLICE_ADDRESS_WIDTH) then
          if bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(0, SLICE_ADDRESS_WIDTH)) then
            state_next <= READ;
          elsif bus_address(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH) = bus_address_active(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH) then
            state_next <= RETURN_VALUE;          
          end if;
        end if;
      when READ =>
        if local_busy = '1' then
          state_next <= READ_WAIT;
        end if;
      when READ_WAIT =>
        if local_busy = '0' then
          state_next <= READ_FINISHED;
        end if;
      when READ_FINISHED =>
        state_next <= RETURN_VALUE;
      when RETURN_VALUE =>
        state_next <= IDLE;
    end case;
  end process;
   
  local_addr <= bus_address(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH);
   
  process(state, bus_address, bus_address_active, slices, local_data_in)
  begin
    local_rd <= '0';
    bus_done <= '0';
    bus_address_active_next <= bus_address_active;
    slices_next <= slices;
	 bus_data_sm <= (others => '0');
    
    case state is
      when IDLE =>
        
      when READ =>
        local_rd <= '1';
        bus_address_active_next <= bus_address;
      when READ_WAIT =>

      when READ_FINISHED =>
        slices_next <= get_slices(local_data_in);
      when RETURN_VALUE =>
        bus_done <= '1';
        if SLICE_ADDRESS_WIDTH = 0 then
          bus_data_sm <= slices(0);
        else
          bus_data_sm <= slices(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0))));
        end if;
    end case;    
  end process;
  
  process(clk, res_n)
  begin
    if res_n = '0' then
      state <= IDLE;
      slices <= get_slices(std_logic_vector(to_unsigned(0, DATA_WIDTH)));
      bus_address_active <= (others => '0');
    elsif rising_edge(clk) then
      state <= state_next;
      slices <= slices_next;
      bus_address_active <= bus_address_active_next;
    end if;
  end process;
  
end architecture beh;