; Speaker programming, shared state and timed effects.
; Original CS:5889..5B54 (end exclusive).

; CS:5889 — write_speaker_divisor_and_enable
; Writes AX low then high to port 42h and sets port 61h bits 0/1. AX is a PIT divisor, not a frequency in Hz.
write_speaker_divisor_and_enable:
    out 0x42, al                                                                ; 5889: e6 42
loc_588b:
    load8 mov, al, ah                                                           ; 588b: 8a c4
loc_588d:
    out 0x42, al                                                                ; 588d: e6 42
loc_588f:
    in al, 0x61                                                                 ; 588f: e4 61
loc_5891:
    or al, 3                                                                    ; 5891: 0c 03
loc_5893:
    out 0x61, al                                                                ; 5893: e6 61
loc_5895:
    ret                                                                         ; 5895: c3
loc_5896:
    ret                                                                         ; 5896: c3
loc_5897:
    cmp byte [sound_enabled], strict byte 0                                     ; 5897: 80 3e 00 00 00
loc_589c:
    je loc_58bc                                                                 ; 589c: 74 1e
loc_589e:
    push ax                                                                     ; 589e: 50
loc_589f:
    push cx                                                                     ; 589f: 51
loc_58a0:
    push dx                                                                     ; 58a0: 52
loc_58a1:
    mov al, 0xb6                                                                ; 58a1: b0 b6
loc_58a3:
    out 0x43, al                                                                ; 58a3: e6 43
loc_58a5:
    mov bx, word [0x5a56]                                                       ; 58a5: 8b 1e 56 5a
loc_58a9:
    and bx, strict word 6                                                       ; 58a9: 81 e3 06 00
loc_58ad:
    add word [0x5a56], strict byte 2                                            ; 58ad: 83 06 56 5a 02
loc_58b2:
    mov ax, word [bx + 0x5a5a]                                                  ; 58b2: 8b 87 5a 5a
loc_58b6:
    call near write_speaker_divisor_and_enable                                  ; 58b6: e8 d0 ff
loc_58b9:
    pop dx                                                                      ; 58b9: 5a
loc_58ba:
    pop cx                                                                      ; 58ba: 59
loc_58bb:
    pop ax                                                                      ; 58bb: 58
loc_58bc:
    ret                                                                         ; 58bc: c3
; CS:58bd — initialize_game_sound
; Resets shared background and asynchronous sound counters, divisors and phase bytes at DS:5920..592D and DS:5B07..5B0E.
initialize_game_sound:
    mov byte [0x5927], 0x80                                                     ; 58bd: c6 06 27 59 80
loc_58c2:
    mov byte [0x5928], 0                                                        ; 58c2: c6 06 28 59 00
loc_58c7:
    mov byte [0x5929], 0                                                        ; 58c7: c6 06 29 59 00
loc_58cc:
    mov word [0x592a], 0x500                                                    ; 58cc: c7 06 2a 59 00 05
loc_58d2:
    mov byte [0x592c], 0xff                                                     ; 58d2: c6 06 2c 59 ff
loc_58d7:
    mov byte [0x592d], 0                                                        ; 58d7: c6 06 2d 59 00
loc_58dc:
    mov byte [two_stage_sound_ticks], 0                                         ; 58dc: c6 06 20 59 00
loc_58e1:
    mov byte [0x5b07], 0                                                        ; 58e1: c6 06 07 5b 00
loc_58e6:
    mov word [0x5b08], 0                                                        ; 58e6: c7 06 08 5b 00 00
loc_58ec:
    mov word [0x5b0c], 1                                                        ; 58ec: c7 06 0c 5b 01 00
loc_58f2:
    mov byte [0x5b0e], 1                                                        ; 58f2: c6 06 0e 5b 01
loc_58f7:
    ret                                                                         ; 58f7: c3
loc_58f8:
    cmp byte [enemy_active], strict byte 0                                      ; 58f8: 80 3e bf 1c 00
loc_58fd:
    jne loc_5908                                                                ; 58fd: 75 09
loc_58ff:
    mov bx, 0x390                                                               ; 58ff: bb 90 03
loc_5902:
    mov cx, 0x1800                                                              ; 5902: b9 00 18
