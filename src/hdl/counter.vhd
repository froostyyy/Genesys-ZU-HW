------------------------------------------------------------------------------
--
-- File: counter.vhd
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
-- Generate two ramp signals using a counter which repeatedly rolls over.
-------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity counter is
    Port(clk: in std_logic;
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
    if rising_edge(clk) then
        if (cresetn='0') then
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