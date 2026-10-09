; Bookshelf targets and scene-specific enemy.
; Original CS:3B30..3E90 (end exclusive).

; CS:3b30 — initialize_bookshelf_targets
; Sets three active target words and remaining count=3 at DS:37AF.
initialize_bookshelf_targets:
    mov byte [bookshelf_targets_remaining], 3                                   ; 3b30: c6 06 af 37 03
loc_3b35:
    mov ax, 1                                                                   ; 3b35: b8 01 00
loc_3b38:
    mov word [bookshelf_target_active], ax                                      ; 3b38: a3 b0 37
loc_3b3b:
    mov word [0x37b2], ax                                                       ; 3b3b: a3 b2 37
loc_3b3e:
    mov word [0x37b4], ax                                                       ; 3b3e: a3 b4 37
loc_3b41:
    ret                                                                         ; 3b41: c3
; CS:3b42 — check_bookshelf_target_contacts
; Once per BIOS tick scans three target rectangles at Y=24; contact erases the target and redraws player/enemy backgrounds.
check_bookshelf_target_contacts:
    load8 sub, ah, ah                                                           ; 3b42: 2a e4
loc_3b44:
    int 0x1a                                                                    ; 3b44: cd 1a
loc_3b46:
    cmp dx, word [bookshelf_targets_last_tick]                                  ; 3b46: 3b 16 b8 37
loc_3b4a:
    jne loc_3b4d                                                                ; 3b4a: 75 01
loc_3b4c:
    ret                                                                         ; 3b4c: c3
loc_3b4d:
    mov word [bookshelf_targets_last_tick], dx                                  ; 3b4d: 89 16 b8 37
loc_3b51:
    mov word [bookshelf_target_byte_offset], 4                                  ; 3b51: c7 06 b6 37 04 00
loc_3b57:
    mov bx, word [bookshelf_target_byte_offset]                                 ; 3b57: 8b 1e b6 37
loc_3b5b:
    cmp word [bx + bookshelf_target_active], strict byte 0                      ; 3b5b: 83 bf b0 37 00
loc_3b60:
    je loc_3b9b                                                                 ; 3b60: 74 39
loc_3b62:
    mov ax, word [bx + bookshelf_target_x]                                      ; 3b62: 8b 87 a3 37
loc_3b66:
    mov dl, 0x18                                                                ; 3b66: b2 18
loc_3b68:
    mov si, 0x10                                                                ; 3b68: be 10 00
loc_3b6b:
    mov bx, word [player_x]                                                     ; 3b6b: 8b 1e 79 05
loc_3b6f:
    mov dh, byte [player_y]                                                     ; 3b6f: 8a 36 7b 05
loc_3b73:
    mov di, 0x18                                                                ; 3b73: bf 18 00
loc_3b76:
    mov cx, 0xe10                                                               ; 3b76: b9 10 0e
loc_3b79:
    call near rectangles_overlap                                                ; 3b79: e8 ad f2
loc_3b7c:
    jae loc_3b9b                                                                ; 3b7c: 73 1d
loc_3b7e:
    mov ax, 0xc00                                                               ; 3b7e: b8 00 0c
loc_3b81:
    mov bx, 0x8fd                                                               ; 3b81: bb fd 08
loc_3b84:
    call near start_two_stage_sound                                             ; 3b84: e8 b4 1d
loc_3b87:
    call near restore_player_background                                         ; 3b87: e8 59 d6
loc_3b8a:
    call near loc_3e38                                                          ; 3b8a: e8 ab 02
loc_3b8d:
    mov bx, word [bookshelf_target_byte_offset]                                 ; 3b8d: 8b 1e b6 37
loc_3b91:
    call near remove_bookshelf_target                                           ; 3b91: e8 0f 00
loc_3b94:
    call near save_player_background                                            ; 3b94: e8 8d d5
loc_3b97:
    call near loc_3e14                                                          ; 3b97: e8 7a 02
loc_3b9a:
    ret                                                                         ; 3b9a: c3
loc_3b9b:
    sub word [bookshelf_target_byte_offset], strict byte 2                      ; 3b9b: 83 2e b6 37 02
loc_3ba0:
    jae loc_3b57                                                                ; 3ba0: 73 b5