loc_5905:
    call near loc_59a3                                                          ; 5905: e8 9b 00
loc_5908:
    mov byte [0x127c], 0                                                        ; 5908: c6 06 7c 12 00
loc_590d:
    ret                                                                         ; 590d: c3
loc_590e:
    cmp byte [enemy_active], strict byte 0                                      ; 590e: 80 3e bf 1c 00
loc_5913:
    jne loc_591e                                                                ; 5913: 75 09
loc_5915:
    mov bx, 0x400                                                               ; 5915: bb 00 04
loc_5918:
    mov cx, 0x1800                                                              ; 5918: b9 00 18
loc_591b:
    call near loc_59a3                                                          ; 591b: e8 85 00
loc_591e:
    ret                                                                         ; 591e: c3
loc_591f:
    mov bx, 0x7d0                                                               ; 591f: bb d0 07
loc_5922:
    mov cx, 0x1800                                                              ; 5922: b9 00 18
loc_5925:
    call near loc_59a3                                                          ; 5925: e8 7b 00
loc_5928:
    mov bx, 0xa6e                                                               ; 5928: bb 6e 0a
loc_592b:
    mov cx, 0x1800                                                              ; 592b: b9 00 18
loc_592e:
    call near loc_59a3                                                          ; 592e: e8 72 00
loc_5931:
    mov bx, 0xdec                                                               ; 5931: bb ec 0d
loc_5934:
    mov cx, 0x1800                                                              ; 5934: b9 00 18
loc_5937:
    call near loc_59a3                                                          ; 5937: e8 69 00
loc_593a:
    ret                                                                         ; 593a: c3
; CS:593b — start_two_stage_sound
; When sound is enabled, programs AX divisor immediately, saves BX as the second divisor, and sets a two-tick countdown serviced by update_game_sound.
start_two_stage_sound:
    cmp byte [sound_enabled], strict byte 0                                     ; 593b: 80 3e 00 00 00
loc_5940:
    je loc_595c                                                                 ; 5940: 74 1a
loc_5942:
    mov word [two_stage_sound_second_divisor], bx                               ; 5942: 89 1e 23 59
loc_5946:
    push ax                                                                     ; 5946: 50
loc_5947:
    mov al, 0xb6                                                                ; 5947: b0 b6
loc_5949:
    out 0x43, al                                                                ; 5949: e6 43
loc_594b:
    pop ax                                                                      ; 594b: 58
loc_594c:
    call near write_speaker_divisor_and_enable                                  ; 594c: e8 3a ff
loc_594f:
    mov byte [two_stage_sound_ticks], 2                                         ; 594f: c6 06 20 59 02
loc_5954:
    load8 sub, ah, ah                                                           ; 5954: 2a e4
loc_5956:
    int 0x1a                                                                    ; 5956: cd 1a
loc_5958:
    mov word [two_stage_sound_last_tick], dx                                    ; 5958: 89 16 21 59
loc_595c:
    ret                                                                         ; 595c: c3
loc_595d:
    cmp byte [sound_enabled], strict byte 0                                     ; 595d: 80 3e 00 00 00
loc_5962:
    je loc_597e                                                                 ; 5962: 74 1a
loc_5964:
    cmp byte [two_stage_sound_ticks], strict byte 0                             ; 5964: 80 3e 20 59 00
loc_5969:
    jne loc_597e                                                                ; 5969: 75 13
loc_596b:
    call near update_random_state                                               ; 596b: e8 8f d4
loc_596e:
    load16 mov, ax, dx                                                          ; 596e: 8b c2
loc_5970:
    and ax, strict word 0x7f                                                    ; 5970: 25 7f 00
loc_5973:
    add ax, strict word 0xaa                                                    ; 5973: 05 aa 00
loc_5976:
    load16 mov, bx, ax                                                          ; 5976: 8b d8
loc_5978:
    add ax, strict word 0x1e                                                    ; 5978: 05 1e 00
loc_597b:
    call near start_two_stage_sound                                             ; 597b: e8 bd ff
loc_597e:
    ret                                                                         ; 597e: c3
loc_597f:
    cmp byte [sound_enabled], strict byte 0                                     ; 597f: 80 3e 00 00 00
