; Scene transitions, palette selection and failure results.
; Original CS:1BF0..1E40 (end exclusive).

; CS:1bf0 — run_scene_transition
; Wipes out, selects palette, dispatches success/failure result by previous scene and flags when returning to the alley, then wipes in the scene fill color.
run_scene_transition:
    load16 sub, bx, bx                                                          ; 1bf0: 2b db
loc_1bf2:
    mov ah, 0xb                                                                 ; 1bf2: b4 0b
loc_1bf4:
    int 0x10                                                                    ; 1bf4: cd 10
loc_1bf6:
    cmp word [previous_scene_index], strict byte 7                              ; 1bf6: 83 3e 06 00 07
loc_1bfb:
    jne loc_1c12                                                                ; 1bfb: 75 15
loc_1bfd:
    cmp byte [scene_complete], strict byte 0                                    ; 1bfd: 80 3e 53 05 00
loc_1c02:
    je loc_1c12                                                                 ; 1c02: 74 0e
loc_1c04:
    call near loc_528b                                                          ; 1c04: e8 84 36
loc_1c07:
    mov word [player_x], 0x98                                                   ; 1c07: c7 06 79 05 98 00
loc_1c0d:
    mov byte [player_y], 0x5f                                                   ; 1c0d: c6 06 7b 05 5f
loc_1c12:
    mov ax, 0xb800                                                              ; 1c12: b8 00 b8
loc_1c15:
    mov es, ax                                                                  ; 1c15: 8e c0
loc_1c17:
    cld                                                                         ; 1c17: fc
loc_1c18:
    mov word [0x1839], 0                                                        ; 1c18: c7 06 39 18 00 00
loc_1c1e:
    call near loc_1c67                                                          ; 1c1e: e8 46 00
loc_1c21:
    call near disable_speaker                                                   ; 1c21: e8 fd 3e
loc_1c24:
    call near configure_scene_palette                                           ; 1c24: e8 0a 01
loc_1c27:
    cmp word [scene_index], strict byte 0                                       ; 1c27: 83 3e 04 00 00
loc_1c2c:
    jne loc_1c49                                                                ; 1c2c: 75 1b
loc_1c2e:
    cmp byte [scene_complete], strict byte 0                                    ; 1c2e: 80 3e 53 05 00
loc_1c33:
    je loc_1c46                                                                 ; 1c33: 74 11
loc_1c35:
    cmp word [previous_scene_index], strict byte 7                              ; 1c35: 83 3e 06 00 07
loc_1c3a:
    jne loc_1c41                                                                ; 1c3a: 75 05
loc_1c3c:
    call near loc_5313                                                          ; 1c3c: e8 d4 36
loc_1c3f:
    jmp short loc_1c49                                                          ; 1c3f: eb 08
loc_1c41:
    call near award_scene_bonus                                                 ; 1c41: e8 6c 1c
loc_1c44:
    jmp short loc_1c49                                                          ; 1c44: eb 03
loc_1c46:
    call near show_scene_failure_or_exit                                        ; 1c46: e8 2d 01
loc_1c49:
    cmp word [scene_index], strict byte 7                                       ; 1c49: 83 3e 04 00 07
loc_1c4e:
    je loc_1c5a                                                                 ; 1c4e: 74 0a
loc_1c50:
    mov ax, 0xaaaa                                                              ; 1c50: b8 aa aa
loc_1c53:
    cmp word [scene_index], strict byte 2                                       ; 1c53: 83 3e 04 00 02
loc_1c58:
    jne loc_1c5d                                                                ; 1c58: 75 03
loc_1c5a:
    mov ax, 0x5555                                                              ; 1c5a: b8 55 55
loc_1c5d:
    mov word [0x1839], ax                                                       ; 1c5d: a3 39 18
loc_1c60:
    call near loc_1c67                                                          ; 1c60: e8 04 00
loc_1c63:
    call near disable_speaker                                                   ; 1c63: e8 bb 3e
loc_1c66:
    ret                                                                         ; 1c66: c3
loc_1c67:
    call near loc_5896                                                          ; 1c67: e8 2c 3c
