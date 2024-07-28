LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc_5 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        DMEM_rd : in std_logic_vector(31 downto 0);
        EX_preSrcb : in std_logic_vector(31 downto 0);
        MEM_WB_AluResult: in std_logic_vector(31 downto 0);
        EX_MEM_MemtoReg : in std_logic;
        EX_MEM_RegWrite : in std_logic;
        EX_MEM_WriteReg : in std_logic_vector(4 downto 0);
        MEM_WB_RegWrite : out std_logic;
        MEM_WB_MemtoReg : out std_logic;
        MEM_WB_WriteReg : out std_logic_vector(4 downto 0);
        WB_Result : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bloc_5 is
  signal MEM_WB_readdata: std_logic_vector(31 downto 0);
  signal WB_AluResult : std_logic_vector(31 downto 0);
  signal s_MEM_WB_MemtoReg : std_logic;
    begin
       bascule_1_bit_inst: entity work.bascule_1_bit
        port map(
           clk => clk,
           reset => reset,
           in1 => EX_MEM_MemtoReg,
           out1 => s_MEM_WB_MemtoReg
       );
       bascule_1_bit_inst2: entity work.bascule_1_bit
        port map(
           clk => clk,
           reset => reset,
           in1 => EX_MEM_RegWrite,
           out1 => MEM_WB_RegWrite
       );
       bascule_inst: entity work.bascule
        generic map(
           N => 32
       )
        port map(
           clk => clk,
           reset => reset,
           in1 => DMEM_rd,
           out1 => MEM_WB_readdata
       );

       bascule_inst2: entity work.bascule
        generic map(
           N => 32
       )
        port map(
           clk => clk,
           reset => reset,
           in1 => EX_preSrcb,
           out1 => WB_AluResult
       );

       bascule_inst3: entity work.bascule
        generic map(
           N => 5
       )
        port map(
           clk => clk,
           reset => reset,
           in1 => EX_MEM_WriteReg,
           out1 => MEM_WB_WriteReg
       );

       mux2_inst: entity work.mux2
        generic map(
           N => 32
       )
        port map(
           Input_0 => MEM_WB_readdata,
           Input_1 => WB_AluResult,
           sel => s_MEM_WB_MemtoReg,
           out1 => WB_Result
       );
       MEM_WB_MemtoReg  <= s_MEM_WB_MemtoReg;
end architecture;