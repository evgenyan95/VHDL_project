        -- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT(    
    reg_t		    : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
    clock       : IN    STD_LOGIC;
    reset       : IN    STD_LOGIC; 
    Opcode      : IN    STD_LOGIC_VECTOR( 5 DOWNTO 0 );
    INTR        : IN    STD_LOGIC;
    Jr          : IN    STD_LOGIC;
    K1_reg_in_use       : IN    STD_LOGIC;
    RegWrite    : OUT   STD_LOGIC;
    BNE         : OUT   STD_LOGIC;
    ALUSrc      : OUT   STD_LOGIC;
    MemWrite    : OUT   STD_LOGIC;
    Branch      : OUT   STD_LOGIC;
    MemRead     : OUT   STD_LOGIC;
	INTA        : OUT   STD_LOGIC;
    Global_IE_control		: OUT   STD_LOGIC;
    Jump        : OUT   STD_LOGIC;
    MemtoReg    : OUT   STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	RegDst      : OUT   STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALUop       : OUT   STD_LOGIC_VECTOR( 2 DOWNTO 0 )
    );

END control;

ARCHITECTURE behavior OF control IS

    SIGNAL  R_format		: STD_LOGIC;
	SIGNAL	I_format		: STD_LOGIC;
	SIGNAL	Lw				: STD_LOGIC;
	SIGNAL Jal				: STD_LOGIC;
	SIGNAL	SW			    : STD_LOGIC;
	SIGNAL Lui				: STD_LOGIC;
	SIGNAL	Beq				: STD_LOGIC;
	SIGNAL	Mul				: STD_LOGIC;
    SIGNAL  INTAbit 		: STD_LOGIC;
	SIGNAL REG_Writebit    	: STD_LOGIC;
BEGIN           
                -- Code to generate control signals using opcode bits
    R_format    <=  '1'  WHEN  Opcode = "000000" ELSE '0';
    I_format    <=  '1'  WHEN  Opcode(5 DOWNTO 3) = "001" ELSE '0';
    Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
    SW          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
    Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
    Mul         <=  '1'  WHEN  Opcode = "011100"  ELSE '0';
    Jump        <=  '1'  WHEN  Opcode = "000011" OR Opcode  = "000010" ELSE '0';
    Lui         <=  '1'  WHEN  Opcode = "001111"  ELSE '0';
    BNE         <=  '1'  WHEN  Opcode = "000101"  ELSE '0';
    Jal         <=  '1'  WHEN  Opcode = "000011"  ELSE '0';
    RegDst      <=  "01" WHEN  (Mul or R_format ) = '1' ELSE
                   "10" WHEN  Jal = '1' ELSE -- reg 31
                   "00";
    MemtoReg    <=  "01" WHEN Lw  = '1' ELSE 
                    "11" WHEN Lui = '1' ELSE 
                    "10" WHEN Jal = '1' ELSE 
                    "00";                    
    REG_Writebit    <=  '1' WHEN   (((NOT Jr AND R_format ) OR I_format OR Mul OR Jal OR Lw ) = '1')and (INTR = '0' OR INTAbit = '1') ELSE '0';
    MemWrite    <=  '1' WHEN ( INTAbit = '1'OR INTR = '0') AND (SW = '1') ELSE '0';
    Global_IE_control	<=  '1'  WHEN (  (reg_t = "11010")AND (REG_Writebit = '1')) ELSE '0' ;
     
    ALUOP   <= "000" when (Opcode = "001111" OR Opcode = "001000")  ELSE  --- ADDI LUI 
               "011" when Opcode = "001101" ELSE  --- OR
               "010" when Opcode = "001110" ELSE  --- XOR
               "110" when Opcode = "001010" ELSE  --- SLT
               "101" when Opcode = "011100" ELSE  --- MUL
               "001" when (Opcode = "000100" OR Opcode = "000101")  ELSE  --- SLTI, BNQ , BEQ
               "111" when Opcode = "000000" ELSE  --- R
               "100" when Opcode = "001100" ELSE  --- ANDI
               "000";
    MemRead     <=  Lw;
    Branch      <=  Beq;
    INTA 		<= INTAbit;
    RegWrite    <=REG_Writebit;
    ALUSrc      <=  Lw OR SW OR I_format;  
    PROCESS (clock,reset)
		BEGIN
			IF(reset='1') THEN
				INTAbit <= '0'; 				
			ELSIF(clock'EVENT AND clock='1') THEN
				IF INTR = '1' THEN 	--  INTR ---> INTA
					INTAbit <= '1';
				ElSIF (R_format='1'  and K1_reg_in_use = '1' and Jr = '1') THEN --  INTA =0 if jr and  $k1
					INTAbit <= '0'; 
				END IF;
			END IF;
	END PROCESS;
    
   END behavior;