loc_3ba2:
    ret                                                                         ; 3ba2: c3
; CS:3ba3 — remove_bookshelf_target
; Clears target BX, erases its image, and decrements the remaining count; the last sets scene_complete only if scene_failed is zero. Caller must ensure target was active.
remove_bookshelf_target:
    mov word [bx + bookshelf_target_active], 0                                  ; 3ba3: c7 87 b0 37 00 00
loc_3ba9:
    push ds                                                                     ; 3ba9: 1e
loc_3baa:
    pop es                                                                      ; 3baa: 07
loc_3bab:
    cld                                                                         ; 3bab: fc
loc_3bac:
    mov ax, 0xaaaa                                                              ; 3bac: b8 aa aa
loc_3baf:
    mov di, 0xe                                                                 ; 3baf: bf 0e 00
loc_3bb2:
    load16 mov, si, di                                                          ; 3bb2: 8b f7
loc_3bb4:
    mov cx, 0x20                                                                ; 3bb4: b9 20 00
loc_3bb7:
    rep stosw                                                                   ; 3bb7: f3 ab
loc_3bb9:
    mov di, word [bx + bookshelf_target_video_offsets]                          ; 3bb9: 8b bf a9 37
loc_3bbd:
    mov ax, 0xb800                                                              ; 3bbd: b8 00 b8
loc_3bc0:
    mov es, ax                                                                  ; 3bc0: 8e c0
loc_3bc2:
    mov cx, 0x1002                                                              ; 3bc2: b9 02 10
loc_3bc5:
    call near copy_rectangle_to_cga                                             ; 3bc5: e8 d5 f1
loc_3bc8:
    dec byte [bookshelf_targets_remaining]                                      ; 3bc8: fe 0e af 37
loc_3bcc:
    jne loc_3bda                                                                ; 3bcc: 75 0c
loc_3bce:
    cmp byte [scene_failed], strict byte 0                                      ; 3bce: 80 3e 52 05 00
loc_3bd3:
    jne loc_3bda                                                                ; 3bd3: 75 05
loc_3bd5:
    mov byte [scene_complete], 1                                                ; 3bd5: c6 06 53 05 01
loc_3bda:
    ret                                                                         ; 3bda: c3
loc_3bdb:
    mov ax, 0xb800                                                              ; 3bdb: b8 00 b8
loc_3bde:
    mov es, ax                                                                  ; 3bde: 8e c0
loc_3be0:
    mov word [0x37a0], 0x66a                                                    ; 3be0: c7 06 a0 37 6a 06
loc_3be6:
    mov cx, 0x10                                                                ; 3be6: b9 10 00
loc_3be9:
    load16 sub, ax, ax                                                          ; 3be9: 2b c0
loc_3beb:
    load16 mov, bx, ax                                                          ; 3beb: 8b d8
loc_3bed:
    mov byte [0x37a2], al                                                       ; 3bed: a2 a2 37
loc_3bf0:
    load8 sub, ah, ah                                                           ; 3bf0: 2a e4
loc_3bf2:
    add ax, strict word 0x3730                                                  ; 3bf2: 05 30 37
loc_3bf5:
    load16 mov, si, ax                                                          ; 3bf5: 8b f0
loc_3bf7:
    mov di, word [0x37a0]                                                       ; 3bf7: 8b 3e a0 37
loc_3bfb:
    load16 add, di, bx                                                          ; 3bfb: 03 fb
loc_3bfd:
    push cx                                                                     ; 3bfd: 51
loc_3bfe:
    mov cx, 0x801                                                               ; 3bfe: b9 01 08
loc_3c01:
    push bx                                                                     ; 3c01: 53
loc_3c02:
    call near copy_rectangle_to_cga                                             ; 3c02: e8 98 f1
loc_3c05:
    pop bx                                                                      ; 3c05: 5b
loc_3c06:
    pop cx                                                                      ; 3c06: 59
loc_3c07:
    add bx, strict byte 2                                                       ; 3c07: 83 c3 02
loc_3c0a:
    cmp bx, strict byte 0x1e                                                    ; 3c0a: 83 fb 1e
