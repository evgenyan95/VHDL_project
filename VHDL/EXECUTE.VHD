--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;


ENTITY  Execute IS
    PORT(   Read_data_1     : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            Read_data_2     : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            funct_Op : IN    STD_LOGIC_VECTOR( 5 DOWNTO 0 );
            Shamt           : IN    STD_LOGIC_VECTOR( 4 DOWNTO 0 );
            PC_plus_4       : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0 );
            ALUSrc          : IN    STD_LOGIC;
            Sign_extend     : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            ALUOp           : IN    STD_LOGIC_VECTOR( 2 DOWNTO 0 );
            clock		    : IN    STD_LOGIC;
			reset		    : IN    STD_LOGIC;
            Zero            : OUT   STD_LOGIC;
            ALU_Result      : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Jr              : OUT   STD_LOGIC;
            Jump_ALU_res     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            Add_Result      : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0 )
			);
END Execute;


ARCHITECTURE behavior OF Execute IS
--------------------------------------------------------

--------------------------------------------------------
TYPE   ALUcommand IS (ANDop,ORop,ADDop, ADDIop, SUBop,XORop,MULop,SLLop,SRLop,SLTop);
SIGNAL Ainput, Binput       : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux       : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL branchAddress           : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL mulres               : STD_LOGIC_VECTOR( 63 DOWNTO 0 );
SIGNAL ALU_ctl              : ALUcommand;
SIGNAL JR1               : STD_LOGIC;

BEGIN
    Ainput <= Read_data_1;
                        -- ALU input mux
    Binput <= Read_data_2  WHEN ( ALUSrc = '0' ) ELSE  Sign_extend( 31 DOWNTO 0 );
        
    ALU_ctl <= ADDop  when  ((funct_Op = "100000" AND ALUOp = "111") OR ALUOp = "000")  else                               -- ADD,ADDI,LUI
               SUBop  when ((funct_Op = "100010"  AND ALUOp = "111") OR ALUOp = "001")  else -- SUB,BNE,BNEQ,SLTI
               XORop  when  ((funct_Op = "100110" AND ALUOp = "111") OR ALUOp = "010" ) else                               -- XORI,XOR
               ORop   when  ((funct_Op = "100101" AND ALUOp = "111") OR ALUOp = "011" ) else                              -- ORI,OR
               ANDop  when  ((funct_Op = "100100" AND ALUOp = "111") OR ALUOp = "100" ) else                               -- ANDI,AND
               SLLop  when (funct_Op = "000000" AND ALUOp = "111") else                                                    -- SLL
               SRLop  when (funct_Op = "000010" AND ALUOp = "111") else                                                    -- SRL
               MULop  when (funct_Op   = "000010" AND ALUOp = "101")  else                                                 -- MUL
               SLTop  when (funct_Op   = "101010" AND ALUOp = "111") OR ALUOp = "110"  else  
               ADDIop when (funct_Op = "100001" AND ALUOp = "111") else                                                   --ADU
               ADDop; -- JUMPS AND SO ON can do add
    
    
                        -- Select ALU output
    ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) 
        WHEN  ALU_ctl = SLTop  -- 
        ELSE    ALU_output_mux( 31 DOWNTO 0 );
		
                        -- Adder to compute Branch Address
    Add_result  <= branchAddress( 7 DOWNTO 0 );
    branchAddress  <= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
     
   
    Jump_ALU_res <= Ainput(9 DOWNTO 2) WHEN JR1 = '1' ELSE Sign_extend( 7 DOWNTO 0 );
    
    mulres <= Ainput*Binput;
	JR1 <= '1' when ALUOP = "111" and  funct_Op = "001000"  ELSE '0';
    Jr <= JR1;
	                     -- Generate Zero Flag
    Zero <= '1' WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000") ELSE '0';   
	
PROCESS ( ALU_ctl, Ainput, Binput, mulres)
    BEGIN
                    -- Select ALU operation
    CASE ALU_ctl IS
    ------------------ Arithmetic Instructions
        WHEN ORop  =>  ALU_output_mux  <= Ainput OR Binput;
                 
        WHEN ANDop =>  ALU_output_mux  <= Ainput AND Binput; 
                       
        WHEN ADDop =>  ALU_output_mux  <= Ainput + Binput;
                      
        WHEN SRLop =>  ALU_output_mux  <= To_StdLogicVector(to_bitvector (Binput) srl CONV_INTEGER((Shamt)));
                      
        WHEN SLLop =>  ALU_output_mux  <= To_StdLogicVector(to_bitvector (Binput) sll CONV_INTEGER((Shamt)));
                     
        WHEN SUBop =>  ALU_output_mux  <= Ainput - Binput;
                        
        WHEN XORop =>  ALU_output_mux  <= Ainput XOR Binput;
                      
        WHEN MULop =>  ALU_output_mux  <= mulres(31 DOWNTO 0);
        
        WHEN ADDIop => ALU_output_mux  <= Binput;
        
        WHEN SLTop =>  ALU_output_mux  <= Ainput - Binput;
		
        WHEN OTHERS     =>  ALU_output_mux  <= (others=>'0') ;        

    END CASE;
  END PROCESS;
END behavior;

