;.\a18.exe ram_tester.asm -b ram_tester.bin -l ram_tester.lst
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

RAM_START EQU 08000h

    org 00h

START
    dis
    idl

    seq
    
    ldi RAM_START.0
    plo R14
    ldi RAM_START.1
    phi R14
    
    ldi 4
    plo R8
    ldi 0
    phi R8

    lbr MAIN_PROGRAM

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
    sep R0  ;--
    nop     ;--
    ghi R4  ;16
    shr     ;16
    phi R4  ;16
    nop     ;24
    br SERIAL_SEND_BIT ;16
;----------------------------------------------

HEX_GET
    glo R5
    ani 0Fh
    
    adi HEX_DIGITS.0
    plo R6
    ldi 0
    adci HEX_DIGITS.1
    phi R6
    
    ldn R6
    plo R7
    
    sep R0
    
HEX_DIGITS
    db "0123456789ABCDEF"

MAIN_PROGRAM
    
FILL_FF
    ldi 0FFh
    str R14
    ldn R14
    xri 0FFh
    bnz RAM_ERROR_FF
    glo R14
    xri 0FFh
    bz AA_PREP
    inc R14
    br FILL_FF
    
AA_PREP
    ldi RAM_START.0
    plo R14
    ldi RAM_START.1
    phi R14
    
FILL_AA
    ldi 0AAh
    str R14
    ldn R14
    xri 0AAh
    bnz RAM_ERROR_AA
    glo R14
    xri 0FFh
    bz CNT_PREP
    inc R14
    br FILL_AA
    
CNT_PREP
    ldi RAM_START.0
    plo R14
    ldi RAM_START.1
    phi R14
    sex R14
    
CNT_TEST
    ldn R14
    xri 0AAh
    bnz RAM_ERROR_CNT
    glo R14
    str R14
    xor
    bnz RAM_ERROR_CNT
    glo R14
    xri 0FFh
    bz RAM_OK
    inc R14
    br CNT_TEST
    
ERROR_MESSAGE_FF
    db "RAM FF error at ", 0
    
ERROR_MESSAGE_AA
    db "RAM AA error at ", 0
    
ERROR_MESSAGE_CNT
    db "RAM CNT error at ", 0
    
SUCCESS_MESSAGE
    db "RAM OK", 0
    
RAM_OK
    ldi 1
    phi R8
    ldi SUCCESS_MESSAGE.0
    plo R13
    ldi SUCCESS_MESSAGE.1
    phi R13
    
    sex R13
    br PRINT_MSG

RAM_ERROR_FF
    ldi ERROR_MESSAGE_FF.0
    plo R13
    ldi ERROR_MESSAGE_FF.1
    phi R13
    
    sex R13
    br PRINT_MSG

RAM_ERROR_AA
    ldi ERROR_MESSAGE_AA.0
    plo R13
    ldi ERROR_MESSAGE_AA.1
    phi R13
    
    sex R13
    br PRINT_MSG
    
RAM_ERROR_CNT
    ldi ERROR_MESSAGE_CNT.0
    plo R13
    ldi ERROR_MESSAGE_CNT.1
    phi R13
    
    sex R13
    
PRINT_MSG
    ldxa
    bz NEXT_PRINT
    phi R4
    
    ldi SERIAL_SEND_START.0
    plo R15
    ldi SERIAL_SEND_START.1
    phi R15
    
    sep R15
    br PRINT_MSG
    
NEXT_PRINT
    ghi R8
    lbnz END_LOOP
   
    ghi R14
    shr
    shr
    shr
    shr

PRINT_DIGIT  
    plo R5
    
    ldi HEX_GET.0
    plo R15
    ldi HEX_GET.1
    phi R15
    
    sep R15
    
    glo R7
    phi R4
    
    ldi SERIAL_SEND_START.0
    plo R15
    ldi SERIAL_SEND_START.1
    phi R15
    
    sep R15
    
    dec R8
    glo R8
    bz END_LOOP
    smi 1
    bz DIGIT_0
    smi 1
    bz DIGIT_1
    smi 1
    bz DIGIT_2
    
DIGIT_0
    glo R14
    ani 0Fh
    lbr PRINT_DIGIT
    
DIGIT_1
    glo R14
    shr
    shr
    shr
    shr
    lbr PRINT_DIGIT
    
DIGIT_2
    ghi R14
    ani 0Fh
    lbr PRINT_DIGIT

END_LOOP
    br END_LOOP

    end