loc_3c0d:
    jb loc_3c1e                                                                 ; 3c0d: 72 0f
loc_3c0f:
    jne loc_3c15                                                                ; 3c0f: 75 04
loc_3c11:
    mov al, 0x20                                                                ; 3c11: b0 20
loc_3c13:
    jmp short loc_3bed                                                          ; 3c13: eb d8
loc_3c15:
    add word [0x37a0], strict word 0x140                                        ; 3c15: 81 06 a0 37 40 01
loc_3c1b:
    loop loc_3be9                                                               ; 3c1b: e2 cc
loc_3c1d:
    ret                                                                         ; 3c1d: c3
loc_3c1e:
    cmp byte [0x37a2], strict byte 0x50                                         ; 3c1e: 80 3e a2 37 50
loc_3c23:
    je loc_3c36                                                                 ; 3c23: 74 11
loc_3c25:
    test cl, 1                                                                  ; 3c25: f6 c1 01
loc_3c28:
    jne loc_3c36                                                                ; 3c28: 75 0c
loc_3c2a:
    call near update_random_state                                               ; 3c2a: e8 d0 f1
loc_3c2d:
    cmp dl, strict byte 0x40                                                    ; 3c2d: 80 fa 40
loc_3c30:
    jb loc_3c36                                                                 ; 3c30: 72 04
loc_3c32:
    mov al, 0x10                                                                ; 3c32: b0 10
loc_3c34:
    jmp short loc_3bed                                                          ; 3c34: eb b7
loc_3c36:
    call near update_random_state                                               ; 3c36: e8 c4 f1
loc_3c39:
    load8 mov, al, dl                                                           ; 3c39: 8a c2
loc_3c3b:
    load8 sub, al, bl                                                           ; 3c3b: 2a c3
loc_3c3d:
    and al, 0x30                                                                ; 3c3d: 24 30
loc_3c3f:
    add al, 0x30                                                                ; 3c3f: 04 30
loc_3c41:
    jmp short loc_3bed                                                          ; 3c41: eb aa
loc_3c43:
    mov ax, word [player_x]                                                     ; 3c43: a1 79 05
loc_3c46:
    and ax, strict word 0xfffc                                                  ; 3c46: 25 fc ff
loc_3c49:
    cmp ax, strict word 0xa4                                                    ; 3c49: 3d a4 00
loc_3c4c:
    jb loc_3c7f                                                                 ; 3c4c: 72 31
loc_3c4e:
    cmp ax, strict word 0x118                                                   ; 3c4e: 3d 18 01
loc_3c51:
    ja loc_3c7f                                                                 ; 3c51: 77 2c
loc_3c53:
    mov dl, byte [player_y]                                                     ; 3c53: 8a 16 7b 05
loc_3c57:
    sub dl, strict byte 2                                                       ; 3c57: 80 ea 02
loc_3c5a:
    and dl, strict byte 0xf8                                                    ; 3c5a: 80 e2 f8
loc_3c5d:
    test dl, 8                                                                  ; 3c5d: f6 c2 08
loc_3c60:
    je loc_3c7f                                                                 ; 3c60: 74 1d
loc_3c62:
    cmp dl, strict byte 0x28                                                    ; 3c62: 80 fa 28
loc_3c65:
    jb loc_3c7f                                                                 ; 3c65: 72 18
loc_3c67:
    cmp dl, strict byte 0xa0                                                    ; 3c67: 80 fa a0
loc_3c6a:
    ja loc_3c7f                                                                 ; 3c6a: 77 13
loc_3c6c:
    mov word [player_x], ax                                                     ; 3c6c: a3 79 05
loc_3c6f:
    add dl, strict byte 2                                                       ; 3c6f: 80 c2 02
loc_3c72:
    mov byte [player_y], dl                                                     ; 3c72: 88 16 7b 05
loc_3c76:
    add dl, strict byte 0x32                                                    ; 3c76: 80 c2 32
loc_3c79:
    mov byte [player_y_plus_50], dl                                             ; 3c79: 88 16 7c 05
loc_3c7d:
    stc                                                                         ; 3c7d: f9
loc_3c7e:
    ret                                                                         ; 3c7e: c3
loc_3c7f:
    clc                                                                         ; 3c7f: f8
