--================ datapath.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--             Chemin des donnée entre les composant
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY datapath IS
PORT (
    CLK,RESET,MemToReg,Branch,AluSrc,
    RegDst,RegWrite,Jump,MemReadIn,MemWriteIn     : IN std_logic;
    AluControl                                   : IN std_logic_vector(3 downto 0);
    Instruction,ReadData                         : IN std_logic_vector(31 downto 0);
    MemReadOut, MemWriteOut                      : OUT std_logic;
    PC,AluResult,WriteData                       : OUT std_logic_vector(31 downto 0)
);
end;

architecture rtl of datapath is
    --Signaux venant du fichier excel de la prep1 
    SIGNAL IF_PCNextBr          : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_PCNext            : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_PC                : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_PCPlus4           : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_ID_PCPlus4        : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_ID_Instruction    : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_PCJump            : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_SignImm           : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_rs                : std_logic_vector(4 DOWNTO 0);
    SIGNAL ID_rt                : std_logic_vector(4 DOWNTO 0);
    SIGNAL ID_rd                : std_logic_vector(4 DOWNTO 0);
    SIGNAL ID_rd1               : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_rd2               : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_Jump              : std_logic;
    SIGNAL ID_MemtoReg          : std_logic;
    SIGNAL ID_MemWrite          : std_logic;
    SIGNAL ID_MemRead           : std_logic;
    SIGNAL ID_Branch            : std_logic;
    SIGNAL ID_AluSrc            : std_logic;
    SIGNAL ID_RegDst            : std_logic;
    SIGNAL ID_RegWrite          : std_logic;
    SIGNAL ID_AluControl        : std_logic_vector(3 DOWNTO 0);
    SIGNAL EX_PCBranch          : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_PCSrc             : std_logic;
    SIGNAL EX_SignImmSh         : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_ForwardA          : std_logic_vector(1 DOWNTO 0);
    SIGNAL EX_ForwardB          : std_logic_vector(1 DOWNTO 0);
    SIGNAL EX_preSrcB           : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_SrcB              : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_SrcA              : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_AluResult         : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_Zero              : std_logic;
    SIGNAL ID_EX_AluSrc         : std_logic;
    SIGNAL ID_EX_RegDst         : std_logic;
    SIGNAL ID_EX_AluControl     : std_logic_vector(3 DOWNTO 0);
    SIGNAL EX_WriteReg          : std_logic_vector(4 downto 0);
    SIGNAL ID_EX_rt             : std_logic_vector(4 DOWNTO 0);
    SIGNAL ID_EX_rs             : std_logic_vector(4 DOWNTO 0);
    SIGNAL ID_EX_rd1            : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_EX_Branch         : std_logic;
    SIGNAL EX_cout              : std_logic;
    SIGNAL ID_EX_MemWrite       : std_logic;
    SIGNAL ID_EX_MemRead        : std_logic;
    SIGNAL ID_EX_RegWrite       : std_logic;
    SIGNAL ID_EX_MemtoReg       : std_logic;
    SIGNAL ID_EX_SignImm        : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_EX_rd             : std_logic_vector(4 DOWNTO 0);
    SIGNAL ID_EX_rd2            : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_EX_PCPlus4        : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_EX_instruction    : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_AluResult     : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_MemWrite      : std_logic;
    SIGNAL EX_MEM_MemRead       : std_logic;
    SIGNAL EX_MEM_MemtoReg      : std_logic;
    SIGNAL EX_MEM_RegWrite      : std_logic;
    SIGNAL EX_MEM_preSrcB       : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_WriteReg      : std_logic_vector(4 DOWNTO 0);
    SIGNAL EX_MEM_instruction   : std_logic_vector(31 DOWNTO 0);
    SIGNAL WB_Result            : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_WriteReg      : std_logic_vector(4 downto 0);
    SIGNAL MEM_WB_MemtoReg      : std_logic;
    SIGNAL MEM_WB_RegWrite      : std_logic;
    SIGNAL MEM_WB_AluResult     : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_readdata      : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_instruction   : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_MEM_MemWrite      : std_logic;
    
