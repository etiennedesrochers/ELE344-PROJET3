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

 
    SIGNAL IF_PC                : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_PCPlus4           : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_ID_PCPlus4        : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_ID_Instruction    : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_PCJump            : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_rd1               : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_rd2               : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_PCBranch          : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_PCSrc             : std_logic;

    SIGNAL EX_preSrcB           : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_AluResult         : std_logic_vector(31 DOWNTO 0);
   
 
    SIGNAL EX_cout              : std_logic;
    signal EX_SignImmSh         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL EX_WriteReg          : std_logic_vector(4 downto 0);
    SIGNAL ID_EX_MemWrite       : std_logic;
    SIGNAL ID_EX_MemRead        : std_logic;
    SIGNAL ID_EX_RegWrite       : std_logic;
    SIGNAL ID_EX_MemtoReg       : std_logic;
    SIGNAL ID_EX_SignImm        : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_AluResult     : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_MemWrite      : std_logic;
    SIGNAL EX_MEM_MemRead       : std_logic;
    SIGNAL EX_MEM_MemtoReg      : std_logic;
    SIGNAL EX_MEM_RegWrite      : std_logic;
    SIGNAL EX_MEM_preSrcB       : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_WriteReg      : std_logic_vector(4 DOWNTO 0);
    SIGNAL WB_Result            : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_WriteReg      : std_logic_vector(4 downto 0);
    SIGNAL MEM_WB_MemtoReg      : std_logic;
    SIGNAL MEM_WB_RegWrite      : std_logic;
    SIGNAL MEM_WB_AluResult     : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_readdata      : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_instruction   : std_logic_vector(31 DOWNTO 0);
    signal ID_SignImm: std_logic_vector(31 downto 0);
    signal ID_rs : std_logic_vector(4 downto 0);
    signal ID_rt : std_logic_vector(4 downto 0);
    signal ID_rd : std_logic_vector(4 downto 0);
    signal ID_EX_rs: std_logic_vector(4 downto 0);
    signal ID_EX_rt: std_logic_vector(4 downto 0);
    signal ID_EX_rd: std_logic_vector(4 downto 0);
    signal IF_PCNextBr : std_logic_vector(31 downto 0);
    signal ID_JUMP : std_logic;
    signal IF_PCNext: std_logic_vector(31 downto 0);
    signal ID_EX_rd1: std_logic_vector(31 downto 0);
    signal ID_EX_rd2: std_logic_vector(31 downto 0);
    signal ID_EX_PCPlus4 :std_logic_vector(31 downto 0);
    signal ID_MemtoReg: std_logic;
    signal ID_MemWrite: std_logic;
    signal ID_Branch: std_logic;
    signal ID_EX_Branch: std_logic;
    signal ID_EX_Alusrc: std_logic;
    signal ID_Regdst: std_logic;
    signal ID_EX_Regdst: std_logic;
    signal ID_RegWrite: std_logic;
    signal ID_AluControl: std_logic_vector(3 downto 0);
    signal ID_EX_AluControl : std_logic_vector(3 downto 0);
    signal EX_Zero : std_logic;
    signal EX_ForwardA : std_logic_vector(1 downto 0);
    signal EX_SrcA : std_logic_vector(31 downto 0);
    signal EX_ForwardB : std_logic_vector(1 downto 0);
    signal EX_SrcB : std_logic_vector(31 downto 0);
begin
  --###############################################BLOC1################################################
    
    IF_PCNextBr <= IF_PCPlus4 when EX_PCSrc = '0' else EX_PCBranch;
    IF_PCNext <= IF_PCNextBr when Jump = '0' else ID_PCJump;
    PC_inst: entity work.PC
    port map(
       Clk => Clk,
       RESET => RESET,
       PC_IN => IF_PCNext,
       PC_OUT => If_PC);
   --On connecte le pc courrent sur la sortie pc pour l'envoyer sur le imem
   PC <= If_PC;

   --Additionneur pc plus 4
   PC_Plus4_inst: entity work.PC_Plus4
   port map(
      PC => IF_PC,
      PC_OUT => IF_PCPlus4
  );
--####################################################################################################

--##################################################BASCULEIF_ID######################################
process (Clk,RESET)
begin
    --Si on a un reset
    if RESET = '1' then
        IF_ID_PCPlus4 <= (others => '0');
        IF_ID_Instruction <= (others => '0');
       
    --Sur un front montant
    elsif rising_edge(CLK) then 
        IF_ID_PCPlus4 <= IF_PCPlus4;
        IF_ID_Instruction<= Instruction;
    end if;             
end process;
--####################################################################################################


--#######################################BLOC2########################################################
ID_PCJump <= IF_ID_PCPlus4(31 downto 28) &  IF_ID_Instruction(25 downto 0) & "00";
RegFile_inst: entity work.RegFile
 port map(
    clk => clk,
    we => MEM_WB_RegWrite,
    ra1 => IF_ID_Instruction(25 downto 21),
    ra2 => IF_ID_Instruction(20 downto 16),
    wa => MEM_WB_WriteReg,
    wd => EX_MEM_AluResult,
    rd1 => ID_rd1,
    rd2 => ID_rd2
);

