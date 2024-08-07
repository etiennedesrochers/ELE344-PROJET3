--================ unite.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--             unite de control 
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity unite is
    port (
        ID_EX_rs, ID_EX_rt, EX_MEM_WriteReg, MEM_WB_WriteReg : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        EX_MEM_RegWrite,MEM_WB_RegWrite: in std_logic;
        EX_ForwardA, EX_ForwardB : OUT STD_LOGIC_VECTOR(1 downto 0)
    );
end entity;

ARCHITECTURE rtl OF unite IS
BEGIN



process (EX_MEM_RegWrite,ID_EX_rs, ID_EX_rt, EX_MEM_WriteReg, MEM_WB_WriteReg,MEM_WB_RegWrite)
begin
    --Valeur de base pour les sortie
    EX_ForwardA <= "00";
    EX_ForwardB <= "00";
    --On regarde si le registre courrent est utilisé dans l'étages EX_MEM
    if(EX_MEM_RegWrite ='1' and (EX_MEM_WriteReg /= "00000") and (EX_MEM_WriteReg = ID_EX_rs)) then
        EX_ForwardA <= "10";
    --On regarde si le registre courrent est utilisé dans l'étages MEM_WB
    elsif (MEM_WB_RegWrite = '1' and  MEM_WB_WriteReg /= "00000" and MEM_WB_WriteReg = ID_EX_rs) then
        EX_ForwardA <= "01";
    end if;

    --On regarde si le registre courrent est utilisé dans l'étages EX_MEM
    if(EX_MEM_RegWrite ='1' and EX_MEM_WriteReg /= "00000" and EX_MEM_WriteReg = ID_EX_rt) then
        EX_ForwardB <= "10"; 
    --On regarde si le registre courrent est utilisé dans l'étages MEM_WB
    elsif(MEM_WB_RegWrite ='1'  and  MEM_WB_WriteReg /= "00000" and MEM_WB_WriteReg = ID_EX_rt) then
        EX_ForwardB <= "01";
     end if;
end process;

END architecture;