loc_5984:
    je loc_59a2                                                                 ; 5984: 74 1c
loc_5986:
    mov ax, 0x1200                                                              ; 5986: b8 00 12
loc_5989:
    mov bx, 0x1312                                                              ; 5989: bb 12 13
loc_598c:
    add ax, word [0x5b08]                                                       ; 598c: 03 06 08 5b
loc_5990:
    add bx, word [0x5b08]                                                       ; 5990: 03 1e 08 5b
loc_5994:
    add word [0x5b08], strict word 0x15e                                        ; 5994: 81 06 08 5b 5e 01
loc_599a:
    call near start_two_stage_sound                                             ; 599a: e8 9e ff
loc_599d:
    mov byte [0x5b07], 0x18                                                     ; 599d: c6 06 07 5b 18
loc_59a2:
    ret                                                                         ; 59a2: c3
loc_59a3:
    cmp byte [sound_enabled], strict byte 0                                     ; 59a3: 80 3e 00 00 00
loc_59a8:
    je loc_59ca                                                                 ; 59a8: 74 20
loc_59aa:
    mov al, 0xb6                                                                ; 59aa: b0 b6
loc_59ac:
    out 0x43, al                                                                ; 59ac: e6 43
loc_59ae:
    load16 mov, ax, bx                                                          ; 59ae: 8b c3
loc_59b0:
    out 0x42, al                                                                ; 59b0: e6 42
loc_59b2:
    load8 mov, al, ah                                                           ; 59b2: 8a c4
loc_59b4:
    out 0x42, al                                                                ; 59b4: e6 42
loc_59b6:
    in al, 0x61                                                                 ; 59b6: e4 61
loc_59b8:
    or al, 3                                                                    ; 59b8: 0c 03
loc_59ba:
    out 0x61, al                                                                ; 59ba: e6 61
loc_59bc:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 59bc: 80 3e 97 06 fd
loc_59c1:
    jne loc_59c5                                                                ; 59c1: 75 02
loc_59c3:
    shr cx, 1                                                                   ; 59c3: d1 e9
loc_59c5:
    loop loc_59c5                                                               ; 59c5: e2 fe
loc_59c7:
    call near disable_speaker                                                   ; 59c7: e8 57 01
loc_59ca:
    ret                                                                         ; 59ca: c3
loc_59cb:
    in al, 0x61                                                                 ; 59cb: e4 61
loc_59cd:
    and al, 0xfe                                                                ; 59cd: 24 fe
loc_59cf:
    out 0x61, al                                                                ; 59cf: e6 61
loc_59d1:
    load8 sub, ah, ah                                                           ; 59d1: 2a e4
loc_59d3:
    int 0x1a                                                                    ; 59d3: cd 1a
loc_59d5:
    mov word [0x5a40], dx                                                       ; 59d5: 89 16 40 5a
loc_59d9:
    mov word [0x5a42], 0                                                        ; 59d9: c7 06 42 5a 00 00
loc_59df:
    mov ax, word [0x5a42]                                                       ; 59df: a1 42 5a
loc_59e2:
    mov cl, 6                                                                   ; 59e2: b1 06
loc_59e4:
    shr ax, cl                                                                  ; 59e4: d3 e8
loc_59e6:
    jne loc_59e9                                                                ; 59e6: 75 01
loc_59e8:
    inc ax                                                                      ; 59e8: 40
loc_59e9:
    load16 mov, cx, ax                                                          ; 59e9: 8b c8
loc_59eb:
    push cx                                                                     ; 59eb: 51
loc_59ec:
    load8 sub, ah, ah                                                           ; 59ec: 2a e4
loc_59ee:
    int 0x1a                                                                    ; 59ee: cd 1a
loc_59f0:
    pop cx                                                                      ; 59f0: 59
loc_59f1:
    sub dx, word [0x5a40]                                                       ; 59f1: 2b 16 40 5a
loc_59f5:
    cmp dx, strict byte 2                                                       ; 59f5: 83 fa 02
loc_59f8:
    jb loc_59eb                                                                 ; 59f8: 72 f1
loc_59fa:
    cmp dx, strict byte 7                                                       ; 59fa: 83 fa 07
loc_59fd:
    jae loc_5a18                                                                ; 59fd: 73 19
