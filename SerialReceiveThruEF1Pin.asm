;.\a18.exe SerialReceiveThruEF1Pin.asm -b SerialReceiveThruEF1Pin.bin -l SerialReceiveThruEF1Pin.lst
;ONLY FOR CDP1806
;HRJ A18 wants register names defined...


R0        EQU    0
R1        EQU    1
R2        EQU    2
R3        EQU    3
R4        EQU    4
R5        EQU    5
R6        EQU    6
R7        EQU    7
R8        EQU    8
R9        EQU    9
R10        EQU    10
R11        EQU    11
R12        EQU    12
R13        EQU    13
R14        EQU    14
R15        EQU    15



  
  ORG 00h ;Important, always put this here
START

  CPU 1805 ;tells the compiler we using CDP1805/6 instruction set
 ;R1 is for calls
 
	LDI low(33023)
	PLO R10
	LDI high(33023)
	PHI R10
	SEX R10
 
loop
	
	
	BN1 IGNORECALL
	SCAL R11, SERIAL_READ_START
IGNORECALL	
	GHI R5
	
	BZ CLEARING
	LSZ
	SEQ
	
	
	
	NOP
	NOP
	
	br loop
 
CLEARING
	REQ
	
	BR loop
 
  
  
SERIAL_READ_START
    ldi 00h
    plo R5
    phi R5
    

SERIAL_WAIT_START
    bn1 SERIAL_WAIT_START ;16
    nop ;24
    nop ;24
    nop ;24
    ori 00h ;16

SERIAL_SAMPLE_BIT
    b1 SERIAL_NULL_BIT ;16
    ori 080h ;16
    br SERIAL_SAVE_BIT ;16

SERIAL_NULL_BIT
    ori 00h ;16
    ori 00h ;16

SERIAL_SAVE_BIT
    phi R5 ;16
    inc R5 ;16
    glo R5 ;16
    xri 09h ;16
    BNZ fakelsnz ;16
    SRET R11;sep R15 ;--
fakelsnz
    nop ;--
    ghi R5 ;16 R5 is the output at the high order so use GHI R5
    shr ;16
    ;nop ;24
    br SERIAL_SAMPLE_BIT ;16

;test
;	nop
	
;	SRET R2





  END
  
  
