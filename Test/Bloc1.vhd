LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc1 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        EX_PCBranch, ID_PCJump : in std_logic_vector(31 downto 0);
        EX_PCSrc,ID_Jump : in std_logic;
        IF_PCPlus4 ,pc_s : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bloc1 is
    signal s_2_i : std_logic_vector(31 downto 0);
    signal pc_s_i : std_logic_vector(31 downto 0);
    signal s_3 : std_logic_vector(31 downto 0);
    signal s_7 : std_logic_vector(31 downto 0);
    signal s_54 : std_logic_vector(31 downto 0);
begin

    mux2_inst1: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 => EX_PCBranch,
        Input_1 => s_2_i,
        sel => EX_PCSrc,
        out1 => s_3
    );

    mux2_inst2: entity work.mux2
     generic map(
        N => 32
    )
     port map(
        Input_0 => ID_PCJump,
        Input_1 => s_3,
        sel => ID_Jump,
        out1 => s_7
    );
    
    PC_bascule: entity work.PC
     port map(
        Clk => Clk,
        RESET => RESET,
        PC_IN =>  s_7,
        PC_OUT =>  pc_s_i
    );

    PC_Plus4_inst: entity work.PC_Plus4
     port map(
        PC => pc_s_i,
        PC_OUT => s_2_i  
    );
    IF_PCPlus4 <= s_2_i;
    pc_s <= pc_s_i;
end architecture;