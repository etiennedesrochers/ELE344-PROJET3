LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity top is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        PC    : out std_logic_vector(31 downto 0);
        WriteData: out  std_logic_vector(31 downto 0);
        AluResult : out std_logic_vector(31 downto 0) 
    );
end entity;

architecture rtl of top is
  signal PC_s : std_logic_vector(31 downto 0);
  signal Instruction: std_logic_vector(31 downto 0);
  signal MemRead : std_logic;
  signal MemWrite : std_logic;
  signal AluResult_s : std_logic_vector(31 downto 0);
  signal WriteData_s   : std_logic_vector(31 downto 0);
  signal ReadData_s   : std_logic_vector(31 downto 0);

begin
    
    imem_inst: entity work.imem
    port map (
      adresse => PC_s(7 downto 2),
      data    => Instruction
    );

    mips_inst: entity work.mips
     port map(
        clk => clk,
        reset => reset,
        ReadData => ReadData_s,
        Instruction => Instruction,
        MemRead => MemRead,
        MemWrite => MemWrite,
        PC => PC_s,
        WriteData => WriteData_s,
        AluResult => AluResult_s
    );
    dmem_inst: entity work.dmem
    port map (
      clk       => clk,
      MemWrite  => MemWrite,
      Memread => MemRead,
      adresse   => AluResult_s,
      WriteData => WriteData_s,
      ReadData  => ReadData_s
      
      );
    PC<= PC_s;
    AluResult <= AluResult_s;
    WriteData <= WriteData_s;
end architecture;