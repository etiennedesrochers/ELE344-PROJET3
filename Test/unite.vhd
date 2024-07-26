LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity unite is
    port (
        ID_EX_rs, ID_EX_rt, EX_MEM_WriteReg, MEM_WB_WriteReg,MEM_WB_REGWRTIE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Forward_A, Forward_B : OUT STD_LOGIC_VECTOR(1 downto 0);
        EX_MEM_RegWrite : in std_logic
        
    );
end entity;

ARCHITECTURE rtl OF unite IS
BEGIN
process (EX_MEM_RegWrite,ID_EX_rs, ID_EX_rt, EX_MEM_WriteReg, MEM_WB_WriteReg,MEM_WB_REGWRTIE)
begin
    if(EX_MEM_RegWrite ='1' and (EX_MEM_WriteReg /= "0000") and (EX_MEM_WriteReg = ID_EX_rs)) then
            Forward_A <= "10";
    elsif (MEM_WB_REGWRTIE /="0" and  EX_MEM_WriteReg /= "0000" and MEM_WB_WriteReg = ID_EX_rs) then
            Forward_A <= "01";
    else 
        Forward_A <= "00";    
    end if;

    if(EX_MEM_RegWrite ='1' and EX_MEM_WriteReg /= "0000" and EX_MEM_WriteReg = ID_EX_rt) then
        Forward_B <= "10";
    elsif(MEM_WB_REGWRTIE/="0"  and  EX_MEM_WriteReg /= "0000" and MEM_WB_WriteReg = ID_EX_rt) then
        Forward_B <= "01";
    else 
        Forward_B <= "00";
     end if;
end process;

END architecture;