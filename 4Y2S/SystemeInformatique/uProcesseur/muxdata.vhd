library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity muxdata is
    Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           DATA_DI : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOUT : out  STD_LOGIC_VECTOR (15 downto 0));
end muxdata;

architecture Behavioral of muxdata is

begin

multiplexeur : process (OP, B, DATA_DI) is
begin
  case OP is
  when x"07" => --LOAD
    DataOUT <= DATA_DI;
  when others =>
    DataOUT <= B;
  end case;
end process;

end Behavioral;
