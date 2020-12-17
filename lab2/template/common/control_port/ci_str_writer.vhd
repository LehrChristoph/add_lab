


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ci_util_pkg.all;
use work.ci_math_pkg.all;


entity ci_str_writer is
	generic (
		STR_LENGTH : integer := 8
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;

		start : in std_logic;
		done : out std_logic;
		str: in ascii_array_t(0 to STR_LENGTH-1);

		tx_wr    : out std_logic;
		tx_data  : out std_logic_vector(7 downto 0);
		tx_free: in std_logic
	);
end entity;


architecture arch of ci_str_writer is
	type state_t is (IDLE, WRITE_CHAR,COMPLETE);
	signal state : state_t;
	
	signal idx : std_logic_vector(log2c(STR_LENGTH)-1 downto 0);
begin
	process (clk, res_n)
	begin
		if (res_n = '0') then
			tx_data <= (others=>'0');
			tx_wr <= '0';
			done <= '0';
		elsif (rising_edge(clk)) then
			tx_wr <= '0';
			done <= '0';
			case state is
				when IDLE =>
					if (start = '1') then
						state <= WRITE_CHAR;
						idx <= (others=>'0');
					end if;
				when WRITE_CHAR =>
					if (tx_free = '1' and tx_wr = '0') then
						tx_wr <= '1';
						tx_data <= str(to_integer(unsigned(idx)));
						
						if(unsigned(idx) = STR_LENGTH-1) then
							state <= COMPLETE;
						end if;
						if (str(to_integer(unsigned(idx))) = x"00") then
							state <= COMPLETE;
						end if;
						idx <= std_logic_vector(unsigned(idx) + 1);
					end if;
				when COMPLETE => 
					done <= '1';
					state <= IDLE;
			end case;
		end if;
	end process;
end architecture;
