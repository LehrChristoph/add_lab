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
		done			: out std_logic;
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
	signal connect, carry_init_t, carry_init_f : std_logic := '0'; -- signal for constraining i/o (needed only for post-timing simulation)
	signal carry_t, carry_f  : std_logic_vector(DATA_WIDTH-2 downto 0);
	signal done_vect, completion_vector  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal inA_complete, inB_complete, input_complete : std_logic;
begin
	
	full_adder_first_inst : entity work.full_adder
	port map
		(
			-- flags
			done			=> done_vect(0),
			-- Input channel
			inA_data_t  => inA_data_t(0),
			inA_data_f  => inA_data_f(0),
			inB_data_t  => inB_data_t(0),
			inB_data_f  => inB_data_f(0),
			carry_in_t  => '0',
			carry_in_f  => carry_init_f,
			-- Output channel
			outC_data_t => outC_data_t(0),
			outC_data_f => outC_data_f(0),
			carry_out_t => carry_t(0),
			carry_out_f => carry_f(0)
		);
			
	
	GEN_ADDERS : for i in 1 to DATA_WIDTH-2 generate
		full_adder_inst : entity work.full_adder
		port map
			(
				-- flags
				done			=> done_vect(i),
				-- Input channel
				inA_data_t  => inA_data_t(i),
				inA_data_f  => inA_data_f(i),
				inB_data_t  => inB_data_t(i),
				inB_data_f  => inB_data_f(i),
				carry_in_t  => carry_t(i-1),
				carry_in_f  => carry_f(i-1),
				-- Output channel
				outC_data_t => outC_data_t(i),
				outC_data_f => outC_data_f(i),
				carry_out_t => carry_t(i),
				carry_out_f => carry_f(i)
			);
	end generate GEN_ADDERS;
	
	full_adder_last_inst : entity work.full_adder
	port map
		(
			-- flags
			done			=> done_vect(DATA_WIDTH-1),
			-- Input channel
			inA_data_t  => inA_data_t(DATA_WIDTH-1),
			inA_data_f  => inA_data_f(DATA_WIDTH-1),
			inB_data_t  => inB_data_t(DATA_WIDTH-1),
			inB_data_f  => inB_data_f(DATA_WIDTH-1),
			carry_in_t  => carry_t(DATA_WIDTH-2),
			carry_in_f  => carry_f(DATA_WIDTH-2),
			-- Output channel
			outC_data_t => outC_data_t(DATA_WIDTH-1),
			outC_data_f => outC_data_f(DATA_WIDTH-1),
			carry_out_t => open,
			carry_out_f => open
		);
		
	c_element_inst_0:	entity work.c_element
	port map
		(
			in1 => done_vect(0),
			in2 => done_vect(1),
			out1 => completion_vector(0)
		);
				
	GEN_C_ELEMENT : for i in 1 to DATA_WIDTH-2 generate
		
		c_element_inst :	entity work.c_element
		port map
		(
			in1 => completion_vector(i-1),
			in2 => done_vect(i+1),
			out1 => completion_vector(i)
		);
	end generate GEN_C_ELEMENT;
			
	set_done_flag : process (completion_vector, rst)
		variable done_temp : std_logic := '0';
	begin
		if rst = '1' then
			done <= '0';
		else
			if DATA_WIDTH = 1 then
				done_temp := completion_vector(0);
			else
				done_temp := completion_vector(DATA_WIDTH-2);
			end if;
			
			if done_temp = '1' then
				done <= '1' after CD_DELAY;
			else 
				done <= '0' after CD_DELAY;
			end if;
		end if;
	end process;
	
--	inA_CD : entity work.completion_detector 
--	generic map(
--		DATA_WIDTH => DATA_WIDTH
--	)
--	port map(
--		rst => rst,
--		data_t => inA_data_t,
--		data_f => inA_data_f,
--		complete => inA_complete
--	);
--	
--	inB_CD : entity work.completion_detector 
--	generic map(
--		DATA_WIDTH => DATA_WIDTH
--	)
--	port map(
--		rst => rst,
--		data_t => inB_data_t,
--		data_f => inB_data_f,
--		complete => inB_complete
--	);
--	
--	c_element_input_complete:	entity work.c_element
--	port map
--	(
--		in1 => inA_complete,
--		in2 => inB_complete,
--		out1 => input_complete
--	);
	
	set_carry_flag : process (inA_data_t, inA_data_f, inB_data_t, inB_data_f, rst)
		variable input_complete_var : std_logic := '0';
	begin
		if rst = '1' then
			carry_init_f <= '0';
		else
			
			input_complete_var := '1';
			for i in (inA_data_t'length -1) downto 0 loop
				input_complete_var := input_complete_var and (inA_data_t(i) or inA_data_f(i)) ;
				input_complete_var := input_complete_var and (inB_data_t(i) or inB_data_f(i)) ;
			end loop;
			
			if input_complete_var = '1' then
				carry_init_f <= '1';
			else 
				carry_init_f <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;