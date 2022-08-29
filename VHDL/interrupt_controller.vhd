        -- BASIC basicTIMER
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY interrupt_controller IS
   PORT(    
    clock 							 : IN    STD_LOGIC;
	reset 							 : IN    STD_LOGIC;
    data                            : IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	INTA  							 : IN    STD_LOGIC;
	Global_IE_en						 : IN    STD_LOGIC;
    Global_IE_control         				: IN    STD_LOGIC;
	IEbit           				: IN    STD_LOGIC;
    IFG_Lbit         			: IN    STD_LOGIC;
	IFG_Sbit     		        : IN    STD_LOGIC;
	irq0,irq1,irq2,irq3,irq4,irq5    : IN    STD_LOGIC;
    type_io                           : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 );
    INTR                            : OUT   STD_LOGIC;
    out_IFG                         : OUT   STD_LOGIC_VECTOR( 31 DOWNTO 0 )
     );

END interrupt_controller;

ARCHITECTURE behavior OF interrupt_controller IS
	type statemachine is ( INTRhold,INTAhold, endINTA,  Flagclear);
    SIGNAL  next_state : statemachine;
	SIGNAL  current_state : statemachine;
    SIGNAL clear1 : STD_LOGIC;
    SIGNAL clear2 : STD_LOGIC;
    SIGNAL  SERVICED            : STD_LOGIC_VECTOR(3 DOWNTO 0); -- FOR AUTOMATICALLY IFG TURNOFF
    SIGNAL  IFG      	        : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL  IFG2        	    : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
    SIGNAL  INTRbit   			: STD_LOGIC;
    SIGNAL  GIE             	: STD_LOGIC; 
    SIGNAL  IE              	: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
   
  
