--========================= imem.vhd ============================
-- ELE-343 Conception des systèmes ordinés
-- HIVER 2017, Ecole de technologie supérieure
-- Auteur : Chakib Tadj, Vincent Trudel-Lapierre, Yves Blaquière
-- =============================================================
-- Description: imem        
-- =============================================================

LIBRARY ieee;
LIBRARY std;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY imem IS -- Memoire d'instructions
  PORT (adresse : IN  std_logic_vector(5 DOWNTO 0); -- Taille a modifier
                                                    -- selon le programme 
        data : OUT std_logic_vector(31 DOWNTO 0));
END;  -- imem;

ARCHITECTURE imem_arch OF imem IS

  CONSTANT TAILLE_ROM : positive := 32;  -- taille de la rom (modifier au besoin)
  TYPE romtype IS ARRAY (0 TO TAILLE_ROM) OF std_logic_vector(31 DOWNTO 0);


  CONSTANT Rom : romtype := (
    0  => x"20030001",
    1  => x"00032820",
    2  => x"00a33822",
    3  => x"20640004",
    4  => x"00641024",
    5  => x"00472825",
    6  => x"10e3000A",
    7  => x"20000000",
    8  => x"20000000",
    9  => x"0085102a",
    10 => x"ac841fd7",
    11 => x"8ca21fdb",
    12  => x"20000000",
    13 => x"2047fffc",
    14  => x"20000000",
    15 => x"08000006",
    16  => x"20000000",
    17 => x"00e2202a",
    18 => x"00e31024",
    19 => x"8c471fdb",
    20  => x"20000000",
    21 => x"ac452003",
    22 => x"10a70001",
    23 => x"20000000",
    24 => x"20000000",
    25 => x"00a33825",
    26 => x"8ce42003",
    27  => x"20000000",
    28 => x"08000000",
    29  => x"20000000",
    30  => x"20000000",
    31  => x"20000000",
    32  => x"20000000");

BEGIN
  PROCESS (adresse)
  BEGIN
    data <= Rom(to_integer(unsigned((adresse))));
  END PROCESS;
END imem_arch;

