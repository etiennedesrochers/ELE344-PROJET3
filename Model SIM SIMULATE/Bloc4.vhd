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
        MEM_WB_RegWrite,MEM_WB_MemtoReg : out std_logic;
        DMEM_MEMWRITE,DMEM_MEMREAD:out  std_logic;
        DMEM_PRESRCB, DMEM_ALURESULT : out std_logic_vector(31 downto 0);
        DMEM_RESULT : in std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bloc4 is
    signal s_EX_MEM_MemtoReg : std_logic;
    signal s_EX_MEM_RegWrite : std_logic;
    signal s_EX_MEM_MemRead  : std_logic;
    signal s_EX_MEM_MemWrite : std_logic;
    signal s_EX_MEM_AluResult: std_logic_vector(31 downto 0); 
    signal s_EX_MEM_preSrcB  : std_logic_vector(31 downto 0); 
    signal s_EX_MEM_WriteReg : std_logic_vector(4 downto 0);

begin
    
    process (clk)
    begin
        if (rising_edge(clk)) then
            s_EX_MEM_MemtoReg <=EX_MEM_MemtoReg;
            s_EX_MEM_RegWrite <=EX_MEM_RegWrite;
            s_EX_MEM_MemRead  <=EX_MEM_MemRead ;
            s_EX_MEM_MemWrite <=EX_MEM_MemWrite;
            s_EX_MEM_AluResult<= EX_MEM_AluResult;
            s_EX_MEM_preSrcB  <= EX_MEM_preSrcB  ;
            s_EX_MEM_WriteReg<= EX_MEM_WriteReg;
        end if;
    end process;

    DMEM_MEMWRITE   <= s_EX_MEM_MemWrite;
    DMEM_MEMREAD    <= s_EX_MEM_MemRead;
    DMEM_PRESRCB   <= s_EX_MEM_preSrcB;
    DMEM_ALURESULT  <= s_EX_MEM_AluResult;
    MEM_WB_MemtoReg <=s_EX_MEM_MemtoReg;
    MEM_WB_RegWrite <=s_EX_MEM_RegWrite;
    MEM_WB_readdata<=DMEM_RESULT;
    MEM_WB_AluResult <= s_EX_MEM_AluResult;
    MEM_WB_WriteReg<=s_EX_MEM_WriteReg;
    EX_MEM_AluResult_o <= s_EX_MEM_AluResult;
end architecture;