loc_1c6a:
    mov word [0x1835], 1                                                        ; 1c6a: c7 06 35 18 01 00
loc_1c70:
    mov byte [0x1837], 8                                                        ; 1c70: c6 06 37 18 08
loc_1c75:
    mov cx, word [player_x]                                                     ; 1c75: 8b 0e 79 05
loc_1c79:
    mov dl, byte [player_y]                                                     ; 1c79: 8a 16 7b 05
loc_1c7d:
    add cx, strict byte 0xc                                                     ; 1c7d: 83 c1 0c
loc_1c80:
    and cx, strict word 0xfff0                                                  ; 1c80: 81 e1 f0 ff
loc_1c84:
    add dl, strict byte 8                                                       ; 1c84: 80 c2 08
loc_1c87:
    mov byte [0x1838], 0                                                        ; 1c87: c6 06 38 18 00
loc_1c8c:
    call near loc_5897                                                          ; 1c8c: e8 08 3c
loc_1c8f:
    mov word [0x1832], cx                                                       ; 1c8f: 89 0e 32 18
loc_1c93:
    mov byte [0x1834], dl                                                       ; 1c93: 88 16 34 18
loc_1c97:
    call near calculate_cga_address                                             ; 1c97: e8 16 10
loc_1c9a:
    load16 mov, di, ax                                                          ; 1c9a: 8b f8
loc_1c9c:
    mov bl, byte [0x1837]                                                       ; 1c9c: 8a 1e 37 18
loc_1ca0:
    mov ax, word [0x1839]                                                       ; 1ca0: a1 39 18
loc_1ca3:
    mov cx, word [0x1835]                                                       ; 1ca3: 8b 0e 35 18
loc_1ca7:
    shr cx, 1                                                                   ; 1ca7: d1 e9
loc_1ca9:
    shr cx, 1                                                                   ; 1ca9: d1 e9
loc_1cab:
    shr cx, 1                                                                   ; 1cab: d1 e9
loc_1cad:
    rep stosw                                                                   ; 1cad: f3 ab
loc_1caf:
    mov cx, word [0x1835]                                                       ; 1caf: 8b 0e 35 18
loc_1cb3:
    shr cx, 1                                                                   ; 1cb3: d1 e9
loc_1cb5:
    shr cx, 1                                                                   ; 1cb5: d1 e9
loc_1cb7:
    and cx, strict word 0xfe                                                    ; 1cb7: 81 e1 fe 00
loc_1cbb:
    load16 sub, di, cx                                                          ; 1cbb: 2b f9
loc_1cbd:
    xor di, strict word 0x2000                                                  ; 1cbd: 81 f7 00 20
loc_1cc1:
    test di, 0x2000                                                             ; 1cc1: f7 c7 00 20
loc_1cc5:
    jne loc_1cca                                                                ; 1cc5: 75 03
loc_1cc7:
    add di, strict byte 0x50                                                    ; 1cc7: 83 c7 50
loc_1cca:
    dec bl                                                                      ; 1cca: fe cb
loc_1ccc:
    jne loc_1ca0                                                                ; 1ccc: 75 d2
loc_1cce:
    cmp byte [0x1838], strict byte 0xf                                          ; 1cce: 80 3e 38 18 0f
loc_1cd3:
    jne loc_1cd6                                                                ; 1cd3: 75 01
loc_1cd5:
    ret                                                                         ; 1cd5: c3
loc_1cd6:
    add word [0x1835], strict byte 0x20                                         ; 1cd6: 83 06 35 18 20
loc_1cdb:
    add byte [0x1837], strict byte 0x10                                         ; 1cdb: 80 06 37 18 10
loc_1ce0:
    mov cx, word [0x1832]                                                       ; 1ce0: 8b 0e 32 18
loc_1ce4:
    mov dl, byte [0x1834]                                                       ; 1ce4: 8a 16 34 18
loc_1ce8:
    sub cx, strict byte 0x10                                                    ; 1ce8: 83 e9 10
loc_1ceb:
    jae loc_1cf4                                                                ; 1ceb: 73 07
