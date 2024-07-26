LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--A revoir je suis pas sur
entity Bloc4 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        EX_MEM_AluResult,EX_MEM_preSrcB: in std_logic_vector(31 downto 0);
        EX_MEM_WriteReg: in std_logic_vector(4 downto 0);
        EX_MEM_MemRead ,EX_MEM_MemtoReg,EX_MEM_RegWrite,EX_MEM_MemWrite: in std_logic;
        EX_MEM_AluResult_o,MEM_WB_AluResult,MEM_WB_readdata  :out std_logic_vector(31 downto 0);
        MEM_WB_WriteReg : out std_logic_vector(4 downto 0);
        EX_MEM_WriteReg_o, EX_MEM_RegWrite_o,MEM_WB_MemtoReg : out std_logic

    );
end entity;

architecture rtl of Bloc4 is

begin

    

end architecture;