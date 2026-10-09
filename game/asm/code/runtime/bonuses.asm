; Scene bonus calculation, conversion and result display.
; Original CS:38B0..3B30 (end exclusive).

; CS:38b0 — award_scene_bonus
; Builds a time-dependent decimal bonus plus a per-scene base, adds it to current score, schedules courtship after ordinary success, and draws a timed award screen.
award_scene_bonus:
    cmp word [previous_scene_index], strict byte 7                              ; 38b0: 83 3e 06 00 07
loc_38b5:
    jne loc_38ba                                                                ; 38b5: 75 03
loc_38b7:
    jmp short loc_38d3                                                          ; 38b7: eb 1a
loc_38b9:
    nop                                                                         ; 38b9: 90
loc_38ba:
    inc word [completed_room_count]                                             ; 38ba: ff 06 14 04
loc_38be:
    mov byte [courtship_pending], 1                                             ; 38be: c6 06 18 04 01
loc_38c3:
    mov dx, 0xaaaa                                                              ; 38c3: ba aa aa
loc_38c6:
    call near loc_3a96                                                          ; 38c6: e8 cd 01
loc_38c9:
    load16 sub, ax, ax                                                          ; 38c9: 2b c0
loc_38cb:
    mov byte [0x369f], 0                                                        ; 38cb: c6 06 9f 36 00
loc_38d0:
    call near loc_3aac                                                          ; 38d0: e8 d9 01
loc_38d3:
    load8 sub, ah, ah                                                           ; 38d3: 2a e4
loc_38d5:
    int 0x1a                                                                    ; 38d5: cd 1a
loc_38d7:
    cmp word [previous_scene_index], strict byte 7                              ; 38d7: 83 3e 06 00 07
loc_38dc:
    jne loc_38ef                                                                ; 38dc: 75 11
loc_38de:
    sub dx, word [courtship_cycle_start_tick]                                   ; 38de: 2b 16 12 04
loc_38e2:
    mov ax, 0x2a30                                                              ; 38e2: b8 30 2a
loc_38e5:
    load16 sub, ax, dx                                                          ; 38e5: 2b c2
loc_38e7:
    jae loc_38eb                                                                ; 38e7: 73 02
loc_38e9:
    load16 sub, ax, ax                                                          ; 38e9: 2b c0
loc_38eb:
    shr ax, 1                                                                   ; 38eb: d1 e8
loc_38ed:
    jmp short loc_390e                                                          ; 38ed: eb 1f
loc_38ef:
    sub dx, word [scene_entry_tick]                                             ; 38ef: 2b 16 10 04
loc_38f3:
    mov ax, 0x546                                                               ; 38f3: b8 46 05
loc_38f6:
    cmp word [previous_scene_index], strict byte 6                              ; 38f6: 83 3e 06 00 06
loc_38fb:
    jne loc_38ff                                                                ; 38fb: 75 02
loc_38fd:
    shl ax, 1                                                                   ; 38fd: d1 e0
loc_38ff:
    load16 sub, ax, dx                                                          ; 38ff: 2b c2
loc_3901:
    jae loc_3905                                                                ; 3901: 73 02
loc_3903:
    load16 sub, ax, ax                                                          ; 3903: 2b c0
loc_3905:
    cmp word [previous_scene_index], strict byte 6                              ; 3905: 83 3e 06 00 06
loc_390a:
    je loc_390e                                                                 ; 390a: 74 02
loc_390c:
    shl ax, 1                                                                   ; 390c: d1 e0
loc_390e:
    mov word [0x3697], ax                                                       ; 390e: a3 97 36
loc_3911:
    call near convert_bonus_to_decimal                                          ; 3911: e8 e0 01
loc_3914:
    mov bx, word [previous_scene_index]                                         ; 3914: 8b 1e 06 00
loc_3918:
    shl bl, 1                                                                   ; 3918: d0 e3
loc_391a:
    mov si, word [bx + 0x36cc]                                                  ; 391a: 8b b7 cc 36
loc_391e:
    mov di, 0x368d                                                              ; 391e: bf 8d 36
loc_3921:
    call near add_seven_decimal_digits                                          ; 3921: e8 fa ed
loc_3924:
    cmp word [previous_scene_index], strict byte 7                              ; 3924: 83 3e 06 00 07
loc_3929:
    jne loc_396e                                                                ; 3929: 75 43
loc_392b:
    mov bx, word [difficulty_level]                                             ; 392b: 8b 1e 08 00
