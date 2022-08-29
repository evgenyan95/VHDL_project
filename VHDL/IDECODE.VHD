                        --  Idecode module (implements the register file for
LIBRARY IEEE;           -- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
    PORT( 
		clock		: IN    STD_LOGIC;
		reset	    : IN    STD_LOGIC;
        RegDst      : IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALU_result  : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        read_data   : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PC_plus_4   : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        RegWrite    : IN    STD_LOGIC;
        MemtoReg    : IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
        Instruction : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        INTA   		: IN    STD_LOGIC;
		INTR		: IN    STD_LOGIC;
        PC          : IN    STD_LOGIC_VECTOR(9 DOWNTO 0);
        K1_reg_in_use       : OUT   STD_LOGIC;
		Sign_extend : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_1 : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        read_data_2 : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 )
    );
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL write_register_address_0     : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL write_register_address_1     : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL write_register_address       : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL Instruction_immediate_value  : STD_LOGIC_VECTOR( 15 DOWNTO 0 );
    SIGNAL read_register_1_address      : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL read_register_2_address      : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    SIGNAL write_data                   : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL register_array               : register_file;

BEGIN
    Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
    write_register_address_0    <= Instruction( 20 DOWNTO 16 );
    write_register_address_1    <= Instruction( 15 DOWNTO 11 );
    read_register_2_address     <= Instruction( 20 DOWNTO 16 );
    read_register_1_address     <= Instruction( 25 DOWNTO 21 );
                    -- read_data_1
    read_data_1 <= register_array( CONV_INTEGER( read_register_1_address ) );
                    -- read_data_2       
    read_data_2 <= register_array(CONV_INTEGER( read_register_2_address ) );
	 -- Sign Extend 16-bits to 32-bits
    Sign_extend <= X"0000" & Instruction_immediate_value WHEN Instruction_immediate_value(15) = '0' ELSE X"FFFF" & Instruction_immediate_value;
	
                    -- Mux write_register_address
    write_register_address <= write_register_address_1 WHEN RegDst = "01" ELSE
                              "11111"                 WHEN RegDst = "10" ELSE
                              write_register_address_0;
					 -- K1 for dibugging
	K1_reg_in_use <= '1' WHEN read_register_1_address = "11011" ELSE '0';
      
    write_data <= X"00000" & B"00" & PC_plus_4 WHEN MemtoReg = "10" ELSE
                  Instruction_immediate_value & X"0000" WHEN MemtoReg = "11" ELSE
			      read_data                    WHEN MemtoReg = "01" ELSE 
                  ALU_result;
				  
    
	
	
	
	
   

PROCESS
    BEGIN
        WAIT UNTIL clock'EVENT AND clock = '1';
		IF INTR = '1' and INTA = '0' THEN
            register_array(27) <= (X"00000"& "00" & PC(9 downto 0));
		END IF;
		
        IF reset = '1' THEN

            FOR i IN 0 TO 31 LOOP
                register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
            END LOOP;
                    -- Write back to register - don't write to register 0
        ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
              register_array( CONV_INTEGER( write_register_address)) <= write_data;
        END IF;
        
    END PROCESS;
END behavior;


