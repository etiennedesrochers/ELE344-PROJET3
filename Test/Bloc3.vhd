LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc3 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        ID_EX_PCPlus4,ID_EX_rd1,ID_EX_rd2,ID_EX_SignImm,WB_Result,EX_MEM_AluResult  : in std_logic_vector(31 downto 0);
        ID_EX_rs, ID_EX_rt,ID_EX_rd,EX_MEM_WriteReg,MEM_WB_WriteReg   : in std_logic_vector(4 downto 0);
        
        ID_MEM_MemWrite,ID_EX_RegDst,ID_EX_AluSrc,ID_EX_Branch,ID_EX_RegWrite,ID_EX_MemtoReg,ID_EX_MemWrite,ID_EX_MemRead: in std_logic;
        EX_AluResult,EX_preSrcB,EX_PCBranch : out std_logic_vector(31 downto 0);
        EX_WriteReg : out std_logic_vector(4 downto 0);
        EX_PCSrc,EX_MEM_MemtoReg,EX_MEM_RegWrite,EX_MEM_MemWrite ,EX_MEM_MemRead : out std_logic;
        ID_EX_AluControl: in std_logic_vector(3 downto 0)
        
    );
end entity;

architecture rtl of Bloc3 is

begin

    

end architecture;
