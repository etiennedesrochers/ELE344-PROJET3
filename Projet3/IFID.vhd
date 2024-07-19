LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity IFID is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        pc_plus4:in std_logic_vector(31 downto 0);
        instruction: in std_logic_vector(31 downto 0);
        pc_plus4_o: out std_logic_vector(31 downto 0);
        instruction_o: out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of IFID is

begin
    process (clk,reset)
    begin
        if reset = '1' then
            pc_plus4_o <= (others => '0');
            instruction_o <= (others => '0');
        elsif rising_edge(clk) then
            pc_plus4_o <= pc_plus4;
            instruction_o <= instruction;
        end if;
        
    end process;
    

end architecture;