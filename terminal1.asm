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

    org 00h

START
    dis
    idl
    
    seq
    
    ldi LOW(33023) ;R14 STACK pointer
    plo R14
    ldi HIGH(33023)
    phi R14
    
    ldi FCALL.1 ;Setting the HIGH part of R15. This will never change again.
    phi R15 ;read more about it in the "FUNCTION CALL HELPER" section.
    
    lbr MAIN_PROGRAM

;-FUNCTION CALL HELPER-------------------------
;This subroutine helps to call "infinite" amount of functions,
;and let us use the R0 register as a permanent program counter.
;The only case when the program counter is need to be changed is
;when this subroutine is called.
;This subroutine uses the R15 register as a program counter.
;It saves the R0 register's value into the STACK
;Then copies the value of the R13 register to the R0 register.
;The STACK address is stored in R14, and it should not be changed,
;only then if you really know what are you doing.
;To call a function first set the R13 to the target function's address
;Then use the following lines to initiate the call:
;ldi FCALL.0
;plo R15
;sep R15
;
;Since this subroutine is stored in the first 256 bytes of the ROM,
;only the LOW part of the R15 needs to be set before using it as
;program counter.
;
;To return from a function, use simply the "sep R15" instruction.

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

;-MAIN-----------------------------------------
;The program starts with the printing of the boot message.
MAIN_PROGRAM
    ldi BOOT_MSG.0 ;The PRINT function uses the R6 register for the address of the string.
    plo R6 ;so we load the BOOT_MSG address in to the R6 register first.
    ldi BOOT_MSG.1
    phi R6

    ldi PRINT.0 ;Setting R13 to the address of PRINT.
    plo R13 ;to call the PRINT function.
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15 ;Calling the function right here.

	lbr ASK_INPUT
	
TEST
	ldi LOW(32768)
	plo R8 
	ldi HIGH(32768)
	phi R8
	
	ldi RUN.0
	plo R9 
	ldi RUN.1
	phi R9
	
	ldi STRCOMP.0
	plo R13 ;to call STRCOMP, R3 is also the last free register
	ldi STRCOMP.1
	phi R13
    
    ldi FCALL.0
    plo R15
    sep R15

	glo R12
	
	lbz NOTHING
	
	ldi RUNINFO.0
    plo R6
    ldi RUNINFO.1
    phi R6
	
	ldi PRINT.0 ;we use R6 to point what we want to print
    plo R13
    ldi PRINT.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
	
NOTHING
	ldi UNKNOWN.0
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

ASK_INPUT ;use SCALL for this 
    ldi LOW(32768)
    plo R7
    ldi HIGH(32768)
    phi R7
    
    ldi READLINE.0
    plo R13
    ldi READLINE.1
    phi R13
    
    ldi FCALL.0
    plo R15
    sep R15
    
    ;check command here.
    
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
	
	lbr test
    lbr ASK_INPUT ;replace by SRET
	
;this is looped, we can make this a function tho	
;----------------------------------------------

;-CONSTANT DATA--------------------------------
BOOT_MSG
    db "CDP1806 Terminal, please use either BASIC or ASM op codes. \r\n For help use HELP command.\r\n 220 Bytes of RAM free "
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
	
;commands

RUN

	DB "RUN",0
	
RUNINFO

	DB "Its Show Time!!",0
	
HELP

	DB "Heres a list of commands: \r\n RUN, runs code from ram.\r\n MEMDUMP, dumps RAMs content to terminal.\r\n DELETE, erases all RAM",0
	

DEL 

	DB "DELETE",0
	
MEMDUMP

	DB "MEMDUMP",0
	
	
 ;STRCOMPARATOR
  
  ;R8 1 string
  ;R9 2 string
STRCOMP
    ldi 0  ;result = 0
    plo R12
    ldi 0
    phi R12
	
	;to compare strings duh
	
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
	ldi $01
	plo R12 ;if A = B then R12 = 1 else R12 = 0, R12 is one of the few free registers
	sep R15
	
INCREMENTING
	inc R8
	inc R9
	br STRCOMPARATOR

;-RAM------------------------------------------
LINE_IN
    db 0
    org $+61
STACK
;----------------------------------------------
    end
    