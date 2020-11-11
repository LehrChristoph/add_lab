library ieee;
use ieee.std_logic_1164.all;
use work.d_ff_pkg.all;
use work.sync_pkg.all;

entity ltd is
	generic (
		SYNC_STAGES : integer range 2 to integer'high
	);
	port (
		clk_ref : in std_logic;
		clk_det : in std_logic;
		i : in std_logic;
		error : out std_logic;
		error01 : out std_logic;
		error10 : out std_logic;
		error010 : out std_logic;
		error101 : out std_logic
	);
end entity;

architecture struct of ltd is
	signal det, ref : std_logic;
	signal ref_old, ref_sync1, ref_sync2, det_sync1, det_sync2 : std_logic;
	signal error_int, error01_int, error10_int, error010_int, error101_int : std_logic;
begin
	det_inst : d_ff
	port map (
		clk => clk_det,
		res_n => '1',
		d => i,
		q => det
	);

	ref_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => i,
		q => ref
	);

	det_sync1_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk_det,
		res_n => '1',
		data_in => det,
		data_out => det_sync1
	);

	det_sync2_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES + 1, -- Extra stage for realligning det to ref
		RESET_VALUE => '0'
	)
	port map (
		clk => clk_ref,
		res_n => '1',
		data_in => det_sync1,
		data_out => det_sync2
	);

	ref_sync1_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk_ref,
		res_n => '1',
		data_in => ref,
		data_out => ref_sync1
	);

	ref_sync2_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk_ref,
		res_n => '1',   
		data_in => ref_sync1,
		data_out => ref_sync2
	);

	ref_old_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => ref_sync2,
		q => ref_old
	);

	-- The case separation is not yet correct! For all cases, only the detector flip flop's output and the 
	-- reference output are compared! Correct the cases error01,error10, error010 and error101!
	error_int <= det_sync2 xor ref_sync2;
	error01_int <= det_sync2 xor ref_sync2;
	error10_int <= det_sync2 xor ref_sync2;
	error010_int <= det_sync2 xor ref_sync2;
	error101_int <= det_sync2 xor ref_sync2;

	error_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => error_int,
		q => error
	);

	error01_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => error01_int,
		q => error01
	);

	error10_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => error10_int,
		q => error10
	);

	error010_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => error010_int,
		q => error010
	);

	error101_inst : d_ff
	port map (
		clk => clk_ref,
		res_n => '1',
		d => error101_int,
		q => error101
	);
end architecture;

