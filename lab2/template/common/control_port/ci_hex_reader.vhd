


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ci_math_pkg.all;

entity ci_hex_reader is
	generic (
		ABORT_CHAR : std_logic_vector(7 downto 0) := x"69"; -- 'i'
		DATA_WIDTH : integer := 64
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;

		start : in std_logic;
		done : out std_logic;
		value : out std_logic_vector(DATA_WIDTH-1 downto 0);
		
		max_length : in std_logic_vector(log2c(DATA_WIDTH)-1 downto 0);
		
		parse_error : out std_logic;
		abort : out std_logic;

		rx_rd          : out std_logic;
		rx_data        : in std_logic_vector(7 downto 0);
		rx_empty  : in std_logic
	);
end entity;


architecture arch of ci_hex_reader is

	type state_t is (IDLE, READ_CHAR, WAIT_CHAR, PROCESS_CHAR, CHECK_LENGTH, COMPLETE_ABORT, COMPLETE_DONE, COMPLETE_ERROR);
	signal state : state_t;
	
	signal expect_leading_space : std_logic;
	signal ignore_leading_zeros : std_logic;
	signal first_char : std_logic;
	signal current_length : std_logic_vector(log2c(DATA_WIDTH) downto 0);
begin

	
	process(clk,res_n)
		variable hex_temp : std_logic_vector(3 downto 0);
	begin
		if (res_n = '0') then
			state <= IDLE;
			expect_leading_space <= '0';
			done <= '0';
			parse_error <= '0';
			abort <= '0';
			rx_rd <= '0';
			abort <= '0';
			value <= (others=>'0');
		elsif (rising_edge(clk)) then
			done <= '0';
			parse_error <= '0';
			abort <= '0';
			rx_rd <= '0';
			hex_temp := (others=>'0');
			
			case state is
				when IDLE => 
					if (start = '1') then
						state <= READ_CHAR;
						expect_leading_space <= '1';
						ignore_leading_zeros <= '1';
						first_char <= '1';
						current_length <= (others=>'0');
						value <= (others=>'0');
					end if;
				when READ_CHAR =>
					if (rx_empty = '0') then
						rx_rd <= '1';
						state <= WAIT_CHAR;
					end if;
				when WAIT_CHAR =>
					state <= PROCESS_CHAR;
				when PROCESS_CHAR =>
					if (rx_data = ABORT_CHAR) then
						state <= COMPLETE_ABORT;
					elsif (rx_data = x"20" or rx_data = x"0D" or rx_data = x"0a" or rx_data = x"09") then --0x20: space, 0x0D: CR, 0x0A: LF, 0x09: TAB
						if (expect_leading_space = '1') then
							state <= READ_CHAR;
						else
							state <= CHECK_LENGTH;
						end if;
					elsif (rx_data = x"30" and ignore_leading_zeros = '1') then
						expect_leading_space <= '0';
						state <= READ_CHAR;
					elsif ( unsigned(rx_data) >= 16#30# and unsigned(rx_data) <= 16#39#) then -- numbers 0 to 9
						expect_leading_space <= '0';
						ignore_leading_zeros <= '0';
						hex_temp := rx_data(3 downto 0);
						value <= value(DATA_WIDTH-5 downto 0) & hex_temp;
						if (first_char = '1') then
							if (unsigned(hex_temp) > 7) then
								current_length <= std_logic_vector(unsigned(current_length) + 4);
							elsif (unsigned(hex_temp) > 3) then
								current_length <= std_logic_vector(unsigned(current_length) + 3);
							elsif (unsigned(hex_temp) > 1) then
								current_length <= std_logic_vector(unsigned(current_length) + 2);
							else
								current_length <= std_logic_vector(unsigned(current_length) + 1);
							end if;
						else
							if(unsigned(current_length) < DATA_WIDTH) then
								current_length <= std_logic_vector(unsigned(current_length) + 4);
							end if;
						end if;
						first_char <= '0';
						state <= READ_CHAR;
					elsif
						((unsigned(rx_data) >= 16#41# and unsigned(rx_data) <= 16#46#) or
						(unsigned(rx_data) >= 16#61# and unsigned(rx_data) <= 16#66#))
					then -- chars A-F and a-f
						expect_leading_space <= '0';
						ignore_leading_zeros <= '0';
						value <= value(DATA_WIDTH-5 downto 0) & std_logic_vector(unsigned(rx_data(3 downto 0)) + 9);
						if(unsigned(current_length) < DATA_WIDTH) then
							current_length <= std_logic_vector(unsigned(current_length) + 4);
						end if;
						first_char <= '0';
						state <= READ_CHAR;
					else
						--value(7 downto 0) <= rx_data;
						state <= COMPLETE_ERROR;
					end if;
				
				when CHECK_LENGTH =>
					if (unsigned(max_length) = 0 and unsigned(current_length) <= DATA_WIDTH) then
						state <= COMPLETE_DONE;
					elsif (unsigned(current_length) <= unsigned(max_length)) then
						state <= COMPLETE_DONE;
					else
						state <= COMPLETE_ERROR;
					end if;

				when COMPLETE_DONE =>
					done <= '1';
					state <= IDLE;
					
				when COMPLETE_ABORT => 
					abort <= '1';
					state <= IDLE;
				
				when COMPLETE_ERROR => 
					parse_error <= '1';
					state <= IDLE;
			end case;
		end if;
	end process;
end architecture;

