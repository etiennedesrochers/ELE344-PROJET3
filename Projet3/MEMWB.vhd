LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity MEMWB is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wb: in std_logic;
        rd: in std_logic_vector(31 downto 0);
        adresse : in std_logic_vector(31 downto 0);
        WriteReg : in std_logic_vector(4 DOWNTO 0);

        wbo: out std_logic;
        rdo: out std_logic_vector(31 downto 0);
        adresseo : out std_logic_vector(31 downto 0);
        WriteRego : out std_logic_vector(4 DOWNTO 0)

    );
end entity;

architecture rtl of MEMWB is
    signal S_wb: std_logic;
    signal S_rd:  std_logic_vector(31 downto 0);
    signal S_adresse :std_logic_vector(31 downto 0);
    signal S_WriteReg : std_logic_vector(4 DOWNTO 0);
begin
    process (CLK,RESET)
    begin
        if reset = '1'then
        S_wb<='0';
        S_rd<= (others => '0');
        S_adresse<= (others => '0');
        S_WriteReg<= (others => '0');

        elsif rising_edge(clk) then 
            S_wb<=wb;
            S_rd<= rd;
            S_adresse<= adresse;
            S_WriteReg<= WriteReg;
        end if;
    end process;
    
    wbo<= S_wb;
    rdo<= S_rd;
    adresseo<=S_adresse;
    S_WriteReg <= WriteReg;

end architecture;