LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity Bloc5 is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        MEM_WB_readdata,MEM_WB_AluResult   :in std_logic_vector(31 downto 0);
        MEM_WB_WriteReg : in std_logic_vector(4 downto 0);
        MEM_WB_MemtoReg  :in std_logic;
        WB_Result:out std_logic_vector(31 downto 0);
        MEM_WB_WriteReg_o : out std_logic_vector(4 downto 0);
        MEM_WB_RegWrite: out std_logic
        
    );
end entity;

architecture rtl of Bloc5 is
  
begin

end architecture;