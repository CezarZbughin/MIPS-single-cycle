library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_fetch is
    Port ( Jump : in STD_LOGIC;
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JmpR : in STD_LOGIC;
           JRAddress : in STD_LOGIC_VECTOR(15 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           EN : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCPlus1 : out STD_LOGIC_VECTOR(15 downto 0)
    );
end instruction_fetch;

architecture Behavioral of instruction_fetch is
type t_mem is array(0 to 31) of std_logic_vector(15 downto 0);
signal ROM: t_mem := (
"0010000010000000",--0  x2080 ADDI $1, $zero, 0 |$1 = 0
"0010000100000000",--1  x2100 ADDI $2, $zero, 0 |$2 = 0
"0010000110000000",--2  x2180 ADDI $3, $zero, 0 |$3 = 0
"0010001000000000",--3  x2200 ADDI $4, $zero, 0 |$4 = 0
"0010001010000000",--4  x2280 ADDI $5, $zero, 0 |$5 = 0
"0010001100000000",--5  x2300 ADDI $6, $zero, 0 |$6 = 0
"0010001110000000",--6  x2380 ADDI $7, $zero, 0 |$7 = 0
"1100000000010101",--7  xC015 J 21              |jump main
"0010000110000000",--8  x2180 ADDI $3, $zero, 0 |$3 = 0
"0010001000000001",--9  x2201 ADDI $4, $zero, 1 |$4 = 1
"0001000101000010",--10 x1142 AND $4, $4, $2    |$4 &= $2
"0101000000000001",--11 x5001 BEQ $4, $zero, 1  |if($4 == 0) jump 1
"0000110010110000",--12 x0CB0 ADD $3, $3, $1    |$3 += $1
"0000000010011101",--13 x009D SLL $1, $1, 1     |$1 <<= 1
"0000000100101110",--14 x012E SLR $2, $2, 1     |$2 >>= 1
"0100100000000001",--15 x4801 BEQ $2, $zero, 1  |if($2 == 0) jump 1
"0100000001111000",--16 x4078 BEQ $zero,&zero,-8|jump -8
"0000000110010000",--17 x0190 ADD $1, $zero, $3 |$1 = $3
"1011110100000000",--18 xBD00 LW $2, 0[$7]      |$2 = *$7 //stackpop retrun addres
"0011111111111111",--19 x3FFF ADDI $7, $7, -1   |$7--     //stackpop return addres
"1110100000000000",--20 xE800 JR $2             |jump $2
"0010000010001010",--21 x208A ADDI $1, $zero, 10 |$1 = 10 
"0010000100001011",--22 x210b ADDI $2, $zero, 11 |$2 = 11 
"0010000110011011",--23 x219B ADDI $3, $zero, 27|$3 = 27        //27 is the return address
"1001110110000001",--24 x9D81 SW $3, 1[$7]      |*($7+1) = $3   //stack push return address
"0011111110000001",--25 x3F81 ADDI $7, $7, 1    |$7++           //stack push return address
"1100000000001000",--26 xC008 J 8               |jump mul       //call mul
"0000010000010000",--27 x0000 ADD $1, $1, $zero |NOOP 
others=>x"0000010000010000");

signal IP: std_logic_vector(15 downto 0):= x"0000";

begin
Instruction <= ROM(conv_integer(IP));

PCPlus1 <= IP + 1;

PC: process(CLK)
begin
    if CLK'event and CLK = '1' then
        if RST = '1' then
            IP<=x"0000";
        elsif EN = '1' then
            if JmpR = '1' then
                IP <= JRAddress;
            elsif jump = '1' then
                IP <= JumpAddress;
            elsif PCSrc = '1' then
                IP <= BranchAddress;
            else
                IP <= IP+1;
            end if;
        end if;
    end if;
end process;

end Behavioral;
