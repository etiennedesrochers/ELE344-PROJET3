LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc_3 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
       
        IF_ID_Instruction: in std_logic_vector(31 downto 0);
        ID_rd1:in std_logic_vector(31 downto 0);
        ID_rd2:in std_logic_vector(31 downto 0);
        ID_MemtoReg: in std_logic;
        ID_MemWrite: in std_logic;
        ID_MemRead: in std_logic;
        ID_Branch: in std_logic;
        ID_Alusrc: in std_logic;
        ID_RegDst: in std_logic;
        ID_RegWrite: in std_logic;
        ID_Alucontrol: in std_logic_vector(3 downto 0);
        ID_EX_PCPlus4 : in std_logic_vector(31 downto 0);
        WB_Result : in std_logic_vector(31 downto 0);
        EX_MEM_AluResult: in std_logic_vector(31 downto 0);
        EX_MEM_WriteReg : in std_logic_vector(4 downto 0);
        MEM_WB_WriteReg : in std_logic_vector(4 downto 0);
        MEM_WB_RegWrite : in std_logic;
        EX_MEM_RegWrite : in std_logic;
        ID_EX_MemtoReg:out std_logic;
        ID_EX_MemWrite:out std_logic;
        ID_EX_MemRead:out std_logic;
        ID_EX_Alusrc:out std_logic;
        ID_EX_RegWrite:out std_logic;
        EX_PCSrc : out std_logic;
        EX_PCBranch : out std_logic_vector(31 downto 0);
        EX_AluResult : out std_logic_vector(31 downto 0);
        EX_WriteReg :out std_logic_vector(4 downto 0)       
    );
end entity;

architecture rtl of Bloc_3 is
    signal EX_Zero          : std_logic;
    signal EX_ForwardA      : std_logic_vector(1 downto 0); 
    signal EX_ForwardB      : std_logic_vector(1 downto 0);
    signal EX_SignImmSh     : std_logic_vector(31 downto 0);
    signal ID_EX_SignImm    : std_logic_vector(31 downto 0);
    SIGNAL ID_EX_Branch     : std_logic;
    signal EX_SrcA          : std_logic_vector(31 downto 0);
    signal EX_SrcB          : std_logic_vector(31 downto 0);
    signal EX_cout          : std_logic;
    signal EX_preSrcB : std_logic_vector(31 downto 0);
    signal ID_EX_rd1 : std_logic_vector(31 downto 0);
    signal ID_EX_rd2 : std_logic_vector(31 downto 0);
    signal ID_EX_rd:  std_logic_vector(4 downto 0);
    signal ID_EX_rt:  std_logic_vector(4 downto 0);
    signal ID_EX_Alucontrol : std_logic_vector(3 downto 0);
    signal ID_EX_RegDst: std_logic;
    signal ID_EX_rs: std_logic_vector(4 downto 0);
begin
  
    bascule_id_ex_rt_rs_rd_inst: entity work.bascule_id_ex_rt_rs_rd
    port map(
       clk => clk,
       reset => reset,
       IF_ID_Instruction => IF_ID_Instruction,
       ID_EX_rs => ID_EX_rs,
       Id_EX_rt => Id_EX_rt,
       ID_EX_rd => ID_EX_rd,
       ID_EX_SignImm => ID_EX_SignImm
   );
   bascule_rd1_rd2_inst: entity work.bascule_rd1_rd2
    port map(
       clk => clk,
       reset => reset,
       ID_rd1 => ID_rd1,
       ID_rd2 => ID_rd2,
       ID_EX_rd1 => ID_EX_rd1,
       ID_EX_rd2 => ID_EX_rd2
   );
   bascule_idex_wb_m_ex_inst: entity work.bascule_idex_wb_m_ex
    port map(
       clk => clk,
       reset => reset,
       ID_MemtoReg =>   ID_MemtoReg,
       ID_MemWrite =>   ID_MemWrite,
       ID_MemRead =>    ID_MemRead,
       ID_Branch =>     ID_Branch,
       ID_Alusrc =>     ID_Alusrc,
       ID_RegDst =>     ID_RegDst,
       ID_RegWrite =>   ID_RegWrite,
       ID_Alucontrol => ID_Alucontrol,
       ID_EX_MemtoReg =>ID_EX_MemtoReg,
       ID_EX_MemWrite =>ID_EX_MemWrite,
       ID_EX_MemRead => ID_EX_MemRead,
       ID_EX_Branch =>  ID_EX_Branch,
       ID_EX_Alusrc =>  ID_EX_Alusrc,
       ID_EX_RegDst =>  ID_EX_RegDst,
       ID_EX_RegWrite =>ID_EX_RegWrite,
       ID_EX_Alucontrol => ID_EX_Alucontrol
   );
   --Et logique 
   EX_PCSrc <= ID_EX_Branch and EX_Zero;
    --Addition
    EX_SignImmSh <= ID_EX_SignImm (29 downto 0) &"00";

    EX_PCBranch <= std_logic_vector(unsigned(ID_EX_PCPlus4) + unsigned(EX_SignImmSh)); 

    mux3_inst: entity work.mux3
     generic map(
        N => 32
    )
     port map(
        Input_0 => ID_EX_rd1,
        Input_1 => WB_Result,
        Input_2 => EX_MEM_AluResult,
        sel => EX_ForwardA,
        out1 => EX_SrcA
    );

    mux3_inst2: entity work.mux3
     generic map(
        N => 32
    )
     port map(
        Input_0 => ID_EX_rd2,
        Input_1 => WB_Result,
        Input_2 => EX_MEM_AluResult,
        sel => EX_ForwardB,
        out1 => EX_preSrcB
    );

    mux2_inst: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 => EX_preSrcB,
        Input_1 => ID_EX_SignImm,
        sel => ID_AluSrc,
        out1 => EX_SrcB
    );

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

    mux2_inst2: entity work.mux2
     generic map(
        N => 5
    )
     port map(
        Input_0 => ID_EX_rt,
        Input_1 => ID_EX_rd,
        sel => ID_EX_RegDst,
        out1 => EX_WriteReg
    );

    unite_inst: entity work.unite
     port map(
        ID_EX_rs => ID_EX_rs,
        ID_EX_rt => ID_EX_rt,
        EX_MEM_WriteReg => EX_MEM_WriteReg,
        MEM_WB_WriteReg => MEM_WB_WriteReg,
        MEM_WB_RegWrite => MEM_WB_RegWrite,
        EX_ForwardA => EX_ForwardA,
        EX_ForwardB => EX_ForwardB,
        EX_MEM_RegWrite => EX_MEM_RegWrite
    );

end architecture;