loc_392f:
    shl bl, 1                                                                   ; 392f: d0 e3
loc_3931:
    load16 mov, ax, bx                                                          ; 3931: 8b c3
loc_3933:
    mov cx, word [bx + 0x36dc]                                                  ; 3933: 8b 8f dc 36
loc_3937:
    cmp word [0x2e8d], strict byte 8                                            ; 3937: 83 3e 8d 2e 08
loc_393c:
    jae loc_3943                                                                ; 393c: 73 05
loc_393e:
    shl cx, 1                                                                   ; 393e: d1 e1
loc_3940:
    add ax, strict word 0x10                                                    ; 3940: 05 10 00
loc_3943:
    mov word [0x370c], ax                                                       ; 3943: a3 0c 37
loc_3946:
    mov si, 0x368d                                                              ; 3946: be 8d 36
loc_3949:
    mov di, 0x1f82                                                              ; 3949: bf 82 1f
loc_394c:
    push cx                                                                     ; 394c: 51
loc_394d:
    call near add_seven_decimal_digits                                          ; 394d: e8 ce ed
loc_3950:
    pop cx                                                                      ; 3950: 59
loc_3951:
    loop loc_3946                                                               ; 3951: e2 f3
loc_3953:
    call near loc_39fa                                                          ; 3953: e8 a4 00
loc_3956:
    mov byte [0x369e], 0x38                                                     ; 3956: c6 06 9e 36 38
loc_395b:
    mov byte [0x3699], 1                                                        ; 395b: c6 06 99 36 01
loc_3960:
    mov word [0x3722], 0x44                                                     ; 3960: c7 06 22 37 44 00
loc_3966:
    call near loc_3a3a                                                          ; 3966: e8 d1 00
loc_3969:
    call near loc_3a6c                                                          ; 3969: e8 00 01
loc_396c:
    jmp short loc_39a7                                                          ; 396c: eb 39
loc_396e:
    mov si, 0x368d                                                              ; 396e: be 8d 36
loc_3971:
    mov di, 0x1f82                                                              ; 3971: bf 82 1f
loc_3974:
    call near add_seven_decimal_digits                                          ; 3974: e8 a7 ed
loc_3977:
    mov byte [0x3699], 2                                                        ; 3977: c6 06 99 36 02
loc_397c:
    mov word [0x3722], 0x1e                                                     ; 397c: c7 06 22 37 1e 00
loc_3982:
    mov dx, 0xffff                                                              ; 3982: ba ff ff
loc_3985:
    call near loc_3a96                                                          ; 3985: e8 0e 01
loc_3988:
    mov ax, 0xa8c                                                               ; 3988: b8 8c 0a
loc_398b:
    sub ax, word [0x3697]                                                       ; 398b: 2b 06 97 36
loc_398f:
    mov cl, 4                                                                   ; 398f: b1 04
loc_3991:
    shr ax, cl                                                                  ; 3991: d3 e8
loc_3993:
    and al, 0xf0                                                                ; 3993: 24 f0
loc_3995:
    mov byte [0x369e], al                                                       ; 3995: a2 9e 36
loc_3998:
    mov ah, 0x28                                                                ; 3998: b4 28
loc_399a:
    mul ah                                                                      ; 399a: f6 e4
loc_399c:
    mov byte [0x369f], 1                                                        ; 399c: c6 06 9f 36 01
loc_39a1:
    call near loc_3aac                                                          ; 39a1: e8 08 01
loc_39a4:
    call near loc_3a3a                                                          ; 39a4: e8 93 00
loc_39a7:
    load8 sub, ah, ah                                                           ; 39a7: 2a e4
loc_39a9:
    int 0x1a                                                                    ; 39a9: cd 1a
loc_39ab:
    mov word [0x3695], dx                                                       ; 39ab: 89 16 95 36
loc_39af:
    cmp word [previous_scene_index], strict byte 7                              ; 39af: 83 3e 06 00 07
loc_39b4:
    jne loc_39bb                                                                ; 39b4: 75 05
loc_39b6:
    call near update_courtship_melody                                           ; 39b6: e8 aa 21
loc_39b9:
    jmp short loc_39be                                                          ; 39b9: eb 03
loc_39bb:
    call near update_alternating_tone_sequence                                  ; 39bb: e8 77 1e
loc_39be:
    call near loc_3a1c                                                          ; 39be: e8 5b 00
