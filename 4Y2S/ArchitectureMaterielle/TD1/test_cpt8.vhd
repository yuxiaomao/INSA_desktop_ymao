LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_cpt8 IS
END test_cpt8;

ARCHITECTURE behavior OF test_cpt8 IS

    -- Component Declaration for the Unit Under Test (UUT)

-- Recopie l'identité du port dans une entité cpt8
    COMPONENT cpt8
    PORT(
         DIN : IN  std_logic_vector(7 downto 0);
         DOUT : OUT  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         RST : IN  std_logic;
         LOAD : IN  std_logic;
         SENS : IN  std_logic;
         EN : IN  std_logic
        );
    END COMPONENT;


   --Inputs
   -- On définit les signaux comme des variables du programme
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal LOAD : std_logic := '0';
   signal SENS : std_logic := '0';
   signal EN : std_logic := '0';

   --Outputs
   signal DOUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    -- DIN du component qu'on cable vers DIN de l'entité
   uut: cpt8 PORT MAP (
          DIN => DIN,
          DOUT => DOUT,
          CLK => CLK,
          RST => RST,
          LOAD => LOAD,
          SENS => SENS,
          EN => EN
        );

   -- Clock process definitions
   -- process = code qui boucle à l'infini
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
      wait for 100 ns;

      wait for CLK_period*10;

      -- insert stimulus here
        DIN<="01011001";
        wait for 20 ns;

        RST <= '1';
        wait for 20 ns;

        LOAD <= '1';
        wait for 20 ns;

        LOAD <= '0';
        EN <= '0';
        SENS <='0';
        wait for 100 ns;

        SENS <='1';

        wait for 100 ns;
        EN <= '0';
        wait for 20 ns;
        RST <= '0';

      wait;
   end process;

END;