BEGIN  

  --INTA
    PROCESS (current_state,INTA,INTRbit)BEGIN
        case current_state is
            
            when INTRhold =>
                IF (INTRbit = '1') THEN
                    next_state <= INTAhold;
                END IF;
                
            when INTAhold =>
                IF (INTA = '1') THEN
                    next_state <= endINTA;
                END IF;
            when endINTA =>
                IF (INTA = '1') THEN
                    next_state <= Flagclear;
                END IF;
            when Flagclear =>
                IF (clear1 = '1' AND clear2 = '1') THEN
                    next_state <= INTRhold;
                END IF;
        end case;
    END PROCESS;    
   
   
	
    state_machine : process(clock, reset)
    begin

        if (reset='1') then
                current_state <= INTRhold;
        elsif (clock'event and clock='1') then
            current_state <= next_state;
        end if;
    end process;
	
 --IE
    PROCESS (reset,clock)
        BEGIN
            IF(reset='1') THEN
                IE <= "000000"; 
            ELSIF(clock'EVENT AND clock='0') THEN
                IF (IEbit='1') THEN 
                    IE <= data(5 DOWNTO 0); 
                END IF;
            END IF;
    END PROCESS;  

    --IFG
    PROCESS (reset,clock)--,clock)
        BEGIN
            IF(reset='1') THEN
                IFG <= "0000000";
            ELSIF(clock'EVENT AND clock='0') THEN -- 0 or 1?    
            
                -- R/W IFG
                IF (IFG_Sbit ='1') THEN  
                    IFG(5 DOWNTO 0) <= data(5 DOWNTO 0);        
                ELSIF (IFG_Lbit='1') THEN 
                    out_IFG <= X"000000" & "00" &IFG(5 downto 0);

                --IFG =>0 aoutomaticly
                ELSIF (current_state = Flagclear) THEN
                    clear1 <= '1';
                    IF (SERVICED(0)='1') THEN 
                        IFG(0) <= '0'; --RX
                    ELSIF (SERVICED(1)='1') THEN 
                        IFG(1) <= '0'; --TX               
                    ELSIF (SERVICED(3)='1') THEN 
                        IFG(6) <='0';
                    ELSE
                        IFG(2) <= '0'; --basic basicTIMER
                    END IF;

                
                --IFG2:  Defualt Val 
                ELSE 
                    clear1<='0';
                    IFG <= IFG2;
                END IF;
            END IF; 
        END PROCESS;
        
    

    -- INTR TYPE
    PROCESS(clock,INTA, GIE, IE, IFG)
        BEGIN
            IF(clock'EVENT AND clock='1') THEN
            IF GIE = '1' AND INTA = '0'  then 
                    IF    (IFG(6) = '1') THEN
                        type_io <= X"000000" & "00000100"; -- "0x04" 
                        INTRbit    <= '1';
                        SERVICED <= "1000";
                    elsIF    IE(0) = '1' AND IFG (0) = '1' THEN --Uart Rx
                        type_io <= X"000000" & "00001000"; -- "0x08" 
                        INTRbit    <= '1';
                        SERVICED <= "0001";
                    elsif     IE(1) = '1' AND IFG (1) = '1' THEN --Uart Tx
                        type_io <= X"000000" & "00001100"; -- "0x0C" 
                        INTRbit    <= '1';
                        SERVICED <= "0010";
                    elsif     IE(2) = '1' AND IFG (2) = '1' THEN --BTIFG
                        type_io <= X"000000" & "00010000"; -- "0x10" 
                        INTRbit    <= '1';
                        SERVICED <= "0100";
                    elsif IE(3) = '1' AND   IFG(3) = '1' THEN --Key1IFG     
                        type_io <= X"000000" & "00010100"; -- "0x14" 
                        INTRbit    <= '1';
                    elsif IE(4) = '1' AND   IFG(4) = '1' THEN --Key2IFG         
                        type_io <= X"000000" & "00011000"; -- "0x18" 
                        INTRbit    <= '1';
                    elsif IE(5) = '1' AND   IFG(5) = '1' THEN --Key3IFG         
                        type_io <= X"000000" & "00011100"; -- "0x1C" 
                        INTRbit    <= '1';
                    END IF;
                ELSE INTRbit <= '0';   
                END IF;
            END IF;
    END PROCESS;
    INTR <= INTRbit;
   

 -- IFG2
    PROCESS ( clock, GIE, reset, IFG_Sbit, INTA, IE, irq0, irq1, irq2, irq3, irq4, irq5 ) 
        BEGIN
            IF(reset='1') THEN
                    IFG2 <=(others => '0');
            ELSIF (clock'EVENT AND clock='0') THEN
                
                IF (IFG_Sbit ='1') THEN  -- store to
                    IFG2(5 DOWNTO 0) <= data(5 DOWNTO 0);
                
                --  IFG =>0 if interrupt_controller done
                ELSIF (current_state = Flagclear) THEN
                    clear2 <= '1';
                    IF (SERVICED(0)='1') THEN 
                        IFG2(0) <= '0';
                    ELSIF (SERVICED(1)='1') THEN 
                        IFG2(1) <= '0';                    
                    ELSIF (SERVICED(3)='1') THEN
                        IFG2(6) <= '0';
                    ELSE
                        IFG2(2) <= '0';
                    END IF;

                -- ifg2  changed if interrupts  enabled
                ELSIF (GIE = '1') THEN  
                    clear2 <= '0';
				
                    IF (irq5 = '0' AND IE(5) = '1')  THEN --Key3
                        IFG2 (5) <= '1';    
                    END IF;
            
                    IF (irq4 = '0' AND IE(4) = '1') THEN --Key2
                        IFG2 (4) <= '1';
                    END IF;
                    IF (irq3 = '0' AND IE(3) = '1')  THEN --Key1
                        IFG2 (3) <= '1'; 
                    END IF; 
					
                    IF (irq2='1' AND IE(2) = '1')  THEN --BTIFG
                        IFG2 (2) <= '1';
                    END IF; 
					-- irq0- uart
					-- irq1-uart
            
         
                END IF;
            END IF;
        END PROCESS;   
    
    -- GIE process
    PROCESS (clock, reset)
        BEGIN
            IF(reset='1') THEN
                GIE <= '0';     
            ELSIF(clock'EVENT AND clock='1') THEN
                IF Global_IE_control='1' THEN 
                    GIE <= Global_IE_en; 
                END IF;
            END IF;
    END PROCESS;    
    
    
    
END behavior;
