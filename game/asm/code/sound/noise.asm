; Call-counted speaker gate modulation.
; Original CS:5797..57D5 (end exclusive).

; CS:5797 — initialize_bitbang_noise
; Disables the speaker, clears noise phase and sets the duty parameter to eight.
initialize_bitbang_noise:
    call near disable_speaker                                                   ; 5797: e8 87 03
loc_579a:
    mov byte [noise_phase], 0                                                   ; 579a: c6 06 cf 5a 00
loc_579f:
    mov word [noise_duty_parameter], 8                                          ; 579f: c7 06 cd 5a 08 00
loc_57a5:
    ret                                                                         ; 57a5: c3
; CS:57a6 — update_bitbang_noise
; Advances a 64-call phase, increases the duty parameter at phase wrap, and writes speaker port bit one masked by sound_enabled; it does not program a PIT divisor.
update_bitbang_noise:
    inc byte [noise_phase]                                                      ; 57a6: fe 06 cf 5a
loc_57aa:
    load8 sub, dl, dl                                                           ; 57aa: 2a d2
loc_57ac:
    mov al, byte [noise_phase]                                                  ; 57ac: a0 cf 5a
loc_57af:
    and al, 0x3f                                                                ; 57af: 24 3f
loc_57b1:
    jne loc_57b7                                                                ; 57b1: 75 04
loc_57b3:
    inc word [noise_duty_parameter]                                             ; 57b3: ff 06 cd 5a
loc_57b7:
    mov bx, word [noise_duty_parameter]                                         ; 57b7: 8b 1e cd 5a
loc_57bb:
    mov cl, 2                                                                   ; 57bb: b1 02
loc_57bd:
    shr bx, cl                                                                  ; 57bd: d3 eb
loc_57bf:
    and bl, strict byte 0x1f                                                    ; 57bf: 80 e3 1f
loc_57c2:
    load8 cmp, al, bl                                                           ; 57c2: 3a c3
loc_57c4:
    jb loc_57c8                                                                 ; 57c4: 72 02
loc_57c6:
    mov dl, 2                                                                   ; 57c6: b2 02
loc_57c8:
    and dl, byte [sound_enabled]                                                ; 57c8: 22 16 00 00
loc_57cc:
    in al, 0x61                                                                 ; 57cc: e4 61
loc_57ce:
    and al, 0xfd                                                                ; 57ce: 24 fd
loc_57d0:
    load8 or, al, dl                                                            ; 57d0: 0a c2
loc_57d2:
    out 0x61, al                                                                ; 57d2: e6 61
loc_57d4:
    ret                                                                         ; 57d4: c3
