library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use work.mainbus_coupling_pkg.all;
use work.math_pkg.all;

entity mainbus_coupling_string is
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
end entity mainbus_coupling_string;

architecture mixed of mainbus_coupling_string is
  function to_rom_array( s : string ) return ROM_ARRAY is
    --TODO: Hack for ISE
    --subtype ROM_ARRAY2 is ROM_ARRAY(s'length - 1 downto 0)(7 downto 0);
    subtype ROM_ARRAY2 is ROM_ARRAY(s'length downto 0);
    variable ret : ROM_ARRAY2;
    variable j : integer;
  begin
    j := 0;
    for i in s'range loop
      ret(j) := (others => '0');
      ret(j)(7 downto 0) := std_logic_vector(to_unsigned(character'pos(s(i)), 8));
      j := j + 1;
		end loop ;
    ret(s'length) := (others => '0'); -- Null termination!
		return ret;
	end function;
begin
  coupling_inst : mainbus_coupling_rom
    generic map
    (
      DATA_WIDTH => 8, --TODO: Hack for ISE
      BASE_ADDRESS => BASE_ADDRESS,
      VALUE => to_rom_array(VALUE)
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm,
      bus_rd => bus_rd,
      bus_done => bus_done
    );
end architecture mixed;
