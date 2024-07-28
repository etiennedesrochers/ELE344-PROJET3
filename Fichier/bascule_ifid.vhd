LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity bascule_ifid is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        IF_PCPLUS4 : in std_logic_vector(31 downto 0);
        Instruction : in std_logic_vector(31 downto 0);
        IF_ID_PCPlus4: out std_logic_vector(31 downto 0);
        IF_ID_Instruction : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of bascule_ifid is

begin
    bascule_inst: entity work.bascule
    generic map(
       N => 32
   )
    port map(
       clk => clk,
       reset => reset,
       in1 => IF_PCPLUS4,
       out1 => IF_ID_PCPlus4
   );
   bascule_inst2: entity work.bascule
    generic map(
       N => 32
   )
    port map(
       clk => clk,
       reset => reset,
       in1 => Instruction,
       out1 => IF_ID_Instruction
   );
end architecture;