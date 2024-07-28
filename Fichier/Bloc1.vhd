LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc_1 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        EX_PCBranch, ID_PCJump : in std_logic_vector(31 downto 0);
        EX_PCSrc,ID_Jump : in std_logic;
        PC_s : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bloc_1 is
    signal IF_PCPlus4 : std_logic_vector(31 downto 0);
    signal IF_PC : std_logic_vector(31 downto 0);
    signal IF_PCNext: std_logic_vector(31 downto 0);

begin
     --Bloc 1 contient:
     ligne_de_mux_pc_inst: entity work.ligne_de_mux_pc
     port map(
        clk => clk,
        reset => reset,
        EX_PCBRANCH => EX_PCBRANCH,
        ID_PCJump => ID_PCJump,
        IF_PCPLUS4 => IF_PCPLUS4,
        EX_PCSrc => EX_PCSrc,
        ID_JUMP => ID_JUMP,
        IF_PCNext => IF_PCNext
    );
    PC_inst: entity work.PC
     port map(
        Clk => Clk,
        RESET => RESET,
        PC_IN => IF_PCNext,
        PC_OUT => If_PC
    );
     --Additionneur pc plus 4
     PC_Plus4_inst: entity work.PC_Plus4
      port map(
         PC => IF_PC,
         PC_OUT => IF_PCPLUS4
     );
     --On doit faire sortir le pc courrent du datapath 
     PC_s<= IF_PCPLUS4;

end architecture;