loc_1ced:
    load16 sub, cx, cx                                                          ; 1ced: 2b c9
loc_1cef:
    or byte [0x1838], strict byte 1                                             ; 1cef: 80 0e 38 18 01
loc_1cf4:
    mov ax, word [0x1835]                                                       ; 1cf4: a1 35 18
loc_1cf7:
    load16 add, ax, cx                                                          ; 1cf7: 03 c1
loc_1cf9:
    cmp ax, strict word 0x140                                                   ; 1cf9: 3d 40 01
loc_1cfc:
    jb loc_1d0b                                                                 ; 1cfc: 72 0d
loc_1cfe:
    mov ax, 0x140                                                               ; 1cfe: b8 40 01
loc_1d01:
    load16 sub, ax, cx                                                          ; 1d01: 2b c1
loc_1d03:
    mov word [0x1835], ax                                                       ; 1d03: a3 35 18
loc_1d06:
    or byte [0x1838], strict byte 2                                             ; 1d06: 80 0e 38 18 02
loc_1d0b:
    sub dl, strict byte 8                                                       ; 1d0b: 80 ea 08
loc_1d0e:
    jae loc_1d17                                                                ; 1d0e: 73 07
loc_1d10:
    load8 sub, dl, dl                                                           ; 1d10: 2a d2
loc_1d12:
    or byte [0x1838], strict byte 4                                             ; 1d12: 80 0e 38 18 04
loc_1d17:
    mov al, byte [0x1837]                                                       ; 1d17: a0 37 18
loc_1d1a:
    load8 add, al, dl                                                           ; 1d1a: 02 c2
loc_1d1c:
    jb loc_1d22                                                                 ; 1d1c: 72 04
loc_1d1e:
    cmp al, 0xc8                                                                ; 1d1e: 3c c8
loc_1d20:
    jb loc_1d2e                                                                 ; 1d20: 72 0c
loc_1d22:
    mov al, 0xc8                                                                ; 1d22: b0 c8
loc_1d24:
    load8 sub, al, dl                                                           ; 1d24: 2a c2
loc_1d26:
    mov byte [0x1837], al                                                       ; 1d26: a2 37 18
loc_1d29:
    or byte [0x1838], strict byte 8                                             ; 1d29: 80 0e 38 18 08
loc_1d2e:
    jmp near loc_1c8c                                                           ; 1d2e: e9 5b ff

; CS:1d31 — configure_scene_palette
; Indexes palette tables with DS:0004; calls INT 10h AH=0Bh or the AX=1000h wrapper on the FD model branch.
configure_scene_palette:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 1d31: 80 3e 97 06 fd
loc_1d36:
    je loc_1d48                                                                 ; 1d36: 74 10
loc_1d38:
    mov ah, 0xb                                                                 ; 1d38: b4 0b
loc_1d3a:
    mov bh, 1                                                                   ; 1d3a: b7 01
loc_1d3c:
    mov si, word [scene_index]                                                  ; 1d3c: 8b 36 04 00
loc_1d40:
    mov bl, byte [si + 0x1853]                                                  ; 1d40: 8a 9c 53 18
loc_1d44:
    int 0x10                                                                    ; 1d44: cd 10
loc_1d46:
    jmp short loc_1d67                                                          ; 1d46: eb 1f
loc_1d48:
    mov si, word [scene_index]                                                  ; 1d48: 8b 36 04 00
loc_1d4c:
    mov bl, 1                                                                   ; 1d4c: b3 01
loc_1d4e:
    mov bh, byte [si + 0x183b]                                                  ; 1d4e: 8a bc 3b 18
loc_1d52:
    call near bios_set_palette_entry                                            ; 1d52: e8 19 00
loc_1d55:
    mov bl, 2                                                                   ; 1d55: b3 02
loc_1d57:
    mov bh, byte [si + 0x1843]                                                  ; 1d57: 8a bc 43 18
loc_1d5b:
    call near bios_set_palette_entry                                            ; 1d5b: e8 10 00
loc_1d5e:
    mov bl, 3                                                                   ; 1d5e: b3 03
