library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;


architecture Behavioral1 of test_env is
component SSD is
    Port ( d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           d4 : in STD_LOGIC_VECTOR (3 downto 0);
           clk: in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

component monopulse is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

component instruction_fetch is
    Port ( Jump : in STD_LOGIC;
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JmpR : in STD_LOGIC;
           JRAddress : in STD_LOGIC_VECTOR(15 downto 0);
           CLK : in STD_LOGIC;
           RST: in STD_LOGIC;
           EN : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCPlus1 : out STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component instruction_decode is
    Port ( RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in STD_LOGIC;
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end component;

component main_control is
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
end component;

component instrunction_execute is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           AluOP : in STD_LOGIC_VECTOR(1 downto 0);
           PCplus1 : in STD_LOGIC_VECTOR (15 downto 0);
           GT : out STD_LOGIC;
           Zero: out STD_LOGIC;
           ALURes: out STD_LOGIC_VECTOR(15 downto 0);
           BranchAdress: out STD_LOGIC_VECTOR(15 downto 0)
           );
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal btn0pulse, btn1pulse: STD_LOGIC;
signal RegDst, ExtOp, ALUSrc, BranchEQ, BranchGTZ, Jump, JumpR, MemWrite, MemToReg, RegWrite : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal PCSrc : STD_LOGIC;
signal JumpAddress, BranchAddress, JRAddress, Instruction, PCplus1 : STD_LOGIC_VECTOR(15 downto 0);
signal zeroFlag, GtFlag: STD_LOGIC;
signal RD1, RD2: STD_LOGIC_VECTOR(15 downto 0);
signal Ext_Imm: STD_LOGIC_VECTOR(15 downto 0);
signal func: STD_LOGIC_VECTOR(2 downto 0);
signal sa: STD_LOGIC;
signal ALURes : STD_LOGIC_VECTOR(15 downto 0);
signal MEMAluResOut, MEMData : STD_LOGIC_VECTOR(15 downto 0);
signal WriteBackOut: STD_LOGIC_VECTOR(15 downto 0);
signal DEBUG_VALUE : STD_LOGIC_VECTOR(15 downto 0);

begin
mpg0: monopulse port map (clk=>clk, input=>btn(0), output=> btn0pulse);
mpg1: monopulse port map (clk=>clk, input=>btn(1), output=> btn1pulse);

if0: instruction_fetch port map(
    Jump => Jump, --ctrl
    JumpAddress => JumpAddress, --must be calculated
    PCSrc => PCSrc, --must be calculated
    BranchAddress => BranchAddress, --from IE
    JmpR => JumpR, --ctrl
    JRAddress => RD1, --from ID
    CLK => clk, 
    RST => btn1pulse,
    EN => btn0pulse,
    Instruction => Instruction, --puts
    PCPlus1 => PCPlus1); --puts
JumpAddress <= PCplus1(15 downto 13) & Instruction(12 downto 0);

mainControl0: main_control port map(
    instr => Instruction(15 downto 13), --from IF
    RegDst => RegDst, --puts
    ExtOp => ExtOp,
    ALUSrc => ALUSrc,
    BranchEQ => BranchEQ,
    BranchGTZ => BranchGTZ,
    Jump => Jump,
    JumpR =>  JumpR,
    MemWrite => MemWrite,
    MemToReg => MemToReg,
    RegWrite => RegWrite,
    ALUOp => ALUOp);    
 
 id: instruction_decode port map(
    RegWrite => RegWrite, --ctrl
    Instr => Instruction(15 downto 0), --from IF
    RegDst => RegDst, --ctrl
    CLK => clk,
    EN => btn0pulse,
    ExtOp => ExtOp, --ctrl
    RD1 => RD1, --puts
    RD2 => RD2, --puts
    WD => WriteBackOut,
    Ext_Imm => Ext_Imm, --puts
    func => func, --puts
    sa => sa); --puts
JRAddress <= RD1;
    
 ie: instrunction_execute port map(
	RD1 => RD1, --from ID
	ALUSrc => ALUSrc, --ctrl
	RD2 => RD2, --from ID
	Ext_Imm => Ext_Imm,
	sa => sa, --from ID
	func => func, --from ID
	AluOP => AluOP, --ctrl
	PCplus1 => PCplus1, --from IF
	GT => GTFlag, --puts
	Zero => ZeroFlag, --puts
	ALURes => ALURes, --puts
	BranchAdress => BranchAddress --puts
 );
 
 PCSrc <= (BranchEQ and ZeroFlag) or (BranchGTZ and GTFlag);
 
 MEM0: MEM port map(
	MemWrite => MemWrite, --ctrl
	ALUResIn => ALURes, --from IE
	RD2 => RD2, --from ID
	CLK => clk,
	EN => btn0pulse,
	MemData => MEMData, --puts
	ALUResOut => MEMALUResOut --puts
 );
 
 with MemToReg select WriteBackOut <=
 MEMAluResOut when '0',
 MEMData when '1';
 
 with sw(7 downto 5) select DEBUG_VALUE <=
    Instruction when "000",
    Pcplus1 when "001",
    RD1 when "010",
    RD2 when "011",
    Ext_Imm when "100",
    ALURes when "101",
    MemData when "110",
    WriteBackOut when "111",
    x"FFFF" when others;
    
SSD0: SSD port map(
    d1 => DEBUG_VALUE(15 downto 12),
    d2 => DEBUG_VALUE(11 downto 8),
    d3 => DEBUG_VALUE(7 downto 4),
    d4 => DEBUG_VALUE(3 downto 0),
    clk => clk,
    cat => cat,
    an => an
);

Led(0) <= RegWrite;
Led(1) <= MemtoReg;
Led(2) <= MemWrite;
Led(3) <= Jump;
Led(4) <= JumpR;
Led(5) <= BranchEQ;
Led(6) <= BranchGTZ;
Led(7) <= AluSrc;
Led(8) <= ExtOp;
Led(9) <= RegDst;
Led(11 downto 10) <=AluOp;
end Behavioral1;
