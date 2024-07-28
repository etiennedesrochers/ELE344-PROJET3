LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--A revoir je suis pas sur
entity Bloc_4 is
    port (
        clk   : in std_logic;
        reset : in std_logic;

        ID_EX_MemtoReg : in std_logic;
        ID_EX_RegWrite : in std_logic;
        ID_EX_MemRead  : in std_logic;
        ID_EX_MemWrite : in std_logic; 
        EX_ALU_Result : in std_logic_vector(31 downto 0);
        EX_preSrcB : in std_logic_vector(31 downto 0);
        Ex_WriteReg : in std_logic_vector(4 downto 0);
        EX_MEM_preSrcB : out std_logic_vector(31 downto 0);
        EX_MEM_MemtoReg : out std_logic;
        EX_MEM_RegWrite : out std_logic;
        EX_MEM_ALU_Result : out std_logic_vector(31 downto 0);
        Ex_MEM_WriteReg : out std_logic_vector(4 downto 0);
        EX_MEM_MemRead  :out  std_logic;
        EX_MEM_MemWrite :out  std_logic
    );
end entity;

architecture rtl of Bloc_4 is
    
begin
  bascule_ex_mem_inst: entity work.bascule_ex_mem
   port map(
      clk => clk,
      reset => reset,
      ID_EX_MemtoReg => ID_EX_MemtoReg,
      ID_EX_RegWrite => ID_EX_RegWrite,
      ID_EX_MemRead => ID_EX_MemRead,
      ID_EX_MemWrite => ID_EX_MemWrite,
      EX_ALU_Result => EX_ALU_Result,
      EX_preSrcB => EX_preSrcB,
      Ex_WriteReg => Ex_WriteReg,
      EX_MEM_MemtoReg => EX_MEM_MemtoReg,
      EX_MEM_RegWrite => EX_MEM_RegWrite,
      EX_MEM_MemRead => EX_MEM_MemRead,
      EX_MEM_MemWrite => EX_MEM_MemWrite,
      EX_MEM_ALU_Result => EX_MEM_ALU_Result,
      EX_MEM_preSrcB => EX_MEM_preSrcB,
      Ex_MEM_WriteReg => Ex_MEM_WriteReg
  );

   
end architecture;