loc_39c1:
    sub dx, word [0x3695]                                                       ; 39c1: 2b 16 95 36
loc_39c5:
    cmp dx, word [0x3722]                                                       ; 39c5: 3b 16 22 37
loc_39c9:
    jb loc_39af                                                                 ; 39c9: 72 e4
loc_39cb:
    load16 sub, bx, bx                                                          ; 39cb: 2b db
loc_39cd:
    mov ah, 0xb                                                                 ; 39cd: b4 0b
loc_39cf:
    int 0x10                                                                    ; 39cf: cd 10
loc_39d1:
    cmp word [previous_scene_index], strict byte 7                              ; 39d1: 83 3e 06 00 07
loc_39d6:
    je loc_39dc                                                                 ; 39d6: 74 04
loc_39d8:
    call near disable_speaker                                                   ; 39d8: e8 46 21
loc_39db:
    ret                                                                         ; 39db: c3
loc_39dc:
    mov ax, 0xb800                                                              ; 39dc: b8 00 b8
loc_39df:
    mov es, ax                                                                  ; 39df: 8e c0
loc_39e1:
    mov si, 0xe                                                                 ; 39e1: be 0e 00
loc_39e4:
    mov di, 0x8e4                                                               ; 39e4: bf e4 08
loc_39e7:
    mov cx, 0x804                                                               ; 39e7: b9 04 08
loc_39ea:
    call near copy_rectangle_to_cga                                             ; 39ea: e8 b0 f3
loc_39ed:
    mov si, 0x4e                                                                ; 39ed: be 4e 00
loc_39f0:
    mov di, 0xc94                                                               ; 39f0: bf 94 0c
loc_39f3:
    mov cx, 0x814                                                               ; 39f3: b9 14 08
loc_39f6:
    call near copy_rectangle_to_cga                                             ; 39f6: e8 a4 f3
loc_39f9:
    ret                                                                         ; 39f9: c3
loc_39fa:
    push ds                                                                     ; 39fa: 1e
loc_39fb:
    pop es                                                                      ; 39fb: 07
loc_39fc:
    mov ax, 0xb800                                                              ; 39fc: b8 00 b8
loc_39ff:
    mov ds, ax                                                                  ; 39ff: 8e d8
loc_3a01:
    mov cx, 0x804                                                               ; 3a01: b9 04 08
loc_3a04:
    mov di, 0xe                                                                 ; 3a04: bf 0e 00
loc_3a07:
    mov si, 0x8e4                                                               ; 3a07: be e4 08
loc_3a0a:
    call near copy_rectangle_from_cga                                           ; 3a0a: e8 bd f3
loc_3a0d:
    mov cx, 0x814                                                               ; 3a0d: b9 14 08
loc_3a10:
    mov di, 0x4e                                                                ; 3a10: bf 4e 00
loc_3a13:
    mov si, 0xc94                                                               ; 3a13: be 94 0c
loc_3a16:
    call near copy_rectangle_from_cga                                           ; 3a16: e8 b1 f3
loc_3a19:
    push es                                                                     ; 3a19: 06
loc_3a1a:
    pop ds                                                                      ; 3a1a: 1f
loc_3a1b:
    ret                                                                         ; 3a1b: c3
loc_3a1c:
    load8 sub, ah, ah                                                           ; 3a1c: 2a e4
loc_3a1e:
    int 0x1a                                                                    ; 3a1e: cd 1a
loc_3a20:
    push dx                                                                     ; 3a20: 52
loc_3a21:
    call near read_cga_vertical_retrace_bit                                     ; 3a21: e8 b4 d9
loc_3a24:
    je loc_3a21                                                                 ; 3a24: 74 fb
loc_3a26:
    pop dx                                                                      ; 3a26: 5a
loc_3a27:
    push dx                                                                     ; 3a27: 52
loc_3a28:
    load16 sub, bx, bx                                                          ; 3a28: 2b db
loc_3a2a:
    test dx, 4                                                                  ; 3a2a: f7 c2 04 00
loc_3a2e:
    jne loc_3a34                                                                ; 3a2e: 75 04
loc_3a30:
    mov bl, byte [0x3699]                                                       ; 3a30: 8a 1e 99 36
loc_3a34:
    mov ah, 0xb                                                                 ; 3a34: b4 0b
loc_3a36:
    int 0x10                                                                    ; 3a36: cd 10
loc_3a38:
    pop dx                                                                      ; 3a38: 5a
