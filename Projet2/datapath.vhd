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
    --Bascule disponinble dans le fichier pc.vhd
    PC_bascule: entity work.PC
     port map(
        Clk => Clk,
        RESET => RESET,
        PC_IN => PCNEXT,
        PC_OUT => PC_S
    );

    --Addionne 4 à la valeur du pc pour passer au pc suivant, pcplus4.vhd
    PC_Plus4_inst: entity work.PC_Plus4
     port map(
        PC => PC_s,
        PC_OUT => PCPLUS4
    );

    --PCBRANCH
    PCBranch <= std_logic_vector(unsigned(PCPLUS4) + unsigned(SignImmSh));
    --PC JUMP 
    PCJUMP <= PCPLUS4(31 downto 28) & Instruction(25 downto 0) & "00";

    
    --Shift left 2 sur SignImm
    SignImmSh <= SignImm(29 downto 0) &"00";
    --Et logic pour un multiplexeur(mux_PCNEXTBR)
    PCSrc <= Branch and Zero;
   
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
        Input_0 => Instruction(20 downto 16),
        Input_1 =>  Instruction(15 downto 11),
        sel => RegDst,
        out1 => WriteReg
    );
    --Registre fournis dans le cours
    RegFile_inst: entity work.RegFile
     port map(
        clk => clk,
        we => RegWrite,
        ra1 => Instruction(25 downto 21),
        ra2 => Instruction(20 downto 16),
        wa => WriteReg,
        wd => Result,
        rd1 => ReadData1,
        rd2 => ReadData2
    );
    --Signau contenant Instruction(15 downto 0)
    SignImm <= ((16 downto 0 => Instruction(15)) ) & (Instruction(14 downto 0)) ;
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
        zero => Zero
    );

    --Assignation des sortie et autres signaux
    AluResult <= AluResult_s;
    WriteData <= ReadData2;
    Pc <= PC_s;
    MemReadOut<= MemReadIn;
    MemWriteOut <= MemWriteIn;
    
end architecture;
