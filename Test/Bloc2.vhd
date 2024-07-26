LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc2 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        IF_ID_PCPlus4,Instruction ,WB_Result: in STD_LOGIC_VECTOR(31 downto 0);
        MEM_WB_WriteReg : in std_logic_vector(4 downto 0);
        MEM_WB_RegWrite: in std_logic;
        
        ID_EX_PCPlus4,ID_rd1,ID_rd2,ID_PCJump,ID_SignImm,ID_rs,ID_rt,ID_rd  : out std_logic_vector(31 downto 0) ;
        ID_EX_AluControl: out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of Bloc2 is
    signal s_MEM_WB_RegWrite            : std_logic;
    signal s_Instruction                : std_logic_vector(31 downto 0);
    signal s_MEM_WB_WriteReg            : std_logic_vector(4 downto 0);
    signal s_WB_Result                  : std_logic_vector(31 downto 0);
    signal s_ID_rd1                     : std_logic_vector(31 downto 0);
    signal s_ID_rd2                     : std_logic_vector(31 downto 0);
    signal s_IF_ID_PCPlus4                : std_logic_vector(31 downto 0);
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            s_MEM_WB_RegWrite<= MEM_WB_RegWrite;
            s_Instruction    <= Instruction    ;
            s_MEM_WB_WriteReg<= MEM_WB_WriteReg;
            s_WB_Result      <= WB_Result      ;
            s_ID_rd1         <= ID_rd1         ;
            s_ID_rd2         <= ID_rd2         ;
            s_IF_ID_PCPlus4 <= IF_ID_PCPlus4;
        end if;
    end process;
    

    RegFile_inst: entity work.RegFile
     port map(
        clk => clk,
        we => s_MEM_WB_RegWrite,
        ra1 => s_Instruction(25 downto 21),
        ra2 => s_Instruction(20 downto 16),
        wa => s_MEM_WB_WriteReg,
        wd => s_WB_Result,
        rd1 => s_ID_rd1,
        rd2 => s_ID_rd2
    );


     ID_EX_PCPlus4 <= s_IF_ID_PCPlus4;
     ID_rd1<= s_ID_rd1;
     ID_rd2<= s_ID_rd2;

end architecture;