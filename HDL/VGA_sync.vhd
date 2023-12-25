-- ******************************************************************************
--                                VGA_sync.vhd
-- ******************************************************************************
-- This file contains the VHDL code for the VGA_sync module.
-- This module is used to generate the VGA sync pulses and the VGA signals.
-- Target resolution for this module is 640x480 @ 60Hz.
-- ******************************************************************************
-- Version: 1.0
-- Date:        2023-10-25
-- Engineer: Aleksandar Djuric
-- Company:
-- Comments:
-- Github: AlDjuric
-- ******************************************************************************

library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

entity VGA_SYNC is
  port (
    -- Clock and reset
    CLK_25    : in    std_logic;
    RESET_N   : in    std_logic;

    -- DP-RAM signals
    DATA      : in    std_logic_vector(2 downto 0);   -- data from DP-RAM
    ADDRESS   : out   std_logic_vector(16 downto 0);  -- address for DP-RAM

    -- VGA signals
    VGA_VS    : out   std_logic;                      -- VGA vertical sync
    VGA_HS    : out   std_logic;                      -- VGA horizontal sync
    VGA_R     : out   std_logic_vector(3 downto 0);   -- VGA red channel
    VGA_G     : out   std_logic_vector(3 downto 0);   -- VGA green channel
    VGA_B     : out   std_logic_vector(3 downto 0)    -- VGA blue channel
  );
end entity VGA_SYNC;

architecture RTL of VGA_SYNC is

  signal x_counter : integer RANGE 0 to 799; -- horizontal counter
  signal y_counter : integer RANGE 0 to 524; -- vertical counter

begin

  -- _____________________________________________________________
  --                         Counter process
  -- _____________________________________________________________
  COUNTER : process (CLK_25, RESET_N) is
  begin

    if (RESET_N = '0') then
      -- clear counters
      x_counter <= 0;
      y_counter <= 0;
    elsif rising_edge(CLK_25) then
      -- counters
      -- increment x_counter (counter.H) every clock pulse

      -- X counter start
      if (x_counter >= 799) then
        x_counter <= 0;
      else
        x_counter <= x_counter + 1;   -- increment x_counter
      end if;
      -- X counter end

      -- increment y_counter (counter.V) when x_counter is 706
      -- Y counter start
      if (x_counter = 706) then
        if (y_counter = 524) then
          y_counter <= 0;
        else
          y_counter <= y_counter + 1; -- increment y_counter
        end if;
      end if;
    -- Y counter end
    end if;

  end process COUNTER;

  -- ___________________________________________________________________
  --                         Address calculation
  -- ___________________________________________________________________
  -- Calculate the address for the DP-RAM based on x_counter and y_counter
  -- Divide x_counter and y_counter by 2 to fit the VGA resolution
  -- When x_counter is within 0 to 639 and y_counter is within 0 to 479 (VGA resolution),
  -- calculate the address as an offset in a memory location; otherwise, set address to all zeros
  -- ___________________________________________________________________

  ADDRESS <= std_logic_vector(to_unsigned(y_counter / 2 * 320 + x_counter / 2, ADDRESS'length))
             when x_counter <= 639 and y_counter <= 479 else
             (OTHERS => '0');
  -- ___________________________________________________________________
  --                          Sync pulses
  -- ___________________________________________________________________

  VGA_HS <= '0' when x_counter >= 660 and x_counter <= 755 else
            '1';
  VGA_VS <= '0' when y_counter = 494 else
            '1';

  -- ___________________________________________________________________
  -- RGB signals
  -- ___________________________________________________________________

  VGA_R <= (OTHERS => '1') when DATA(2) = '1' and
                                (x_counter >= 0 and x_counter <= 639) and
                                (y_counter >= 0 and y_counter <= 479) else
           (OTHERS => '0');

  VGA_G <= (OTHERS => '1') when DATA(1) = '1' and
                                (x_counter >= 0 and x_counter <= 639) and
                                (y_counter >= 0 and y_counter <= 479) else
           (OTHERS => '0');

  VGA_B <= (OTHERS => '1') when DATA(0) = '1' and
                                (x_counter >= 0 and x_counter <= 639) and
                                (y_counter >= 0 and y_counter <= 479) else
           (OTHERS => '0');

end architecture RTL;
