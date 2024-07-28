LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity bascule is
    generic (
    N: integer :=32
);
    port (
        clk   : in std_logic;
        reset : in std_logic;
        in1: in std_logic_vector(N-1 downto 0);
        out1: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of bascule is
    signal value : std_logic_vector(N-1 downto 0);
begin
     --Process qui attend qu'il y ai un changement sur les Signaux CLK,RESET et PC_IN
     process (Clk,RESET,in1)
     begin
         --Si on a un reset
         if RESET = '1' then
             value <= (others=>'0');
         
         --Sur un front montant
         elsif rising_edge(CLK) then 
             --Sort la prochaine adresse
             value <= in1;
         end if;             
     end process;
     --Assignation de sortie
     out1 <= value;
end architecture;