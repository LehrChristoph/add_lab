----------------------------------------------------------------------------------
-- Add-block
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity add_block is
  generic ( 
		DATA_WIDTH: natural := DATA_WIDTH);
  port (
		-- flags
		rst			: in  std_logic;
		ack_in    	: in  std_logic;
		ack_out			: out std_logic;
		-- Input channel
		inA_data_t  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_data_f  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_data_t  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_data_f  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Output channel
		outC_data_t : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data_f : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end add_block;

architecture Behavioral of add_block is
	signal carry_init_f : std_logic := '0';
	signal input_carry_t, input_carry_f, output_carry_t, output_carry_f   : std_logic_vector(DATA_WIDTH-2 downto 0);
	signal completion_vector, add_t, add_f  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal inA_complete, inB_complete, input_complete : std_logic;
	signal calc_complete, calc_done : std_logic;
	
	signal inA_data_selected_t, inA_data_selected_f, inB_data_selected_t, inB_data_selected_f: std_logic_vector(DATA_WIDTH-1 downto 0);
	
	attribute keep: boolean;
	attribute keep of inA_data_t, inA_data_f: signal is true;
	attribute keep of inB_data_t, inB_data_f: signal is true;
	attribute keep of input_carry_t, input_carry_f, output_carry_t, output_carry_f : signal is true;
	attribute keep of completion_vector, add_t, add_f: signal is true;
	attribute keep of inA_complete, inB_complete, input_complete: signal is true;
	attribute keep of calc_complete, calc_done: signal is true;
	
begin
	
	init_adder : process (rst, add_t, add_f, inA_data_t, inA_data_f, inB_data_t, inB_data_f, output_carry_t, output_carry_f)
	begin
		if rst = '1' then
			outC_data_t <= (others => '0');
			outC_data_f <= (others => '0');
			inA_data_selected_t <= (others => '0');
			inA_data_selected_f <= (others => '0');
			inB_data_selected_t <= (others => '0');
			inB_data_selected_f <= (others => '0');
			input_carry_t <= (others => '0');
			input_carry_f <= (others => '0');
		else
			outC_data_t <= add_t;
			outC_data_f <= add_f;
			inA_data_selected_t <= inA_data_t;
			inA_data_selected_f <= inA_data_f;
			inB_data_selected_t <= inB_data_t;
			inB_data_selected_f <= inB_data_f;
			input_carry_t <= output_carry_t;
			input_carry_f <= output_carry_f;
		end if;
	end process;
	
	
	full_adder_first_inst : entity work.full_adder
	port map
	(
		-- Input channel
		inA_data_t  => inA_data_selected_t(0),
		inA_data_f  => inA_data_selected_f(0),
		inB_data_t  => inB_data_selected_t(0),
		inB_data_f  => inB_data_selected_f(0),
		carry_in_t  => '0',
		carry_in_f  => carry_init_f,
		-- Output channel
		outC_data_t => add_t(0),
		outC_data_f => add_f(0),
		carry_out_t => output_carry_t(0),
		carry_out_f => output_carry_f(0)
	);
			
	
	GEN_ADDERS : for i in 1 to DATA_WIDTH-2 generate
		full_adder_inst : entity work.full_adder
		port map
		(
			-- Input channel
			inA_data_t  => inA_data_selected_t(i),
			inA_data_f  => inA_data_selected_f(i),
			inB_data_t  => inB_data_selected_t(i),
			inB_data_f  => inB_data_selected_f(i),
			carry_in_t  => input_carry_t(i-1),
			carry_in_f  => input_carry_f(i-1),
			-- Output channel
			outC_data_t => add_t(i),
			outC_data_f => add_f(i),
			carry_out_t => output_carry_t(i),
			carry_out_f => output_carry_f(i)
		);
	end generate GEN_ADDERS;
	
	full_adder_last_inst : entity work.full_adder
	port map
	(
		-- Input channel
		inA_data_t  => inA_data_selected_t(DATA_WIDTH-1),
		inA_data_f  => inA_data_selected_f(DATA_WIDTH-1),
		inB_data_t  => inB_data_selected_t(DATA_WIDTH-1),
		inB_data_f  => inB_data_selected_f(DATA_WIDTH-1),
		carry_in_t  => input_carry_t(DATA_WIDTH-2),
		carry_in_f  => input_carry_f(DATA_WIDTH-2),
		-- Output channel
		outC_data_t => add_t(DATA_WIDTH-1),
		outC_data_f => add_f(DATA_WIDTH-1),
		carry_out_t => open,
		carry_out_f => open
	);

	calc_cd : entity work.completion_detector
	generic map ( DATA_WIDTH => DATA_WIDTH)
	port map(
		data_t => add_t,
		data_f => add_f,
		rst => rst,
		complete => calc_complete
	);
	
	c_element_inst_ack_in:	entity work.c_element
	port map
		(
			in1 => calc_complete,
			in2 => ack_in,
			out1 => calc_done
		);
		
	set_done_flag : process (calc_done, rst)
		variable done_temp : std_logic := '0';
	begin
		if rst = '1' then
			ack_out <= '0';
		else
			if calc_done = '1' then
				ack_out <= '1' after CD_DELAY;
			else 
				ack_out <= '0' after CD_DELAY;
			end if;
		end if;
	end process;
	
	set_input_carry_flag : process (inA_data_t, inA_data_f, inB_data_t, inB_data_f, rst)
		variable input_complete_var : std_logic := '0';
	begin
		if rst = '1' then
			carry_init_f <= '0';
		else
			carry_init_f <= inA_data_t(0) xor inA_data_f(0);
--			input_complete_var := '1';
--			for i in (inA_data_t'length -1) downto 0 loop
--				input_complete_var := input_complete_var and (inA_data_t(i) or inA_data_f(i)) ;
--				input_complete_var := input_complete_var and (inB_data_t(i) or inB_data_f(i)) ;
--			end loop;
--			
--			if input_complete_var = '1' then
--				carry_init_f <= '1';
--			else 
--				carry_init_f <= '0';
--			end if;
		end if;
	end process;
	
end Behavioral;