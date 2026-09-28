    AREA |.text|, CODE, READONLY
    THUMB
    EXPORT PORTF_Init
    EXPORT PORTF_Input

; Register Addresses
SYSCTL_RCGCGPIO_R EQU 0x400FE608
GPIO_PORTF_DIR_R  EQU 0x40025400
GPIO_PORTF_DEN_R  EQU 0x4002551C
GPIO_PORTF_PUR_R  EQU 0x40025510
GPIO_PORTF_LOCK_R EQU 0x40025520
GPIO_PORTF_CR_R   EQU 0x40025524
GPIO_PORTF_DATA_R EQU 0x400253FC

;------------PORTF_Init------------
PORTF_Init
    ; 1) Enable Port F Clock
    LDR R1, =SYSCTL_RCGCGPIO_R
    LDR R0, [R1]
    ORR R0, R0, #0x20       ; Enable clock for Port F
    STR R0, [R1]
    NOP
    NOP                     ; Small delay for clock to stabilize

    ; 2) Unlock PF0 (SW2)
    LDR R1, =GPIO_PORTF_LOCK_R
    LDR R0, =0x4C4F434B     ; Magic unlock key
    STR R0, [R1]

    ; Commit PF0
    LDR R1, =GPIO_PORTF_CR_R
    MOV R0, #0x01
    STR R0, [R1]

    ; 3) Set Direction: PF0-PF4 inputs
    LDR R1, =GPIO_PORTF_DIR_R
    MOV R0, #0x00           ; All inputs
    STR R0, [R1]

    ; 4) Enable Pull-ups for PF0-PF4
    LDR R1, =GPIO_PORTF_PUR_R
    MOV R0, #0x1F           ; Bits 0-4
    STR R0, [R1]

    ; 5) Digital Enable PF0-PF4
    LDR R1, =GPIO_PORTF_DEN_R
    MOV R0, #0x1F
    STR R0, [R1]

    BX LR

;------------PORTF_Input------------
PORTF_Input
    ; Read Port F input
    LDR R1, =GPIO_PORTF_DATA_R
    LDR R0, [R1]
    MVN R0, R0              ; Invert: Pressed = 1
    AND R0, R0, #0x1F       ; Mask only PF0-PF4
    BX LR

    ALIGN
    END