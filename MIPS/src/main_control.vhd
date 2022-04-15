library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_control is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           BranchEQ : out STD_LOGIC;
           BranchGTZ : out STD_LOGIC;
           Jump : out STD_LOGIC;
           JumpR : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(1 downto 0));
end main_control;

architecture Behavioral of main_control is
begin
    process(instr)
    begin
    case instr is
    when "000" =>
        RegDst <= '1';
        ExtOp <= 'X';
        ALUSrc <= '0';
        BranchEQ <= '0';
        BranchGTZ <= '0';
        Jump <= '0';
        JumpR <= '0';
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '1';
        ALUOp <= "00";
    when "001" =>
        RegDst <= '0';
        ExtOp <= '1';
        ALUSrc <= '1';
        BranchEQ <= '0';
        BranchGTZ <= '0';
        Jump <= '0';
        JumpR <= '0';
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '1';
        ALUOp <= "01";
    when "010" =>
        RegDst <= 'X';
        ExtOp <=  '1';
        ALUSrc <= '0';
        BranchEQ <= '1';
        BranchGTZ <= '0';
        Jump <= '0';
        JumpR <= '0';
        MemWrite <= '0';
        MemToReg <= 'X';
        RegWrite <= '0';
        ALUOp <= "10";
    when "011" =>
        RegDst <= 'X';
        ExtOp <=  '1';
        ALUSrc <= '0';
        BranchEQ <= '0';
        BranchGTZ <= '1';
        Jump <= '0';
        JumpR <= '0';
        MemWrite <= '0';
        MemToReg <= 'X';
        RegWrite <= '0';
    when "100" =>
        RegDst <= 'X';
        ExtOp <= '1';
        ALUSrc <= '1';
        BranchEQ <= '0';
        BranchGTZ <= '0';
        Jump <= '0';
        JumpR <= '0';
        MemWrite <= '1';
        MemToReg <= 'X';
        RegWrite <= '0';
        ALUOp <= "01";
    when "101" =>
        RegDst <= '0';
        ExtOp <= '1';
        ALUSrc <= '1';
        BranchEQ <= '0';
        BranchGTZ <= '0';
        Jump <= '0';
        JumpR <= '0';
        MemWrite <= '0';
        MemToReg <= '1';
        RegWrite <= '1';
        ALUOp <= "01";
    when "110" =>
        RegDst <= 'X';
        ExtOp <= 'X';
        ALUSrc <= 'X';
        BranchEQ <= 'X';
        BranchGTZ <= 'X';
        Jump <= '1';
        JumpR <= '0';
        MemWrite <= '0';
        MemToReg <= 'X';
        RegWrite <= '0';
        ALUOp <= "XX";
    when "111" =>
        RegDst <= 'X';
        ExtOp <= 'X';
        ALUSrc <= 'X';
        BranchEQ <= 'X';
        BranchGTZ <= 'X';
        Jump <= 'X';
        JumpR <= '1';
        MemWrite <= '0';
        MemToReg <= 'X';
        RegWrite <= '0';
        ALUOp <= "XX";
    when others => 
    RegDst <= 'X';
        ExtOp <= 'X';
        ALUSrc <= 'X';
        BranchEQ <= 'X';
        BranchGTZ <= 'X';
        Jump <= 'X';
        JumpR <= 'X';
        MemWrite <= 'X';
        MemToReg <= 'X';
        RegWrite <= 'X';
        ALUOp <= "XX";
    end case;
    end process;
end Behavioral;
