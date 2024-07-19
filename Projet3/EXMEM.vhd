LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity EXMEM is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wb : in std_logic;
        m : in std_logic;
        alu : in std_logic_vector(31 downto 0);
        presrb: in std_logic_vector(31 downto 0);
        WriteReg  : in std_logic;
        wbo : out std_logic;
        aluo : out std_logic_vector(31 downto 0);
        presrbo: out std_logic_vector(31 downto 0);
        WriteRego  : out std_logic
        
    );
end entity;

architecture rtl of EXMEM is
    SIGNAL S_wb :  std_logic;
    SIGNAL S_m :  std_logic;
    SIGNAL S_alu :  std_logic_vector(31 downto 0);
    SIGNAL S_presrb: std_logic_vector(31 downto 0);
    SIGNAL S_WriteReg  : std_logic;
begin
    process (CLK,RESET)
    begin
        if reset = '1' then
            S_wb <='0';
            S_alu <=(others => '0');
            S_presrb<=(others=>'0');
            S_WriteReg <= '0'; 
        elsif rising_edge(CLK) then
            S_wb <= wb;
            S_alu <=alu;
            S_presrb<=presrb;
            S_WriteReg <=WriteReg; 
        end if;

    end process;
    wbo <= S_wb;
    aluo <= S_alu;
    presrbo<=S_presrb;
    WriteRego <=S_WriteReg; 

end architecture;