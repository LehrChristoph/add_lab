----------------------------------------------------------------------------------
-- (A > B)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity sel_a_larger_b is
	generic(
		DATA_WIDTH    : natural := DATA_WIDTH
	);
	port(
		-- Flags
		rst				: in std_logic;
		ack_in			: in std_logic;
		ack_out			: out std_logic;
		-- Input channel
		in_data_t     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		in_data_f     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		-- Output channel
		selector_t    : out std_logic;
		selector_f    : out std_logic
	);
	end sel_a_larger_b;

architecture Behavioral of sel_a_larger_b is
	signal selector_complete : std_logic;
	signal a_t, a_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal input_complete, selector_temp_t, selector_temp_f : std_logic;
	
begin

  a_t <= in_data_t(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b_t <= in_data_t(DATA_WIDTH/2 -1 downto 0);
  
  a_f <= in_data_f(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b_f <= in_data_f(DATA_WIDTH/2 -1 downto 0);
    
  cd_input : entity work.completion_detector
	generic map ( DATA_WIDTH => DATA_WIDTH)
	port map(
		data_t => in_data_t,
		data_f => in_data_f,
		rst => rst,
		complete => input_complete
	);
	
	c_element_inst_inBf : entity work.c_element_3in
	port map
	(
		in1 => selector_complete,
		in2 => ack_in,
		in3 => input_complete,
		out1 => ack_out
	);
	
	selector_temp_t <= '1' when a_t >  b_t else '0';
	selector_temp_f <= '1' when a_f >= b_f else '0';
				
	set_outputs : process (input_complete, rst) --, selector_temp_t, selector_temp_f)
	begin
		if rst = '1' then
			selector_t <= '0';
			selector_f <= '0';
			selector_complete <= '0';
		else
			if input_complete = '1' then
				selector_t <= selector_temp_t;
				selector_f <= selector_temp_f;

				if (selector_temp_t or selector_temp_f) = '1' then
					selector_complete <= '1';
				else 
					selector_complete <= '0';
				end if;
				
			else
				selector_t <= '0';
				selector_f <= '0';
				selector_complete <= '0';
			end if;
		end if;
	end process;

end Behavioral;