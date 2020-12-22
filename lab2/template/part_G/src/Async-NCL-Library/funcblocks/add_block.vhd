----------------------------------------------------------------------------------
-- Add-block
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.delay_element_pkg.all;

entity add_block is
  generic ( 
    DATA_WIDTH: natural := DATA_WIDTH);
  port (
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
	signal connect: std_logic := '0'; -- signal for constraining i/o (needed only for post-timing simulation)
	signal carry_t, carry_f  : std_logic_vector(DATA_WIDTH-2 downto 0);
	
	attribute dont_touch : string;
	attribute dont_touch of  connect : signal is "true";   
begin
	
	full_adder_first_inst : work.full_adder
	port map
		(
			-- flags
			done			: out std_logic;
			-- Input channel
			inA_data_t  => inA_data_t(0),
			inA_data_f  => inA_data_f(0),
			inB_data_t  => inB_data_t(0),
			inB_data_f  => inB_data_f(0),
			carry_in_t  => 0,
			carry_in_f  => 0,
			-- Output channel
			outC_data_t => outC_data_t(0),
			outC_data_f => outC_data_f(0),
			carry_out_t => carry_t(0),
			carry_out_f => carry_f(0),
		);
			
	
	GEN_ADDERS : for i in 1 to DATA_WIDTH-2 generate
		full_adder_inst : work.full_adder
		port map
			(
				-- flags
				done			: out std_logic;
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
				carry_out_f => carry_f(i),
			);
	end generate GEN_ADDERS;
	
	full_adder_last_inst : work.full_adder
	port map
		(
			-- flags
			done			: out std_logic;
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
		
end Behavioral;