library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity muxual is
    Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           S : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOUT : out  STD_LOGIC_VECTOR (15 downto 0));
end muxual;

architecture Behavioral of muxual is

begin

multiplexeur : process (OP, B, S) is
begin
  case OP is -- out<=S if calcul
  when x"01" => --ADD
    DataOUT <= S;
  when x"02" => --MUL
    DataOUT <= S;
  when x"03" => --SUB
    DataOUT <= S;
  when x"04" => --DIV
    DataOUT <= S;
  when x"07" => --LOAD R31+offset
    DataOUT <= S;
  when x"08" => --store R31+offset
    DataOUT <= S;
  when others =>
    DataOUT <= B;
  end case;
end process;

end Behavioral;
