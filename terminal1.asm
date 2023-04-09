;.\a18.exe terminal1.asm -b terminal1.bin -l terminal1.lst
R0 EQU 0
R1 EQU 1
R2 EQU 2
R3 EQU 3
R4 EQU 4
R5 EQU 5
R6 EQU 6
R7 EQU 7
R8 EQU 8
R9 EQU 9
R10 EQU 10
R11 EQU 11
R12 EQU 12
R13 EQU 13
R14 EQU 14
R15 EQU 15

;;TODO:: Implement BANKING
; make a memory limiter to avoid accidental overwrite when loading to ram



STACK_POS EQU 33023
INPUT_BUFF EQU 32768

    org 00h

START
    dis
    idl
    
    seq
    
    ldi STACK_POS.0 ;R14 STACK pointer
    plo R14
    ldi STACK_POS.1
    phi R14
    
    ldi FCALL.1
    phi R15
    
    lbr MAIN_PROGRAM
    
;-FUNCTION CALL HELPER-------------------------
FCALL
    sex R14
    glo R0
    stxd
    ghi R0
    stxd
    
    glo R13
    plo R0
    ghi R13
    phi R0
    sep R0
    
FRETURN
    inc R14
    sex R14
    ldxa
    phi R0
    ldx
    plo R0
    sep R0
    br FRETURN
;----------------------------------------------

;-SERIAL SEND BYTE-----------------------------
;-DATA-R4.1------------------------------------
SERIAL_SEND_START
    ghi R4
    xri 0FFh
    phi R4   
    ldi 085h
    shl
    plo R4

SERIAL_SEND_BIT
    lsnf ;24
    req  ;16
    lskp   ;24
    seq  ;16
    nop  ;24
    
    dec R4  ;16
    glo R4  ;16
    lsnz    ;24
    sep R15  ;--
    nop     ;--
    ghi R4  ;16
    shr     ;16
    phi R4  ;16
    nop     ;24
    br SERIAL_SEND_BIT ;16
;----------------------------------------------

;-SERIAL READ BYTE-----------------------------
;-RETURN R5.1----------------------------------
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
    lsnz ;24
    sep R15 ;--
    nop ;--
    ghi R5 ;16
    shr ;16
    nop ;24
    br SERIAL_SAMPLE_BIT ;16
;----------------------------------------------

;-PRINT----------------------------------------
;-FIRST CHAR-R6--------------------------------
PRINT
    sex R6
    ldxa
    lsnz
    sep R15
    nop
    
    phi R4
    
    ldi SERIAL_SEND_START.0
    plo R13
    ldi SERIAL_SEND_START.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    br PRINT
;----------------------------------------------
    
;-READ LINE------------------------------------
;-WHERE TO READ-R7-----------------------------
READLINE
    ldi SERIAL_READ_START.0
    plo R13
    ldi SERIAL_READ_START.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    ghi R5
    xri 13
    bnz STORE_CHAR
    
END_LINE
    ldi 00h
    str R7
    
    ldi NEW_LINE.0
    plo R6
    ldi NEW_LINE.1
    phi R6
    
    ldi PRINT.0
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    sep R15
    
STORE_CHAR
    ghi R5
    str R7
    inc R7
    
    phi R4
    
    ldi SERIAL_SEND_START.0
    plo R13
    ldi SERIAL_SEND_START.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    br READLINE
;----------------------------------------------

;-STR COMPARATOR-------------------------------
;-R8 stringA-R9 stringB------------------------
;-RETURN R12.0---------------------------------
STRCOMP
    ldi 0  ;result = 0
    plo R12
    ldi 0
    phi R12
	
STRCOMPARATOR ;the while loop
    ldn R8 ;load value from memory[a_pointer] to D register
    sex R9 ;set X pointer to b_pointer
    xor ; memory[X] xor D
    
    bz NEXT_IF ; you need to think in a way how the code flow, so we will jump when memory[a_pointer] == memory[b_pointer]
                ; so when memory[a_pointer] != memory[b_pointer] the code continues
    sep R15 ;get back to main code
    
NEXT_IF 
	ldn R8
	bnz INCREMENTING
	ldi 1
	plo R12 ;if A = B then R12 = 1 else R12 = 0, R12 is one of the few free registers
	sep R15
	
INCREMENTING
	inc R8
	inc R9
	br STRCOMPARATOR
;----------------------------------------------

;-NOTIMPLEMENTEDYET----------------------------
NOTIMPLEMENTEDYET
    ldi NOTIMPYET_MSG.0
    plo R6
    ldi NOTIMPYET_MSG.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    sep R15
;----------------------------------------------

;-OUPUT_FUNC-----------------------------------
OUTPUT_FUNC
    ldi OUTPUT_MSG1.0
    plo R6
    ldi OUTPUT_MSG1.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    sep R15
;----------------------------------------------

;DEMO GAME ------------------------------------

DEMOGAME  ;we use 👾👾 for the alians


    ldi DEMOGAMEBASELEVEL.0
    plo R6
    ldi DEMOGAMEBASELEVEL.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
	
	
	
    sep R15 ;end of code



;----------------------------------------------





;CREDITS---------------------------------------
CREDITS

	ldi CREDITSTXT.0
    plo R6
    ldi CREDITSTXT.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
	
	
	
    sep R15 ;end of code

;----------------------------------------------


;LCDDRIVER--------------------------------------

LCDDRIVER


	ldi DRIVERINFO.0
    plo R6
    ldi DRIVERINFO.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
	
	
	
    sep R15 ;end of code


;---------------------------------------------





