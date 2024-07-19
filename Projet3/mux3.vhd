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
END; -- Controller;

architecture rtl of mux3 is

signal intermediaire : std_logic_vector(N-1 downto 0);

begin
    --Sort sur la sortie "out1" selon le selectionneur "sel"
    with sel select
    out1<=  Input_0 when "00",
        Input_1 when "01",
         Input_2 when others;    
end architecture;

