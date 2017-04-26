LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fifotest IS
END fifotest;

ARCHITECTURE behavior OF fifotest IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT fifo
    PORT(
         Data_in : IN  std_logic_vector(3 downto 0);
         CLK : IN  std_logic;
         RST : IN  std_logic;
         READ : IN  std_logic;
         WRITE : IN  std_logic;
         Data_out : OUT  std_logic_vector(3 downto 0);
         EMPTY : OUT  std_logic;
         FULL : OUT  std_logic
        );
    END COMPONENT;


   --Inputs
   signal Data_in : std_logic_vector(3 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal READ : std_logic := '0';
   signal WRITE : std_logic := '0';

   --Outputs
   signal Data_out : std_logic_vector(3 downto 0);
   signal EMPTY : std_logic;
   signal FULL : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
   uut: fifo PORT MAP (
          Data_in => Data_in,
          CLK => CLK,
          RST => RST,
          READ => READ,
          WRITE => WRITE,
          Data_out => Data_out,
          EMPTY => EMPTY,
          FULL => FULL
        );

   -- Clock process definitions
   CLK_process :process
   begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
        -- hold reset state for 100 ns.
        wait for 20 ns;

        wait for CLK_period*10;

        -- insert stimulus here
        RST <= '0';
        wait for 20 ns;

        RST <= '1';

        Data_in <= "1001";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        READ <= '1';
        wait for CLK_period;
        READ <= '0';

        Data_in <= "0010";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        READ <= '1';
        wait for CLK_period;
        READ <= '0';

        Data_in <= "1101";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        Data_in <= "1011";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        Data_in <= "0011";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        Data_in <= "0001";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        Data_in <= "1000";
        WRITE <= '1';
        wait for CLK_period;
        WRITE <= '0';

        READ <= '1';
        wait for CLK_period*20;
        READ <= '0';

        wait for 100 ns;

        wait;
   end process;

END;
