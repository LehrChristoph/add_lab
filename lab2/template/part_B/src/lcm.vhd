----------------------------------------------------------------------------------
--LCM Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.utils_pkg.all;

entity LCM is
    generic (
        DATA_WIDTH : natural := 16
    );
    port(
        clk: in std_logic;
        res_n: in std_logic;
        AB : in std_logic_vector(DATA_WIDTH-1 downto 0);
        ready : in std_logic;
        done : out std_logic;
        result: out std_logic_vector(DATA_WIDTH-1 downto 0);
        valid: out std_logic
    );
end LCM;


architecture beh of LCM is
    type TYPE_FSM_STATE IS (IDLE, CALC);

    -- Define registers
    type TYPE_REGS is record
        fsm_state : TYPE_FSM_STATE;
        start     : std_logic;
        done      : std_logic;
        A         : unsigned(DATA_WIDTH/2-1 downto 0);
        B         : unsigned(DATA_WIDTH/2-1 downto 0);
        sumA      : unsigned(DATA_WIDTH-1 downto 0);
        sumB      : unsigned(DATA_WIDTH-1 downto 0);
    end record;

    -- Reset values of registers
    constant CONST_REGS_RESET : TYPE_REGS := (
        fsm_state => IDLE,
        start     => '0',
        done      => '0',
        A         => (others => '0'),
        B         => (others => '0'),
        sumA      => (others => '0'),
        sumB      => (others => '0')
    );

    signal R : TYPE_REGS;
begin
    done <= R.done;
    valid <= R.start;
    result <= std_logic_vector(R.sumA);

    lcm : process(clk, res_n)
        variable S : TYPE_REGS;
    begin
        if res_n = '0' then
            R <= CONST_REGS_RESET;
        elsif rising_edge(clk) then
            S := R;
            S.done  := '0';
            S.start := '0';
            case R.fsm_state is
                when IDLE =>
                    if ready = '1' then
                        S.fsm_state := CALC;
                        S.start := '1';
                        S.A := unsigned(AB(DATA_WIDTH-1 downto DATA_WIDTH/2));
                        S.B := unsigned(AB(DATA_WIDTH/2-1 downto 0));
                        S.sumA := resize(S.A, S.sumA'length);
                        S.sumB := resize(S.B, S.sumB'length);
                    end if;
                when CALC =>
                    if R.sumA < R.sumB then
                        S.sumA := R.sumA + resize(R.A, R.sumA'length);
                    else
                        S.sumB := R.sumB + resize(R.B, R.sumB'length);
                    end if;

                    -- using R instead of S delays the output by 1 cycle but shortens the critical path
                    if R.sumA = R.sumB then
                        S.fsm_state := IDLE;
                        S.done := '1';
                    end if;
            end case;

            R <= S;
        end if;
    end process;
end beh;
