LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity bascule_1_bit is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        in1: in std_logic;
        out1: out std_logic
    );
end entity;
    
architecture rtl of bascule_1_bit is
    signal value : std_logic;
begin

    process (Clk,RESET,in1)
    begin
        --Si on a un reset
        if RESET = '1' then
            value <= '0';
        --Sur un front montant
        elsif rising_edge(CLK) then 
            --Sort la prochaine adresse
            value <= in1;
        end if;             
    end process;
    --Assignation de sortie
    out1 <= value;

end architecture;