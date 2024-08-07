--================ mux3.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--             Multiplexeur 3 entrée
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux3 IS
generic (
    N: integer :=32
);
PORT (
 Input_0, Input_1,Input_2: IN std_logic_vector(N-1 downto 0);
 sel      :  IN std_logic_vector(1 downto 0);
 out1     : OUT std_logic_vector(N-1 downto 0));
END; 

architecture rtl of mux3 is



begin
    out1 <= Input_0 when sel = "00" else
        Input_1 when sel = "01" else
        Input_2;
end architecture;