loc_3c80:
    ret                                                                         ; 3c80: c3
    times 15 db 0 ; original zero fill at CS:3c81
loc_3c90:
    mov byte [0x3966], 8                                                        ; 3c90: c6 06 66 39 08
loc_3c95:
    mov byte [0x396a], 1                                                        ; 3c95: c6 06 6a 39 01
loc_3c9a:
    mov byte [0x3967], 0                                                        ; 3c9a: c6 06 67 39 00
loc_3c9f:
    mov byte [0x396d], 2                                                        ; 3c9f: c6 06 6d 39 02
loc_3ca4:
    mov word [0x3964], 0x118                                                    ; 3ca4: c7 06 64 39 18 01
loc_3caa:
    mov word [0x396b], 0                                                        ; 3caa: c7 06 6b 39 00 00
loc_3cb0:
    ret                                                                         ; 3cb0: c3
loc_3cb1:
    load8 sub, ah, ah                                                           ; 3cb1: 2a e4
loc_3cb3:
    int 0x1a                                                                    ; 3cb3: cd 1a
loc_3cb5:
    load16 mov, ax, dx                                                          ; 3cb5: 8b c2
loc_3cb7:
    sub ax, word [0x39c8]                                                       ; 3cb7: 2b 06 c8 39
loc_3cbb:
    cmp ax, strict word 2                                                       ; 3cbb: 3d 02 00
loc_3cbe:
    jae loc_3cc1                                                                ; 3cbe: 73 01
loc_3cc0:
    ret                                                                         ; 3cc0: c3
loc_3cc1:
    mov word [0x39c8], dx                                                       ; 3cc1: 89 16 c8 39
loc_3cc5:
    call near loc_3e52                                                          ; 3cc5: e8 8a 01
loc_3cc8:
    jb loc_3cc0                                                                 ; 3cc8: 72 f6
loc_3cca:
    call near loc_3e6e                                                          ; 3cca: e8 a1 01
loc_3ccd:
    jae loc_3cd2                                                                ; 3ccd: 73 03
loc_3ccf:
    jmp near loc_3d90                                                           ; 3ccf: e9 be 00
loc_3cd2:
    mov bx, word [difficulty_level]                                             ; 3cd2: 8b 1e 08 00
loc_3cd6:
    shl bl, 1                                                                   ; 3cd6: d0 e3
loc_3cd8:
    mov ax, word [bx + 0x39cc]                                                  ; 3cd8: 8b 87 cc 39
loc_3cdc:
    mov word [0x39c6], ax                                                       ; 3cdc: a3 c6 39
loc_3cdf:
    mov ax, word [0x3964]                                                       ; 3cdf: a1 64 39
loc_3ce2:
    mov word [0x39c3], ax                                                       ; 3ce2: a3 c3 39
loc_3ce5:
    mov dl, byte [0x3966]                                                       ; 3ce5: 8a 16 66 39
loc_3ce9:
    mov byte [0x39c5], dl                                                       ; 3ce9: 88 16 c5 39
loc_3ced:
    cmp dl, strict byte 8                                                       ; 3ced: 80 fa 08
loc_3cf0:
    jne loc_3d25                                                                ; 3cf0: 75 33
loc_3cf2:
    and ax, strict word 0xfff8                                                  ; 3cf2: 25 f8 ff
loc_3cf5:
    mov dx, word [player_x]                                                     ; 3cf5: 8b 16 79 05
loc_3cf9:
    and dx, strict word 0xfff8                                                  ; 3cf9: 81 e2 f8 ff
loc_3cfd:
    load16 cmp, ax, dx                                                          ; 3cfd: 3b c2
loc_3cff:
    jne loc_3d0d                                                                ; 3cff: 75 0c
loc_3d01:
    mov byte [0x3967], 1                                                        ; 3d01: c6 06 67 39 01
loc_3d06:
    mov byte [0x396e], 1                                                        ; 3d06: c6 06 6e 39 01
loc_3d0b:
    jmp short loc_3d25                                                          ; 3d0b: eb 18
loc_3d0d:
    mov ax, word [0x3964]                                                       ; 3d0d: a1 64 39
