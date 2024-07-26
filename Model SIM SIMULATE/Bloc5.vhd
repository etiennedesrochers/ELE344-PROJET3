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
        MEM_WB_RegWrite: in std_logic;
        MEM_WB_RegWrite_o: out std_logic
    );
end entity;

architecture rtl of Bloc5 is
   signal s_MEM_WB_RegWrite : std_logic; 
   signal s_MEM_WB_MemtoReg : std_logic;
   signal s_MEM_WB_WriteReg: std_logic_vector(4 downto 0);
   signal s_MEM_WB_readdata  : std_logic_vector(31 downto 0); 
   signal s_MEM_WB_AluResult : std_logic_vector(31 downto 0);  
   signal s_WB_Result        : std_logic_vector(31 downto 0); 
    begin
        process (clk)
        begin
            if (rising_edge(clk)) then
                s_MEM_WB_RegWrite<= MEM_WB_RegWrite;
                s_MEM_WB_MemtoReg<= MEM_WB_MemtoReg;
                s_MEM_WB_WriteReg <= MEM_WB_WriteReg;
                s_MEM_WB_readdata  <=  MEM_WB_readdata   ;
                s_MEM_WB_AluResult <=  MEM_WB_AluResult ;
       
            end if;
        end process;

        mux2_inst: entity work.mux2
         generic map(
            N => 32
        )
         port map(
            Input_0 =>s_MEM_WB_AluResult ,
            Input_1 => s_MEM_WB_readdata,
            sel => s_MEM_WB_MemtoReg,
            out1 => s_WB_Result
        );
        WB_Result<= s_WB_Result;
        MEM_WB_RegWrite_o <= s_MEM_WB_RegWrite;
        MEM_WB_WriteReg_o <= s_MEM_WB_WriteReg;


end architecture;