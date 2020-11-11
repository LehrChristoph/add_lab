library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity mainbus_coupling_no_local_address_1cyc is
  generic
  (
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

    local_data_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    local_data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    local_wr : out std_logic
  );
end entity mainbus_coupling_no_local_address_1cyc;

architecture beh of mainbus_coupling_no_local_address_1cyc is
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
  
  type STATE_TYPE is (IDLE, READ_VALUE, RETURN_VALUE, INIT_VALUE, SET_VALUE, WRITE_VALUE, INIT_AND_WRITE_VALUE);
  signal state, state_next : STATE_TYPE;
begin
  process(slices_next)
  begin
    for i in 0 to SLICE_COUNT - 1 loop
      if (32 * (i + 1) - 1 <= DATA_WIDTH) then
        local_data_out(32 * (i + 1) - 1 downto 32 * i)  <= slices_next(i);
      else
        local_data_out(DATA_WIDTH - 1 downto 32 * i)  <= slices_next(i)(DATA_WIDTH - 1 - 32 * i downto 0);
      end if;
    end loop;
  end process;

  process(state, bus_rd, bus_wr, bus_address)
  begin
    state_next <= state;
    
    case state is
      when IDLE =>
        if bus_rd = '1' and bus_address(31 downto SLICE_ADDRESS_WIDTH) = BASE_ADDRESS(31 downto SLICE_ADDRESS_WIDTH) then
          if SLICE_COUNT = 1 or bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(0, SLICE_ADDRESS_WIDTH)) then
            state_next <= READ_VALUE;
          else
            state_next <= RETURN_VALUE;
          end if;
        elsif bus_wr ='1' and bus_address(31 downto SLICE_ADDRESS_WIDTH) = BASE_ADDRESS(31 downto SLICE_ADDRESS_WIDTH) then
          if SLICE_ADDRESS_WIDTH > 0 and  bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(0, SLICE_ADDRESS_WIDTH)) then
            state_next <= WRITE_VALUE;
          elsif SLICE_COUNT = 1 then
            state_next <= INIT_AND_WRITE_VALUE;
          elsif bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0) = std_logic_vector(to_unsigned(SLICE_COUNT - 1, SLICE_ADDRESS_WIDTH)) then
            state_next <= INIT_VALUE;
          else
            state_next <= SET_VALUE;
          end if;
        end if;
      when READ_VALUE =>
        state_next <= IDLE;
      when RETURN_VALUE =>
        state_next <= IDLE;
      when INIT_VALUE =>
        state_next <= IDLE;
      when SET_VALUE =>
        state_next <= IDLE;
      when WRITE_VALUE =>
        state_next <= IDLE;      
      when INIT_AND_WRITE_VALUE =>
        state_next <= IDLE;
    end case;    
  end process;

  process(state, bus_address, slices, local_data_in, bus_data_ms)
  begin
    local_wr <= '0';
    bus_done <= '0';
    slices_next <= slices;
    bus_data_sm <= (others => '0');
	 
    case state is
      when IDLE =>
        
      when READ_VALUE =>
        slices_next <= get_slices(local_data_in);
        bus_done <= '1';
        if SLICE_ADDRESS_WIDTH = 0 then
          bus_data_sm <= get_slices(local_data_in)(0);
        else
          bus_data_sm <= get_slices(local_data_in)(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0))));
        end if;
      when RETURN_VALUE =>
        bus_done <= '1';
        if SLICE_ADDRESS_WIDTH = 0 then
          bus_data_sm <= slices(0);
        else
          bus_data_sm <= slices(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0))));
        end if;
        
      when INIT_VALUE =>
        slices_next <= get_slices(std_logic_vector(to_unsigned(0, DATA_WIDTH)));
        if SLICE_ADDRESS_WIDTH = 0 then
          slices_next(0) <= bus_data_ms;
        else
          slices_next(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0)))) <= bus_data_ms;
        end if;
        bus_done <= '1';
      when SET_VALUE =>
        if SLICE_ADDRESS_WIDTH = 0 then
          slices_next(0) <= bus_data_ms;
        else
          slices_next(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0)))) <= bus_data_ms;
        end if;
        bus_done <= '1';
      when WRITE_VALUE =>
        if SLICE_ADDRESS_WIDTH = 0 then
          slices_next(0) <= bus_data_ms;
        else
          slices_next(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0)))) <= bus_data_ms;
        end if;        
        bus_done <= '1';
        local_wr <= '1';
      when INIT_AND_WRITE_VALUE =>
        slices_next <= get_slices(std_logic_vector(to_unsigned(0, DATA_WIDTH)));
        if SLICE_ADDRESS_WIDTH = 0 then
          slices_next(0) <= bus_data_ms;
        else
          slices_next(to_integer(unsigned(bus_address(SLICE_ADDRESS_WIDTH - 1 downto 0)))) <= bus_data_ms;
        end if;
        bus_done <= '1';
        local_wr <= '1';
    end case;    
  end process;
  
  process(clk, res_n)
  begin
    if res_n = '0' then
      state <= IDLE;
      slices <= get_slices(std_logic_vector(to_unsigned(0, DATA_WIDTH)));
    elsif rising_edge(clk) then
      state <= state_next;
      slices <= slices_next;
    end if;
  end process;  
end architecture beh;
