library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ci_math_pkg.all;

package ci_util_pkg is
	
	type ascii_array_t is array(integer range <>) of std_logic_vector(7 downto 0);
	
	component ci_hex_reader is
		generic (
			ABORT_CHAR : std_logic_vector(7 downto 0) := x"69";
			DATA_WIDTH : integer := 64
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			start : in std_logic;
			done : out std_logic;
			value : out std_logic_vector(DATA_WIDTH-1 downto 0);
			max_length : in std_logic_vector(log2c(DATA_WIDTH)-1 downto 0);
			parse_error : out std_logic;
			abort : out std_logic;
			rx_rd : out std_logic;
			rx_data : in std_logic_vector(7 downto 0);
			rx_empty : in std_logic
		);
	end component;
	
	component ci_str_writer is
		generic (
			STR_LENGTH : integer := 8
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			start : in std_logic;
			done : out std_logic;
			str : in ascii_array_t(0 to STR_LENGTH-1);
			tx_wr : out std_logic;
			tx_data : out std_logic_vector(7 downto 0);
			tx_free : in std_logic
		);
	end component;

	component ci_uart_loopback is
		port (
			clk : in std_logic;
			res_n : in std_logic;
			rx : in std_logic;
			tx : out std_logic
		);
	end component;
	
	component ci_hex_writer is
		generic (
			DATA_WIDTH : integer := 64;
			TERM_CHAR : std_logic_vector(7 downto 0) := x"0a"
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			start : in std_logic;
			done : out std_logic;
			width : in std_logic_vector(log2c(DATA_WIDTH)-1 downto 0);
			value : in std_logic_vector(DATA_WIDTH-1 downto 0);
			tx_wr : out std_logic;
			tx_data : out std_logic_vector(7 downto 0);
			tx_free : in std_logic
		);
	end component;
	
	function str_to_ascii_array(x : string; l : integer; add_newline : boolean := false) return ascii_array_t;
end package;


package body ci_util_pkg is
	function str_to_ascii_array(x : string; l : integer; add_newline : boolean := false) return ascii_array_t is
		variable char_array : ascii_array_t(0 to l-1) := (others=>(others=>'0'));
	begin
		for i in x'range loop
			char_array(i-1) := std_logic_vector(to_unsigned(character'pos(x(i)),8));
		end loop;
		if (add_newline) then
			char_array(x'right) := x"0a";
			if(x'length+1 < l) then
				char_array(x'right+1) := x"00"; -- zero termination
			end if;
		else
			if(x'length < l) then
				char_array(x'right) := x"00"; -- zero termination
			end if;
		end if;
		return char_array;
	end function;
end package body;
