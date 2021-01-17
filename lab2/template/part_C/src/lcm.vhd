----------------------------------------------------------------------------------
-- lcm Implementation
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;
use ieee.std_logic_unsigned.all;

entity lcm is
  generic ( DATA_WIDTH : natural := DATA_WIDTH);
  port (
    A : in std_logic_vector ( DATA_WIDTH/2-1 downto 0 );
    B : in std_logic_vector ( DATA_WIDTH/2-1 downto 0 );
    RESULT : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
    rst : in std_logic;
    i_req:  in std_logic;
    i_ack:  out std_logic;
    o_req: out std_logic;
    o_ack: in std_logic
  );
end lcm;

architecture STRUCTURE of lcm is
	signal calculate : STD_LOGIC;
	signal a_buf : unsigned( DATA_WIDTH/2-1 downto 0 );
	signal b_buf : unsigned( DATA_WIDTH/2-1 downto 0 );
	signal sum_a : unsigned( DATA_WIDTH-1 downto 0 );
	signal sum_b : unsigned( DATA_WIDTH-1 downto 0 );
begin
	process(all)
	begin
		if rst = '1' then
			RESULT <= (others => '0');
			i_ack <= '0';
			o_req <= '0';
			calculate <= '0';
        	else
			if calculate = '0' and o_req = o_ack and i_req /= i_ack then
				a_buf <= unsigned(A);
				b_buf <= unsigned(B);
				--first loop iteration unrolled
				if unsigned(A) < unsigned(B) then
					sum_a <= unsigned((DATA_WIDTH-1 downto A'length => '0') & A) + unsigned((DATA_WIDTH-1 downto A'length => '0') & A);
					sum_b <= unsigned((DATA_WIDTH-1 downto B'length => '0') & B);
				else
					sum_a <= unsigned((DATA_WIDTH-1 downto A'length => '0') & A);
					sum_b <= unsigned((DATA_WIDTH-1 downto B'length => '0') & B) + unsigned((DATA_WIDTH-1 downto B'length => '0') & B);
				end if;
				calculate <= '1';
				i_ack <= not i_ack;
			end if;

			if calculate = '1' then
				if sum_a = sum_b then
					RESULT <= std_logic_vector(sum_a);
					o_req <= not o_req;
					calculate <= '0';
				elsif sum_a < sum_b then
					sum_a <= sum_a + a_buf after ADDER_DELAY;
				else
					sum_b <= sum_b + b_buf after ADDER_DELAY;
				end if;
				
			end if;
		end if;
	end process;
end STRUCTURE;
