                -- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS
    --GENERIC (bus_width : INTEGER :=12; BUS_address: INTEGER :=10; QUARTUS : INTEGER := 1); -- QUARTUS MODE = 12; 10 | MODELSIM = 10; 8
        GENERIC (bus_width : INTEGER := 8; BUS_address: INTEGER :=8; QUARTUS : INTEGER := 0); -- QUARTUS MODE = 12; 10 | MODELSIM = 10; 8
    PORT(clock                  : IN    STD_LOGIC; 
        -- Output important signals to pins for easy display in Simulator
        KEYS						: IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        Swithes								: IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
		PC                              : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        ALU_result_out					: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_1_out 				: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        read_data_2_out				    : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		write_data_out					: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Instruction_out                 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Branch_out			            : OUT STD_LOGIC;
		Zero_out						: OUT STD_LOGIC;
        Memwrite_out					: OUT STD_LOGIC;
		Regwrite_out       				: OUT STD_LOGIC;
        LEDG, LEDR                   	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        HEX0, HEX1, HEX2, HEX3          : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));

END     MIPS;

ARCHITECTURE structure OF MIPS IS

    COMPONENT Ifetch
         GENERIC (bus_width : INTEGER := 12; BUS_address: INTEGER :=10; QUARTUS : INTEGER := 1); -- QUARTUS MODE = 12; 10 | MODELSIM = 8; 8
          PORT(   
            Jr               : IN    STD_LOGIC;
            Jump_ALU_res      : IN    STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			reset     : IN    STD_LOGIC;
            Add_result       : IN    STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            BNE              : IN    STD_LOGIC;
            Jump             : IN    STD_LOGIC;
            clock			: IN    STD_LOGIC;
            INTR		 	 : IN 	STD_LOGIC;
            Zero             : IN    STD_LOGIC;
            Branch           : IN    STD_LOGIC;
            read_data 		 : IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			INTA		 	 : IN 	STD_LOGIC;
			PC_out           : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			-- instruction
			Instruction      : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            PC_plus_4_out    : OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0 )
			);
    END COMPONENT; 

    COMPONENT Idecode
        PORT( 
        MemtoReg    : IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALU_result  : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PC_plus_4   : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        RegWrite    : IN    STD_LOGIC;
        Instruction : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        INTR		: IN    STD_LOGIC;
		RegDst      : IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
        INTA   		: IN    STD_LOGIC;
        clock,reset : IN    STD_LOGIC;
        read_data   : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PC          : IN    STD_LOGIC_VECTOR(9 DOWNTO 0);
		read_data_1 : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        read_data_2 : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        K1_reg_in_use       : OUT   STD_LOGIC;
		Sign_extend : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 )
    );
    END COMPONENT;

    COMPONENT control
          PORT(    
			Opcode      : IN    STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			Jr          : IN    STD_LOGIC;
			clock       : IN    STD_LOGIC;
			reset       : IN    STD_LOGIC; 
			INTR        : IN    STD_LOGIC;
			reg_t		    : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			K1_reg_in_use       : IN    STD_LOGIC;
			Global_IE_control		: OUT   STD_LOGIC;
			RegDst      : OUT   STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc      : OUT   STD_LOGIC;
			MemtoReg    : OUT   STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			RegWrite    : OUT   STD_LOGIC;
			Jump        : OUT   STD_LOGIC;
			MemRead     : OUT   STD_LOGIC;
			BNE         : OUT   STD_LOGIC;
			Branch      : OUT   STD_LOGIC;
			MemWrite    : OUT   STD_LOGIC;
			ALUop       : OUT   STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			INTA        : OUT   STD_LOGIC
			);
    END COMPONENT;

    COMPONENT  Execute
             PORT(   Read_data_1     : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            Sign_extend     : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            Shamt           : IN    STD_LOGIC_VECTOR( 4 DOWNTO 0 );
            PC_plus_4       : IN    STD_LOGIC_VECTOR( 9 DOWNTO 0 );
            funct_Op : IN    STD_LOGIC_VECTOR( 5 DOWNTO 0 );
            Read_data_2     : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            ALUOp           : IN    STD_LOGIC_VECTOR( 2 DOWNTO 0 );
            ALUSrc          : IN    STD_LOGIC;
            reset		    : IN    STD_LOGIC;
			clock			: IN    STD_LOGIC;
            Add_Result      : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            Zero            : OUT   STD_LOGIC;
            ALU_Result      : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Jr              : OUT   STD_LOGIC;
            Jump_ALU_res     : OUT   STD_LOGIC_VECTOR( 7 DOWNTO 0 )
			);
    END COMPONENT;


