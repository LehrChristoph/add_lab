library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity mainbus_coupling is
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
    bus_data_ms  : in std_logic_vector(31 downto 0);
    bus_data_sm  : out std_logic_vector(31 downto 0);
    bus_rd : in std_logic;
    bus_wr : in std_logic;
    bus_done : out std_logic;

    local_addr : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
    local_data_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    local_data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    local_rd : out std_logic;
    local_wr : out std_logic;
    local_busy : in std_logic
  );
end entity mainbus_coupling;

architecture beh of mainbus_coupling is
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
  
  type STATE_TYPE is (IDLE, READ, READ_WAIT, READ_FINISHED, RETURN_VALUE, INIT_VALUE, SET_VALUE, WRITE, WRITE_WAIT, WRITE_DONE);
  signal state, state_next : STATE_TYPE;
  signal bus_address_active, bus_address_active_next : std_logic_vector(31 downto 0);
begin
  process(slices)
  begin
    for i in 0 to SLICE_COUNT - 1 loop
      if (32 * (i + 1) - 1 <= DATA_WIDTH) then
        local_data_out(32 * (i + 1) - 1 downto 32 * i)  <= slices(i);
      else
        local_data_out(DATA_WIDTH - 1 downto 32 * i)  <= slices(i)(DATA_WIDTH - 1 - 32 * i downto 0);
      end if;
    end loop;
  end process;

  process(state, bus_rd, bus_wr, local_busy, bus_address, bus_address_active)
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
        elsif bus_wr ='1' and bus_address(31 downto ADDR_WIDTH + SLICE_ADDRESS_WIDTH) = BASE_ADDRESS(31 downto ADDR_WIDTH + SLICE_ADDRESS_WIDTH) then
          if bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(SLICE_COUNT - 1, SLICE_ADDRESS_WIDTH)) then
            state_next <= INIT_VALUE;
          elsif bus_address(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH) = bus_address_active(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH) then
            state_next <= SET_VALUE;
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
      when INIT_VALUE =>
        if bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(0, SLICE_ADDRESS_WIDTH)) then
          state_next <= WRITE;
        else
          state_next <= WRITE_DONE;
        end if;
      when SET_VALUE =>
        if bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(0, SLICE_ADDRESS_WIDTH)) then
          state_next <= WRITE;
        else
          state_next <= WRITE_DONE;
        end if;
      when WRITE =>
        if local_busy = '1' then
          state_next <= WRITE_WAIT;
        end if;
      when WRITE_WAIT =>
        if local_busy = '0' then
          state_next <= WRITE_DONE;
        end if;
      when WRITE_DONE =>
        state_next <= IDLE;
    end case;    
  end process;
   
  local_addr <= bus_address(ADDR_WIDTH + SLICE_ADDRESS_WIDTH - 1 downto SLICE_ADDRESS_WIDTH);
   
  process(state, bus_address, bus_address_active)
  begin
    local_rd <= '0';
    local_wr <= '0';
    bus_done <= '0';
    bus_address_active_next <= bus_address_active;
    slices_next <= slices;
    
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
      when INIT_VALUE =>
        bus_address_active_next <= bus_address;
        slices_next <= get_slices(std_logic_vector(to_unsigned(0, DATA_WIDTH)));
        if SLICE_ADDRESS_WIDTH = 0 then
          slices_next(0) <= bus_data_ms;
        else
          slices_next(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0)))) <= bus_data_ms;
        end if;
      when SET_VALUE =>
        if SLICE_ADDRESS_WIDTH = 0 then
          slices_next(0) <= bus_data_ms;
        else
          slices_next(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0)))) <= bus_data_ms;
        end if;
      when WRITE =>
        local_wr <= '1';
      when WRITE_WAIT =>
     
      when WRITE_DONE =>
        bus_done <= '1';
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