library ieee;
use ieee.std_logic_1164.all;
use work.sync_pkg.all;

entity serial_port is
	generic (
		CLK_DIVISOR : integer;
		SYNC_STAGES : integer
	);
	port (
		clk, res_n : in  std_logic;

		data_in   : in  std_logic_vector(7 downto 0);
		wr        : in  std_logic;
		free      : out std_logic;

		data_out  : out std_logic_vector(7 downto 0);
		new_data  : out std_logic;

		rx        : in  std_logic;
		tx        : out std_logic
	);
end entity;

architecture beh of serial_port is
	signal rx_sync : std_logic;
	component serial_port_receiver is
		generic (
			CLK_DIVISOR : integer
		);
		port (
			clk, res_n : in  std_logic;
			data_out  : out std_logic_vector(7 downto 0);
			new_data  : out std_logic;
			rx        : in  std_logic
		);
	end component;

	component serial_port_transmitter is
		generic (
			CLK_DIVISOR : integer
		);
		port (
			clk, res_n : in  std_logic;

			data_in   : in  std_logic_vector(7 downto 0);
			wr        : in  std_logic;
			free      : out std_logic;

			tx        : out std_logic
		);
	end component;
begin
	rx_sync_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '1'
	)
	port map (
		clk => clk,
		res_n => res_n,
		data_in => rx,
		data_out => rx_sync
	);

	receiver : serial_port_receiver
	generic map(CLK_DIVISOR)
	port map(clk, res_n, data_out, new_data, rx_sync);

	transmitter : serial_port_transmitter
	generic map(CLK_DIVISOR)
	port map(clk, res_n, data_in, wr, free, tx);
end architecture;
