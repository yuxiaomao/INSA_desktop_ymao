component system_ctl port (
  -- System
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- Data bus
  di : out std_logic_vector(31 downto 0);
  we : in std_logic;
  a : in std_logic_vector(15 downto 0);
  do : in std_logic_vector(31 downto 0);
  -- LEDs
  led : out std_logic_vector(7 downto 0);
  -- Switches
  sw : in std_logic_vector(7 downto 0);
  -- User buttons
  btn : in std_logic_vector(3 downto 0));
end component;
