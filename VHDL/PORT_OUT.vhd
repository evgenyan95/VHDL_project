LIBRARY ieee;
USE ieee.std_logic_1164.all;

--------------------------------------
ENTITY PORT_OUT IS
	GENERIC (n : INTEGER := 8);
	PORT (datainIo  : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  MemRead, MemWrite, CSi, clk : IN STD_LOGIC;
		  databus  : OUT STD_LOGIC_VECTOR(31 downto 0);
		  dataout_IO     : OUT STD_LOGIC_VECTOR(n-1 downto 0));
END PORT_OUT;
--------------------------------------
ARCHITECTURE dataflow OF PORT_OUT IS

	SIGNAL data_out_la : std_logic_vector(7 downto 0);
	SIGNAL enable : std_logic;

BEGIN
	
	enable <= '1' when (MemWrite='1' AND CSi = '1') ELSE '0';
    
    -- IO Latch
    PROCESS (clk)
    BEGIN
	IF (clk'EVENT and clk='1') THEN
		IF (enable = '1') THEN
			data_out_la <= datainIo(7 DOWNTO 0); -- IT IS 7 always! 
		End IF;
    END IF;
    END PROCESS;
    
	dataout_IO <= data_out_la(n-1 downto 0); -- take only the n bits from the register..! 
	
  -- If MemRead is on pass the Register to the DataBus
	databus <= X"000000" & data_out_la when (MemRead AND CSi) = '1' else X"00000000";
    

	

END dataflow;