loc_3d10:
    jb loc_3d1c                                                                 ; 3d10: 72 0a
loc_3d12:
    sub ax, word [0x39c6]                                                       ; 3d12: 2b 06 c6 39
loc_3d16:
    jae loc_3d20                                                                ; 3d16: 73 08
loc_3d18:
    load16 sub, ax, ax                                                          ; 3d18: 2b c0
loc_3d1a:
    jmp short loc_3d20                                                          ; 3d1a: eb 04
loc_3d1c:
    add ax, word [0x39c6]                                                       ; 3d1c: 03 06 c6 39
loc_3d20:
    mov word [0x3964], ax                                                       ; 3d20: a3 64 39
loc_3d23:
    jmp short loc_3d79                                                          ; 3d23: eb 54
loc_3d25:
    mov al, byte [0x3966]                                                       ; 3d25: a0 66 39
loc_3d28:
    inc byte [0x396e]                                                           ; 3d28: fe 06 6e 39
loc_3d2c:
    mov dl, byte [0x396e]                                                       ; 3d2c: 8a 16 6e 39
loc_3d30:
    shr dl, 1                                                                   ; 3d30: d0 ea
loc_3d32:
    shr dl, 1                                                                   ; 3d32: d0 ea
loc_3d34:
    and dl, strict byte 3                                                       ; 3d34: 80 e2 03
loc_3d37:
    add dl, strict byte 2                                                       ; 3d37: 80 c2 02
loc_3d3a:
    cmp byte [0x3967], strict byte 1                                            ; 3d3a: 80 3e 67 39 01
loc_3d3f:
    je loc_3d52                                                                 ; 3d3f: 74 11
loc_3d41:
    load8 sub, al, dl                                                           ; 3d41: 2a c2
loc_3d43:
    jb loc_3d49                                                                 ; 3d43: 72 04
loc_3d45:
    cmp al, 9                                                                   ; 3d45: 3c 09
loc_3d47:
    jae loc_3d76                                                                ; 3d47: 73 2d
loc_3d49:
    mov al, 8                                                                   ; 3d49: b0 08
loc_3d4b:
    mov byte [0x3967], 0                                                        ; 3d4b: c6 06 67 39 00
loc_3d50:
    jmp short loc_3d76                                                          ; 3d50: eb 24
loc_3d52:
    load8 add, al, dl                                                           ; 3d52: 02 c2
loc_3d54:
    cmp al, byte [player_y]                                                     ; 3d54: 3a 06 7b 05
loc_3d58:
    ja loc_3d71                                                                 ; 3d58: 77 17
loc_3d5a:
    mov bx, word [0x3964]                                                       ; 3d5a: 8b 1e 64 39
loc_3d5e:
    sub bx, word [player_x]                                                     ; 3d5e: 2b 1e 79 05
loc_3d62:
    jae loc_3d66                                                                ; 3d62: 73 02
loc_3d64:
    not bx                                                                      ; 3d64: f7 d3
loc_3d66:
    cmp bx, strict byte 0x30                                                    ; 3d66: 83 fb 30
loc_3d69:
    ja loc_3d71                                                                 ; 3d69: 77 06
loc_3d6b:
    cmp al, 0xa0                                                                ; 3d6b: 3c a0
loc_3d6d:
    jb loc_3d76                                                                 ; 3d6d: 72 07
loc_3d6f:
    mov al, 0x9f                                                                ; 3d6f: b0 9f
loc_3d71:
    mov byte [0x3967], 0xff                                                     ; 3d71: c6 06 67 39 ff
loc_3d76:
    mov byte [0x3966], al                                                       ; 3d76: a2 66 39
loc_3d79:
    call near loc_3e52                                                          ; 3d79: e8 d6 00
loc_3d7c:
    jae loc_3d8b                                                                ; 3d7c: 73 0d
loc_3d7e:
    mov ax, word [0x39c3]                                                       ; 3d7e: a1 c3 39
loc_3d81:
    mov word [0x3964], ax                                                       ; 3d81: a3 64 39
loc_3d84:
    mov al, byte [0x39c5]                                                       ; 3d84: a0 c5 39
loc_3d87:
    mov byte [0x3966], al                                                       ; 3d87: a2 66 39
