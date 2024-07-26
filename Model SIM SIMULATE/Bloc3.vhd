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
        EX_AluResult,EX_PCBranch : out std_logic_vector(31 downto 0);
        EX_WriteReg: out std_logic_vector(4 downto 0);
        EX_MEM_RegWrite : out std_logic;
        EX_PCSrc,EX_MEM_MemtoReg,EX_MEM_MemWrite ,EX_MEM_MemRead : out std_logic;
        ID_EX_AluControl: in std_logic_vector(3 downto 0)
        
    );
end entity;

architecture rtl of Bloc3 is
    signal s_ID_EX_RegWrite : std_logic;
    signal s_ID_EX_MemtoReg : std_logic;
    signal s_ID_EX_MemWrite : std_logic;
    signal s_ID_EX_MemRead : std_logic;
    signal s_ID_EX_Branch : std_logic;
    signal s_ID_EX_AluSrc : std_logic;
    signal s_ID_EX_RegDst : std_logic;
    signal s_ID_EX_AluControl: STD_LOGIC_VECTOR(3 downto 0);
    signal s_zero : std_logic;
    signal s_EX_PCSrc: std_logic;
    signal s_ID_EX_SignImm : std_logic_vector(31 downto 0);
    signal EX_SignImmSh: std_logic_vector(31 downto 0);
    signal s_EX_PCBranch: std_logic_vector(31 downto 0);
    signal s_ID_EX_rd1        :std_logic_vector(31 downto 0);  
    signal s_EX_MEM_AluResult :std_logic_vector(31 downto 0);  
    signal s_WB_Result        :std_logic_vector(31 downto 0);  
    signal EX_Foward_A          : std_logic_vector(1 downto 0);
    signal EX_Foward_B         :  std_logic_vector(1 downto 0);
    signal EX_SRC_A              : std_logic_vector(31 downto 0);
    signal s_ID_EX_RD2        : std_logic_vector(31 downto 0);
    signal EX_MEM_preSrcb        : std_logic_vector(31 downto 0);
    signal EX_SRC_B : std_logic_vector(31 downto 0);
    signal s_EX_AluResult: std_logic_vector(31 downto 0);
    signal cout1: std_logic;
    signal s_ID_EX_rt : STD_LOGIC_VECTOR(4 downto 0);
    signal s_ID_EX_rd : STD_LOGIC_VECTOR(4 downto 0);
    signal s_EX_WriteReg:std_logic_vector(4 downto 0) ;
    signal s_MEM_WB_WriteReg : std_logic_vector(4 downto 0);
    signal s_EX_MEM_RegWrite : std_logic;
    signal EX_preSrcB : std_logic_vector(31 downto 0);
    signal s_EX_MEM_MemtoReg : std_logic;
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            s_ID_EX_RegWrite     <= ID_EX_RegWrite ;   
            s_ID_EX_MemtoReg     <= ID_EX_MemtoReg ;        
            s_ID_EX_MemWrite     <= ID_EX_MemWrite  ;      
            s_ID_EX_MemRead      <= ID_EX_MemRead ;      
            s_ID_EX_Branch       <= ID_EX_Branch;
            s_ID_EX_AluSrc       <= ID_EX_AluSrc;        
            s_ID_EX_RegDst       <= ID_EX_RegDst;           
            s_ID_EX_AluControl   <= ID_EX_AluControl;  
            s_EX_PCSrc <= s_zero and ID_EX_Branch; 
            EX_SignImmSh <= ID_EX_SignImm (29 downto 0) &"00";
            s_EX_PCBranch <= std_logic_vector(unsigned(ID_EX_PCPlus4) + unsigned(EX_SignImmSh));      
            s_ID_EX_rd1          <= ID_EX_rd1          ;
            s_EX_MEM_AluResult   <= EX_MEM_AluResult   ;
            s_WB_Result          <= WB_Result           ;   
            s_ID_EX_RD2 <= ID_EX_RD2;
            s_ID_EX_SignImm<= ID_EX_SignImm;
            s_ID_EX_rt<= ID_EX_rt;
            s_ID_EX_rd<= ID_EX_rd;
            s_MEM_WB_WriteReg <= MEM_WB_WriteReg;
            s_EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            
        end if;
        if reset = '1' then 
            s_ID_EX_RegWrite     <= '0' ;   
            s_ID_EX_MemtoReg     <= '0';      
            s_ID_EX_MemWrite     <= '0';     
            s_ID_EX_MemRead      <= '0';   
            s_ID_EX_Branch       <= '0';
            s_ID_EX_AluSrc       <= '0';   
            s_ID_EX_RegDst       <= '0';      
            s_ID_EX_AluControl   <= (others =>'0'); 
            s_EX_PCSrc <= '0'; 
            EX_SignImmSh <= (others =>'0');
            s_EX_PCBranch <= (others =>'0');      
            s_ID_EX_rd1          <= (others =>'0')         ;
            s_EX_MEM_AluResult   <= (others =>'0')   ;
            s_WB_Result          <= (others =>'0');  
            s_ID_EX_RD2 <= (others =>'0');
            s_ID_EX_SignImm<= (others =>'0');
            s_ID_EX_rt<= (others =>'0');
            s_ID_EX_rd<= (others =>'0');
            s_MEM_WB_WriteReg <= (others =>'0');
            s_EX_MEM_MemtoReg <= '0';
        end if;
    end process;
        
    mux3_inst: entity work.mux3
     generic map(
        N => 32
    )
     port map(
        Input_0 => s_ID_EX_rd1,
        Input_1 => s_EX_MEM_AluResult,
        Input_2 => s_WB_Result,
        sel => EX_Foward_A,
        out1 => EX_SRC_A
    );


    mux3_inst2: entity work.mux3
     generic map(
        N => 32
    )
     port map(
        Input_0 => s_ID_EX_RD2,
        Input_1 => s_EX_MEM_AluResult,
        Input_2 => s_WB_Result,
        sel => EX_Foward_B,
        out1 => EX_MEM_preSrcb
    );

    mux2_inst: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 => EX_preSrcB,
        Input_1 => s_ID_EX_SignImm,
        sel => s_ID_EX_AluSrc,
        out1 => EX_SRC_B
    );

    UAL_inst: entity work.UAL
     generic map(
        N => 32
    )
     port map(
        ualControl => s_ID_EX_AluControl,
        srcA => EX_SRC_A,
        srcB => EX_SRC_B,
        result => s_EX_AluResult,
        cout => cout1,
        zero => s_zero
    );
    
    mux2_inst2: entity work.mux2
     generic map(
        N => 5
    )
     port map(
        Input_0 => s_ID_EX_rt,
        Input_1 => s_ID_EX_rd,
        sel => s_ID_EX_RegDst,
        out1 => s_EX_WriteReg
    );

    unite_inst: entity work.unite
     port map(
        ID_EX_rs => ID_EX_rs,
        ID_EX_rt => ID_EX_rt,
        EX_MEM_WriteReg => EX_MEM_WriteReg,
        MEM_WB_WriteReg => MEM_WB_WriteReg,
        Forward_A => EX_Foward_A,
        Forward_B => EX_Foward_B,
        EX_MEM_RegWrite => s_EX_MEM_RegWrite,
        MEM_WB_REGWRTIE => s_MEM_WB_WriteReg
    );
    EX_MEM_MemRead <= s_ID_EX_MemtoReg;
    EX_MEM_MemWrite <= s_ID_EX_MemWrite;
    EX_PCSrc <= s_EX_PCSrc;
    EX_AluResult<= s_EX_AluResult;
    EX_MEM_preSrcb<= EX_preSrcB;
    EX_WriteReg<=s_EX_WriteReg;
    EX_PCBranch <= s_EX_PCBranch;
    EX_MEM_RegWrite <= s_EX_MEM_RegWrite;
    EX_MEM_MemtoReg <= s_EX_MEM_MemtoReg;
end architecture;
