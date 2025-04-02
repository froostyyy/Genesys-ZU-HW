-- Manually enable VADJ with 1.8V, then wait for ~3 seconds so VADJ gets set by the PMCU
-- and finally enable the Zmod AWG supplied by VADJ.

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity set_vadj_and_delay is
    -- clk should be 100MHz, for a 3s delay
    Port ( clk: in std_logic;
           cresetn: in std_logic;
           vadj_level0: out std_logic;
           vadj_level1: out std_logic;
           vadj_auton: out std_logic;
           enable_awg: out std_logic
     );
end set_vadj_and_delay;

architecture rtl of set_vadj_and_delay is
    signal counter_lcl: unsigned(28 downto 0) := (others => '0');
    signal enable_awg_lcl: std_logic := '0';
    signal vadj_auton_lcl: std_logic := '1';
begin

DelayWithCounter: process(clk)
begin
    if(rising_edge(clk)) then
        if(cresetn='0') then
             counter_lcl <= (others => '0');
             enable_awg_lcl <= '0';
        -- Counter will not roll over, unless it is reset
        elsif (counter_lcl < "1"& x"FFFFFFF") then
            counter_lcl <= counter_lcl + 1;
            enable_awg_lcl <= '0';
        else
            -- Enable the AWG only after the counter reached its final value
            enable_awg_lcl <= '1';
        end if;
    end if;
end process DelayWithCounter;

EnableVadj: process(clk)
begin
    if(rising_edge(clk)) then
        if(cresetn='0') then
            vadj_auton_lcl <= '1';
        -- Enable manual control of VADJ early on in the count phase (0xFF means 0.85us delay)
        elsif (counter_lcl = "0"& x"00000FF") then
            vadj_auton_lcl <= '0';
        end if;
    end if;
end process EnableVadj;

-- Set VADJ to 1.8V
vadj_level0 <= '1';
vadj_level1 <= '1';
vadj_auton <= vadj_auton_lcl;

enable_awg <= enable_awg_lcl;

end rtl;