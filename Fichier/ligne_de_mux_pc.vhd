LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity ligne_de_mux_pc is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        EX_PCBRANCH :in std_logic_vector(31 downto 0);
        ID_PCJump: in std_logic_vector(31 downto 0);
        IF_PCPLUS4 : std_logic_vector(31 downto 0);
        EX_PCSrc : in std_logic;
        ID_JUMP : in std_logic;
        IF_PCNext : out std_logic_vector(31 downto 0) 
    );
end entity;

architecture rtl of ligne_de_mux_pc is
    signal IF_PCNextBr: std_logic_vector(31 downto 0);
begin

    --MUX 2 entrée 32 bit  
        --0     :IF_PCPLUS4
        --1     :EX_BRANCH
        --sel   :EX_PCSrc
        --out   :IF_PCNextBr
        mux2_inst: entity work.mux2
        generic map(
           N => 32
       )
        port map(
           Input_0 => IF_PCPLUS4,
           Input_1 => EX_PCBRANCH,
           sel => EX_PCSrc,
           out1 => IF_PCNextBr
       );    
       --MUX 2 entrée 32 bit
       mux2_inst2: entity work.mux2
        generic map(
           N => 32
       )
        port map(
           Input_0 => IF_PCNextBr,
           Input_1 => ID_PCJump,
           sel => ID_JUMP,
           out1 => IF_PCNext
       );

end architecture;