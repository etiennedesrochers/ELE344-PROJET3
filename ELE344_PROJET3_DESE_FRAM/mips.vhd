--================ mips.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--              Lien entre le controlleur et le datapath
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity mips is
    port (
        clk                     : in std_logic;
        reset                   : in std_logic;
        ReadData                : in std_logic_vector (31 downto 0);
        Instruction             : in std_logic_vector (31 downto 0);
        MemRead                 : out std_logic;
        MemWrite                : out std_logic;
        PC                      : out std_logic_vector(31 downto 0);
        WriteData               : out std_logic_vector(31 downto 0);
        AluResult               : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of mips is
  signal SignalDeControl    : std_logic_vector(3 downto 0);
  signal MemToReg           : std_logic;
  signal MemoryToWrite      : std_logic;
  signal MemoryToRead       : std_logic;
  signal Branch             : std_logic;
  signal Alusrc             : std_logic;
  signal RegDst             : std_logic;
  signal RegWrite           : std_logic;
  signal Jump               : std_logic;
  signal AluControl         : std_logic_vector(3 downto 0);
begin

  --Unité de control
  control_inst: entity work.control
  port map (
    OP         => Instruction(31 downto 26),
    Funct      => Instruction(5 downto 0),
    MemtoReg   => MemToReg,
    MemWrite   => MemoryToWrite,
    MemRead    => MemoryToRead,
    Branch     => Branch,
    AluSrc     => Alusrc,
    RegDst     => RegDst,
    RegWrite   => RegWrite,
    Jump       => Jump,
    AluControl => AluControl
  );
  --Datapath
  data_path_inst: entity work.datapath
  port map (
    CLK         => CLK,
    RESET       => RESET,
    MemToReg    => MemToReg,
    Branch      => Branch,
    AluSrc      => AluSrc,
    RegDst      => RegDst,
    RegWrite    => RegWrite,
    Jump        => Jump,
    MemReadIn   => MemoryToRead,
    MemWriteIn  => MemoryToWrite,
    AluControl  => AluControl,
    Instruction => Instruction,
    ReadData    => ReadData,
    MemReadOut  => MemRead,
    MemWriteOut => MemWrite,
    PC          => PC,
    AluResult   => AluResult,
    WriteData   => WriteData
  );
end architecture;