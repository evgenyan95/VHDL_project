LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

--------------------------------------------------------------------
entity HexGen is
    port( HexIn : in std_logic_vector(3 downto 0);
          HexOut : out std_logic_vector(6 downto 0));          
end HexGen;

--------------------------------------------------------------------
architecture arc_sys of HexGen is
begin
    HexOut <= "1000000" when HexIn = "0000" else 
              "1111001" when HexIn = "0001" else 
              "0100100" when HexIn = "0010" else 
              "0110000" when HexIn = "0011" else 
              "0011001" when HexIn = "0100" else 
              "0010010" when HexIn = "0101" else 
              "0000010" when HexIn = "0110" else 
              "1111000" when HexIn = "0111" else 
              "0000000" when HexIn = "1000" else 
              "0011000" when HexIn = "1001" else 
              "0001000" when HexIn = "1010" else 
              "0000011" when HexIn = "1011" else 
              "1000110" when HexIn = "1100" else 
              "0100001" when HexIn = "1101" else 
              "0000110" when HexIn = "1110" else 
              "0001110" when HexIn = "1111";
end arc_sys;

