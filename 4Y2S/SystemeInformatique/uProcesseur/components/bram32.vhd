component bram32
  generic (
    init_file : String := "none";
    adr_width : Integer := 11);
  port (
  -- System
  sys_clk : in std_logic;
  sys_rst : in std_logic;
  -- Master
  di : out std_logic_vector(31 downto 0);
  we : in std_logic;
  a : in std_logic_vector(15 downto 0);
  do : in std_logic_vector(31 downto 0));
end component;
