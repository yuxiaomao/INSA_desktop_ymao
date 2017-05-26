library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipeline is
    Port ( CLK : in  STD_LOGIC;
          NOP : in STD_LOGIC;
          OPIN : in  STD_LOGIC_VECTOR (7 downto 0);
          AIN : in  STD_LOGIC_VECTOR (15 downto 0);
          BIN : in  STD_LOGIC_VECTOR (15 downto 0);
          CIN : in  STD_LOGIC_VECTOR (15 downto 0);
          OPOUT : out  STD_LOGIC_VECTOR (7 downto 0);
          AOUT : out  STD_LOGIC_VECTOR (15 downto 0);
          BOUT : out  STD_LOGIC_VECTOR (15 downto 0);
          COUT : out  STD_LOGIC_VECTOR (15 downto 0));
end pipeline;

architecture Behavioral of pipeline is

begin

pl : process (CLK, NOP) is
begin
    if rising_edge(CLK) then
        OPOUT <= OPIN;
        AOUT <= AIN;
        BOUT <= BIN;
        COUT <= CIN;
    end if;

    if (NOP = '1') then
        OPOUT <= x"00";
        AOUT <= x"0000";
        BOUT <= x"0000";
        COUT <= x"0000";
    end if;
end process;

end Behavioral;
