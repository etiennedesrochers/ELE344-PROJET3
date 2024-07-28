LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity unite is
    port (
        ID_EX_rs, ID_EX_rt, EX_MEM_WriteReg, MEM_WB_WriteReg : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        EX_ForwardA, EX_ForwardB : OUT STD_LOGIC_VECTOR(1 downto 0);
        EX_MEM_RegWrite,MEM_WB_RegWrite: in std_logic
        
    );
end entity;

ARCHITECTURE rtl OF unite IS
BEGIN
process (EX_MEM_RegWrite,ID_EX_rs, ID_EX_rt, EX_MEM_WriteReg, MEM_WB_WriteReg,MEM_WB_RegWrite)
begin
    if(EX_MEM_RegWrite ='1' and (EX_MEM_WriteReg /= "0000") and (EX_MEM_WriteReg = ID_EX_rs)) then
        EX_ForwardA <= "10";
    elsif (MEM_WB_RegWrite = '1' and  EX_MEM_WriteReg /= "0000" and MEM_WB_WriteReg = ID_EX_rs) then
        EX_ForwardA <= "01";
    else 
        EX_ForwardA <= "00";    
    end if;

    if(EX_MEM_RegWrite ='1' and EX_MEM_WriteReg /= "0000" and EX_MEM_WriteReg = ID_EX_rt) then
        EX_ForwardB <= "10";
    elsif(MEM_WB_RegWrite ='1'  and  EX_MEM_WriteReg /= "0000" and MEM_WB_WriteReg = ID_EX_rt) then
        EX_ForwardB <= "01";
    else 
        EX_ForwardB <= "00";
     end if;
end process;

END architecture;