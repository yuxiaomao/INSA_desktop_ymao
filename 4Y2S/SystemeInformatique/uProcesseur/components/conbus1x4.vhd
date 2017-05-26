component conbus1x4 port (
  -- System
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- Master
  m_di : out std_logic_vector(15 downto 0);
  m_we : in std_logic;
  m_a : in std_logic_vector(15 downto 0);
  m_do : in std_logic_vector(15 downto 0);
  -- Slave 0
  s0_di : in std_logic_vector(15 downto 0);
  s0_we : out std_logic;
  s0_a : out std_logic_vector(15 downto 0);
  s0_do : out std_logic_vector(15 downto 0);
  -- Slave 1
  s1_di : in std_logic_vector(15 downto 0);
  s1_we : out std_logic;
  s1_a : out std_logic_vector(15 downto 0);
  s1_do : out std_logic_vector(15 downto 0);
  -- Slave 2
  s2_di : in std_logic_vector(15 downto 0);
  s2_we : out std_logic;
  s2_a : out std_logic_vector(15 downto 0);
  s2_do : out std_logic_vector(15 downto 0);
  -- Slave 3
  s3_di : in std_logic_vector(15 downto 0);
  s3_we : out std_logic;
  s3_a : out std_logic_vector(15 downto 0);
  s3_do : out std_logic_vector(15 downto 0));
end component;
