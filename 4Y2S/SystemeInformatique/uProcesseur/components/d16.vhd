component d16_top port (
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- Instructions bus
  ins_di : in std_logic_vector(31 downto 0);
  ins_a : out std_logic_vector(15 downto 0);
  -- Data bus
  data_di : in std_logic_vector(15 downto 0);
  data_we : out std_logic;
  data_a : out std_logic_vector(15 downto 0);
  data_do : out std_logic_vector(15 downto 0));
end component;
