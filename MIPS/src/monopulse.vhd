library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity monopulse is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end monopulse;

architecture Behavioral of monopulse is
signal tmp: std_logic_vector(15 downto 0) := "0000000000000000";
signal Q1: std_logic;
signal cnt_out: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

begin

process (CLK)
begin
    if (CLK'event and CLK='1') then
        tmp <= tmp + 1;
    end if;
end process;

cnt_out <= tmp(0) AND tmp(1) AND tmp(2) AND tmp(3) AND 
           tmp(4) AND tmp(5) AND tmp(6) AND tmp(7) AND
           tmp(8) AND tmp(9) AND tmp(10) AND tmp(11) AND
           tmp(12) AND tmp(13) AND tmp(14) AND tmp(15);
            
process(clk)
begin
    if rising_edge(clk) then
        if(cnt_out = '1') then
           Q1 <= input;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        Q2 <= Q1;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        Q3 <= Q2;
    end if;
end process;

output <= (NOT Q3) AND Q2;

end Behavioral;
