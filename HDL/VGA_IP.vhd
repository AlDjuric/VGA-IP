-- ******************************************************************************
--                              VGA_IP.vhd
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
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

entity VGA_IP is
  port (
    -- Clock and Reset Inputs
    RESET_N        : in    std_logic;
    CLOCK_50       : in    std_logic;                     -- System clock
    CLOCK_25       : in    std_logic;                     -- VGA clock

    -- VGA Signals
    VGA_HS         : out   std_logic;
    VGA_VS         : out   std_logic;
    VGA_R          : out   std_logic_vector(3 downto 0);
    VGA_G          : out   std_logic_vector(3 downto 0);
    VGA_B          : out   std_logic_vector(3 downto 0);

    -- Avalon
    AVALON_CS_N    : in    std_logic;                     -- Avalon chip select
    AVALON_READ_N  : in    std_logic;                     -- Avalon read enable
    AVALON_WRITE_N : in    std_logic;                     -- Avalon write enable
    AVALON_ADDRESS : in    std_logic_vector(16 downto 0); -- Avalon address
    AVALON_DIN     : in    std_logic_vector(31 downto 0); -- Avalon data in
    AVALON_DOUT    : out   std_logic_vector(31 downto 0)  -- Avalon data out
  );
end entity VGA_IP;

architecture BEHAVIORAL of VGA_IP is

  -- _____________________________________________________________
  --                      Signal declarations
  -- _____________________________________________________________

  signal write_vga              : std_logic;
  signal vga_data_r_wire        : std_logic_vector(2 downto 0);
  signal address_b_wire         : std_logic_vector(16 downto 0);

  signal reset_n_1, reset_n_2   : std_logic;

  -- _____________________________________________________________

  -- Instantiate the DP_RAM component
  component DP_RAM is
    generic (
      DATA_WIDTH  : integer := 3;
      DATA_LENGTH : integer := 76800;
      ADDR_WIDTH  : integer := 17
    );
    port (
      CLK_A  : in    std_logic;
      CLK_B  : in    std_logic;
      ADDR_A : in    std_logic_vector((ADDR_WIDTH - 1) downto 0);
      ADDR_B : in    std_logic_vector((ADDR_WIDTH - 1) downto 0);
      DATA_A : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
      WE_A   : in    std_logic;
      Q_A    : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
      Q_B    : out   std_logic_vector((DATA_WIDTH - 1) downto 0)
    );
  end component;

  -- Instantiate the VGA_Sync component
  component VGA_SYNC is
    port (
      CLK_25    : in    std_logic;
      RESET_N   : in    std_logic;
      DATA      : in    std_logic_vector(2 downto 0);
      ADDRESS   : out   std_logic_vector(16 downto 0);
      VGA_VS    : out   std_logic;
      VGA_HS    : out   std_logic;
      VGA_R     : out   std_logic_vector(3 downto 0);
      VGA_G     : out   std_logic_vector(3 downto 0);
      VGA_B     : out   std_logic_vector(3 downto 0)
    );
  end component;

begin

  -- _____________________________________________________________
  --                 Meta-stability handling
  RESET_SYNC : process (CLOCK_50, RESET_N) is
  begin

    if (RESET_N = '0') then
      reset_n_1 <= '0';
      reset_n_2 <= '0';
    elsif rising_edge(CLOCK_50) then
      reset_n_1 <= '1';
      reset_n_2 <= reset_n_1;
    end if;

  end process RESET_SYNC;

  -- _____________________________________________________________

  -- Instantiate the Double-Port RAM
  DP_RAM_INST : DP_RAM
    generic map (

      DATA_WIDTH  => 3,
      DATA_LENGTH => 76800,
      ADDR_WIDTH  => 17
    )
    port map (
      CLK_A => CLOCK_25,
      CLK_B => CLOCK_50,
      -- Port A
      ADDR_A => AVALON_ADDRESS,
      DATA_A => AVALON_DIN(2 DOWNTO 0),
      WE_A   => write_vga,
      Q_A    => AVALON_DOUT(2 DOWNTO 0),
      -- Port B
      ADDR_B => address_b_wire,
      Q_B    => vga_data_r_wire
    );

  -- _____________________________________________________________
  -- Avalon interface
  -- _____________________________________________________________
  avalon_dout(31 DOWNTO 3) <= (OTHERS => '0'); -- Set unused bits to 0
  write_vga                <= '1' when         -- Write enable for the VGA
                                       AVALON_CS_N = '0' and
                                       AVALON_READ_N = '1' and
                                       AVALON_WRITE_N = '0' else
                              '0';
  -- _____________________________________________________________
  -- Instantiate the VGA_Sync
  VGA_SYNC_INST : VGA_SYNC
    port map (
      CLK_25  => CLOCK_25,
      RESET_N => reset_n_2,
      -- RAM
      DATA    => vga_data_r_wire,
      ADDRESS => address_b_wire,
      -- VGA
      VGA_VS => VGA_VS,
      VGA_HS => VGA_HS,
      VGA_R  => VGA_R,
      VGA_G  => VGA_G,
      VGA_B  => VGA_B
    );

end architecture BEHAVIORAL;