loc_3d8a:
    ret                                                                         ; 3d8a: c3
loc_3d8b:
    call near loc_3e6e                                                          ; 3d8b: e8 e0 00
loc_3d8e:
    jae loc_3dee                                                                ; 3d8e: 73 5e
loc_3d90:
    cmp byte [scene_complete], strict byte 0                                    ; 3d90: 80 3e 53 05 00
loc_3d95:
    je loc_3d98                                                                 ; 3d95: 74 01
loc_3d97:
    ret                                                                         ; 3d97: c3
loc_3d98:
    mov cx, word [player_x]                                                     ; 3d98: 8b 0e 79 05
loc_3d9c:
    sub cx, strict byte 0xc                                                     ; 3d9c: 83 e9 0c
loc_3d9f:
    jae loc_3da3                                                                ; 3d9f: 73 02
loc_3da1:
    load16 sub, cx, cx                                                          ; 3da1: 2b c9
loc_3da3:
    cmp cx, strict word 0x10f                                                   ; 3da3: 81 f9 0f 01
loc_3da7:
    jb loc_3dac                                                                 ; 3da7: 72 03
loc_3da9:
    mov cx, 0x10e                                                               ; 3da9: b9 0e 01
loc_3dac:
    mov dl, byte [player_y]                                                     ; 3dac: 8a 16 7b 05
loc_3db0:
    sub dl, strict byte 4                                                       ; 3db0: 80 ea 04
loc_3db3:
    jae loc_3db7                                                                ; 3db3: 73 02
loc_3db5:
    load8 sub, dl, dl                                                           ; 3db5: 2a d2
loc_3db7:
    call near calculate_cga_address                                             ; 3db7: e8 f6 ee
loc_3dba:
    load16 mov, di, ax                                                          ; 3dba: 8b f8
loc_3dbc:
    mov ax, 0xb800                                                              ; 3dbc: b8 00 b8
loc_3dbf:
    mov es, ax                                                                  ; 3dbf: 8e c0
loc_3dc1:
    mov si, 0x37c0                                                              ; 3dc1: be c0 37
loc_3dc4:
    mov bp, 0xe                                                                 ; 3dc4: bd 0e 00
loc_3dc7:
    mov cx, 0x1506                                                              ; 3dc7: b9 06 15
loc_3dca:
    call near blit_zero_transparent                                             ; 3dca: e8 ff ee
loc_3dcd:
    call near loc_56f4                                                          ; 3dcd: e8 24 19
loc_3dd0:
    load8 sub, ah, ah                                                           ; 3dd0: 2a e4
loc_3dd2:
    int 0x1a                                                                    ; 3dd2: cd 1a
loc_3dd4:
    mov word [0x39c8], dx                                                       ; 3dd4: 89 16 c8 39
loc_3dd8:
    call near loc_5704                                                          ; 3dd8: e8 29 19
loc_3ddb:
    load8 sub, ah, ah                                                           ; 3ddb: 2a e4
loc_3ddd:
    int 0x1a                                                                    ; 3ddd: cd 1a
loc_3ddf:
    sub dx, word [0x39c8]                                                       ; 3ddf: 2b 16 c8 39
loc_3de3:
    cmp dx, strict byte 9                                                       ; 3de3: 83 fa 09
loc_3de6:
    jb loc_3dd8                                                                 ; 3de6: 72 f0
loc_3de8:
    mov byte [scene_failed], 1                                                  ; 3de8: c6 06 52 05 01
loc_3ded:
    ret                                                                         ; 3ded: c3
loc_3dee:
    mov cx, word [0x3964]                                                       ; 3dee: 8b 0e 64 39
loc_3df2:
    mov dl, byte [0x3966]                                                       ; 3df2: 8a 16 66 39
loc_3df6:
    call near calculate_cga_address                                             ; 3df6: e8 b7 ee
loc_3df9:
    mov word [0x39ca], ax                                                       ; 3df9: a3 ca 39
loc_3dfc:
    call near loc_3e38                                                          ; 3dfc: e8 39 00
loc_3dff:
    dec byte [0x396d]                                                           ; 3dff: fe 0e 6d 39
loc_3e03:
    jne loc_3e10                                                                ; 3e03: 75 0b