;YOUR PROG-------------------------------------
YOUR_PROG
    ldi COMMANDFUNCTIONS.0 ;load the address of the first function address to the R4
    plo R4
    ldi COMMANDFUNCTIONS.1
    phi R4
    
    ldi COMMANDTABLE.0 ;load the commantable in R9
    plo R9
    ldi COMMANDTABLE.1
    phi R9
    
CONTINUE_COMPARISON
    ldi INPUT_BUFF.0 ;load the Input buffer in R8
    plo R8
    ldi INPUT_BUFF.1
    phi R8
    
    ldi STRCOMP.0 ;start comparing the two strings
    plo R13
    ldi STRCOMP.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    glo R12 ;load the lower of R12 into D register
    lbz NOMATCH
    ldn R4
    plo R13
    inc R4
    ldn R4
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    sep R15
    
NOMATCH
    inc R4 ;increment R4 twice.
    inc R4
    
GO_TO_END
    ldn R9 ;load the last char from the command table.
    bz GET_NEXT_COMMAND ;if R9 pointing to 0 then go to the next command.
    inc R9 ;else increment R9 by one and check again.
    br GO_TO_END
    
GET_NEXT_COMMAND
    inc R9 ; R9 is pointing to the 0, so we increment it by one to point to the next command's firs character.
    ldn R9 ;get the next command's first character. The end of the command table will terminated by two 0s.
    lbnz CONTINUE_COMPARISON ;if it's not zero then do a comparison with input buffer again.
    
    ldi UNKNOWN.0 ;UNKNOWN command meassage.
    plo R6
    ldi UNKNOWN.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    sep R15 ;else return and ask for another input.
;----------------------------------------------

;-MAIN-----------------------------------------
MAIN_PROGRAM
    ldi BOOT_MSG.0
    plo R6
    ldi BOOT_MSG.1
    phi R6
	
    ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15

ASK_INPUT ;use SCALL for this 
    ldi INPUT_BUFF.0
    plo R7
    ldi INPUT_BUFF.1
    phi R7
    
    ldi READLINE.0
    plo R13
    ldi READLINE.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    ;Program goes here:
    
    ldi YOUR_PROG.0
    plo R13
    ldi YOUR_PROG.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    ;Program ends here
    
    ldi NEW_LINE.0
    plo R6
    ldi NEW_LINE.1
    phi R6
    
    ldi PRINT.0
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    ldi ASK_IN.0
    plo R6
    ldi ASK_IN.1
    phi R6
    
    ldi PRINT.0
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
	
    lbr ASK_INPUT ;replace by SRET
	
;this is looped, we can make this a function tho	
;----------------------------------------------

;-CONSTANT DATA--------------------------------
BOOT_MSG
    db "CDP1806 Terminal, please use either BASIC or ASM op codes. \r\n For help use HELP command.\r\n 128KBytes of RAM free ",0
ASK_IN
    db "\r\n>",0
RESULT_OUT
    db "You typed in: ",0
NEW_LINE
    db "\r\n",0
	
READY
	db "READY \r\n",0	
UNKNOWN
    db "Command doesnt exist. For help use HELP command. \r\n",0
NOTIMPYET_MSG
    db "Not implemented yet.\r\n",0
	
;commands
	
HELP

	DB "Heres a list of commands: \r\n OUTPUT, outputs a value to an port \r\n HELP, shows this \r\n RESET, erases RAM and sets all ports to 00\r\n",0
	

DEL 

	DB "DELETE",0
	
MEMDUMP

	DB "MEMDUMP",0
    
OUTPUT_MSG1
    db "select IO chip, WARNING:IO chip 1 can control ram and rom banks!!\r\n","HEX:00, port A (reference to BANK 0)\r\n","HEX:01, port B\r\n","HEX:02, port C\r\n","HEX:03, CONFIG REGISTER",0
	
OUTPUT_MSG2
    db "Port?\r\n",0
	
OUTPUT_MSG3
    db "Value? (HEX, values can be also an array of multiple HEX values terminated by two following HEX:00)\r\n",0
    
COMMANDTABLE ;to test for a command
	db "STR",0,"ADD",0,"SUB",0,"LDN",0,"OUTPUT",0,"INPUT",0,"SLEEP",0,"WAIT",0,"PAUSE",0,"IF",0,"PRINT",0,"CLEAR",0,"CLEAR SCREEN",0,"DRAW",0,"DEMO",0,"CREDITS",0,"LCDDRIVER",0,0
	
COMMANDFUNCTIONS
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;STR
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;ADD
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;SUB
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;LDN
    db OUTPUT_FUNC.0, OUTPUT_FUNC.1 ;OUTPUT
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;INPUT
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;SLEEP
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;WAIT
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;PAUSE
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;IF
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;PRINT
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;CLEAR
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;CLEAR SCREEN
    db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;DRAW
	db DEMOGAME.0, DEMOGAME.1 ;DEMO GAME
	db CREDITS.0, CREDITS.1 ;CREDITS
	db NOTIMPLEMENTEDYET.0, NOTIMPLEMENTEDYET.1 ;LCDDRIVER


DEMOGAMEBASELEVEL

		DB "👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾 \r\n","👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾 \r\n","👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾 \r\n","👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾 \r\n",0

SPACEBETWEEN

	db "\r\n",0

PLAYERSHIP

	db "▲ \r\n",0

CREDITSTXT

	db "Feito por Marta 🏳️‍⚧️ \r\n",0
	
	
	
DRIVERINFO

	DB "Usage, 4-bit mode, E on P7, RS on P6, R/W on P5, P4 float, P0 to P3 to D0 to D3 respectivly, type your string!! end it with HEX:00\r\n",0
	
	
;-RAM------------------------------------------
LINE_IN
    db 0
    org $+61
STACK
;----------------------------------------------
    end
    
