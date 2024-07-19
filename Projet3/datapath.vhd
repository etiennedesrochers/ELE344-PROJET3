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
    SIGNAL EX_WriteReg          : std_logic_vector(4 DOWNTO 0);
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
    SIGNAL MEM_WB_WriteReg      : std_logic;
    SIGNAL MEM_WB_MemtoReg      : std_logic;
    SIGNAL MEM_WB_RegWrite      : std_logic;
    SIGNAL MEM_WB_AluResult     : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_readdata      : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_instruction   : std_logic_vector(31 DOWNTO 0);



    --Signaux pour les connections
    signal PCPLUS4 :std_Logic_vector(31 downto 0);
    signal PC_s    :std_logic_vector(31 downto 0);
    signal PCNEXT :std_Logic_vector(31 downto 0);
    signal SignImmSh: std_logic_vector(31 downto 0);
    signal SignImm: std_logic_vector(31 downto 0);
    signal PCBranch: std_logic_vector(31 downto 0);
    signal PCJUMP: std_logic_vector(31 downto 0);
    signal PCNextbr: std_logic_vector(31 downto 0);
    signal WriteReg : std_logic_vector(4 downto 0);
    signal Result : std_logic_vector(31 downto 0);
    signal ReadData1: std_logic_vector(31 downto 0); 
    signal ReadData2: std_logic_vector(31 downto 0);
    signal srcB : std_logic_vector(31 downto 0);
    signal AluResult_s : std_logic_vector(31 downto 0);
    signal PCSrc: std_logic;
    signal Zero : std_logic;
    signal cout : std_logic;
    
begin   
    --mux 2
end architecture;