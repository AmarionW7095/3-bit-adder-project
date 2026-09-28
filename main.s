    AREA DATA, READWRITE

    AREA |.text|, CODE, READONLY
    THUMB
    EXPORT Start

    IMPORT PORTB_Init
    IMPORT PORTB_Input
    IMPORT PORTB_Output
    IMPORT PORTF_Init
    IMPORT PORTF_Input

Start
    BL  PORTB_Init      ; Init PB0-PB6 (LED) and PB7 (input)
    BL  PORTF_Init      ; Init PF0-PF4 (buttons)

loop
    ; Read Port F (Input A: PF0-PF2, Input B (MOSTLY): PF3-PF4)
    BL  PORTF_Input
    MOV R4, R0          ; Save Port F 

    ; Read PB7 (Input B bit 2)
    BL  PORTB_Input
    MOV R5, R0

    ; Input A = PF0-PF2(RESETTING the 3 bits)
    AND R1, R4, #0x07

    ; Input B = PB7:PF4:PF3
    ; CHECK PF3 bit 0, CHECK PF4 bit 1
    LSR R2, R4, #3
    AND R2, R2, #0x03
    ; CHECK PB7 bit 2
    LSR R6, R5, #7
    AND R6, R6, #0x01
    LSL R6, R6, #2
    ORR R2, R2, R6       ; R2 = Input B (0-7)

    ; Sum
    ADD R3, R1, R2       ; 0-14

    ; Convert sum to 7-segment-COMMON ANODE by taking the base address and using R3 to index through the display patterns
    LDR R6, =hex7seq
    LDRB R0, [R6, R3]

    ; Display Port B outputs
    BL PORTB_Output

    ; Delay
    LDR R0, =100000
    BL delay

    B loop

;------------7-Segment Lookup Table (Common Anode)------------
hex7seq
    DCB 0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
    DCB 0x80,0x90,0x88,0x83,0xC6,0xA1,0x86

;------------Delay Function------------
	ALIGN
delay
    SUBS R0, R0, #1
    BNE delay
    BX LR

    END