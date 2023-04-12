list p=16f88
processor 16F88

#include <proc/pic16f88.inc>

psect kmain,class=CODE,delta=2

setup:
    banksel TRISA  ; move to the bank where TRISA is
    bcf TRISA, 1   ; set RA1 port to output mode (TRISA<1> <- 0)

loop:
    banksel PORTA  ; move to the bank where PORTA is
    bsf PORTA, 1   ; output HIGH on RA1

    call sleep_500ms

    banksel PORTA  ; move to the bank where PORTA is
    bcf PORTA, 1   ; output LOW on RA1

    call sleep_500ms

    goto loop

; clock is 20 MHz
; 1 cycle take 4 clock

; this routine will took (1 + 1 + 1 + ((1 + 1 + 2) * 249 - 1) + 2) = 1000 cycles
; 1000 cycles are equal to 0.0002 sec under 20 MHz clock
sleep_2ms:
    movlw 249                 ; 1       ; W <- 249
    banksel 0x20              ; 1       ; move to the bank where 0x20 is
    movwf 0x20                ; 1       ; *(0x20) <- W, 0x20 is general purpose register

    sleep_2ms_loop1:
        nop                   ; 1       ; do nothing
        decfsz 0x20, 1        ; 1 or 2  ; if --*(0x20) != 0 { next instruction } else { nop instead }
        goto sleep_2ms_loop1  ; 2

    return                    ; 2       ; go back


; this routine will took (1 + 1 + 1 + ((1000 + 2 + 1 + 2) * 249 - 1) + 2) = 250249 cycles
; 250249 cycles are equal to 0.0500498 sec under 20 MHz clock
sleep_50ms:
    movlw 249                   ; 1         ; W <- 249
    banksel 0x21                ; 1         ; move to the bank where 0x21 is
    movwf 0x21                  ; 1         ; *(0x21) <- W, 0x21 is general purpose register

    sleep_50ms_loop1:
        call sleep_2ms          ; 1000 + 2
        decfsz 0x21, 1          ; 1 or 2    ; if --*(0x21) != 0 { next instruction } else { nop instead }
        goto sleep_50ms_loop1  ; 2

    return                      ; 2         ; go back

; this routine will took (1 + 1 + 1 + ((250249 + 2 + 1 + 2) * 10 - 1) + 2) = 2502544 cycles
; 2502544 cycles are equal to 0.5005088 sec under 20 MHz clock
sleep_500ms:
    movlw 10                    ; 1         ; W <- 10
    banksel 0x22                ; 1         ; move to the bank where 0x22 is
    movwf 0x22                  ; 1         ; *(0x22) <- W, 0x22 is general purpose register

    sleep_500ms_loop1:
        call sleep_50ms          ; 250249 + 2
        decfsz 0x22, 1           ; 1 or 2    ; if --*(0x22) != 0 { next instruction } else { nop instead }
        goto sleep_500ms_loop1   ; 2

    return                       ; 2         ; go back

end setup
