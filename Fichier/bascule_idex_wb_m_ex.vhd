LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity bascule_idex_wb_m_ex is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        ID_MemtoReg : in std_logic;
        ID_MemWrite : in std_logic;
        ID_MemRead  : in std_logic;
        ID_Branch   : in std_logic;
        ID_Alusrc   : in std_logic;
        ID_RegDst   : in std_logic;
        ID_RegWrite : in std_logic; 
        ID_Alucontrol  : in std_logic_vector(3 downto 0);

        ID_EX_MemtoReg  :out std_logic;
        ID_EX_MemWrite  :out std_logic;
        ID_EX_MemRead   :out std_logic;
        ID_EX_Branch    :out std_logic;
        ID_EX_Alusrc    :out std_logic;
        ID_EX_RegDst    :out std_logic;
        ID_EX_RegWrite  :out std_logic;
        ID_EX_Alucontrol:out std_logic_vector(3 downto 0)
    );
end entity;


architecture rtl of bascule_idex_wb_m_ex is

begin

   bascule_1_bit_inst: entity work.bascule_1_bit
    port map(
       clk => clk,
       reset => reset,
       in1 => ID_MemtoReg,
       out1 => ID_EX_MemtoReg
   );
   bascule_1_bit_inst2: entity work.bascule_1_bit
    port map(
       clk => clk,
       reset => reset,
       in1 => ID_MemWrite,
       out1 => ID_EX_MemWrite
   );
   bascule_1_bit_inst3: entity work.bascule_1_bit
    port map(
       clk => clk,
       reset => reset,
       in1 => ID_MemRead,
       out1 => ID_EX_MemRead
   );
   bascule_1_bit_inst4: entity work.bascule_1_bit
    port map(
       clk => clk,
       reset => reset,
       in1 => ID_Branch,
       out1 => ID_EX_Branch
   );
   bascule_1_bit_inst5: entity work.bascule_1_bit
    port map(
       clk => clk,
       reset => reset,
       in1 => ID_Alusrc,
       out1 => ID_EX_Alusrc
   );
   bascule_1_bit_inst6: entity work.bascule_1_bit
    port map(
       clk => clk,
       reset => reset,
       in1 => ID_RegDst,
       out1 => ID_EX_RegDst
   );
   bascule_1_bit_inst7: entity work.bascule_1_bit
   port map(
      clk => clk,
      reset => reset,
      in1 => ID_RegWrite,
      out1 => ID_EX_RegWrite
  );
  bascule_inst: entity work.bascule
   generic map(
      N => 4
  )
   port map(
      clk => clk,
      reset => reset,
      in1 => ID_Alucontrol,
      out1 => ID_EX_Alucontrol
  );


end architecture;