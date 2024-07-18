LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
-- vsim -gui work.control_tb -do "add wave -r *;run 120 ns; add list *"
ENTITY control_tb IS
  GENERIC (TAILLE : integer := 32);
END control_tb;

architecture control_tb_arc of control_tb is
   signal OP, Funct:  std_logic_vector(5 downto 0);
   signal MemtoReg, MemWrite, MemRead, Branch, AluSrc,RegDst, RegWrite, Jump :  std_logic;
   signal AluControl :  std_logic_vector(3 downto 0);
BEGIN
   Control1 : Entity work.controller
        PORT MAP (std_logic_vector(OP),std_logic_vector(Funct),(MemtoReg),(MemWrite),(MemRead),(Branch),(AluSrc),(RegDst),(RegWrite),(Jump),(AluControl));




process 
begin
   
   OP<= "000000";
   Funct <="100000";
   wait for 20 ns;
   Funct <="100010";
   wait for 20 ns;
   Funct <="100100";
   wait for 20 ns;
   Funct <="100101";
   wait for 20 ns;
   Funct <="101010";
   wait for 20 ns;
   op <= "100011";
   wait for 20 ns;  
   OP<= "101011";
   wait for 20 ns;
   OP<= "000100";
   wait for 20 ns;
   OP<= "001000";
   wait for 20 ns;
   OP<= "000010";
   wait for 20 ns;
end process;
end control_tb_arc;