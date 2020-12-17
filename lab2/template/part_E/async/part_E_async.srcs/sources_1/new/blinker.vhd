library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity iotest is
 Port ( led1 :out STD_LOGIC;
 sw1 :in STD_LOGIC;
 clk :in STD_LOGIC);
end iotest;
architecture Behavioral of iotest is
 signal toggle :std_logic:='0';
begin
delay:process(clk)
 variable count :natural:=1;
begin
 if (rising_edge(clk)) then
 count := count +1;
 if count >=50000000 then
 toggle <= not toggle;
 count :=1;
 end if;
 end if;
end process;
main:process(clk,sw1,toggle)
begin
 if (rising_edge(clk)) then
 if sw1 ='0' then
 led1 <='1';
 else
 led1 <= toggle;
 end if;
 end if;
end process;
end Behavioral;




