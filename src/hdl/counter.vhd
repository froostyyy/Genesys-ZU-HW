-- Generate two ramp signals using a counter which repeatedly rolls over.

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity counter is
    Port ( clk: in std_logic;
        cresetn: in std_logic;
        counter: out unsigned(31 downto 0);
        dvalid : out std_logic
    );
end counter;

architecture rtl of counter is
    signal counter_lcl: unsigned(13 downto 0) := (others => '0');
    signal reverse_counter_lcl: unsigned(13 downto 0) := (others => '1');
begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(cresetn='0') then
             counter_lcl <= (others => '0');
             dvalid <= '0';
        else
            counter_lcl <= counter_lcl + 1;
            dvalid <= '1';
        end if;
    end if;
end process;

reverse_counter_lcl <= "11"&x"FFF" - counter_lcl;

-- Channel 1 ramp signal is ascending, Channel 2 ramp is descending
counter <= counter_lcl & "00" & reverse_counter_lcl & "00";

end rtl;