--================ alu.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ************
-- ***** Code DESE28369801 ************
-- =============================================================
-- Description: 
--              Architecture RTL du UAL de N bits.
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UAL IS
  GENERIC (N : integer := 32);
  PORT (ualControl : IN  std_logic_vector(3 DOWNTO 0);
        srcA, srcB : IN  std_logic_vector(N-1 DOWNTO 0);
        result     : OUT std_logic_vector(N-1 DOWNTO 0);
        cout, zero : OUT std_logic);
END UAL;

ARCHITECTURE rtl OF UAL IS
  SIGNAL operation                    : std_logic_vector(1 DOWNTO 0);
  SIGNAL op1, op2                     : std_logic;
  SIGNAL somme, srcAMux, srcBMux, res : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL retenueSomme                 : unsigned(N DOWNTO 0);
  constant zeros : std_logic_vector(res'range) := (others => '0');
BEGIN
  --Assignation des valeur des opération
  operation <= ualControl(1 DOWNTO 0);
  op1       <= ualControl(3);
  op2       <= ualControl(2);

  --Assignation des valeurs des multiplexeur  
  srcAMux   <= srcA when op1 ='0' else not srcA;
  srcBMux   <= srcB when op2 ='0' else not srcB;

  -- Multiplexeur 4-a-1 pour generer le signal res
  PROCESS (ualControl, srcAMux, srcBMux, somme)
  BEGIN
    case operation is
      when "00" => res <= srcAMux and srcBMux; --AND
      when "01" => res <= srcAMux or srcBMux;  --OR
      when "10" => res <= somme;               --ADD
      when others =>                           --SLT
        res <= (others => '0');
        res(0) <= somme(N-1);
    end case;
  END PROCESS;

  --Assignation de la valeur de la somme sur 33 bits
  retenueSomme <= resize(unsigned(srcAMux), N+1) + unsigned(srcBMux) + unsigned'("" & op2);
  --Assigne la valeur de la somme sur 32 bits
  somme <= std_logic_vector(retenueSomme(N-1 DOWNTO 0));
  --Assigne la valeur de la retenue
  cout <= retenueSomme(N);
  --Assigne la valeur result = 0 
  zero <= '1' when (res = zeros) else '0';
  --Assigne le resultat
  result <= res;

END rtl;
