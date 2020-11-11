library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram_1c1r1w is
	generic (
		ADDR_WIDTH : integer;
		DATA_WIDTH : integer
	);
	port (
		clk    : in  std_logic;

		raddr1 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
		rdata1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		rd1    : in  std_logic;

		waddr2 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
		wdata2 : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
		wr2    : in  std_logic
	);
end entity;

architecture beh of dp_ram_1c1r1w is
	subtype ram_entry is std_logic_vector(DATA_WIDTH - 1 downto 0);
	type ram_type is array(0 to (2 ** ADDR_WIDTH) - 1) of ram_entry;
	signal ram : ram_type := ( others => (others => '0') );
begin

	sync : process(clk)
	begin
		if rising_edge(clk) then
			if wr2 = '1' then
				ram(to_integer(unsigned(waddr2))) <= wdata2;
			end if;
			--if rd1 = '1' then
			rdata1 <= ram(to_integer(unsigned(raddr1)));
			--end if;
		end if;
	end process;
end architecture;