loc_3e05:
    mov byte [0x396d], 2                                                        ; 3e05: c6 06 6d 39 02
loc_3e0a:
    xor word [0x396b], strict word 0x54                                         ; 3e0a: 81 36 6b 39 54 00
loc_3e10:
    call near loc_3e14                                                          ; 3e10: e8 01 00
loc_3e13:
    ret                                                                         ; 3e13: c3
loc_3e14:
    mov ax, 0xb800                                                              ; 3e14: b8 00 b8
loc_3e17:
    mov es, ax                                                                  ; 3e17: 8e c0
loc_3e19:
    mov di, word [0x39ca]                                                       ; 3e19: 8b 3e ca 39
loc_3e1d:
    mov word [0x3968], di                                                       ; 3e1d: 89 3e 68 39
loc_3e21:
    mov bp, 0x396f                                                              ; 3e21: bd 6f 39
loc_3e24:
    mov byte [0x396a], 0                                                        ; 3e24: c6 06 6a 39 00
loc_3e29:
    mov si, word [0x396b]                                                       ; 3e29: 8b 36 6b 39
loc_3e2d:
    add si, strict word 0x38bc                                                  ; 3e2d: 81 c6 bc 38
loc_3e31:
    mov cx, 0xe03                                                               ; 3e31: b9 03 0e
loc_3e34:
    call near blit_zero_transparent                                             ; 3e34: e8 95 ee
loc_3e37:
    ret                                                                         ; 3e37: c3
loc_3e38:
    mov ax, 0xb800                                                              ; 3e38: b8 00 b8
loc_3e3b:
    mov es, ax                                                                  ; 3e3b: 8e c0
loc_3e3d:
    cmp byte [0x396a], strict byte 0                                            ; 3e3d: 80 3e 6a 39 00
loc_3e42:
    jne loc_3e51                                                                ; 3e42: 75 0d
loc_3e44:
    mov di, word [0x3968]                                                       ; 3e44: 8b 3e 68 39
loc_3e48:
    mov si, 0x396f                                                              ; 3e48: be 6f 39
loc_3e4b:
    mov cx, 0xe03                                                               ; 3e4b: b9 03 0e
loc_3e4e:
    call near copy_rectangle_to_cga                                             ; 3e4e: e8 4c ef
loc_3e51:
    ret                                                                         ; 3e51: c3
loc_3e52:
    mov ax, word [0x3964]                                                       ; 3e52: a1 64 39
loc_3e55:
    mov dl, byte [0x3966]                                                       ; 3e55: 8a 16 66 39
loc_3e59:
    mov si, 0x18                                                                ; 3e59: be 18 00
loc_3e5c:
    mov bx, word [shared_object_x]                                                       ; 3e5c: 8b 1e 7d 32
loc_3e60:
    mov dh, byte [shared_object_y]                                                       ; 3e60: 8a 36 7f 32
loc_3e64:
    mov di, 0x10                                                                ; 3e64: bf 10 00
loc_3e67:
    mov cx, 0x1e0e                                                              ; 3e67: b9 0e 1e
loc_3e6a:
    call near rectangles_overlap                                                ; 3e6a: e8 bc ef
loc_3e6d:
    ret                                                                         ; 3e6d: c3
loc_3e6e:
    mov ax, word [0x3964]                                                       ; 3e6e: a1 64 39
loc_3e71:
    mov dl, byte [0x3966]                                                       ; 3e71: 8a 16 66 39
loc_3e75:
    mov si, 0x18                                                                ; 3e75: be 18 00
loc_3e78:
    load16 mov, di, si                                                          ; 3e78: 8b fe
loc_3e7a:
    mov bx, word [player_x]                                                     ; 3e7a: 8b 1e 79 05
loc_3e7e:
    mov dh, byte [player_y]                                                     ; 3e7e: 8a 36 7b 05
loc_3e82:
    mov cx, 0xe0e                                                               ; 3e82: b9 0e 0e
loc_3e85:
    call near rectangles_overlap                                                ; 3e85: e8 a1 ef
loc_3e88:
    ret                                                                         ; 3e88: c3
    times 7 db 0 ; original zero fill at CS:3e89
