LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity IDEX is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wb : in std_logic;
        m : in std_logic;
        ex: in std_logic;
        plus4 : in std_logic_vector(31 downto 0);
        rd1: in std_logic_vector(31 downto 0);
        rd2: in std_logic_vector(31 downto 0);
        SignImm : in std_logic_vector(31 downto 0);
        rs : in std_logic_vector(4 downto 0);
        rt: in std_logic_vector(4 downto 0);
        rd: in std_logic_vector(4 downto 0);

        plus4o      : out std_logic_vector(31 downto 0);
        rd1o        : out std_logic_vector(31 downto 0);
        rd2o        : out std_logic_vector(31 downto 0);
        SignImmo    : out std_logic_vector(31 downto 0);
        rso         : out std_logic_vector(4 downto 0);
        rto         : out std_logic_vector(4 downto 0);
        rdo         : out std_logic_vector(4 downto 0);
        wbo : out std_logic_vector(downto 0);
        mo : out std_logic_vector(downto 0);
        exo: out std_logic
    );
end entity;

architecture rtl of ent is  
    SIGNAL S_PLUS4              : std_logic_vector(31 downto 0);
    SIGNAL S_RD1                : std_logic_vector(31 downto 0);
    SIGNAL S_RD2                : std_logic_vector(31 downto 0);
    SIGNAL S_SIGNIMM            : std_logic_vector(31 downto 0);
    SIGNAL S_rs                 : std_logic_vector(4 downto 0);
    SIGNAL S_rt                 : std_logic_vector(4 downto 0);
    SIGNAL S_rd                 : std_logic_vector(4 downto 0);
    SIGNAL S_WB                 : std_Logic;
    SIGNAL S_MO                 : std_Logic;
    SIGNAL S_EXO                : std_Logic;
begin 
    process (clk,reset)
    begin
        if reset = '1' then
            S_PLUS4<= (others => '0');
            S_RD1 <= (others => '0');
            S_RD2 <= (others => '0');
            S_SIGNIMM <= (others => '0');
            S_rs <=  '0';
            S_rd <= '0';
            S_rt <= '0';
            S_WB <= '0';
            S_MO <= '0';
            S_EXO <= '0';
        elsif rising_edge(clk) then 
            S_PLUS4<= plus4;
            S_RD1 <= S_RD1;
            S_RD2 <= S_RD2;
            S_SIGNIMM <= SignImm;
            S_rs <=  rs;
            S_rd <= rd;
            S_rt <= rt;
            S_WB <= wb;
            S_MO <= mo;
            S_EXO <= exo;
        end if;
    end process;

    plus4o  <= S_PLUS4;  
    rd1o     <= S_RD1;   
    rd2o      <= S_RD2;  
    SignImmo   <= S_SIGNIMMO ;
    rso         <= S_RS;
    rto         <=S_RT;
    rdo        <= S_RD;
    wb0 <= S_WB;
    mo<=S_MO;
    exo <=S_EXO;
end architecture;