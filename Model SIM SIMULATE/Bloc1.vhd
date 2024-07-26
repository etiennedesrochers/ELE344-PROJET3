LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc1 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        EX_PCBranch, ID_PCJump : in std_logic_vector(31 downto 0);
        EX_PCSrc,ID_Jump : in std_logic;
        IF_ID_PCPlus4 ,pc_s : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bloc1 is
    signal IF_PCPlus4 : std_logic_vector(31 downto 0);
    signal IF_PC : std_logic_vector(31 downto 0);
    signal IF_PCNext: std_logic_vector(31 downto 0);
    signal IF_PCNextBr : std_logic_vector(31 downto 0);
begin
 
    mux2_inst: entity work.mux2
    generic map(
       N => 32
   )
    port map(
       Input_0 =>IF_PCPlus4 ,
       Input_1 => EX_PCBranch,
       sel => EX_PCSrc,
       out1 =>IF_PCNextBr
   );

   mux2_inst2: entity work.mux2
    generic map(
       N => 32
   )
    port map(
       Input_0 => IF_PCNextBr,
       Input_1 => ID_PCJump,
       sel => ID_Jump,
       out1 =>IF_PCNext
   );

  pc_i :ENTITY work.PC
port map (
    Clk=> clk,
    RESET=>reset,
    PC_IN =>IF_PCNext,   
    PC_OUT => IF_PC  
); 



pc_plus4 :ENTITY work.PC_Plus4
port map (
    PC => IF_PC,
    PC_OUT=> IF_PCPlus4
);

pc_s <= IF_PC;
IF_ID_PCPlus4 <= IF_PCPlus4;





   


end architecture;