ID_SignImm <= ((16 downto 0 => IF_ID_Instruction(15)) ) & (IF_ID_Instruction(14 downto 0)) ;
ID_rs<= IF_ID_Instruction(25 downto 21);
ID_rt<= IF_ID_Instruction(20 downto 16);
ID_rd<= IF_ID_Instruction(15 downto 11);
--####################################################################################################
process (Clk,RESET)
begin
    --Si on a un reset
    if RESET = '1' then
        ID_EX_MemtoReg      <= '0';
        ID_EX_MemWrite      <= '0';
        ID_EX_MemRead       <= '0';
        ID_EX_Branch        <= '0';
        ID_EX_Alusrc        <= '0';
        ID_EX_Regdst        <= '0';
        ID_EX_RegWrite      <= '0';
        ID_EX_AluControl    <= (others => '0');
        ID_EX_PCPlus4       <= (others => '0');
        ID_EX_SignImm       <= (others => '0');
        ID_EX_rs            <= (others => '0');
        ID_EX_rt            <= (others => '0');
        ID_EX_rd            <= (others => '0');
        ID_EX_rd1           <= (others => '0');
        ID_EX_rd2           <= (others => '0');

    --Sur un front montant
    elsif rising_edge(CLK) then 
        ID_EX_MemtoReg      <= MemToReg;
        ID_EX_MemWrite      <= MemWriteIn;
        ID_EX_MemRead       <= MemReadIn;
        ID_EX_Branch        <= Branch;
        ID_EX_Alusrc        <=  AluSrc;
        ID_EX_Regdst        <= RegDst;
        ID_EX_RegWrite      <= RegWrite;
        ID_EX_AluControl    <=  AluControl;
        ID_EX_PCPlus4       <= IF_ID_PCPlus4;
        ID_EX_SignImm       <= ID_SignImm;
        ID_EX_rs            <= ID_rs;
        ID_EX_rt            <= ID_rt;
        ID_EX_rd            <= ID_rd;
        ID_EX_rd1           <= ID_rd1;
        ID_EX_rd2           <= ID_rd2;
    end if;             
end process;

--####################################################################################################

--###############################################BLOC3#####################################################
EX_PCSrc <= ID_EX_Branch and EX_Zero;
EX_SignImmSh <= ID_EX_SignImm (29 downto 0) &"00";

EX_PCBranch <= std_logic_vector(unsigned(ID_EX_PCPlus4) + unsigned(EX_SignImmSh)); 


EX_SrcA <= ID_Ex_rd1 when EX_ForwardA = "00" else
WB_Result when EX_ForwardA = "01" else
    EX_MEM_AluResult;


EX_preSrcB <= ID_Ex_rd2 when EX_ForwardB = "00" else
WB_Result when EX_ForwardB = "01" else
    EX_MEM_AluResult;

EX_SrcB <= EX_preSrcB when ID_EX_Alusrc = '0' else ID_EX_SignImm;
UAL_inst: entity work.UAL
 generic map(
    N => 32
)
 port map(
    ualControl => ID_EX_AluControl,
    srcA => EX_SrcA,
    srcB => EX_SrcB,
    result => EX_AluResult,
    cout => EX_cout,
    zero => EX_Zero
);
    EX_WriteReg <= ID_EX_rt when ID_EX_Regdst = '0' else ID_EX_rd;
    
 unite_inst: entity work.unite
  port map(
     ID_EX_rs => ID_EX_rs,
     ID_EX_rt => ID_EX_rt,
     EX_MEM_WriteReg => EX_MEM_WriteReg,
     MEM_WB_WriteReg => MEM_WB_WriteReg,
     EX_ForwardA => EX_ForwardA,
     EX_ForwardB => EX_ForwardB,
     EX_MEM_RegWrite => EX_MEM_RegWrite,
     MEM_WB_RegWrite => MEM_WB_RegWrite
 );

--####################################################################################################
process (Clk,RESET)
begin
    --Si on a un reset
    if RESET = '1' then
        EX_MEM_MemtoReg <= '0';
        EX_MEM_MemWrite <= '0';
        EX_MEM_MemRead <= '0';
        EX_MEM_RegWrite <= '0';
        EX_MEM_AluResult <= (others => '0');
        EX_MEM_presrcb <= (others => '0');
        EX_MEM_WriteReg <= (others => '0');


    --Sur un front montant
    elsif rising_edge(CLK) then 
        EX_MEM_MemtoReg <= ID_EX_MemtoReg;
        EX_MEM_MemWrite <= ID_EX_MemWrite;
        EX_MEM_MemRead <= ID_EX_MemRead;
        EX_MEM_RegWrite <= ID_EX_RegWrite;
        EX_MEM_AluResult <= EX_AluResult;
        EX_MEM_presrcb <= EX_preSrcB;
        EX_MEM_WriteReg <= EX_WriteReg;
    end if;             
end process;

--##############################################Bloc4######################################################
AluResult <= EX_MEM_AluResult;
WriteData <=  EX_MEM_presrcb;
MemReadOut <= EX_MEM_MemRead;
MemWriteOut <= EX_MEM_MemWrite;
--####################################################################################################

process (Clk,RESET)
begin
    --Si on a un reset
    if RESET = '1' then
        MEM_WB_MemtoReg <= '0';
        MEM_WB_RegWrite <= '0';
        MEM_WB_AluResult <= (others => '0');
        MEM_WB_readdata <= (others => '0');
        MEM_WB_WriteReg <= (others => '0');

    --Sur un front montant
    elsif rising_edge(CLK) then 
        MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
        MEM_WB_RegWrite <= EX_MEM_RegWrite;
        MEM_WB_AluResult <= EX_MEM_AluResult;
        MEM_WB_readdata <= ReadData;
        MEM_WB_WriteReg <= EX_MEM_WriteReg;
    end if;             
end process;



--#################################BLOC5###################################################################
WB_Result <= MEM_WB_readdata when MEM_WB_MemtoReg = '0' else MEM_WB_AluResult;
--####################################################################################################
end architecture;
