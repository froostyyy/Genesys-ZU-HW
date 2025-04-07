------------------------------------------------------------------------------
--
-- File: set_vadj_and_delay.vhd
-- Author: Ioan Catuna
-- Original Project: Genesys ZU + Zmod AWG Demo 
-- Date: 02 April 2025
--
-------------------------------------------------------------------------------
-- (c) 2025 Copyright Digilent Incorporated
-- All Rights Reserved
-- 
-- This program is free software; distributed under the terms of BSD 3-clause 
-- license ("Revised BSD License", "New BSD License", or "Modified BSD License")
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this
--    list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
-- 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
--    of its contributors may be used to endorse or promote products derived
--    from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
-- CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
-- OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
-- OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-------------------------------------------------------------------------------
--
-- Purpose:
-- Manually enable VADJ with 1.8V, then wait for ~3 seconds so VADJ gets set by the PMCU
-- and finally enable the Zmod AWG supplied by VADJ.
-------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity set_vadj_and_delay is
    -- clk should be 100MHz, for a 3s delay
    Port(clk: in std_logic;
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
    if rising_edge(clk) then
        if (cresetn='0') then
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
    if rising_edge(clk) then
        if (cresetn='0') then
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