begin    
    b1 : entity work.Bloc1
    port map (
        clk   =>CLK,
        reset => RESET,
        EX_PCBranch => EX_PCBranch,
        ID_PCJump =>ID_PCJump,
        EX_PCSrc=>EX_PCSrc,
        ID_Jump =>ID_Jump,
        IF_PCPlus4 =>IF_PCPlus4,
        pc_s=>PC
    );

    Bloc2_inst: entity work.Bloc2
    port map(
       clk => clk,
       reset => reset,
       IF_ID_PCPlus4 => IF_ID_PCPlus4,
       Instruction => Instruction,
       WB_Result => WB_Result,
       MEM_WB_WriteReg => MEM_WB_WriteReg,
       MEM_WB_RegWrite => MEM_WB_RegWrite,
       ID_MemtoReg => ID_MemtoReg,
       ID_MemWrite => ID_MemWrite,
       ID_EX_PCPlus4 => ID_EX_PCPlus4,
       ID_rd1 => ID_rd1,
       ID_rd2 => ID_rd2,
       ID_PCJump => ID_PCJump,
       ID_EX_SignImm => ID_EX_SignImm,
       ID_EX_AluControl => ID_EX_AluControl,
       ID_EX_rt => ID_EX_rt,
       ID_EX_rd => ID_EX_rd,
       ID_EX_rs => ID_EX_rs
   );

   Bloc3_inst: entity work.Bloc3
   port map(
      clk => clk,
      reset => reset,
      ID_EX_PCPlus4 => ID_EX_PCPlus4,
      ID_EX_rd1 => ID_EX_rd1,
      ID_EX_rd2 => ID_EX_rd2,
      ID_EX_SignImm => ID_EX_SignImm,
      WB_Result => WB_Result,
      EX_MEM_AluResult => EX_MEM_AluResult,
      ID_EX_rs => ID_EX_rs,
      ID_EX_rt => ID_EX_rt,
      ID_EX_rd => ID_EX_rd,
      EX_MEM_WriteReg => EX_MEM_WriteReg,
      MEM_WB_WriteReg => MEM_WB_WriteReg,
      ID_MEM_MemWrite => ID_MEM_MemWrite,
      ID_EX_RegDst => RegDst,
      ID_EX_AluSrc => AluSrc,
      ID_EX_Branch => Branch,
      ID_EX_RegWrite => RegWrite,
      ID_EX_MemtoReg => MemToReg,
      ID_EX_MemWrite => MemWriteIn,
      ID_EX_MemRead => MemReadIn,
      EX_AluResult => EX_AluResult,
      EX_PCBranch => EX_PCBranch,
      EX_WriteReg => EX_WriteReg,
      EX_MEM_RegWrite => EX_MEM_RegWrite,
      EX_PCSrc => EX_PCSrc,
      EX_MEM_MemtoReg => EX_MEM_MemtoReg,
      EX_MEM_MemWrite => EX_MEM_MemWrite,
      EX_MEM_MemRead => EX_MEM_MemRead,
      ID_EX_AluControl => AluControl
  );
Bloc4_inst: entity work.Bloc4
 port map(
    clk => clk,
    reset => reset,
    EX_MEM_AluResult => EX_AluResult,
    EX_MEM_preSrcB => EX_MEM_preSrcB,
    EX_MEM_WriteReg => EX_MEM_WriteReg,
    EX_MEM_MemRead => EX_MEM_MemRead,
    EX_MEM_MemtoReg => EX_MEM_MemtoReg,
    EX_MEM_RegWrite => EX_MEM_RegWrite,
    EX_MEM_MemWrite => EX_MEM_MemWrite,
    EX_MEM_AluResult_o => EX_MEM_AluResult,
    MEM_WB_AluResult => MEM_WB_AluResult,
    MEM_WB_readdata => MEM_WB_readdata,
    MEM_WB_WriteReg => EX_MEM_WriteReg,
    MEM_WB_WriteReg_o => MEM_WB_WriteReg,
    MEM_WB_RegWrite => MEM_WB_RegWrite,
    MEM_WB_MemtoReg => MEM_WB_MemtoReg,
    DMEM_MEMWRITE => MemWriteOut,
    DMEM_MEMREAD => MemReadOut,
    DMEM_PRESRCB => WriteData,
    DMEM_ALURESULT => AluResult,
    DMEM_RESULT => ReadData
);                     

Bloc5_inst: entity work.Bloc5
 port map(
    clk => clk,
    reset => reset,
    MEM_WB_readdata => MEM_WB_readdata,
    MEM_WB_AluResult => MEM_WB_AluResult,
    MEM_WB_WriteReg => EX_MEM_WriteReg,
    MEM_WB_MemtoReg => MEM_WB_MemtoReg,
    WB_Result => WB_Result,
    MEM_WB_WriteReg_o => MEM_WB_WriteReg,
    MEM_WB_RegWrite => EX_MEM_RegWrite,
    MEM_WB_RegWrite_o => MEM_WB_RegWrite
);
    
end architecture;
