; Result melody and alternating tone sequences.
; Original CS:57D5..5889 (end exclusive).

; CS:57d5 — initialize_result_melody
; Clears the result melody byte offset and records the current BIOS tick.
initialize_result_melody:
    mov word [result_melody_byte_offset], 0                                     ; 57d5: c7 06 85 5a 00 00
loc_57db:
    load8 sub, ah, ah                                                           ; 57db: 2a e4
loc_57dd:
    int 0x1a                                                                    ; 57dd: cd 1a
loc_57df:
    mov word [result_melody_last_tick], dx                                      ; 57df: 89 16 83 5a
loc_57e3:
    ret                                                                         ; 57e3: c3
; CS:57e4 — update_result_melody
; When sound is enabled and two ticks have elapsed, advances a word-table index and emits a divisor; scene failure selects DS:5AA3 and its zero word disables the speaker.
update_result_melody:
    cmp byte [sound_enabled], strict byte 0                                     ; 57e4: 80 3e 00 00 00
loc_57e9:
    je loc_5828                                                                 ; 57e9: 74 3d
loc_57eb:
    load8 sub, ah, ah                                                           ; 57eb: 2a e4
loc_57ed:
    int 0x1a                                                                    ; 57ed: cd 1a
loc_57ef:
    load16 mov, ax, dx                                                          ; 57ef: 8b c2
loc_57f1:
    sub ax, word [result_melody_last_tick]                                      ; 57f1: 2b 06 83 5a
loc_57f5:
    cmp ax, strict word 2                                                       ; 57f5: 3d 02 00
loc_57f8:
    jb loc_5828                                                                 ; 57f8: 72 2e
loc_57fa:
    mov word [result_melody_last_tick], dx                                      ; 57fa: 89 16 83 5a
loc_57fe:
    mov bx, word [result_melody_byte_offset]                                    ; 57fe: 8b 1e 85 5a
loc_5802:
    add word [result_melody_byte_offset], strict byte 2                         ; 5802: 83 06 85 5a 02
loc_5807:
    cmp byte [scene_failed], strict byte 0                                      ; 5807: 80 3e 52 05 00
loc_580c:
    je loc_581b                                                                 ; 580c: 74 0d
loc_580e:
    mov ax, word [bx + result_failure_divisors]                                 ; 580e: 8b 87 a3 5a
loc_5812:
    cmp ax, strict word 0                                                       ; 5812: 3d 00 00
loc_5815:
    jne loc_581f                                                                ; 5815: 75 08
loc_5817:
    call near disable_speaker                                                   ; 5817: e8 07 03
loc_581a:
    ret                                                                         ; 581a: c3
loc_581b:
    mov ax, word [bx + result_success_divisors]                                 ; 581b: 8b 87 87 5a
loc_581f:
    push ax                                                                     ; 581f: 50
loc_5820:
    mov al, 0xb6                                                                ; 5820: b0 b6
loc_5822:
    out 0x43, al                                                                ; 5822: e6 43
loc_5824:
    pop ax                                                                      ; 5824: 58
loc_5825:
    call near write_speaker_divisor_and_enable                                  ; 5825: e8 61 00
loc_5828:
    ret                                                                         ; 5828: c3
; CS:5829 — initialize_alternating_tone_sequence
; Clears the divisor-table byte offset at DS:5A62 and the phase byte at DS:5A82.
initialize_alternating_tone_sequence:
    mov word [alternating_tone_byte_offset], 0                                  ; 5829: c7 06 62 5a 00 00
loc_582f:
    mov byte [alternating_tone_phase], 0                                        ; 582f: c6 06 82 5a 00
loc_5834:
    ret                                                                         ; 5834: c3
; CS:5835 — update_alternating_tone_sequence
; On each distinct BIOS tick increments phase and alternates the selected divisor at DS:5A64 with the following word; sound-disabled calls return immediately.
update_alternating_tone_sequence:
    cmp byte [sound_enabled], strict byte 0                                     ; 5835: 80 3e 00 00 00
loc_583a:
    je loc_5846                                                                 ; 583a: 74 0a
loc_583c:
    load8 sub, ah, ah                                                           ; 583c: 2a e4
loc_583e:
    int 0x1a                                                                    ; 583e: cd 1a
loc_5840:
    cmp dx, word [alternating_tone_last_tick]                                   ; 5840: 3b 16 80 5a
loc_5844:
    jne loc_5847                                                                ; 5844: 75 01
loc_5846:
    ret                                                                         ; 5846: c3
loc_5847:
    mov word [alternating_tone_last_tick], dx                                   ; 5847: 89 16 80 5a
loc_584b:
    inc byte [alternating_tone_phase]                                           ; 584b: fe 06 82 5a
loc_584f:
    mov al, 0xb6                                                                ; 584f: b0 b6
loc_5851:
    out 0x43, al                                                                ; 5851: e6 43
loc_5853:
    mov bx, word [alternating_tone_byte_offset]                                 ; 5853: 8b 1e 62 5a
loc_5857:
    test byte [alternating_tone_phase], 1                                       ; 5857: f6 06 82 5a 01
loc_585c:
    jne loc_5861                                                                ; 585c: 75 03
loc_585e:
    add bx, strict byte 2                                                       ; 585e: 83 c3 02
loc_5861:
    mov ax, word [bx + alternating_tone_divisors]                               ; 5861: 8b 87 64 5a
loc_5865:
    call near write_speaker_divisor_and_enable                                  ; 5865: e8 21 00
loc_5868:
    ret                                                                         ; 5868: c3
; CS:5869 — advance_alternating_tone_sequence
; When sound is enabled, plays the divisor at DS:5A64 plus the current byte offset and advances that offset by two; preserves AX and BX.
advance_alternating_tone_sequence:
    cmp byte [sound_enabled], strict byte 0                                     ; 5869: 80 3e 00 00 00
loc_586e:
    je loc_5888                                                                 ; 586e: 74 18
loc_5870:
    push bx                                                                     ; 5870: 53
loc_5871:
    push ax                                                                     ; 5871: 50
loc_5872:
    mov al, 0xb6                                                                ; 5872: b0 b6
loc_5874:
    out 0x43, al                                                                ; 5874: e6 43
loc_5876:
    mov bx, word [alternating_tone_byte_offset]                                 ; 5876: 8b 1e 62 5a
loc_587a:
    add word [alternating_tone_byte_offset], strict byte 2                      ; 587a: 83 06 62 5a 02
loc_587f:
    mov ax, word [bx + alternating_tone_divisors]                               ; 587f: 8b 87 64 5a
loc_5883:
    call near write_speaker_divisor_and_enable                                  ; 5883: e8 03 00
loc_5886:
    pop ax                                                                      ; 5886: 58
loc_5887:
    pop bx                                                                      ; 5887: 5b
loc_5888:
    ret                                                                         ; 5888: c3
