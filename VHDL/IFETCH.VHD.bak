-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
    GENERIC(bus_width : INTEGER := 12; BUS_address: INTEGER :=10; QUARTUS : INTEGER := 1);
    PORT(   
            Add_result       : IN    STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            clock 			: IN    STD_LOGIC;
			reset     		: IN    STD_LOGIC;
            Branch           : IN    STD_LOGIC;
            Jump_ALU_res      : IN    STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            Jump             : IN    STD_LOGIC;
            BNE              : IN    STD_LOGIC;
            Zero             : IN    STD_LOGIC;
            Jr               : IN    STD_LOGIC;
            read_data 		 : IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			INTA		 	 : IN 	STD_LOGIC;			
            INTR		 	 : IN 	STD_LOGIC;
            PC_plus_4_out    : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Instruction      : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_out           : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0 )
			);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
    SIGNAL PC, PC_plus_4     : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
    SIGNAL Mem_Addr : STD_LOGIC_VECTOR( BUS_address-1 DOWNTO 0 );
    SIGNAL BranchAdd: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL JumpPc  : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL next_PC  : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	
BEGIN
--ROM for Instruction Memory
inst_memory: altsyncram
    GENERIC MAP (
        operation_mode => "ROM",
        width_a => 32,
        widthad_a => BUS_address,
        lpm_type => "altsyncram",
        outdata_reg_a => "UNREGISTERED",
        init_file => "C:\Users\evgen\Desktop\labs\lab6\312124662_315822221\Interrupt_based_IO\test3\program.hex", 
        intended_device_family => "Cyclone"
    )
    PORT MAP (
        clock0          => clock,
        address_a       => Mem_Addr, 
        q_a             => Instruction 
    );
        

		
        MODELSIM_PC : IF QUARTUS = 0 GENERATE                                                    
            Mem_Addr    <= Next_PC;       
        END GENERATE;
        QUARTUS_PC : IF QUARTUS = 1 GENERATE                                                    
            Mem_Addr    <= Next_PC & "00";
        END GENERATE;
        
        PC(1 DOWNTO 0)  <= "00";

        PC_out          <= PC;
        PC_plus_4_out   <= PC_plus_4;

                        -- Mux to select Branch Address or PC + 4        
        Next_PC         <=(others=>'0')             WHEN Reset = '1' ELSE
                           read_data (9 downto 2)   WHEN INTR = '1' and INTA ='0' ELSE
                           Jump_ALU_res WHEN Jump = '1' OR Jr = '1' ELSE
                           BranchAdd;
--		branch controll
        BranchAdd <= Add_result WHEN ( (( Zero='0'   )and( BNE='1' ) ) or  (( Zero='1' )and( Branch ='1') ))ELSE PC_plus_4( 9 DOWNTO 2 );
        -- Adder to increment PC by 4        
        PC_plus_4( 1 DOWNTO 0 )  <= "00";
        PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
        
          PROCESS BEGIN
            WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
            IF reset = '1' THEN
                   PC( 9 DOWNTO 2) <= (others=>'0') ; 
            ELSE 
                   PC( 9 DOWNTO 2 ) <= next_PC;
            END IF;
    END PROCESS;
END behavior;


