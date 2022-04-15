library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           d4 : in STD_LOGIC_VECTOR (3 downto 0);
           clk: in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
           );
end SSD;

architecture Behavioral of SSD is
signal selected_digit: STD_LOGIC_VECTOR(3 downto 0);
signal count: STD_LOGIC_VECTOR(15 downto 0);
begin

selected_digit <= d1 when count(15 downto 14) = "00" else
                  d2 when count(15 downto 14) = "01" else
                  d3 when count(15 downto 14) = "10" else
                  d4 when count(15 downto 14) = "11";
--d7seg
 cat <= "1111001" when selected_digit="0001" else   --1
         "0100100" when selected_digit="0010" else   --2
         "0110000" when selected_digit="0011" else   --3
         "0011001" when selected_digit="0100" else   --4
         "0010010" when selected_digit="0101" else   --5
         "0000010" when selected_digit="0110" else   --6
         "1111000" when selected_digit="0111" else   --7
         "0000000" when selected_digit="1000" else   --8
         "0010000" when selected_digit="1001" else   --9
         "0001000" when selected_digit="1010" else   --A
         "0000011" when selected_digit="1011" else   --b
         "1000110" when selected_digit="1100" else   --C
         "0100001" when selected_digit="1101" else   --d
         "0000110" when selected_digit="1110" else   --E
         "0001110" when selected_digit="1111" else
         "1000000" when selected_digit="0000";

counter: process (clk)
begin
    if (CLK'event and CLK='1') then
        count <= count + 1;
    end if;
end process;
        
an <= "0111" when count(15 downto 14) = "00" else
      "1011" when count(15 downto 14) = "01" else
      "1101" when count(15 downto 14) = "10" else
      "1110" when count(15 downto 14) = "11";
end Behavioral;
