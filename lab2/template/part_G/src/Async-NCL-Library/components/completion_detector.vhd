----------------------------------------------------------------------------------
-- completion_detector Implementation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity completion_detector is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port (
    data_t : in std_logic_vector ( DATA_WIDTH-1 downto 0 );
    data_f : in std_logic_vector ( DATA_WIDTH-1 downto 0 );
    rst : in std_logic;
    complete:  out std_logic
  );
end completion_detector;

architecture STRUCTURE of completion_detector is  
	signal rail_state : std_logic_vector ( DATA_WIDTH-1 downto 0 );
	signal completion_vector : std_logic_vector ( DATA_WIDTH-1 downto 0 );
	
begin
	rail_state <= data_t xor data_f;
	
	c_element_inst_0:	entity work.c_element
	port map
		(
			in1 => rail_state(0),
			in2 => rail_state(1),
			out1 => completion_vector(0)
		);
				
	GEN_C_ELEMENT : for i in 1 to DATA_WIDTH-2 generate
		
		c_element_inst :	entity work.c_element
		port map
		(
			in1 => completion_vector(i-1),
			in2 => rail_state(i+1),
			out1 => completion_vector(i)
		);
	end generate GEN_C_ELEMENT;
	
	set_complete_flag : process (completion_vector, rst)
		variable comp_temp : std_logic := '0';
	begin
		if rst = '1' then
			complete <= '0';
		else
			if DATA_WIDTH = 1 then
				comp_temp := completion_vector(0);
			else
				comp_temp := completion_vector(DATA_WIDTH-2);
			end if;
			
			if comp_temp = '1' then
				complete <= '1' after CD_DELAY;
			else 
				complete <= '0' after CD_DELAY;
			end if;
		end if;
	end process;
	
	
end STRUCTURE;