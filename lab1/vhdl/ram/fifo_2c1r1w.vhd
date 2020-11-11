library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ram_pkg.all;
use work.math_pkg.all;
use work.sync_pkg.all;

entity fifo_2c1r1w is
  generic
  (
    MIN_DEPTH  : integer;
    DATA_WIDTH : integer;
    SYNC_STAGES : integer
  );
  port
  (
    clk1 : in  std_logic;    
    res1_n : in  std_logic;    
    data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    rd1 : in  std_logic;
    ack1 : out  std_logic;
    empty1 : out std_logic;
    full1 : out std_logic;
    overflowed1 : out std_logic;
    
    clk2 : in std_logic;
    res2_n : in std_logic;
    data_in2 : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    wr2 : in  std_logic;
    empty2 : out std_logic;
    full2 : out std_logic;
    overflowed2 : out std_logic
  );
end entity fifo_2c1r1w;

architecture mixed of fifo_2c1r1w is
  signal full_int : std_logic;
  signal empty_int : std_logic;
  signal rd2, rd_int, ack2, overflowed_int : std_logic;
begin
   sync_rd_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => '0'
    )
    port map
    (
      clk => clk2,
      res_n => res2_n,
      data_in => rd1,
      data_out => rd2
    );
  
  sync_ack_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => '0'
    )
    port map
    (
      clk => clk1,
      res_n => res1_n,
      data_in => ack2,
      data_out => ack1
    );

  sync_empty_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => '1'
    )
    port map
    (
      clk => clk1,
      res_n => res1_n,
      data_in => empty_int,
      data_out => empty1
    );

  sync_full_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => '0'
    )
    port map
    (
      clk => clk1,
      res_n => res1_n,
      data_in => full_int,
      data_out => full1
    );
    
  sync_overflowed_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => '0'
    )
    port map
    (
      clk => clk1,
      res_n => res1_n,
      data_in => overflowed_int,
      data_out => overflowed1
    );

  empty2 <= empty_int;
  full2 <= full_int;
  overflowed2 <= overflowed_int;
  
  fifo_inst : fifo_1c1r1w
			 generic map
			 (
				MIN_DEPTH => MIN_DEPTH,
				DATA_WIDTH => DATA_WIDTH
			 )
			 port map
			 (
				clk => clk2,
				res_n => res2_n,
				
				data_out1 => data_out1,
				rd1 => rd_int,
				  
				data_in2 => data_in2,
				wr2 => wr2,
				
				empty => empty_int,
				full => full_int,
				overflowed => overflowed_int
			 );

--  fifo_gen1 : for i in 0 to 7 generate
--     fifo_gen2 : if i = 0 generate 
--		  fifo_inst : fifo_1c1r1w
--			 generic map
--			 (
--				MIN_DEPTH => MIN_DEPTH,
--				DATA_WIDTH => DATA_WIDTH / 8
--			 )
--			 port map
--			 (
--				clk => clk2,
--				res_n => res2_n,
--				
--				data_out1 => data_out1(DATA_WIDTH / 8 * (i + 1) - 1 downto DATA_WIDTH / 8 * i),
--				rd1 => rd2,
--				  
--				data_in2 => data_in2(DATA_WIDTH / 8 * (i + 1) - 1 downto DATA_WIDTH / 8 * i),
--				wr2 => wr2,
--				
--				empty => empty_int,
--				full => full_int,
--				overflowed => overflowed_int
--			 );
--		end generate;
--		fifo_gen3 : if i > 0 generate 
--		  fifo_inst : fifo_1c1r1w
--			 generic map
--			 (
--				MIN_DEPTH => MIN_DEPTH,
--				DATA_WIDTH => DATA_WIDTH / 8
--			 )
--			 port map
--			 (
--				clk => clk2,
--				res_n => res2_n,
--				
--				data_out1 => data_out1(DATA_WIDTH / 8 * (i + 1) - 1 downto DATA_WIDTH / 8 * i),
--				rd1 => rd2,
--				  
--				data_in2 => data_in2(DATA_WIDTH / 8 * (i + 1) - 1 downto DATA_WIDTH / 8 * i),
--				wr2 => wr2,
--				
--				empty => open,
--				full => open,
--				overflowed => open
--			 );
--		end generate;
--	end generate;
--	
	process(res2_n, clk2)
	begin
	  if res2_n = '0' then
	    ack2 <= '0';
		 rd_int <= '0';
	  elsif rising_edge(clk2) then
	    rd_int <= '0';
		 
	    if rd2 = '1' and ack2 = '0' then
		   ack2 <= '1';
			rd_int <= '1';
	    end if;
		 if rd2 = '0' then
		   ack2 <= '0';
	    end if;
	  end if;
	end process;
end architecture mixed;
