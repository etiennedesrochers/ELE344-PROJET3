--================ mux2.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--             Multiplexeur 2 entrée
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux2 IS
generic (
    N: integer :=32
);
PORT (
 Input_0, Input_1 : IN std_logic_vector(N-1 downto 0);
 sel      :  IN std_logic;
 out1     : OUT std_logic_vector(N-1 downto 0));
END; -- Controller;

architecture rtl of mux2 is

begin
out1 <= Input_1 when sel = '1' else Input_1;
end architecture;

