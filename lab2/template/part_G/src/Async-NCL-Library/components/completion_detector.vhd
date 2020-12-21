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
	component c_element is 
		port(
			in1, in2 : in std_logic;
			out1 : out std_logic
		);
	end component;
  
	signal rail_state : std_logic_vector ( DATA_WIDTH-1 downto 0 );
	signal completion_vector : std_logic_vector ( DATA_WIDTH-2 downto 0 );
	
begin
	rail_state <= data_t or data_f;
	
	c_element_inst_0:	c_element
	port map
		(
			in1 => rail_state(0),
			in2 => rail_state(1),
			out1 => completion_vector(0)
		);
				
	GEN_C_ELEMENT : for i in 1 to DATA_WIDTH-2 generate
		
		c_element_inst :	c_element
		port map
			(
				in1 => completion_vector(i-1),
				in2 => rail_state(i+1),
				out1 => completion_vector(i)
			);
	end generate GEN_C_ELEMENT;
	
	complete <= completion_vector(DATA_WIDTH-2);
end STRUCTURE;