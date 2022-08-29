LIBRARY ieee;
USE ieee.std_logic_1164.all;

--------------------------------------
ENTITY PORT_IN IS
	PORT (datain : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  MemRead, CS7 : IN STD_LOGIC;
		  dataout : OUT STD_LOGIC_VECTOR(31 downto 0));
		  
		  
		  
END PORT_IN;
--------------------------------------
ARCHITECTURE dataflow OF PORT_IN IS
BEGIN
	dataout <= X"000000" & datain when (MemRead and CS7  )='1' else (others=>'0');  
END dataflow;