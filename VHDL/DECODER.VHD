LIBRARY ieee;
USE ieee.std_logic_1164.all;

--------------------------------------
ENTITY Decoder IS
    GENERIC (bus_width : INTEGER := 8); -- QUARTUS MODE = 12; | MODELSIM = 8;
	PORT (Address : IN STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
		  CS: OUT STD_LOGIC_VECTOR(15 downto 0));
END Decoder;
--------------------------------------
 
ARCHITECTURE dataflow OF Decoder IS
BEGIN
	Cs <= "0000000000000001" when Address = X"800" else -- LEDG  <- 0
		  "0000000000000010" when Address = X"804" else -- LEDR  <- 1
		  "0000000000000100" when Address = X"808" else -- HEX0  <- 2
		  "0000000000001000" when Address = X"80C" else -- HEX1 <- 3
		  "0000000000010000" when Address = X"810" else -- HEX2 <- 4
		  "0000000000100000" when Address = X"814" else -- HEX3 <- 5
		  "0000000001000000" when Address = X"818" else -- SW <- 6
          "0000000010000000" when Address = X"81C" else -- keys <- 7
          "0000000100000000" when Address = X"820" else -- UCTL <- 8
          "0000001000000000" when Address = X"821" else -- RX <- 9
          "0000010000000000" when Address = X"822" else -- TX <- 10
          "0000100000000000" when Address = X"824" else -- BTCTL <- 11
          "0001000000000000" when Address = X"828" else -- BTCNT <- 12
          "0010000000000000" when Address = X"82C" else -- IE <- 13
          "0100000000000000" when Address = X"82D" else -- IFG <- 14
          "1000000000000000" when Address = X"82E" else -- TYPE <- 15
		  "0000000000000000";
END dataflow;

