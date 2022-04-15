
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decode is
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
end instruction_decode;

architecture Behavioral of instruction_decode is
component REG_FILE is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           EN : in STD_LOGIC;
           clk : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;
signal selected_WA : std_logic_vector(2 downto 0);

begin
    with RegDst select selected_WA <=
        Instr(9 downto 7) when '0',
        Instr(6 downto 4) when '1',
        "XXX" when others;
        
    reg_file0: REG_FILE port map (
        RA1 => Instr(12 downto 10),
        RA2 => Instr(9 downto 7),
        WA => selected_WA,
        WD => WD,
        EN => EN,
        clk => clk,
        RegWr => RegWrite,
        RD1 => RD1,
        RD2 => RD2
    );
    
    with ExtOp select Ext_imm <=
        "000000000" & instr(6 downto 0) when '0',
        instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0) when '1',
        "XXXXXXXXXXXXXXXX" when others;
    
    func <=instr(2 downto 0);
    sa <= instr(3);
end Behavioral;