loc_3a39:
    ret                                                                         ; 3a39: c3
loc_3a3a:
    mov ah, 2                                                                   ; 3a3a: b4 02
loc_3a3c:
    mov dh, byte [0x369e]                                                       ; 3a3c: 8a 36 9e 36
loc_3a40:
    mov cl, 3                                                                   ; 3a40: b1 03
loc_3a42:
    shr dh, cl                                                                  ; 3a42: d2 ee
loc_3a44:
    mov dl, 0x12                                                                ; 3a44: b2 12
loc_3a46:
    load8 sub, bh, bh                                                           ; 3a46: 2a ff
loc_3a48:
    int 0x10                                                                    ; 3a48: cd 10
loc_3a4a:
    mov word [0x36a0], 3                                                        ; 3a4a: c7 06 a0 36 03 00
loc_3a50:
    mov bx, word [0x36a0]                                                       ; 3a50: 8b 1e a0 36
loc_3a54:
    mov al, byte [bx + 0x368d]                                                  ; 3a54: 8a 87 8d 36
loc_3a58:
    add al, 0x30                                                                ; 3a58: 04 30
loc_3a5a:
    mov ah, 0xe                                                                 ; 3a5a: b4 0e
loc_3a5c:
    mov bl, 3                                                                   ; 3a5c: b3 03
loc_3a5e:
    int 0x10                                                                    ; 3a5e: cd 10
loc_3a60:
    inc word [0x36a0]                                                           ; 3a60: ff 06 a0 36
loc_3a64:
    cmp word [0x36a0], strict byte 7                                            ; 3a64: 83 3e a0 36 07
loc_3a69:
    jb loc_3a50                                                                 ; 3a69: 72 e5
loc_3a6b:
    ret                                                                         ; 3a6b: c3
loc_3a6c:
    mov ah, 2                                                                   ; 3a6c: b4 02
loc_3a6e:
    mov dl, 0xa                                                                 ; 3a6e: b2 0a
loc_3a70:
    load8 mov, dh, dl                                                           ; 3a70: 8a f2
loc_3a72:
    load16 sub, bx, bx                                                          ; 3a72: 2b db
loc_3a74:
    int 0x10                                                                    ; 3a74: cd 10
loc_3a76:
    mov bx, word [0x370c]                                                       ; 3a76: 8b 1e 0c 37
loc_3a7a:
    mov ax, word [bx + 0x36ec]                                                  ; 3a7a: 8b 87 ec 36
loc_3a7e:
    mov word [0x3720], ax                                                       ; 3a7e: a3 20 37
loc_3a81:
    load16 sub, bx, bx                                                          ; 3a81: 2b db
loc_3a83:
    mov ah, 0xe                                                                 ; 3a83: b4 0e
loc_3a85:
    mov al, byte [bx + 0x370e]                                                  ; 3a85: 8a 87 0e 37
loc_3a89:
    push bx                                                                     ; 3a89: 53
loc_3a8a:
    mov bl, 3                                                                   ; 3a8a: b3 03
loc_3a8c:
    int 0x10                                                                    ; 3a8c: cd 10
loc_3a8e:
    pop bx                                                                      ; 3a8e: 5b
loc_3a8f:
    inc bx                                                                      ; 3a8f: 43
loc_3a90:
    cmp bx, strict byte 0x14                                                    ; 3a90: 83 fb 14
loc_3a93:
    jb loc_3a83                                                                 ; 3a93: 72 ee
loc_3a95:
    ret                                                                         ; 3a95: c3
loc_3a96:
    cld                                                                         ; 3a96: fc
loc_3a97:
    mov ax, DATA_PARAGRAPH                                                      ; 3a97: b8 10 00
loc_3a9a:
    mov es, ax                                                                  ; 3a9a: 8e c0
loc_3a9c:
    mov di, 0xe                                                                 ; 3a9c: bf 0e 00
loc_3a9f:
    mov si, 0x35e0                                                              ; 3a9f: be e0 35
loc_3aa2:
    mov cx, 0x1e                                                                ; 3aa2: b9 1e 00
loc_3aa5:
    lodsw                                                                       ; 3aa5: ad
loc_3aa6:
    load16 and, ax, dx                                                          ; 3aa6: 23 c2
loc_3aa8:
    stosw                                                                       ; 3aa8: ab
loc_3aa9:
    loop loc_3aa5                                                               ; 3aa9: e2 fa