loc_59ff:
    loop loc_59eb                                                               ; 59ff: e2 ea
loc_5a01:
    call near update_random_state                                               ; 5a01: e8 f9 d3
loc_5a04:
    and dl, strict byte 2                                                       ; 5a04: 80 e2 02
loc_5a07:
    and dl, byte [sound_enabled]                                                ; 5a07: 22 16 00 00
loc_5a0b:
    in al, 0x61                                                                 ; 5a0b: e4 61
loc_5a0d:
    load8 xor, al, dl                                                           ; 5a0d: 32 c2
loc_5a0f:
    out 0x61, al                                                                ; 5a0f: e6 61
loc_5a11:
    add word [0x5a42], strict byte 7                                            ; 5a11: 83 06 42 5a 07
loc_5a16:
    jmp short loc_59df                                                          ; 5a16: eb c7
loc_5a18:
    call near disable_speaker                                                   ; 5a18: e8 06 01
loc_5a1b:
    ret                                                                         ; 5a1b: c3
loc_5a1c:
    cmp byte [sound_enabled], strict byte 0                                     ; 5a1c: 80 3e 00 00 00
loc_5a21:
    je loc_5a34                                                                 ; 5a21: 74 11
loc_5a23:
    call near read_pit_channel_zero                                             ; 5a23: e8 91 b9
loc_5a26:
    mov bx, word [0x5a16]                                                       ; 5a26: 8b 1e 16 5a
loc_5a2a:
    load16 sub, bx, ax                                                          ; 5a2a: 2b d8
loc_5a2c:
    jb loc_5a35                                                                 ; 5a2c: 72 07
loc_5a2e:
    cmp bx, strict word 0x260                                                   ; 5a2e: 81 fb 60 02
loc_5a32:
    ja loc_5a35                                                                 ; 5a32: 77 01
loc_5a34:
    ret                                                                         ; 5a34: c3
loc_5a35:
    mov word [0x5a16], ax                                                       ; 5a35: a3 16 5a
loc_5a38:
    mov al, 0xb6                                                                ; 5a38: b0 b6
loc_5a3a:
    out 0x43, al                                                                ; 5a3a: e6 43
loc_5a3c:
    inc word [0x5a18]                                                           ; 5a3c: ff 06 18 5a
loc_5a40:
    mov bx, word [0x5a18]                                                       ; 5a40: 8b 1e 18 5a
loc_5a44:
    and bx, strict word 0x1e                                                    ; 5a44: 81 e3 1e 00
loc_5a48:
    mov ax, word [0x5a3c]                                                       ; 5a48: a1 3c 5a
loc_5a4b:
    and ax, strict word 0x3ff                                                   ; 5a4b: 25 ff 03
loc_5a4e:
    cmp ax, strict word 0x180                                                   ; 5a4e: 3d 80 01
loc_5a51:
    jb loc_5a59                                                                 ; 5a51: 72 06
loc_5a53:
    mov cx, 0x180                                                               ; 5a53: b9 80 01
loc_5a56:
    load16 sub, cx, ax                                                          ; 5a56: 2b c8
loc_5a58:
    xchg cx, ax                                                                 ; 5a58: 91
loc_5a59:
    shr ax, 1                                                                   ; 5a59: d1 e8
loc_5a5b:
    shr ax, 1                                                                   ; 5a5b: d1 e8
loc_5a5d:
    add ax, word [bx + 0x5a1a]                                                  ; 5a5d: 03 87 1a 5a
loc_5a61:
    mov bx, 1                                                                   ; 5a61: bb 01 00
loc_5a64:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 5a64: 80 3e 97 06 fd
loc_5a69:
    jne loc_5a6d                                                                ; 5a69: 75 02
loc_5a6b:
    shl bl, 1                                                                   ; 5a6b: d0 e3
loc_5a6d:
    add word [0x5a3e], bx                                                       ; 5a6d: 01 1e 3e 5a
loc_5a71:
    shl bx, 1                                                                   ; 5a71: d1 e3
loc_5a73:
    shl bx, 1                                                                   ; 5a73: d1 e3
loc_5a75:
    add word [0x5a3c], bx                                                       ; 5a75: 01 1e 3c 5a