COMPONENT dmemory IS
    GENERIC (bus_width : INTEGER := 8; BUS_address: INTEGER :=8); -- QUARTUS MODE = 12; 10 | MODELSIM = 8; 8
    PORT(   address                : IN     STD_LOGIC_VECTOR( bus_width-1 DOWNTO 0 );
            MemRead				   : IN     STD_LOGIC;
			Memwrite      		   : IN     STD_LOGIC;
            write_data             : IN     STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            clock,reset            : IN     STD_LOGIC;
            type_io                  : IN     STD_LOGIC_VECTOR(BUS_address-1 DOWNTO 0);
            INTR                   : IN     STD_LOGIC;
			read_data              : OUT    STD_LOGIC_VECTOR( 31 DOWNTO 0 )
			);
END COMPONENT;

COMPONENT MCU IS
    GENERIC (bus_width : INTEGER := 8);
    PORT (    
			address                : IN STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
			Swithes                     : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            datain                 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            KEYS            : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			clk						: IN std_logic;
			MemRead					: IN std_logic;
			MemWrite 				: IN std_logic;
            reset                   : IN std_logic;
            Global_IE_control           		: IN std_logic;
			INTA           			: IN std_logic;
			LEDG, LEDR             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            type_io                  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            INTR                   : OUT std_logic;
            dataout                : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
END COMPONENT;

                    -- declare signals used to connect VHDL components
    SIGNAL Sign_Extend      : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL Add_result       : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
    SIGNAL Jump_ALU_res      : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
    SIGNAL ALU_result       : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL ALUSrc           : STD_LOGIC;
    SIGNAL Branch           : STD_LOGIC;
    SIGNAL read_data        : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL read_data_1      : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL read_data_2      : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL BNE              : STD_LOGIC;
    signal clk2 : std_logic := '0';
    SIGNAL Regwrite         : STD_LOGIC;
    SIGNAL Jump             : STD_LOGIC;
	SIGNAL readDataIo 		: STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL Jr               : STD_LOGIC;
    SIGNAL RegDst           : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
    SIGNAL Instruction      : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    SIGNAL Zero             : STD_LOGIC;
    SIGNAL MemWrite         : STD_LOGIC;
    SIGNAL MemtoReg         : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
    SIGNAL K1_reg_in_use            : STD_LOGIC;
    SIGNAL MemRead          : STD_LOGIC;
    SIGNAL type_io            : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_plus_4        : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
    SIGNAL resetSync        : STD_LOGIC;
	signal clok 			:std_logic;
	signal addret			: std_logic_vector(11 DOWNTO 0); 
    SIGNAL readDataMem		: STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL INTR             : STD_LOGIC;
    SIGNAL ALUop            : STD_LOGIC_VECTOR(  2 DOWNTO 0 );
    SIGNAL INTA             : STD_LOGIC;
	signal int_was			:std_logic;
	signal ena1				:std_logic;
    SIGNAL Global_IE_control          : STD_LOGIC;
    SIGNAL addressQuartus   : STD_LOGIC_VECTOR( 11 DOWNTO 0 );
   	SIGNAL PC_OUT 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
    
BEGIN

-- signals go out to the signal tap:
   read_data_2_out  <= read_data_2;
   ALU_result_out   <= ALU_result;
   read_data_1_out  <= read_data_1;
   write_data_out   <= read_data                            WHEN MemtoReg = "01" ELSE  -- LW
                       Instruction( 15 DOWNTO 0 )& X"0000"  WHEN MemtoReg = "11" ELSE  -- LAI
                       X"00000" & B"00" & PC_plus_4         WHEN MemtoReg = "10" ELSE  -- JAL
                       ALU_result;                                                     -- alu result
   int_was<= INTA and INTR	;
   read_data 		<= readDataIo WHEN ALU_result(12-1) = '1' ELSE readDataMem;  --bus_width -> 12
   RegWrite_out     <= RegWrite;
   Branch_out       <= Branch;
   Zero_out         <= Zero;
   clok				<= clk2 when  ALU_result(0)='1' else clock;
   addressQuartus   <= ALU_Result(11 DOWNTO 2) & "00";
   MemWrite_out     <= MemWrite;    
   PC           	<= PC_OUT;
   Instruction_out  <= Instruction;


 
                    -- connect the 5 MIPS components   
  IFE : Ifetch
    GENERIC MAP(bus_width => bus_width, 
                BUS_address => BUS_address,
                QUARTUS => QUARTUS) 
				
    PORT MAP ( 
                Add_result      => Add_result,
                Branch          => Branch,
				INTR		    => INTR,
                BNE             => BNE,
                Jump            => Jump,
		       	INTA	        => INTA,
                Jr              => Jr,
                Zero            => Zero,                             
                clock           => clk2,  
                Jump_ALU_res     => Jump_ALU_res,
                read_data		=> read_data,
			    Instruction     => Instruction,
                reset           => resetSync,
				PC_plus_4_out   => PC_plus_4,
				PC_out          => PC_OUT );

   ID : Idecode
    PORT MAP ( 
                read_data       => read_data,
                RegDst          => RegDst,                
                PC_plus_4       => PC_plus_4,
                RegWrite        => RegWrite,
                reset           => resetSync,
                MemtoReg        => MemtoReg,
                Instruction     => Instruction,
                K1_reg_in_use           => K1_reg_in_use,
                clock           => clk2,  
                PC              =>PC_out,
                INTR            => INTR,
                ALU_result      => ALU_result,
                INTA            => INTA,
				Sign_extend     => Sign_extend,
                read_data_2     => read_data_2,
				read_data_1     => read_data_1);

   CTL:   control
    PORT MAP (  Opcode          => Instruction( 31 DOWNTO 26 ),         
                reset           => resetSync,
                clock           => clk2,
                INTR            => INTR,             
                MemWrite        => MemWrite,
				RegDst          => RegDst,
				MemRead         => MemRead,
				MemtoReg        => MemtoReg,
				Branch          => Branch,
                reg_t		    => Instruction(20 DOWNTO 16),
				ALUSrc          => ALUSrc,
                Global_IE_control=> Global_IE_control,
                Jr              => Jr,               
                RegWrite        => RegWrite,
				Jump            => Jump,
				ALUop           => ALUop,
                K1_reg_in_use   => K1_reg_in_use,
				INTA            => INTA,
                BNE             => BNE
    );

   EXE:  Execute
    PORT MAP (  Read_data_1     => read_data_1,
                funct_Op 		=> Instruction( 5 DOWNTO 0 ),
                Shamt           => Instruction( 10 DOWNTO 6 ),
                Sign_extend     => Sign_extend,
				PC_plus_4       => PC_plus_4,
                ALUSrc          => ALUSrc,
                Clock           => clk2,
                ALU_Result      => ALU_Result,
                ALUOp           => ALUop,
                Read_data_2     => read_data_2,
                Add_Result      => Add_Result,
                Reset           => resetSync,
                Jr              => Jr,
                Zero            => Zero,
                Jump_ALU_res     => Jump_ALU_res
                );
    

    Q_MEM : IF QUARTUS = 1 GENERATE
       MEM:  dmemory
        GENERIC MAP(bus_width => bus_width, 
                    BUS_address => BUS_address) -- QUARTUS MODE = 12; 10 | MODELSIM = 8; 8
        PORT MAP (  
                    write_data      => read_data_2,
                    MemRead         => MemRead, 
                    Memwrite        => MemWrite, 
                    address         => addressQuartus, --jump memory address by 4
                    type_io           => type_io(9 DOWNTO 0),
                    reset           => resetSync,
                    INTR            => INTR,
                    clock           => clk2,  
					read_data       => readDataMem);

        
    END GENERATE;
    
    MODELSIM_MEM : IF QUARTUS = 0 GENERATE
        MEM:  dmemory
        GENERIC MAP(bus_width => bus_width, 
                    BUS_address => BUS_address) -- QUARTUS MODE = 12; 10 | MODELSIM = 8; 8
        PORT MAP (  read_data       => readDataMem,
                    write_data      => read_data_2,
                    Memwrite        => MemWrite, 
                    INTR            => INTR,
                    MemRead         => MemRead, 
                    type_io         => type_io(9 DOWNTO 2),
                    clock           => clk2,  
                    address         => ALU_Result (bus_width+1 DOWNTO 2), --jump memory address by 4
                    reset           => resetSync);
                    
       
    END GENERATE;
    
    IO: MCU GENERIC MAP(bus_width    => bus_width)
    PORT MAP (datain      => read_data_2,
              address     => ALU_Result(11 DOWNTO 0),        
              Swithes     => Swithes,
              LEDR        => LEDR,
              LEDG        => LEDG,
              KEYS		 => KEYS(3 DOWNTO 1),
              clk         => clk2,
              reset       => resetSync,
              HEX0        => HEX0,
              HEX1        => HEX1,
              HEX2        => HEX2,
              HEX3        => HEX3,
              MemRead     => MemRead,
              MemWrite    => Memwrite,
              Global_IE_control => Global_IE_control,
              INTR        => INTR,
              INTA        => INTA,
              type_io     => type_io,
              dataout     => readDataIo
    );
    
	


	PROCESS (clock) -- clk2=2clk
		BEGIN
			IF RISING_EDGE(clock) THEN
                clk2 <= NOT clk2;
				ena1 <= '1';
            END IF;
	END PROCESS;

        
    PROCESS (clk2)BEGIN
        if(rising_edge(clk2)) then
            resetSync <= not KEYS(0); 
        end if;   
    END PROCESS;
END structure;