loc_1d60:
    mov bh, byte [si + 0x184b]                                                  ; 1d60: 8a bc 4b 18
loc_1d64:
    call near bios_set_palette_entry                                            ; 1d64: e8 07 00
loc_1d67:
    mov ah, 0xb                                                                 ; 1d67: b4 0b
loc_1d69:
    load16 sub, bx, bx                                                          ; 1d69: 2b db
loc_1d6b:
    int 0x10                                                                    ; 1d6b: cd 10
loc_1d6d:
    ret                                                                         ; 1d6d: c3

; CS:1d6e — bios_set_palette_entry
; Sets AX=1000h, preserves SI around INT 10h, and returns. No EGA-only assumption.
bios_set_palette_entry:
    mov ax, 0x1000                                                              ; 1d6e: b8 00 10
loc_1d71:
    push si                                                                     ; 1d71: 56
loc_1d72:
    int 0x10                                                                    ; 1d72: cd 10
loc_1d74:
    pop si                                                                      ; 1d74: 5e
loc_1d75:
    ret                                                                         ; 1d75: c3
; CS:1d76 — show_scene_failure_or_exit
; For non-courtship scenes, decrements lives only when scene_failed is nonzero; zero lives do not underflow. Draws a timed result animation.
show_scene_failure_or_exit:
    cmp word [previous_scene_index], strict byte 7                              ; 1d76: 83 3e 06 00 07
loc_1d7b:
    jne loc_1d81                                                                ; 1d7b: 75 04
loc_1d7d:
    call near loc_6040                                                          ; 1d7d: e8 c0 42
loc_1d80:
    ret                                                                         ; 1d80: c3
loc_1d81:
    call near initialize_result_melody                                          ; 1d81: e8 51 3a
loc_1d84:
    mov ax, 0x185b                                                              ; 1d84: b8 5b 18
loc_1d87:
    cmp byte [scene_failed], strict byte 0                                      ; 1d87: 80 3e 52 05 00
loc_1d8c:
    je loc_1dc6                                                                 ; 1d8c: 74 38
loc_1d8e:
    mov bx, word [0x1c30]                                                       ; 1d8e: 8b 1e 30 1c
loc_1d92:
    add word [0x1c30], strict byte 2                                            ; 1d92: 83 06 30 1c 02
loc_1d97:
    and bx, strict word 6                                                       ; 1d97: 81 e3 06 00
loc_1d9b:
    mov ax, word [bx + 0x1c26]                                                  ; 1d9b: 8b 87 26 1c
loc_1d9f:
    cmp byte [lives_remaining], strict byte 0                                   ; 1d9f: 80 3e 80 1f 00
loc_1da4:
    je loc_1daa                                                                 ; 1da4: 74 04
loc_1da6:
    dec byte [lives_remaining]                                                  ; 1da6: fe 0e 80 1f
loc_1daa:
    cmp byte [scene_failed], strict byte 0xdd                                   ; 1daa: 80 3e 52 05 dd
loc_1daf:
    jne loc_1dc6                                                                ; 1daf: 75 15
loc_1db1:
    cmp word [difficulty_level], strict byte 0                                  ; 1db1: 83 3e 08 00 00
loc_1db6:
    je loc_1dc6                                                                 ; 1db6: 74 0e
loc_1db8:
    cmp byte [lives_remaining], strict byte 1                                   ; 1db8: 80 3e 80 1f 01
loc_1dbd:
    jb loc_1dc6                                                                 ; 1dbd: 72 07
loc_1dbf:
    call near loc_5be0                                                          ; 1dbf: e8 1e 3e
loc_1dc2:
    call near disable_speaker                                                   ; 1dc2: e8 5c 3d
loc_1dc5:
    ret                                                                         ; 1dc5: c3
loc_1dc6:
    mov word [0x1c2e], ax                                                       ; 1dc6: a3 2e 1c
loc_1dc9:
    mov word [0x1c1b], 0x8080                                                   ; 1dc9: c7 06 1b 1c 80 80
