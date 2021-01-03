----------------------------------------------------------------------------------
-- Week Condition Half Buffer
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;


entity wchb_ncl is
	generic ( 
		DATA_WIDTH    	: natural 	:= DATA_WIDTH;
		INIT_VALUE		: natural 	:= 0;
		INIT_PHASE		: std_logic := '1'
	);
	port(
	   -- flags
		rst       : in std_logic;
		ack_in    : in std_logic;
		ack_out   : out std_logic;
		-- Input channel
		in_t      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		in_f      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Output channel
		out_t     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		out_f     : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end wchb_ncl;

architecture STRUCTURE of wchb_ncl is
	signal temp_t : std_logic_vector(DATA_WIDTH-1 downto 0):= (others => '0'); 
	signal temp_f : std_logic_vector(DATA_WIDTH-1 downto 0):= (others => '0');
	signal in_selected_t: std_logic_vector(DATA_WIDTH-1 downto 0):= (others => '0'); 
	signal in_selected_f : std_logic_vector(DATA_WIDTH-1 downto 0):= (others => '0');
	signal internal_ack, enable_c_elements, internal_done, ack_in_temp : std_logic := '0';
begin
	GEN_C_ELEMENT : for i in 0 to DATA_WIDTH-1 generate	
		c_element_inst_t : entity work.c_element
		port map
		(
			in1 => in_selected_t(i),
			in2 => not enable_c_elements,
			out1 => temp_t(i)
		);
		
		c_element_inst_f : entity work.c_element
		port map
		(
			in1 => in_selected_f(i),
			in2 => not enable_c_elements,
			out1 => temp_f(i)
		);
	end generate GEN_C_ELEMENT;
	
	output_complete : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => temp_t,
		data_f => temp_f,
		complete => internal_done
	);
		
	c_element_ack : entity work.c_element
	port map
	(
		in1 => internal_done,
		in2 => ack_in_temp,
		out1 => internal_ack
	);

	
	set_outputs : process (temp_t, temp_f, rst, internal_done, internal_ack, in_t, in_f, ack_in)
	begin
		if rst = '1' then
			out_t <= (others => '0');
			out_f <= (others => '0');
			
			if INIT_PHASE = '1' then
				in_selected_t <= (others => '0');
				in_selected_f <= (others => '0');
			else 
				in_selected_t <= std_logic_vector(to_unsigned(INIT_VALUE, DATA_WIDTH));
				in_selected_f <= not std_logic_vector(to_unsigned(INIT_VALUE, DATA_WIDTH));
			end if;
			
			ack_out <= '0';
			enable_c_elements <= INIT_PHASE;
			ack_in_temp <= '0';
		else
			in_selected_t <= in_t;
			in_selected_f <= in_f;
			out_t <= temp_t;
			out_f <= temp_f;
			ack_out <= internal_done;
			enable_c_elements <= internal_ack;
			ack_in_temp <= ack_in;
		end if;
	end process;
	
end STRUCTURE;
