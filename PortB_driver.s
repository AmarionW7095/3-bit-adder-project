    AREA |.text|, CODE, READONLY
    THUMB
    EXPORT PORTB_Init
    EXPORT PORTB_Input
    EXPORT PORTB_Output

; Register Addresses
SYSCTL_RCGCGPIO_R EQU 0x400FE608
GPIO_PORTB_DATA_R EQU 0x400053FC
GPIO_PORTB_DIR_R  EQU 0x40005400
GPIO_PORTB_PUR_R  EQU 0x40005510
GPIO_PORTB_DEN_R  EQU 0x4000551C

;------------PORTB_Init------------
PORTB_Init
    ; Enable Port B clock
    LDR R1, =SYSCTL_RCGCGPIO_R
    LDR R0, [R1]
    ORR R0, R0, #0x02
    STR R0, [R1]
    NOP
    NOP

    ; PB0-PB6 output, PB7 input
    LDR R1, =GPIO_PORTB_DIR_R
    MOV R0, #0x7F
    STR R0, [R1]

    ; Pull-up PB7
    LDR R1, =GPIO_PORTB_PUR_R
    MOV R0, #0x80
    STR R0, [R1]

    ; Digital enable
    LDR R1, =GPIO_PORTB_DEN_R
    MOV R0, #0xFF
    STR R0, [R1]
    BX LR

;------------PORTB_Input------------
PORTB_Input
    LDR R1, =GPIO_PORTB_DATA_R
    LDR R0, [R1]
    MVN R0, R0
    BX LR

;------------PORTB_Output------------
PORTB_Output
    LDR R1, =GPIO_PORTB_DATA_R
    STR R0, [R1]        ; simple write, no PB7 preserve
    BX LR

    ALIGN
    END