loc_3aab:
    ret                                                                         ; 3aab: c3
loc_3aac:
    mov word [0x369a], ax                                                       ; 3aac: a3 9a 36
loc_3aaf:
    mov ax, 0xb800                                                              ; 3aaf: b8 00 b8
loc_3ab2:
    mov es, ax                                                                  ; 3ab2: 8e c0
loc_3ab4:
    call near initialize_alternating_tone_sequence                              ; 3ab4: e8 72 1d
loc_3ab7:
    mov ax, 0x1b80                                                              ; 3ab7: b8 80 1b
loc_3aba:
    mov bx, 0x361c                                                              ; 3aba: bb 1c 36
loc_3abd:
    mov word [0x369c], ax                                                       ; 3abd: a3 9c 36
loc_3ac0:
    call near loc_2b24                                                          ; 3ac0: e8 61 f0
loc_3ac3:
    cmp byte [0x369f], strict byte 0                                            ; 3ac3: 80 3e 9f 36 00
loc_3ac8:
    je loc_3ae2                                                                 ; 3ac8: 74 18
loc_3aca:
    call near advance_alternating_tone_sequence                                 ; 3aca: e8 9c 1d
loc_3acd:
    load8 sub, ah, ah                                                           ; 3acd: 2a e4
loc_3acf:
    int 0x1a                                                                    ; 3acf: cd 1a
loc_3ad1:
    mov word [0x3695], dx                                                       ; 3ad1: 89 16 95 36
loc_3ad5:
    load8 sub, ah, ah                                                           ; 3ad5: 2a e4
loc_3ad7:
    int 0x1a                                                                    ; 3ad7: cd 1a
loc_3ad9:
    sub dx, word [0x3695]                                                       ; 3ad9: 2b 16 95 36
loc_3add:
    cmp dx, strict byte 2                                                       ; 3add: 83 fa 02
loc_3ae0:
    jb loc_3ad5                                                                 ; 3ae0: 72 f3
loc_3ae2:
    mov ax, word [0x369c]                                                       ; 3ae2: a1 9c 36
loc_3ae5:
    sub ax, strict word 0x280                                                   ; 3ae5: 2d 80 02
loc_3ae8:
    jb loc_3af0                                                                 ; 3ae8: 72 06
loc_3aea:
    cmp ax, word [0x369a]                                                       ; 3aea: 3b 06 9a 36
loc_3aee:
    jae loc_3aba                                                                ; 3aee: 73 ca
loc_3af0:
    call near disable_speaker                                                   ; 3af0: e8 2e 20
loc_3af3:
    ret                                                                         ; 3af3: c3
; CS:3af4 — convert_bonus_to_decimal
; Converts only AX bits 0..12 into seven unpacked decimal digits at DS:368D; higher input bits are ignored.
convert_bonus_to_decimal:
    mov word [0x368b], ax                                                       ; 3af4: a3 8b 36
loc_3af7:
    load16 sub, ax, ax                                                          ; 3af7: 2b c0
loc_3af9:
    mov word [0x368d], ax                                                       ; 3af9: a3 8d 36
loc_3afc:
    mov word [0x368f], ax                                                       ; 3afc: a3 8f 36
loc_3aff:
    mov word [0x3691], ax                                                       ; 3aff: a3 91 36
loc_3b02:
    mov word [0x3693], ax                                                       ; 3b02: a3 93 36
loc_3b05:
    mov bx, 0x3684                                                              ; 3b05: bb 84 36
loc_3b08:
    mov dx, 0x1000                                                              ; 3b08: ba 00 10
loc_3b0b:
    test word [0x368b], dx                                                      ; 3b0b: 85 16 8b 36
loc_3b0f:
    je loc_3b19                                                                 ; 3b0f: 74 08
loc_3b11:
    load16 mov, si, bx                                                          ; 3b11: 8b f3
loc_3b13:
    mov di, 0x368d                                                              ; 3b13: bf 8d 36
loc_3b16:
    call near add_seven_decimal_digits                                          ; 3b16: e8 05 ec
loc_3b19:
    sub bx, strict byte 7                                                       ; 3b19: 83 eb 07
loc_3b1c:
    shr dx, 1                                                                   ; 3b1c: d1 ea
loc_3b1e:
    jae loc_3b0b                                                                ; 3b1e: 73 eb
loc_3b20:
    ret                                                                         ; 3b20: c3
    times 15 db 0 ; original zero fill at CS:3b21
