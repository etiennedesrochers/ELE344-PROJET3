LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc_2 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        IF_PCPLUS4  : in std_logic_vector(31 downto 0);
        Instruction : in std_logic_vector(31 downto 0);
        MEM_WB_RegWrite : in std_logic;
        MEM_WB_WriteReg  : in std_logic_vector(4 downto 0);
        WB_Result  :in std_logic_vector(31 downto 0);
        ID_rd1 : out std_logic_vector(31 downto 0); 
        ID_rd2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bloc_2 is
    signal IF_ID_PCPlus4  : std_logic_vector(31 downto 0);
    signal IF_ID_Instruction  : std_logic_vector(31 downto 0);
begin
  
   --Bloc 2 
    --Bascule IF/ID
    bascule_ifid_inst: entity work.bascule_ifid
     port map(
        clk => clk,
        reset => reset,
        IF_PCPLUS4 => IF_PCPLUS4,
        Instruction => Instruction,
        IF_ID_PCPlus4 => IF_ID_PCPlus4,
        IF_ID_Instruction => IF_ID_Instruction
    );
    
    --Registre
    RegFile_inst: entity work.RegFile
     port map(
        clk => clk,
        we => MEM_WB_RegWrite,
        ra1 => IF_ID_Instruction(25 downto 21),
        ra2 => IF_ID_Instruction(20 downto 16),
        wa =>MEM_WB_WriteReg ,
        wd => WB_Result,
        rd1 => ID_rd1,
        rd2 => ID_rd2
    );
   
end architecture;