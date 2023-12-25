-- Quartus Prime VHDL Template
-- True Dual-Port RAM with single clock
--
-- Read-during-write on port A or B returns newly written data
--
-- Read-during-write between A and B returns either new or old data depending
-- on the order in which the simulator executes the process statements.
-- Quartus Prime will consider this read-during-write scenario as a
-- don't care condition to optimize the performance of the RAM.  If you
-- need a read-during-write between ports to return the old data, you
-- must instantiate the altsyncram Megafunction directly.

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity DP_RAM is
  generic (
    DATA_WIDTH  : integer := 3;     -- Colors, (RGB)
    DATA_LENGTH : integer := 76800; -- Data elements in the RAM
    ADDR_WIDTH  : integer := 17     --  Element addresses
  );
  port (
    CLK_A  : in    std_logic;                                   -- 50 Mhz
    CLK_B  : in    std_logic;                                   -- 25 Mhz

    ADDR_A : in    std_logic_vector((ADDR_WIDTH - 1) downto 0); -- 17 bits
    ADDR_B : in    std_logic_vector((ADDR_WIDTH - 1) downto 0); -- 17 bits
    DATA_A : in    std_logic_vector((DATA_WIDTH - 1) downto 0); -- 3 bits
    --    data_b : IN STD_LOGIC_VECTOR((DATA_WIDTH - 1) DOWNTO 0); -- 3 bits data
    WE_A   : in    std_logic;

    Q_A    : out   std_logic_vector((DATA_WIDTH - 1) downto 0); -- 3 bits
    Q_B    : out   std_logic_vector((DATA_WIDTH - 1) downto 0)  -- 3 bits
  );
end entity DP_RAM;

architecture RTL of DP_RAM is

  -- Build a 2-D array type for the RAM
  SUBTYPE word_t IS std_logic_vector((DATA_WIDTH - 1) downto 0);

  type memory_t is ARRAY(DATA_LENGTH - 1 downto 0) OF word_t;

  -- Declare the RAM
  SHARED variable ram : memory_t;

begin

  -- Port A (Read/Write)
  PORT_A_RAM : process (CLK_A) is
  begin

    if (rising_edge(CLK_A)) then
      if (WE_A = '1') then
        ram(to_integer(unsigned(ADDR_A))) := DATA_A; -- WRITE
      end if;
      Q_A <= ram(to_integer(unsigned(ADDR_A)));      -- READ
    end if;

  end process PORT_A_RAM;

  -- Port B (Read only)
  PORT_B_RAM : process (CLK_B) is
  begin

    if (rising_edge(CLK_B)) then
      Q_B <= ram(to_integer(unsigned(ADDR_B)));
    end if;

  end process PORT_B_RAM;

end architecture RTL;
