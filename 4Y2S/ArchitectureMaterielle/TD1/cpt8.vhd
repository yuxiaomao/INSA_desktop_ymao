library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; --Addition avec INTEGER et STDLOGIC VECTOR
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Addition avec STDLOGIC_VECTOR et lui même

entity cpt8 is
    Port ( DIN : in  STD_LOGIC_VECTOR (7 downto 0);
           DOUT : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           LOAD : in  STD_LOGIC;
           SENS : in  STD_LOGIC;
           EN : in  STD_LOGIC);
end cpt8;

architecture Behavioral of cpt8 is
--Declaration
--Signal de la mémoire interne qu'on va incrémenter de 1 à chaque itération
    signal memory : STD_LOGIC_VECTOR (7 downto 0);

begin
--Corps

DOUT <= memory;

--  le compter on fait un process sur la CLK
compter : process (CLK) is

begin
    --Si on est sur un front montant de la clock + ' 1' "00000001"
    if rising_edge(CLK) then
        if(RST = '0') then
            memory <= "00000000";
        else
            if(LOAD='1') then
                memory <= DIN;
            else
                if(EN='0') then
                    if(SENS='0') then --alors on décrémente
                    memory <= memory-"00000001";
                    else
                    memory <= memory+"00000001";
                    end if;
                end if;
            end if;
        end if;
    end if;
end process;

end Behavioral;
