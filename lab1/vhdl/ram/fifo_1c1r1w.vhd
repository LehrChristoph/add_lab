library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ram_pkg.all;
use work.math_pkg.all;
use work.sync_pkg.all;

entity fifo_1c1r1w is
  generic
  (
    MIN_DEPTH  : integer;
    DATA_WIDTH : integer
  );
  port
  (
    clk : in  std_logic;    
    res_n : in  std_logic;    
	 
    data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    rd1 : in  std_logic;
	 
	 data_in2 : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    wr2 : in  std_logic;
    	 
    empty : out std_logic;
    full : out std_logic;
    overflowed : out std_logic
  );
end entity fifo_1c1r1w;

architecture mixed of fifo_1c1r1w is
  signal read_address, read_address_next : std_logic_vector(log2c(MIN_DEPTH) - 1 downto 0);
  signal write_address, write_address_next : std_logic_vector(log2c(MIN_DEPTH) - 1 downto 0);
  signal full_int, full_next : std_logic;
  signal empty_int, empty_next : std_logic;
  signal wr_int, rd_int : std_logic;
  signal overflowed_int, overflowed_int_next : std_logic;
  signal data_int1, data_int2 : std_logic_vector(DATA_WIDTH - 1 downto 0);
--  component ram IS
--	PORT
--	(
--		clock		: IN STD_LOGIC  := '1';
--		data		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
--		rdaddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
--		wraddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
--		wren		: IN STD_LOGIC  := '0';
--		q		: OUT STD_LOGIC_VECTOR (47 DOWNTO 0)
--	);
--END component ram;

begin
--    memory_inst : ram
--	   port map
--		(
--		  clock => clk,
--		  data => data_in2,
--		  rdaddress => read_address,
--		  wraddress => write_address,
--		  wren => wr_int,
--		  q => data_int1
--		);

  memory_inst : dp_ram_1c1r1w
    generic map
    (
      ADDR_WIDTH => log2c(MIN_DEPTH),
      DATA_WIDTH => DATA_WIDTH
    )
    port map
    (
      clk   => clk,
      raddr1 => read_address,
      rdata1 => data_int1,
      rd1    => rd_int,
      waddr2 => write_address,
      wdata2 => data_in2,
      wr2    => wr_int
    );

  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      read_address <= (others => '0');
      write_address <= (others => '0');
      full_int <= '0';
      empty_int <= '1';
      overflowed_int <= '0';
		data_out1 <= (others=> '0');
		data_int2 <= (others=> '0');
    elsif rising_edge(clk) then
      read_address <= read_address_next;
      write_address <= write_address_next;
      full_int <= full_next;
      empty_int <= empty_next;
      overflowed_int <= overflowed_int_next;
		data_int2 <= data_int1;
		if rd_int = '1' then
		  data_out1 <= data_int2;
		end if;
    end if;
  end process sync;
  
  exec : process(write_address, read_address, full_int, empty_int, wr2, rd1, overflowed_int)
  begin
    write_address_next <= write_address;
    read_address_next <= read_address;  
    full_next <= full_int;
    empty_next <= empty_int;
    wr_int <= '0';
    rd_int <= '0';
    overflowed_int_next <= overflowed_int;
   
    if rd1 = '1' and empty_int = '0'  then
      rd_int <= '1'; -- only read, if fifo is not empty
      read_address_next <= std_logic_vector(unsigned(read_address) + 1);
      full_next <= '0';
      if write_address = std_logic_vector(unsigned(read_address) + 1) then
        empty_next <= '1';
      end if;
    end if;

    if wr2 = '1' and full_int = '1' then
      overflowed_int_next <= '1';
    elsif wr2 = '1' and full_int = '0' and overflowed_int = '0' then
      wr_int <= '1'; -- only write, if fifo is not full
      write_address_next <= std_logic_vector(unsigned(write_address) + 1);
      empty_next <= '0';
      if read_address = std_logic_vector(unsigned(write_address) + 1) then
        full_next <= '1';
      end if;
    end if;
  end process exec;

  empty <= empty_int;
  full <= full_int;
  overflowed <= overflowed_int;
end architecture mixed;
