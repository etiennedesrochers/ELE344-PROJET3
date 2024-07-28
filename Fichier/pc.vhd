--================ pc.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--             Bascule du pc
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC IS
PORT (
    Clk,RESET   : IN std_logic;
    PC_IN       : IN std_logic_vector(31 downto 0);
    PC_OUT      : OUT std_logic_vector(31 downto 0)
);
end;

architecture rtl of PC is
    signal PC_Value : std_logic_vector(31 downto 0);
begin
    --Process qui attend qu'il y ai un changement sur les Signaux CLK,RESET et PC_IN
    process (Clk,RESET,PC_IN)
    begin
        --Si on a un reset
        if RESET = '1' then
            PC_Value <= (others=>'0');
        
        --Sur un front montant
        elsif rising_edge(CLK) then 
            --Sort la prochaine adresse
            PC_Value <= PC_IN;
        end if;             
    end process;
    --Assignation de sortie
    PC_OUT <= PC_Value;
end architecture;