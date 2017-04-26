library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity fifo is
    Port ( Data_in : in  STD_LOGIC_VECTOR (3 downto 0);
           CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           READ : in  STD_LOGIC;
           WRITE : in  STD_LOGIC;
           Data_out : out  STD_LOGIC_VECTOR (3 downto 0);
           EMPTY : out  STD_LOGIC;
           FULL : out  STD_LOGIC);
end fifo;

architecture Behavioral of fifo is
-- declaration
    type mem is array (integer range 3 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
    signal m : mem;
    signal head : STD_LOGIC_VECTOR(1 downto 0);
    signal tail : STD_LOGIC_VECTOR(1 downto 0);
    signal compteur : integer range 3 downto 0; --nombre d'element dans file
begin

rw : process (CLK) is
begin
    --Si on est sur un front montant de la clock
    if rising_edge(CLK) then
        if(RST = '0') then
            head <= "00";
            tail <= "00";
            compteur <= 0;
        else
            if ((READ = '1') and (WRITE = '1')) then
                if (compteur = 0) then
                    -- Si file vide on fait que write
                    tail <= tail + 1;
                    m(conv_integer(tail)) <= Data_in;
                    compteur <= compteur + 1;
                else
                    --Sinon on peut faire les deux
                    head <= head + 1;
                    Data_out <= m(conv_integer(head));
                    tail <= tail + 1;
                    m(conv_integer(tail)) <= Data_in;
                end if;
            elsif ((READ = '0') and (WRITE = '1')) then
                if (compteur < 4) then
                    tail <= tail + 1;
                    m(conv_integer(tail)) <= Data_in;
                    compteur <= compteur + 1;
                end if;
            elsif ((READ = '1') and (WRITE = '0')) then
                if (compteur > 0) then
                    head <= head + 1;
                    Data_out <= m(conv_integer(head));
                    compteur <= compteur - 1;
                end if;
            else -- READ and WRITE = 0
            end if;
        end if;
    end if;
end process;

ef : process (CLK) is
begin
--Si on est sur un front montant de la clock
    if rising_edge(CLK) then
        EMPTY <= '0';
        FULL <= '0';
        if (compteur = 0) then
            EMPTY <= '1';
        elsif (compteur = 4) then
            FULL <= '1';
        end if;
    end if;
end process;

end Behavioral;
