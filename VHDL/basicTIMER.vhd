		-- BASIC basicTIMER
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY basicTIMER IS
   PORT( 	
    clock			    : IN 	STD_LOGIC;
	reset			    : IN 	STD_LOGIC;
	data			   	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	BTCTLbit		 	: IN 	STD_LOGIC;
	BTCNTbit 			: IN 	STD_LOGIC;
	set_BTIFG 		 		: OUT 	STD_LOGIC
	 );

END basicTIMER;

ARCHITECTURE behavior OF basicTIMER IS

	SIGNAL  counter 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL  BTHOLD				: STD_LOGIC;
	SIGNAL  BTSSEL  			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL  BTIPX				: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL  BTCTL   		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL  BTIFG				: STD_LOGIC;
	SIGNAL  BTSSELout			: STD_LOGIC;
	SIGNAL  MCLK2				: STD_LOGIC;
	SIGNAL  MCLK4				: STD_LOGIC;
	SIGNAL  MCLK8				: STD_LOGIC;
	SIGNAL  BTIFG_REG			: STD_LOGIC := '0';
	SIGNAL	clkincreas			: STD_LOGIC_VECTOR( 2 DOWNTO 0 ) := (others => '0');

BEGIN     
	set_BTIFG <= BTIFG_REG;
	
	BTHOLD  <=  BTCTL(5);
    BTSSEL	<=  BTCTL(4 DOWNTO 3);
	BTIPX   <=	BTCTL(2 DOWNTO 0);
	
	MCLK8 <= clkincreas(2);
	MCLK4 <= clkincreas(1);
	MCLK2 <= clkincreas(0);
	
	
	--BTCTL reg
	PROCESS (clock)
		BEGIN
			IF(clock'EVENT AND clock='1') THEN
				IF  BTCTLbit='1' THEN
					BTCTL <= data( 7 DOWNTO 0);
				END IF;
			END IF;
	END PROCESS;
	

	

	
					
					
	--COUNTER
	PROCESS (BTSSELout, BTIFG, BTCNTbit)
		BEGIN
			IF (reset = '1') THEN
				counter <= x"00000000";
			ELSIF (BTIFG='1') THEN
				counter <= (others => '0');
			ELSIF (BTSSELout'EVENT AND BTSSELout = '1') THEN	
				IF(BTCNTbit='0') THEN
					IF (BTHOLD = '0') THEN
						counter <= counter + 1;
					END IF;
				ELSE
					counter <= data;
				END IF;
				
			END IF;
	END PROCESS;
	
	
		PROCESS 
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
				clkincreas <= clkincreas + 1;
	END PROCESS;
	

	
    -- Sampling register.
	PROCESS (clock,BTIFG )
		BEGIN
			IF (BTIFG='1') then 
				BTIFG_REG <= '1';
			ELSIF(clock'EVENT AND clock='1') THEN
				IF (BTIFG='0') THEN
					BTIFG_REG <= '0';
				END IF;
			END IF;	
	END PROCESS;
	
	
	
	PROCESS ( MCLK2, MCLK4, MCLK8,BTSSEL, clock)
		BEGIN
			CASE BTSSEL IS
				WHEN "11"	=>	BTSSELout <= MCLK8;
				WHEN "10"	=>	BTSSELout <= MCLK4;
				WHEN "01"	=>	BTSSELout <= MCLK2;
				WHEN "00"	=> 	BTSSELout <= clock;
				WHEN OTHERS => 	BTSSELout <= '0';
			END CASE;
	END PROCESS;
					
	--mux for result
	PROCESS(counter,BTIPX )
		BEGIN		
		CASE BTIPX IS 
			WHEN "000" => BTIFG <= counter(0);
			WHEN "001" => BTIFG <= counter(3);
			WHEN "010" => BTIFG <= counter(7);
			WHEN "011" => BTIFG <= counter(11);
			WHEN "100" => BTIFG <= counter(15);
			WHEN "101" => BTIFG <= counter(19);
			WHEN "110" => BTIFG <= counter(23);
			WHEN "111" => BTIFG <= counter(25);
			WHEN OTHERS => BTIFG <= '0';
		END CASE;
	END PROCESS;

END behavior;
