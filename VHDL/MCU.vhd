LIBRARY ieee;
USE ieee.std_logic_1164.all;

-------------------------------------
ENTITY MCU IS
  GENERIC (bus_width : INTEGER := 8); -- QUARTUS MODE = 12; | MODELSIM = 8;
  PORT (    datain 				: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			address 			: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			Swithes			    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            KEYS				: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Global_IE_control   : IN std_logic;
			INTA           		: IN std_logic;
			MemWrite			: IN std_logic;
			clk					: IN std_logic;
			MemRead				: IN std_logic;
			reset				: IN std_logic;
            type_io             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            INTR				: OUT std_logic;
			HEX0, HEX1, HEX2, HEX3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
			LEDG, LEDR : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            dataout: OUT STD_LOGIC_VECTOR(31 downto 0));
END MCU;
--------------------------------------------------------------
--------------------------------------------------------------
architecture dfl of MCU is
  component HexGen is
		port(
			HexIn : in std_logic_vector(3 downto 0);
			----------------------------------------
			HexOut : out std_logic_vector(6 downto 0)
		);
	end component;
	
    component PORT_OUT IS
        GENERIC (n : INTEGER := 8);
        PORT (
        datainIo  : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
              MemRead, MemWrite, CSi, clk : IN STD_LOGIC;
              databus  : OUT STD_LOGIC_VECTOR(31 downto 0);
              dataout_IO     : OUT STD_LOGIC_VECTOR(n-1 downto 0));
    END component;
	
	component PORT_IN IS
		PORT (datain : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			  MemRead, CS7 : IN STD_LOGIC;
			  dataout : OUT STD_LOGIC_VECTOR(31 downto 0));
	END component;
	
	component Decoder IS
    GENERIC (bus_width : INTEGER := 8); -- QUARTUS MODE = 12; | MODELSIM = 8;
	PORT (Address : IN STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
		  CS: OUT STD_LOGIC_VECTOR(15 downto 0));
    END component;
    
    COMPONENT basicTIMER 
		 PORT( 	clock,reset					: IN 	STD_LOGIC;
				data						: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				BTCTLbit, BTCNTbit 		: IN 	STD_LOGIC;
				set_BTIFG 		 				: OUT 	STD_LOGIC
			);
	END COMPONENT;
    COMPONENT interrupt_controller IS
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
    END COMPONENT;
    


	-----------------------------------------------------------

	SIGNAL out_IFG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL keysout: STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL SWout: STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL  LEDGout, LEDRout: STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL  hexout0, hexout1, hexout2, hexout3 : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL CS : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL keyin : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL hexin0,hexin1,hexin2,hexin3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL BTIFG: STD_LOGIC;
    SIGNAL ifgWriteBit       : STD_LOGIC;
	 signal ifgReadBit       : STD_LOGIC;
    SIGNAL clkNot               : STD_LOGIC;

begin
	    -- Basic basicTIMER
	BT : basicTIMER
	PORT MAP (clock => clkNot, reset => reset, data=> datain,
				BTCTLbit => CS(11),
				BTCNTbit => CS(12),
				set_BTIFG => BTIFG
  );
  
    clkNot <= NOT clk;
	keyin<="0000" & KEYS & "0";

    ifgWriteBit <= CS(14) AND MemWrite;
    ifgReadBit  <= CS(14) AND MemRead;
	
	
	B1 : Decoder generic map(12) port map(address, CS);    
	B2 : PORT_IN port map(Swithes,MemRead,CS(6),SWout);
 
	PushButtons_comp : PORT_IN port map(keyin,MemRead,CS(7),keysout);

    dataout <= 
			   LEDGout WHEN CS(0) = '1' ELSE
			   LEDRout WHEN CS(1) = '1' ELSE
			   hexout0 WHEN CS(2) = '1' ELSE
			   hexout1 WHEN CS(3) = '1' ELSE
			   hexout2 WHEN CS(4) = '1' ELSE
			   hexout3 WHEN CS(5) = '1' ELSE
               SWout   WHEN CS(6) = '1' ELSE
 			   keysout WHEN CS(7) = '1' ELSE
               out_IFG  WHEN CS(14) = '1' ELSE              
			   X"00000000";
			   
    
    -- Hex Signal Generators
    hexp0 : HexGen port map(HexIn=>hexin0,HexOut=>HEX0);
	hexp1 : HexGen port map(hexin1,HEX1);
	hexp2 : HexGen port map(hexin2,HEX2);
	hexp3 : HexGen port map(hexin3,HEX3);
    
    -- LEDS
	LEDGP: PORT_OUT generic map(8) port map(datain(7 DOWNTO 0),MemRead,MemWrite,CS(0),clkNot,LEDGout,LEDG);
	LEDRP: PORT_OUT generic map(8) port map(datain(7 DOWNTO 0),MemRead,MemWrite,CS(1),clkNot,LEDRout,LEDR);

    -- HEX LCD
	HEX01p : PORT_OUT generic map(4) port map(datain(7 DOWNTO 0),MemRead,MemWrite,CS(2),clkNot,hexout0,hexin0);
	HEX11p : PORT_OUT generic map(4) port map(datain(7 DOWNTO 0),MemRead,MemWrite,CS(3),clkNot,hexout1,hexin1);
	HEX21p: PORT_OUT generic map(4) port map(datain(7 DOWNTO 0),MemRead,MemWrite,CS(4),clkNot,hexout2,hexin2);
	HEX1p: PORT_OUT generic map(4) port map(datain(7 DOWNTO 0),MemRead,MemWrite,CS(5),clkNot,hexout3,hexin3);
	
    

    
  INTRPT: interrupt_controller PORT MAP (  
        clock			=> clk,
        reset			=> reset,
        data			=> datain,
        Global_IE_en		=> address(0),
        out_IFG			=> out_IFG,
        Global_IE_control			=> Global_IE_control,
        INTA			=> INTA,
        IFG_Lbit	=> ifgReadBit,
        IFG_Sbit	=> ifgWriteBit,
        IEbit			=> CS(13),
        type_io			=> type_io,
        INTR			=> INTR,
        irq0			=> '0', --rx_valid, 
        irq1			=> '0', --tx_ready, 
        irq2			=> BTIFG, 
        irq3			=> KEYS(0),
        irq4			=> KEYS(1),
        irq5			=> KEYS(2)
    );	              
  
END dfl;

