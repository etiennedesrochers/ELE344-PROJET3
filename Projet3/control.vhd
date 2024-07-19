--================ control.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ÉTÉ 2024 Ecole de technologie superieure
-- ***** Desrochers Etienne ,Francoeur Maxime	  ************
-- ***** Code DESE28369801 , FRAM19039903 ************
-- =============================================================
-- Description: 
--             Unité de control du processeur mips
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY control IS
PORT (
 OP, Funct: IN std_logic_vector(5 downto 0);
 MemtoReg, MemWrite, MemRead, Branch, AluSrc,
 RegDst, RegWrite, Jump : OUT std_logic;
 AluControl : OUT std_logic_vector(3 downto 0));
END; -- Controller;

architecture control of control is 
--signal
    SIGNAL BUSE      :std_logic_vector(9 downto 0);
    SIGNAL ALUOP    :std_logic_vector(1 downto 0);
begin
--Besoin de 2 process differnt pour le Main Decoder et le ALU DECODER
    process(op)
    begin
        case op is 
            when "000000" => BUSE <= "1100000100";
            when "100011" => BUSE <= "1010101000";
            when "101011" => BUSE <= "0X1001X000";
            when "000100" => BUSE <= "0X0100X010";
            when "001000" => BUSE <= "1010000000";
            when others => BUSE <=   "0XXX00XXX1";
        end case;
    end process;
    --Process pour le control de l'ALU
    process(op,Funct,ALUOP,BUSE)
    begin
        case ALUOP is 
            when "00" =>  AluControl <= "0010";
            when "01" => AluControl  <= "0110";
            when "10" =>
                case Funct is 
                    when "100000" => AluControl <= "0010";
                    when "100010" => AluControl <= "0110";
                    when "100100" => AluControl <= "0000";
                    when "100101" => AluControl <= "0001";
                    when others => AluControl <= "0111";
                end case;
            when others=> AluControl <= "XXXX";
            end case;
    end process;

    --Assignation des sorties
    Jump <= BUSE(0);
    ALUOP(0) <= BUSE(1);
    ALUOP(1) <= BUSE(2);
    MemtoReg <= BUSE(3);
    MemWrite <= BUSE(4);
    MemRead <= BUSE(5);
    Branch <= BUSE(6);
    AluSrc <= BUSE(7);
    RegDst <= BUSE(8);
    RegWrite <= BUSE(9);
end control;