LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity bascule_rd1_rd2 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        ID_rd1 : std_logic_vector(31 downto 0);
        ID_rd2 : std_logic_vector(31 downto 0);

        ID_EX_rd1:out std_logic_vector(31 downto 0);
        ID_EX_rd2:out  std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of bascule_rd1_rd2 is

begin

    bascule_inst: entity work.bascule
     generic map(
        N =>32
    )
     port map(
        clk => clk,
        reset => reset,
        in1 => ID_rd1,
        out1 => ID_EX_rd1
    );

    bascule_inst2: entity work.bascule
     generic map(
        N => 32
    )
     port map(
        clk => clk,
        reset => reset,
        in1 => ID_rd2,
        out1 => ID_EX_rd2
    );
end architecture;