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
    
begin    

    mux_IF_PCNextBr: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 =>IF_PCPlus4 ,
        Input_1 => EX_PCBranch,
        sel => EX_PCSrc,
        out1 => IF_PCNextBr 
    );

    mux_ : entity work.mux2
    generic map(
       N => 32
   )
    port map(
       Input_0 => IF_PCNextBr ,
       Input_1 => ID_PCJump ,
       sel => ID_JUMP,
       out1 => IF_PCNext  
   );

    --Bascule disponinble dans le fichier pc.vhd
    PC_bascule: entity work.PC
     port map(
        Clk => Clk,
        RESET => RESET,
        PC_IN =>  IF_PCNext,
        PC_OUT =>  IF_PC
    );

    --Addionne 4 à la valeur du pc pour passer au pc suivant, pcplus4.vhd
    PC_Plus4_inst: entity work.PC_Plus4
     port map(
        PC => IF_PC,
        PC_OUT => IF_PCPlus4  
    );
    ifid_ :entity work.IFId
    port map (
        clk   => CLK,
        reset => RESET,
        pc_plus4=> IF_PCPlus4,  
        instruction=> Instruction,
        pc_plus4_o=> IF_ID_PCPlus4,
        instruction_o=>IF_ID_Instruction
    );
    

    --PCBRANCH
    EX_PCBranch<= std_logic_vector(unsigned(IF_ID_PCPlus4) + unsigned(EX_SignImmSh));
    --PC JUMP 
    ID_PCJump  <= IF_ID_PCPlus4(31 downto 28) & IF_ID_Instruction(25 downto 0) & "00";

    --Signau contenant Instruction(15 downto 0)
    ID_SignImm <= ((16 downto 0 => IF_ID_Instruction(15)) ) & (IF_ID_Instruction(14 downto 0)) ;
    --Shift left 2 sur SignImm
    EX_SignImmSh   <= ID_EX_SignImm (29 downto 0) &"00";
    --Et logic pour un multiplexeur(mux_PCNEXTBR)
    EX_PCSrc  <=  ID_EX_Branch and EX_Zero;
   
    --Multiplexeur 2 entrée
    mux_PCNEXTBR: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 => PCPLUS4,
        Input_1 => PCBranch,
        sel => PCSrc,
        out1 => PCNextbr
    );
    --Multiplexeur 2 entrée
    mux_Jump: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 => PCNextbr,
        Input_1 => PCJUMP,
        sel => JUMP,
        out1 => PCNEXT
    );


    --Muliplexeur pour l'entrée Write register du registre
    mux_WriteReg 
    : entity work.mux2
     generic map(
        N => 5
    )
     port map(
        Input_0 => IF_ID_Instruction(20 downto 16),
        Input_1 =>  IF_ID_Instruction(15 downto 11),
        sel => RegDst,
        out1 => WriteReg
    );
    ID_rs <= IF_ID_Instruction(25 downto 21);
    ID_rt <= IF_ID_Instruction(20 downto 16);
    ID_rt <= IF_ID_Instruction(15 downto 11);
    --Registre fournis dans le cours
    RegFile_inst: entity work.RegFile
     port map(
        clk => clk,
        we => RegWrite,
        ra1 => ID_rs ,
        ra2 => ID_rt,
        we => MEM_WB_RegWrite,
        wa => TOFIND,
        wd => TOFIND,
        rd1 => ID_rd1 ,
        rd2 => ID_rd2 
    );
  

    IDEX_inst : entity work.IDEX
    port map (
        clk   <= CLK,
        reset <= RESET,
        wb <= todo,
        m <= todo,
        ex<= todo,
        plus4 <= IF_ID_PCPlus4,
        rd1<=ID_rd1,
        rd2<=ID_rd2,
        SignImm <= ID_SignImm,
        rs <= ID_RS,
        rt <= ID_RT,
        rd <= ID_RD,

        plus4o     <=ID_EX_PCPlus4,
        rd1o       <=ID_EX_rd1 ,
        rd2o       <= ID_EX_rd2,
        SignImmo   <=ID_EX_SignImm,
        rso         <=ID_EX_rs,
        rto         <=ID_EX_rt,
        rdo         <=ID_EX_rd,
        wbo <= todo,
        mo <= todo,
        exo<= todo
    );
    --Multiplexeur 2 entrée
    mux_Result: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_1 => ReadData,
        Input_0 =>AluResult_s,
        sel => MemToReg,
        out1 => Result
    );
    --Multiplexeur 2 entrée
    mux_srcB: entity work.mux2
    generic map (
      N => 32
    )
    port map (
      Input_0 => ReadData2,
      Input_1 => SignImm,
      sel     => AluSrc,
      out1    => srcB
    );
    --ALU réalisé dans le cadre du projet 1
    UAL_inst: entity work.UAL
     generic map(
        N => 32
    )
     port map(
        ualControl => AluControl,
        srcA => ReadData1,
        srcB => srcB,
        result => AluResult_s,
        cout => cout,
        zero =>  EX_Zero  
    );

    --Assignation des sortie et autres signaux
    AluResult <= AluResult_s;
    WriteData <= ReadData2;
    Pc <= IF_PC;
    MemReadOut<= MemReadIn;
    MemWriteOut <= MemWriteIn;
    
end architecture;