loc_5a79:
    mov dx, word [0x5a3e]                                                       ; 5a79: 8b 16 3e 5a
loc_5a7d:
    mov cl, 3                                                                   ; 5a7d: b1 03
loc_5a7f:
    shr dx, cl                                                                  ; 5a7f: d3 ea
loc_5a81:
    load16 add, ax, dx                                                          ; 5a81: 03 c2
loc_5a83:
    out 0x42, al                                                                ; 5a83: e6 42
loc_5a85:
    load8 mov, al, ah                                                           ; 5a85: 8a c4
loc_5a87:
    out 0x42, al                                                                ; 5a87: e6 42
loc_5a89:
    in al, 0x61                                                                 ; 5a89: e4 61
loc_5a8b:
    or al, 3                                                                    ; 5a8b: 0c 03
loc_5a8d:
    out 0x61, al                                                                ; 5a8d: e6 61
loc_5a8f:
    ret                                                                         ; 5a8f: c3
loc_5a90:
    cmp byte [sound_enabled], strict byte 0                                     ; 5a90: 80 3e 00 00 00
loc_5a95:
    je loc_5aa1                                                                 ; 5a95: 74 0a
loc_5a97:
    load8 sub, ah, ah                                                           ; 5a97: 2a e4
loc_5a99:
    int 0x1a                                                                    ; 5a99: cd 1a
loc_5a9b:
    cmp dx, word [0x5a14]                                                       ; 5a9b: 3b 16 14 5a
loc_5a9f:
    jne loc_5aa2                                                                ; 5a9f: 75 01
loc_5aa1:
    ret                                                                         ; 5aa1: c3
loc_5aa2:
    mov word [0x5a14], dx                                                       ; 5aa2: 89 16 14 5a
loc_5aa6:
    mov al, 0xb6                                                                ; 5aa6: b0 b6
loc_5aa8:
    out 0x43, al                                                                ; 5aa8: e6 43
loc_5aaa:
    call near update_random_state                                               ; 5aaa: e8 50 d3
loc_5aad:
    load16 mov, ax, dx                                                          ; 5aad: 8b c2
loc_5aaf:
    and ax, strict word 0x70                                                    ; 5aaf: 25 70 00
loc_5ab2:
    add ax, strict word 0x200                                                   ; 5ab2: 05 00 02
loc_5ab5:
    out 0x42, al                                                                ; 5ab5: e6 42
loc_5ab7:
    load8 mov, al, ah                                                           ; 5ab7: 8a c4
loc_5ab9:
    out 0x42, al                                                                ; 5ab9: e6 42
loc_5abb:
    in al, 0x61                                                                 ; 5abb: e4 61
loc_5abd:
    or al, 3                                                                    ; 5abd: 0c 03
loc_5abf:
    out 0x61, al                                                                ; 5abf: e6 61
loc_5ac1:
    ret                                                                         ; 5ac1: c3
loc_5ac2:
    mov word [0x5a12], 0x338                                                    ; 5ac2: c7 06 12 5a 38 03
loc_5ac8:
    load8 sub, ah, ah                                                           ; 5ac8: 2a e4
loc_5aca:
    int 0x1a                                                                    ; 5aca: cd 1a
loc_5acc:
    mov word [0x5a10], dx                                                       ; 5acc: 89 16 10 5a
loc_5ad0:
    call near read_pit_channel_zero                                             ; 5ad0: e8 e4 b8
loc_5ad3:
    mov word [0x5a0e], ax                                                       ; 5ad3: a3 0e 5a
loc_5ad6:
    call near read_pit_channel_zero                                             ; 5ad6: e8 de b8
loc_5ad9:
    load16 mov, dx, ax                                                          ; 5ad9: 8b d0
loc_5adb:
    sub ax, word [0x5a0e]                                                       ; 5adb: 2b 06 0e 5a
loc_5adf:
    cmp ax, strict word 0x9c40                                                  ; 5adf: 3d 40 9c
loc_5ae2:
    jb loc_5b10                                                                 ; 5ae2: 72 2c
loc_5ae4:
    mov word [0x5a0e], dx                                                       ; 5ae4: 89 16 0e 5a
