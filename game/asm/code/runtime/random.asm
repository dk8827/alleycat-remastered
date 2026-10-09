; Random-state feedback and PIT seeding.
; Original CS:2DFD..2E29 (end exclusive).

; CS:2dfd — update_random_state
; Returns DX = (old >> 1) | ((((old >> 1) XOR (old >> 9)) AND 1) << 15), and stores it at 2AE5.
update_random_state:
    mov dx, word [random_state]                                                 ; 2dfd: 8b 16 e5 2a
loc_2e01:
    load8 xor, dl, dh                                                           ; 2e01: 32 d6
loc_2e03:
    shr dl, 1                                                                   ; 2e03: d0 ea
loc_2e05:
    shr dl, 1                                                                   ; 2e05: d0 ea
loc_2e07:
    rcr word [random_state], 1                                                  ; 2e07: d1 1e e5 2a
loc_2e0b:
    mov dx, word [random_state]                                                 ; 2e0b: 8b 16 e5 2a
loc_2e0f:
    ret                                                                         ; 2e0f: c3

; CS:2e10 — seed_random_from_pit
; Reads two PIT bytes into AH then AL without the other timer routine's XCHG; substitutes FA59 for zero; stores AX into random_state.
seed_random_from_pit:
    mov al, 0                                                                   ; 2e10: b0 00
loc_2e12:
    out 0x43, al                                                                ; 2e12: e6 43
loc_2e14:
    nop                                                                         ; 2e14: 90
loc_2e15:
    nop                                                                         ; 2e15: 90
loc_2e16:
    in al, 0x40                                                                 ; 2e16: e4 40
loc_2e18:
    load8 mov, ah, al                                                           ; 2e18: 8a e0
loc_2e1a:
    nop                                                                         ; 2e1a: 90
loc_2e1b:
    in al, 0x40                                                                 ; 2e1b: e4 40
loc_2e1d:
    cmp ax, strict word 0                                                       ; 2e1d: 3d 00 00
loc_2e20:
    jne loc_2e25                                                                ; 2e20: 75 03
loc_2e22:
    mov ax, 0xfa59                                                              ; 2e22: b8 59 fa
loc_2e25:
    mov word [random_state], ax                                                 ; 2e25: a3 e5 2a
loc_2e28:
    ret                                                                         ; 2e28: c3
