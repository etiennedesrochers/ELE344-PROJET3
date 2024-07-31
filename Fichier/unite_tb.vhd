LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY unite_tb IS
END unite_tb;

ARCHITECTURE behavior OF unite_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT unite
    PORT(
        ID_EX_rs : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        ID_EX_rt : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        EX_MEM_WriteReg : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        MEM_WB_WriteReg : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        EX_MEM_RegWrite : IN  STD_LOGIC;
        MEM_WB_RegWrite : IN  STD_LOGIC;
        EX_ForwardA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        EX_ForwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Inputs
    signal ID_EX_rs : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal ID_EX_rt : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal EX_MEM_WriteReg : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal MEM_WB_WriteReg : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal EX_MEM_RegWrite : STD_LOGIC := '0';
    signal MEM_WB_RegWrite : STD_LOGIC := '0';

    -- Outputs
    signal EX_ForwardA : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal EX_ForwardB : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: unite PORT MAP (
          ID_EX_rs => ID_EX_rs,
          ID_EX_rt => ID_EX_rt,
          EX_MEM_WriteReg => EX_MEM_WriteReg,
          MEM_WB_WriteReg => MEM_WB_WriteReg,
          EX_MEM_RegWrite => EX_MEM_RegWrite,
          MEM_WB_RegWrite => MEM_WB_RegWrite,
          EX_ForwardA => EX_ForwardA,
          EX_ForwardB => EX_ForwardB
        );

    -- Stimulus process
    stim_proc: process
    begin        
        -- Test Case 1
        ID_EX_rs <= "00001";
        ID_EX_rt <= "00010";
        EX_MEM_WriteReg <= "00000";
        MEM_WB_WriteReg <= "00000";
        EX_MEM_RegWrite <= '0';
        MEM_WB_RegWrite <= '0';
        wait for 10 ns;
        
        -- Test Case 2
        ID_EX_rs <= "00011";
        ID_EX_rt <= "00100";
        EX_MEM_WriteReg <= "00011";
        MEM_WB_WriteReg <= "00100";
        EX_MEM_RegWrite <= '1';
        MEM_WB_RegWrite <= '0';
        wait for 10 ns;
        
        -- Test Case 3
        ID_EX_rs <= "00101";
        ID_EX_rt <= "00110";
        EX_MEM_WriteReg <= "00111";
        MEM_WB_WriteReg <= "00101";
        EX_MEM_RegWrite <= '0';
        MEM_WB_RegWrite <= '1';
        wait for 10 ns;
        
        wait;
    end process;

END;