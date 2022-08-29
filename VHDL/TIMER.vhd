		-- BASIC TIMER
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY timer IS
   PORT( 	
    clock,reset			    : IN 	STD_LOGIC;
	data				   	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	BTCTL_ctl, BTCNT_ctl 	: IN 	STD_LOGIC;
	BTIFG_OUT 		 		: OUT 	STD_LOGIC
	 );

END timer;

ARCHITECTURE behavior OF timer IS

	SIGNAL  counter, counterPlus, counterInput : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL  BTIPX				: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL  BTSSEL  			: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL  BTHOLD				: STD_LOGIC;
	SIGNAL  BTCTL_reg   		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL  BTSSEL_mux			: STD_LOGIC;
	SIGNAL  MCLK2, MCLK4, MCLK8	: STD_LOGIC;
	SIGNAL	inCounter			: STD_LOGIC_VECTOR( 2 DOWNTO 0 ) := (others => '0');
	SIGNAL  BTIFG				: STD_LOGIC;
	SIGNAL  BTIFG_REG			: STD_LOGIC := '0';

BEGIN     
	
	BTIPX   <=	BTCTL_reg(2 DOWNTO 0);
    BTSSEL	<=  BTCTL_reg(4 DOWNTO 3);
	BTHOLD  <=  BTCTL_reg(5);
	
	MCLK2 <= inCounter(0);
	MCLK4 <= inCounter(1);
	MCLK8 <= inCounter(2);
	
	BTIFG_OUT <= BTIFG_REG;
	
	--BTCTL register
	PROCESS (clock)
		BEGIN
			IF(clock'EVENT AND clock='1') THEN
				IF BTCTL_ctl='1' THEN
					BTCTL_reg <= data( 7 DOWNTO 0);
				END IF;
			END IF;
	END PROCESS;
	

	
	PROCESS 
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
				inCounter <= inCounter + 1;
	END PROCESS;
	
					
					
	--counter for timer
	PROCESS (BTSSEL_mux, BTIFG, BTCNT_ctl)
		BEGIN
			IF (reset = '1') THEN
				counter <= x"00000000";
			ELSIF (BTIFG='1') THEN
				counter <= (others => '0');
			ELSIF (BTSSEL_mux'EVENT AND BTSSEL_mux = '1') THEN	
				IF(BTCNT_ctl='0') THEN
					IF (BTHOLD = '0') THEN
						counter <= counter + 1;
					END IF;
				ELSE
					counter <= data;
				END IF;
				
			END IF;
	END PROCESS;
	
	
	
	
	--DFF to alow counter clear when BTIFG='1'
	--PROCESS
	--	BEGIN
	--		WAIT UNTIL (BTIFG'EVENT) AND (BTIFG='1');
	--			BTIFG_REG <= '1';-- XOR BTIFG_REG;
--
--	END PROCESS;
	
    -- Sampling register.
	PROCESS (BTIFG, clock)
		BEGIN
			IF (BTIFG='1') then 
				BTIFG_REG <= '1';
			ELSIF(clock'EVENT AND clock='1') THEN
				IF (BTIFG='0') THEN
					BTIFG_REG <= '0';
				END IF;
			END IF;	
	END PROCESS;
	
	
	
	PROCESS (BTSSEL, clock, MCLK2, MCLK4, MCLK8)
		BEGIN
			CASE BTSSEL IS
				WHEN "00"	=> 	BTSSEL_mux <= clock;
				
				WHEN "01"	=>	BTSSEL_mux <= MCLK2;
				
				WHEN "10"	=>	BTSSEL_mux <= MCLK4;
				
				WHEN "11"	=>	BTSSEL_mux <= MCLK8;
				
				WHEN OTHERS => 	BTSSEL_mux <= '0';
			END CASE;
	END PROCESS;
					
	--mux for result
	PROCESS(BTIPX, counter)
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