loc_5ae8:
    cmp byte [sound_enabled], strict byte 0                                     ; 5ae8: 80 3e 00 00 00
loc_5aed:
    je loc_5b10                                                                 ; 5aed: 74 21
loc_5aef:
    mov al, 0xb6                                                                ; 5aef: b0 b6
loc_5af1:
    out 0x43, al                                                                ; 5af1: e6 43
loc_5af3:
    call near update_random_state                                               ; 5af3: e8 07 d3
loc_5af6:
    load16 mov, ax, dx                                                          ; 5af6: 8b c2
loc_5af8:
    and ax, strict word 0x7ff                                                   ; 5af8: 25 ff 07
loc_5afb:
    add ax, word [0x5a12]                                                       ; 5afb: 03 06 12 5a
loc_5aff:
    sub word [0x5a12], strict byte 2                                            ; 5aff: 83 2e 12 5a 02
loc_5b04:
    out 0x42, al                                                                ; 5b04: e6 42
loc_5b06:
    load8 mov, al, ah                                                           ; 5b06: 8a c4
loc_5b08:
    out 0x42, al                                                                ; 5b08: e6 42
loc_5b0a:
    in al, 0x61                                                                 ; 5b0a: e4 61
loc_5b0c:
    or al, 3                                                                    ; 5b0c: 0c 03
loc_5b0e:
    out 0x61, al                                                                ; 5b0e: e6 61
loc_5b10:
    load8 sub, ah, ah                                                           ; 5b10: 2a e4
loc_5b12:
    int 0x1a                                                                    ; 5b12: cd 1a
loc_5b14:
    sub dx, word [0x5a10]                                                       ; 5b14: 2b 16 10 5a
loc_5b18:
    cmp dx, strict byte 2                                                       ; 5b18: 83 fa 02
loc_5b1b:
    jb loc_5ad6                                                                 ; 5b1b: 72 b9
loc_5b1d:
    call near disable_speaker                                                   ; 5b1d: e8 01 00
loc_5b20:
    ret                                                                         ; 5b20: c3

; CS:5b21 — disable_speaker
; Reads port 61h, clears bits 0/1, writes it back, and returns.
disable_speaker:
    in al, 0x61                                                                 ; 5b21: e4 61
loc_5b23:
    and al, 0xfc                                                                ; 5b23: 24 fc
loc_5b25:
    out 0x61, al                                                                ; 5b25: e6 61
loc_5b27:
    ret                                                                         ; 5b27: c3
loc_5b28:
    mov al, 0xb6                                                                ; 5b28: b0 b6
loc_5b2a:
    out 0x43, al                                                                ; 5b2a: e6 43
loc_5b2c:
    mov ax, word [0x592a]                                                       ; 5b2c: a1 2a 59
loc_5b2f:
    out 0x42, al                                                                ; 5b2f: e6 42
loc_5b31:
    load8 mov, al, ah                                                           ; 5b31: 8a c4
loc_5b33:
    out 0x42, al                                                                ; 5b33: e6 42
loc_5b35:
    in al, 0x61                                                                 ; 5b35: e4 61
loc_5b37:
    or al, 3                                                                    ; 5b37: 0c 03
loc_5b39:
    out 0x61, al                                                                ; 5b39: e6 61
loc_5b3b:
    call near read_pit_channel_zero                                             ; 5b3b: e8 79 b8
loc_5b3e:
    load16 mov, cx, ax                                                          ; 5b3e: 8b c8
loc_5b40:
    call near read_pit_channel_zero                                             ; 5b40: e8 74 b8
loc_5b43:
    load16 mov, dx, cx                                                          ; 5b43: 8b d1
loc_5b45:
    load16 sub, dx, ax                                                          ; 5b45: 2b d0
loc_5b47:
    cmp dx, word [0x592e]                                                       ; 5b47: 3b 16 2e 59
loc_5b4b:
    jb loc_5b40                                                                 ; 5b4b: 72 f3
loc_5b4d:
    in al, 0x61                                                                 ; 5b4d: e4 61
loc_5b4f:
    and al, 0xfc                                                                ; 5b4f: 24 fc
loc_5b51:
    out 0x61, al                                                                ; 5b51: e6 61
loc_5b53:
    ret                                                                         ; 5b53: c3
