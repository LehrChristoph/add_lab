


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ci_math_pkg.all;


entity ci_hex_writer is
	generic (
		DATA_WIDTH : integer := 64;
		TERM_CHAR : std_logic_vector(7 downto 0) := x"0a"
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;

		start : in std_logic;
		done : out std_logic;
		width : in std_logic_vector(log2c(DATA_WIDTH)-1 downto 0);
		value : in std_logic_vector(DATA_WIDTH-1 downto 0);
		--sign_extend : in std_logic;

		tx_wr    : out std_logic;
		tx_data  : out std_logic_vector(7 downto 0);
		tx_free  : in std_logic
	);
end entity;


architecture arch of ci_hex_writer is
	type state_t is (IDLE, CALC_SHIFT, SHIFT, WRITE_CHAR, WRITE_TERM_CHAR, COMPLETE);
	signal state : state_t;
	
	signal value_buffer : std_logic_vector(((DATA_WIDTH+3)/4)*4-1 downto 0);
	signal last_hex_digit_idx : std_logic_vector(log2c(DATA_WIDTH)-3 downto 0);
	signal shift_amount : std_logic_vector(log2c(DATA_WIDTH)-3 downto 0);
	
	signal first_digit_mask : std_logic_vector(3 downto 0);
begin
	process (clk, res_n)
		variable digit_to_write : std_logic_vector(3 downto 0);
	begin
		if (res_n = '0') then
			tx_data <= (others=>'0');
			tx_wr <= '0';
			done <= '0';
			value_buffer <= (others=>'0');
			shift_amount <= (others=>'0');
			last_hex_digit_idx <= (others=>'0');
			first_digit_mask <= (others=>'0');
		elsif (rising_edge(clk)) then
			tx_wr <= '0';
			done <= '0';
			digit_to_write := (others=>'0');
			case state is
				when IDLE =>
					if (start = '1') then
						value_buffer <= (others=>'0');
						value_buffer(DATA_WIDTH-1 downto 0) <= value;
						first_digit_mask <= (others=>'1');
						if (unsigned(width) = 0) then
							last_hex_digit_idx <= std_logic_vector(to_unsigned((DATA_WIDTH+3)/4-1, last_hex_digit_idx'length));
						else
							case width(1 downto 0) is
								when "01" =>
									first_digit_mask <= "0001";
								when "10" =>
									first_digit_mask <= "0011";
								when "11" => 
									first_digit_mask <= "0111";
								when others => null;
							end case;
						
							if( (width(0) or width(1)) = '1') then
								last_hex_digit_idx <= std_logic_vector( unsigned(width(log2c(DATA_WIDTH)-1 downto 2)));
							else
								last_hex_digit_idx <= std_logic_vector( unsigned(width(log2c(DATA_WIDTH)-1 downto 2)) -1);
							end if;
						end if;
						state <= CALC_SHIFT;
					end if;
					
				when CALC_SHIFT => 
					shift_amount <= std_logic_vector((DATA_WIDTH+3)/4-1 - unsigned(last_hex_digit_idx));
					state <= SHIFT;
				
				when SHIFT =>
					if (unsigned(shift_amount) = 0) then
						state <= WRITE_CHAR;
					else
						value_buffer <= value_buffer(value_buffer'length-5 downto 0) & x"5";
						shift_amount <= std_logic_vector(unsigned(shift_amount)-1);
					end if;
				
				when WRITE_CHAR =>
					if(tx_free = '1') then
						digit_to_write := value_buffer(value_buffer'length-1 downto value_buffer'length-4) and first_digit_mask;
						first_digit_mask <= (others=>'1');
						if (unsigned(digit_to_write) <= 9) then
							tx_data <= x"3" & digit_to_write;
						else
							tx_data <= x"6" & std_logic_vector(unsigned(digit_to_write)-9);
						end if;
						tx_wr <= '1';
						
						value_buffer <= value_buffer(value_buffer'length-5 downto 0) & x"0";
						
						if (unsigned(last_hex_digit_idx) = 0) then
							state <= WRITE_TERM_CHAR;
						else
							last_hex_digit_idx <= std_logic_vector(unsigned(last_hex_digit_idx)-1);
						end if;
					end if;
				
				when WRITE_TERM_CHAR => 
					if(tx_free = '1') then
						tx_wr <= '1';
						tx_data <= TERM_CHAR;
						state <= COMPLETE;
					end if;
				
				when COMPLETE =>
					done <= '1';
					state <= IDLE;
			end case;
		end if;
	end process;
	
end architecture;
