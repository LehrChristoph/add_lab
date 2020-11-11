library ieee;
use ieee.std_logic_1164.all;

package mainbus_coupling_pkg is
  type ROM_ARRAY is array(natural range <>) of std_logic_vector(255 downto 0); --TODO: Hack for ISE

  component mainbus_coupling is
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
  end component mainbus_coupling;

  component mainbus_coupling_value_1cyc is
    generic
    (
      DATA_WIDTH : integer;
      BASE_ADDRESS : std_logic_vector(31 downto 0)
    );
    port
    (
      clk, res_n      : in    std_logic;

      bus_address     : in    std_logic_vector(31 downto 0);
      bus_data_sm     : out   std_logic_vector(31 downto 0);
      bus_rd          : in    std_logic;
      bus_done        : out   std_logic;

      local_data_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
  end component mainbus_coupling_value_1cyc;
  
  component mainbus_coupling_no_local_address_1cyc is
    generic
    (
      DATA_WIDTH : integer;
      BASE_ADDRESS : std_logic_vector(31 downto 0)
    );
    port
    (
      clk, res_n      : in    std_logic;

      bus_address     : in    std_logic_vector(31 downto 0);
      bus_data_ms     : in    std_logic_vector(31 downto 0);
      bus_data_sm     : out   std_logic_vector(31 downto 0);
      bus_rd          : in    std_logic;
      bus_wr          : in    std_logic;
      bus_done        : out   std_logic;

      local_data_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      local_data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      local_wr       : out std_logic
    );
  end component mainbus_coupling_no_local_address_1cyc;

  component mainbus_coupling_readonly is
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
  end component mainbus_coupling_readonly;

  component mainbus_coupling_rom is
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
  end component mainbus_coupling_rom;

  component mainbus_coupling_constant is
    generic
    (
      BASE_ADDRESS : std_logic_vector(31 downto 0);
      VALUE : std_logic_vector
    );
    port
    (
      clk, res_n : in std_logic;

      bus_address : in std_logic_vector(31 downto 0);
      bus_data_sm  : out std_logic_vector(31 downto 0);
      bus_rd : in std_logic;
      bus_done : out std_logic
    );
  end component mainbus_coupling_constant;
  
  component mainbus_coupling_string is
    generic
    (
      BASE_ADDRESS : std_logic_vector(31 downto 0);
      VALUE : string
    );
    port
    (
      clk, res_n : in std_logic;

      bus_address : in std_logic_vector(31 downto 0);
      bus_data_sm  : out std_logic_vector(31 downto 0);
      bus_rd : in std_logic;
      bus_done : out std_logic
    );
  end component mainbus_coupling_string;
end package mainbus_coupling_pkg;