loc_1dcf:
    mov byte [0x1c1d], 0x1c                                                     ; 1dcf: c6 06 1d 1c 1c
loc_1dd4:
    call near loc_1e17                                                          ; 1dd4: e8 40 00
loc_1dd7:
    load8 sub, ah, ah                                                           ; 1dd7: 2a e4
loc_1dd9:
    int 0x1a                                                                    ; 1dd9: cd 1a
loc_1ddb:
    mov word [0x1830], dx                                                       ; 1ddb: 89 16 30 18
loc_1ddf:
    call near update_result_melody                                              ; 1ddf: e8 02 3a
loc_1de2:
    load8 sub, ah, ah                                                           ; 1de2: 2a e4
loc_1de4:
    int 0x1a                                                                    ; 1de4: cd 1a
loc_1de6:
    cmp dx, word [0x1830]                                                       ; 1de6: 3b 16 30 18
loc_1dea:
    je loc_1ddf                                                                 ; 1dea: 74 f3
loc_1dec:
    cmp byte [0x1c1d], strict byte 0x14                                         ; 1dec: 80 3e 1d 1c 14
loc_1df1:
    ja loc_1e02                                                                 ; 1df1: 77 0f
loc_1df3:
    load8 sub, bh, bh                                                           ; 1df3: 2a ff
loc_1df5:
    mov bl, byte [0x1c1d]                                                       ; 1df5: 8a 1e 1d 1c
loc_1df9:
    and bl, strict byte 6                                                       ; 1df9: 80 e3 06
loc_1dfc:
    mov ax, word [bx + 0x1c1e]                                                  ; 1dfc: 8b 87 1e 1c
loc_1e00:
    jmp short loc_1e0a                                                          ; 1e00: eb 08
loc_1e02:
    mov ax, word [0x1c1b]                                                       ; 1e02: a1 1b 1c
loc_1e05:
    stc                                                                         ; 1e05: f9
loc_1e06:
    rcr al, 1                                                                   ; 1e06: d0 d8
loc_1e08:
    load8 mov, ah, al                                                           ; 1e08: 8a e0
loc_1e0a:
    mov word [0x1c1b], ax                                                       ; 1e0a: a3 1b 1c
loc_1e0d:
    dec byte [0x1c1d]                                                           ; 1e0d: fe 0e 1d 1c
loc_1e11:
    jne loc_1dd4                                                                ; 1e11: 75 c1
loc_1e13:
    call near disable_speaker                                                   ; 1e13: e8 0b 3d
loc_1e16:
    ret                                                                         ; 1e16: c3
loc_1e17:
    cld                                                                         ; 1e17: fc
loc_1e18:
    push ds                                                                     ; 1e18: 1e
loc_1e19:
    pop es                                                                      ; 1e19: 07
loc_1e1a:
    mov si, word [0x1c2e]                                                       ; 1e1a: 8b 36 2e 1c
loc_1e1e:
    mov di, 0xe                                                                 ; 1e1e: bf 0e 00
loc_1e21:
    mov cx, 0x60                                                                ; 1e21: b9 60 00
loc_1e24:
    lodsw                                                                       ; 1e24: ad
loc_1e25:
    and ax, word [0x1c1b]                                                       ; 1e25: 23 06 1b 1c
loc_1e29:
    stosw                                                                       ; 1e29: ab
loc_1e2a:
    loop loc_1e24                                                               ; 1e2a: e2 f8
loc_1e2c:
    mov ax, 0xb800                                                              ; 1e2c: b8 00 b8
loc_1e2f:
    mov es, ax                                                                  ; 1e2f: 8e c0
loc_1e31:
    mov si, 0xe                                                                 ; 1e31: be 0e 00
loc_1e34:
    mov di, 0xed0                                                               ; 1e34: bf d0 0e
loc_1e37:
    mov cx, 0xc08                                                               ; 1e37: b9 08 0c
loc_1e3a:
    call near copy_rectangle_to_cga                                             ; 1e3a: e8 60 0f
loc_1e3d:
    ret                                                                         ; 1e3d: c3
    times 2 db 0 ; original zero fill at CS:1e3e
