--================ pcplus4.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--            Additionne au pc la valeur 4 pour passer au prochain 
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC_Plus4 IS
PORT (
    PC : in std_logic_vector (31 downto 0);
    PC_OUT: out std_logic_vector(31 downto 0)
);
end;

architecture rtl of PC_Plus4 is
    signal add4: unsigned(31 downto 0);
begin
    --Additione 4 à la valeur du PC 
    add4 <= unsigned(PC) +4;
    PC_OUT <= std_logic_vector(add4);
end architecture;

