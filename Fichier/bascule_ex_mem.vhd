LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity bascule_ex_mem is
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
        EX_MEM_MemtoReg : out std_logic;
        EX_MEM_RegWrite : out std_logic;
        EX_MEM_MemRead  : out std_logic;
        EX_MEM_MemWrite : out std_logic;
        EX_MEM_ALU_Result : out std_logic_vector(31 downto 0);
        EX_MEM_preSrcB : out std_logic_vector(31 downto 0);
        Ex_MEM_WriteReg : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of bascule_ex_mem is

begin
    bascule_1_bit_inst: entity work.bascule_1_bit
   port map(
      clk => clk,
      reset => reset,
      in1 => ID_EX_MemtoReg,
      out1 => EX_MEM_MemtoReg
  );
  bascule_1_bit_inst1: entity work.bascule_1_bit
   port map(
      clk => clk,
      reset => reset,
      in1 => ID_EX_RegWrite,
      out1 => EX_MEM_RegWrite
  );
  bascule_1_bit_inst2: entity work.bascule_1_bit
   port map(
      clk => clk,
      reset => reset,
      in1 => ID_EX_MemRead,
      out1 => EX_MEM_MemRead
  );
  bascule_1_bit_inst3: entity work.bascule_1_bit
   port map(
      clk => clk,
      reset => reset,
      in1 => ID_EX_MemtoReg,
      out1 => EX_MEM_MemWrite
  );
  bascule_inst: entity work.bascule
   generic map(
      N => 32
  )
   port map(
      clk => clk,
      reset => reset,
      in1 => EX_ALU_Result,
      out1 => EX_MEM_ALU_Result
  );

    bascule_inst2: entity work.bascule
    generic map(
        N => 32
    )
    port map(
        clk => clk,
        reset => reset,
        in1 => EX_preSrcB,
        out1 =>EX_MEM_preSrcB 
    );

    bascule_inst3: entity work.bascule
     generic map(
        N => 5
    )
     port map(
        clk => clk,
        reset => reset,
        in1 => Ex_WriteReg,
        out1 => Ex_MEM_WriteReg
    );
    

end architecture;