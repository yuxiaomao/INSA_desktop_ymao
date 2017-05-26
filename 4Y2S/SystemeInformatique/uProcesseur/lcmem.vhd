library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lcmem is
    Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
           LC_OUT : out  STD_LOGIC);
end lcmem;

architecture Behavioral of lcmem is

begin

logic_controller : process (OP) is
begin
  case OP is
  when x"08" => --STORE
    LC_OUT <= '1';
  when others =>
    LC_OUT <= '0';
  end case;
end process;

end Behavioral;
