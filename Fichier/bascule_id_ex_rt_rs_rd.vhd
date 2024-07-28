LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity bascule_id_ex_rt_rs_rd is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        IF_ID_Instruction : in std_logic_vector(31 downto 0);
        ID_EX_rs,Id_EX_rt,ID_EX_rd: out std_logic_vector(4 downto 0);
        ID_EX_SignImm : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of bascule_id_ex_rt_rs_rd is
    signal t : std_logic_vector(31 downto 0);
begin
    t <= ((16 downto 0 => IF_ID_Instruction(15)) ) & (IF_ID_Instruction(14 downto 0));
    --Bascule pour rt rs rd de l'instruction
    bascule_inst4: entity work.bascule
    generic map(
    N => 5
    )
    port map(
    clk => clk,
    reset => reset,
    in1 => IF_ID_Instruction(25 downto 21),
    out1 => ID_EX_rs
    );

    bascule_inst5: entity work.bascule
    generic map(
    N => 5
    )
    port map(
    clk => clk,
    reset => reset,
    in1 => IF_ID_Instruction(20 downto 16),
    out1 => Id_EX_rt
    );

    bascule_inst6: entity work.bascule
    generic map(
    N => 5
    )
    port map(
    clk => clk,
    reset => reset,
    in1 => IF_ID_Instruction(15 downto 11),
    out1 => ID_EX_rd
    );
    bascule_inst3: entity work.bascule
    generic map(
       N => 32
   )
    port map(
       clk => clk,
       reset => reset,
       in1 =>t ,
       out1 => ID_EX_SignImm
   );
    

end architecture;

