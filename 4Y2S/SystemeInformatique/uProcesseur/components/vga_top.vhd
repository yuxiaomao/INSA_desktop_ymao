component vga_top port (
  -- System
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- VGA
  vga_clk : in std_logic;
  vga_rst : in std_logic;
  vga_red : out std_logic_vector(2 downto 0);
  vga_grn : out std_logic_vector(2 downto 0);
  vga_blu : out std_logic_vector(1 downto 0);
  vga_hsync : out std_logic;
  vga_vsync : out std_logic;
  -- Data bus
  mem_dr : out std_logic_vector(15 downto 0);
  mem_we : in std_logic;
  mem_a : in std_logic_vector(10 downto 0);
  mem_dw : in std_logic_vector(15 downto 0));
end component;
