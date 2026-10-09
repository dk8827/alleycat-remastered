; Courtship action and platform updates; internal field meanings remain under review.
; Original CS:2E60..3150 (end exclusive).

loc_2e60:
    cmp word [0x2e8d], strict byte 8                                            ; 2e60: 83 3e 8d 2e 08
loc_2e65:
    jb loc_2e68                                                                 ; 2e65: 72 01
loc_2e67:
    ret                                                                         ; 2e67: c3
loc_2e68:
    cmp byte [action_button_state], strict byte 0                               ; 2e68: 80 3e 9a 06 00
loc_2e6d:
    jne loc_2e67                                                                ; 2e6d: 75 f8
loc_2e6f:
    mov word [0x2e92], 0xffff                                                   ; 2e6f: c7 06 92 2e ff ff
loc_2e75:
    mov byte [0x2e91], 0xff                                                     ; 2e75: c6 06 91 2e ff
loc_2e7a:
    mov cx, 7                                                                   ; 2e7a: b9 07 00
loc_2e7d:
    load16 mov, bx, cx                                                          ; 2e7d: 8b d9
loc_2e7f:
    dec bx                                                                      ; 2e7f: 4b
loc_2e80:
    mov al, byte [player_y]                                                     ; 2e80: a0 7b 05
loc_2e83:
    sub al, byte [bx + courtship_platform_y]                                                  ; 2e83: 2a 87 d4 2b
loc_2e87:
    jae loc_2e8b                                                                ; 2e87: 73 02
loc_2e89:
    not al                                                                      ; 2e89: f6 d0
loc_2e8b:
    cmp al, byte [0x2e91]                                                       ; 2e8b: 3a 06 91 2e
loc_2e8f:
    ja loc_2e98                                                                 ; 2e8f: 77 07
loc_2e91:
    mov byte [0x2e91], al                                                       ; 2e91: a2 91 2e
loc_2e94:
    mov word [0x2e92], bx                                                       ; 2e94: 89 1e 92 2e
loc_2e98:
    loop loc_2e7d                                                               ; 2e98: e2 e3
loc_2e9a:
    cmp word [0x2e92], strict word 0xffff                                       ; 2e9a: 81 3e 92 2e ff ff
loc_2ea0:
    jne loc_2ea8                                                                ; 2ea0: 75 06
loc_2ea2:
    mov word [0x2e92], 0                                                        ; 2ea2: c7 06 92 2e 00 00
loc_2ea8:
    mov bx, word [0x2e8d]                                                       ; 2ea8: 8b 1e 8d 2e
loc_2eac:
    mov si, word [0x2e92]                                                       ; 2eac: 8b 36 92 2e
loc_2eb0:
    mov al, byte [si + courtship_platform_y]                                                  ; 2eb0: 8a 84 d4 2b
loc_2eb4:
    mov byte [bx + 0x2b6a], al                                                  ; 2eb4: 88 87 6a 2b
loc_2eb8:
    mov byte [0x2e98], al                                                       ; 2eb8: a2 98 2e
loc_2ebb:
    mov ax, word [player_x]                                                     ; 2ebb: a1 79 05
loc_2ebe:
    shl bl, 1                                                                   ; 2ebe: d0 e3
loc_2ec0:
    cmp ax, strict word 0x108                                                   ; 2ec0: 3d 08 01
loc_2ec3:
    jb loc_2ec8                                                                 ; 2ec3: 72 03
loc_2ec5:
    mov ax, 0x107                                                               ; 2ec5: b8 07 01
loc_2ec8:
    and ax, strict word 0xffc                                                   ; 2ec8: 25 fc 0f
loc_2ecb:
    mov word [bx + 0x2b5a], ax                                                  ; 2ecb: 89 87 5a 2b
loc_2ecf:
    mov word [0x2e96], ax                                                       ; 2ecf: a3 96 2e
loc_2ed2:
    mov cx, 8                                                                   ; 2ed2: b9 08 00
loc_2ed5:
    load16 mov, bx, cx                                                          ; 2ed5: 8b d9
loc_2ed7:
    dec bx                                                                      ; 2ed7: 4b
loc_2ed8:
    cmp bx, word [0x2e8d]                                                       ; 2ed8: 3b 1e 8d 2e
loc_2edc:
    je loc_2f07                                                                 ; 2edc: 74 29
loc_2ede:
    cmp byte [bx + 0x2b72], strict byte 0                                       ; 2ede: 80 bf 72 2b 00
loc_2ee3:
    je loc_2f07                                                                 ; 2ee3: 74 22
loc_2ee5:
    push cx                                                                     ; 2ee5: 51
loc_2ee6:
    mov dl, byte [bx + 0x2b6a]                                                  ; 2ee6: 8a 97 6a 2b
loc_2eea:
    shl bl, 1                                                                   ; 2eea: d0 e3
loc_2eec:
    mov ax, word [bx + 0x2b5a]                                                  ; 2eec: 8b 87 5a 2b
loc_2ef0:
    mov bx, word [0x2e96]                                                       ; 2ef0: 8b 1e 96 2e
loc_2ef4:
    mov dh, byte [0x2e98]                                                       ; 2ef4: 8a 36 98 2e
loc_2ef8:
    mov si, 0x18                                                                ; 2ef8: be 18 00
loc_2efb:
    load16 mov, di, si                                                          ; 2efb: 8b fe
loc_2efd:
    mov cx, 0xf0f                                                               ; 2efd: b9 0f 0f
loc_2f00:
    call near rectangles_overlap                                                ; 2f00: e8 26 ff
loc_2f03:
    pop cx                                                                      ; 2f03: 59
loc_2f04:
    jae loc_2f07                                                                ; 2f04: 73 01
loc_2f06:
    ret                                                                         ; 2f06: c3
loc_2f07:
    loop loc_2ed5                                                               ; 2f07: e2 cc
loc_2f09:
    call near restore_player_background                                         ; 2f09: e8 d7 e2
loc_2f0c:
    cmp byte [courtship_object_active], strict byte 0                                            ; 2f0c: 80 3e f2 70 00
loc_2f11:
    je loc_2f16                                                                 ; 2f11: 74 03
loc_2f13:
    call near erase_courtship_moving_object                                                          ; 2f13: e8 15 33
loc_2f16:
    mov bx, word [0x2e8d]                                                       ; 2f16: 8b 1e 8d 2e
loc_2f1a:
    mov word [0x2e94], bx                                                       ; 2f1a: 89 1e 94 2e
loc_2f1e:
    mov byte [bx + 0x2b72], 1                                                   ; 2f1e: c6 87 72 2b 01
loc_2f23:
    mov dl, byte [bx + 0x2b6a]                                                  ; 2f23: 8a 97 6a 2b
loc_2f27:
    shl bl, 1                                                                   ; 2f27: d0 e3
loc_2f29:
    mov cx, word [bx + 0x2b5a]                                                  ; 2f29: 8b 8f 5a 2b
loc_2f2d:
    call near calculate_cga_address                                             ; 2f2d: e8 80 fd
loc_2f30:
    load16 mov, di, ax                                                          ; 2f30: 8b f8
loc_2f32:
    mov si, 0x2af0                                                              ; 2f32: be f0 2a
loc_2f35:
    mov ax, 0xb800                                                              ; 2f35: b8 00 b8
loc_2f38:
    mov es, ax                                                                  ; 2f38: 8e c0
loc_2f3a:
    mov cx, 0xf03                                                               ; 2f3a: b9 03 0f
loc_2f3d:
    call near copy_rectangle_to_cga                                             ; 2f3d: e8 5d fe
loc_2f40:
    mov word [0x2e8d], 0xffff                                                   ; 2f40: c7 06 8d 2e ff ff
loc_2f46:
    load16 sub, bx, bx                                                          ; 2f46: 2b db
loc_2f48:
    mov ah, 0xb                                                                 ; 2f48: b4 0b
loc_2f4a:
    int 0x10                                                                    ; 2f4a: cd 10
loc_2f4c:
    call near loc_4e3e                                                          ; 2f4c: e8 ef 1e
loc_2f4f:
    cmp byte [courtship_object_active], strict byte 0                                            ; 2f4f: 80 3e f2 70 00
loc_2f54:
    je loc_2f59                                                                 ; 2f54: 74 03
loc_2f56:
    call near draw_courtship_moving_object                                                          ; 2f56: e8 a1 32
loc_2f59:
    call near draw_player_mask                                                  ; 2f59: e8 e9 e1
loc_2f5c:
    mov ax, 0x3e8                                                               ; 2f5c: b8 e8 03
loc_2f5f:
    mov bx, 0x4a5                                                               ; 2f5f: bb a5 04
loc_2f62:
    call near start_two_stage_sound                                             ; 2f62: e8 d6 29
loc_2f65:
    ret                                                                         ; 2f65: c3
loc_2f66:
    load8 sub, ah, ah                                                           ; 2f66: 2a e4
loc_2f68:
    int 0x1a                                                                    ; 2f68: cd 1a
loc_2f6a:
    cmp dx, word [0x2e8f]                                                       ; 2f6a: 3b 16 8f 2e
loc_2f6e:
    jne loc_2f71                                                                ; 2f6e: 75 01
loc_2f70:
    ret                                                                         ; 2f70: c3
loc_2f71:
    mov word [0x2e8f], dx                                                       ; 2f71: 89 16 8f 2e
loc_2f75:
    cmp word [0x2e8d], strict byte 8                                            ; 2f75: 83 3e 8d 2e 08
loc_2f7a:
    jb loc_2fac                                                                 ; 2f7a: 72 30
loc_2f7c:
    mov cx, 8                                                                   ; 2f7c: b9 08 00
loc_2f7f:
    load16 mov, bx, cx                                                          ; 2f7f: 8b d9
loc_2f81:
    dec bx                                                                      ; 2f81: 4b
loc_2f82:
    cmp byte [bx + 0x2b72], strict byte 0                                       ; 2f82: 80 bf 72 2b 00
loc_2f87:
    je loc_2faa                                                                 ; 2f87: 74 21
loc_2f89:
    push cx                                                                     ; 2f89: 51
loc_2f8a:
    mov dl, byte [bx + 0x2b6a]                                                  ; 2f8a: 8a 97 6a 2b
loc_2f8e:
    shl bl, 1                                                                   ; 2f8e: d0 e3
loc_2f90:
    mov ax, word [bx + 0x2b5a]                                                  ; 2f90: 8b 87 5a 2b
loc_2f94:
    mov si, 0x18                                                                ; 2f94: be 18 00
loc_2f97:
    load16 mov, di, si                                                          ; 2f97: 8b fe
loc_2f99:
    mov bx, word [player_x]                                                     ; 2f99: 8b 1e 79 05
loc_2f9d:
    mov dh, byte [player_y]                                                     ; 2f9d: 8a 36 7b 05
loc_2fa1:
    mov cx, 0xe0f                                                               ; 2fa1: b9 0f 0e
loc_2fa4:
    call near rectangles_overlap                                                ; 2fa4: e8 82 fe
loc_2fa7:
    pop cx                                                                      ; 2fa7: 59
loc_2fa8:
    jb loc_2fb3                                                                 ; 2fa8: 72 09
loc_2faa:
    loop loc_2f7f                                                               ; 2faa: e2 d3
loc_2fac:
    mov word [0x2e94], 0xffff                                                   ; 2fac: c7 06 94 2e ff ff
loc_2fb2:
    ret                                                                         ; 2fb2: c3
loc_2fb3:
    load16 mov, bx, cx                                                          ; 2fb3: 8b d9
loc_2fb5:
    dec bx                                                                      ; 2fb5: 4b
loc_2fb6:
    cmp bx, word [0x2e94]                                                       ; 2fb6: 3b 1e 94 2e
loc_2fba:
    je loc_2fb2                                                                 ; 2fba: 74 f6
loc_2fbc:
    push bx                                                                     ; 2fbc: 53
loc_2fbd:
    call near restore_player_background                                         ; 2fbd: e8 23 e2
loc_2fc0:
    cmp byte [courtship_object_active], strict byte 0                                            ; 2fc0: 80 3e f2 70 00
loc_2fc5:
    je loc_2fca                                                                 ; 2fc5: 74 03
loc_2fc7:
    call near erase_courtship_moving_object                                                          ; 2fc7: e8 61 32
loc_2fca:
    pop bx                                                                      ; 2fca: 5b
loc_2fcb:
    mov byte [bx + 0x2b72], 0                                                   ; 2fcb: c6 87 72 2b 00
loc_2fd0:
    mov dl, byte [bx + 0x2b6a]                                                  ; 2fd0: 8a 97 6a 2b
loc_2fd4:
    mov word [0x2e8d], bx                                                       ; 2fd4: 89 1e 8d 2e
loc_2fd8:
    shl bl, 1                                                                   ; 2fd8: d0 e3
loc_2fda:
    mov cx, word [bx + 0x2b5a]                                                  ; 2fda: 8b 8f 5a 2b
loc_2fde:
    call near calculate_cga_address                                             ; 2fde: e8 cf fc
loc_2fe1:
    load16 mov, di, ax                                                          ; 2fe1: 8b f8
loc_2fe3:
    mov si, 0x2b7a                                                              ; 2fe3: be 7a 2b
loc_2fe6:
    mov ax, 0xb800                                                              ; 2fe6: b8 00 b8
loc_2fe9:
    mov es, ax                                                                  ; 2fe9: 8e c0
loc_2feb:
    mov cx, 0xf03                                                               ; 2feb: b9 03 0f
loc_2fee:
    call near copy_rectangle_to_cga                                             ; 2fee: e8 ac fd
loc_2ff1:
    cmp byte [courtship_object_active], strict byte 0                                            ; 2ff1: 80 3e f2 70 00
loc_2ff6:
    je loc_2ffb                                                                 ; 2ff6: 74 03
loc_2ff8:
    call near draw_courtship_moving_object                                                          ; 2ff8: e8 ff 31
loc_2ffb:
    call near draw_player_mask                                                  ; 2ffb: e8 47 e1
loc_2ffe:
    mov bx, 1                                                                   ; 2ffe: bb 01 00
loc_3001:
    mov ah, 0xb                                                                 ; 3001: b4 0b
loc_3003:
    int 0x10                                                                    ; 3003: cd 10
loc_3005:
    mov ax, 0x3e8                                                               ; 3005: b8 e8 03
loc_3008:
    mov bx, 0x349                                                               ; 3008: bb 49 03
loc_300b:
    call near start_two_stage_sound                                             ; 300b: e8 2d 29
loc_300e:
    ret                                                                         ; 300e: c3
loc_300f:
    load16 sub, ax, ax                                                          ; 300f: 2b c0
loc_3011:
    mov bx, 0x2e24                                                              ; 3011: bb 24 2e
loc_3014:
    call near loc_2b24                                                          ; 3014: e8 0d fb
loc_3017:
    mov byte [0x2e8a], 0xbf                                                     ; 3017: c6 06 8a 2e bf
loc_301c:
    mov word [0x2e8b], 0                                                        ; 301c: c7 06 8b 2e 00 00
loc_3022:
    mov word [0x2e88], 0x20                                                     ; 3022: c7 06 88 2e 20 00
loc_3028:
    load16 sub, bx, bx                                                          ; 3028: 2b db
loc_302a:
    cmp byte [0x2e8a], strict byte 0xbf                                         ; 302a: 80 3e 8a 2e bf
loc_302f:
    je loc_3039                                                                 ; 302f: 74 08
loc_3031:
    call near update_random_state                                               ; 3031: e8 c9 fd
loc_3034:
    load8 mov, bl, dl                                                           ; 3034: 8a da
loc_3036:
    and bl, strict byte 2                                                       ; 3036: 80 e3 02
loc_3039:
    mov cx, word [0x2e88]                                                       ; 3039: 8b 0e 88 2e
loc_303d:
    mov dl, byte [0x2e8a]                                                       ; 303d: 8a 16 8a 2e
loc_3041:
    push bx                                                                     ; 3041: 53
loc_3042:
    call near loc_30e3                                                          ; 3042: e8 9e 00
loc_3045:
    pop bx                                                                      ; 3045: 5b
loc_3046:
    mov si, word [0x2e8b]                                                       ; 3046: 8b 36 8b 2e
loc_304a:
    mov ax, word [0x2e88]                                                       ; 304a: a1 88 2e
loc_304d:
    mov cl, 4                                                                   ; 304d: b1 04
loc_304f:
    shr ax, cl                                                                  ; 304f: d3 e8
loc_3051:
    sub ax, strict word 2                                                       ; 3051: 2d 02 00
loc_3054:
    jae loc_3058                                                                ; 3054: 73 02
loc_3056:
    load16 sub, ax, ax                                                          ; 3056: 2b c0
loc_3058:
    cmp ax, strict word 0x12                                                    ; 3058: 3d 12 00
loc_305b:
    jb loc_3060                                                                 ; 305b: 72 03
loc_305d:
    mov ax, 0x11                                                                ; 305d: b8 11 00
loc_3060:
    mov dl, byte [si + courtship_platform_row_offsets]                                                  ; 3060: 8a 94 db 2b
loc_3064:
    load8 sub, dh, dh                                                           ; 3064: 2a f6
loc_3066:
    load16 add, ax, dx                                                          ; 3066: 03 c2
loc_3068:
    load16 mov, si, ax                                                          ; 3068: 8b f0
loc_306a:
    mov byte [si + courtship_platform_cells], bl                                                  ; 306a: 88 9c e2 2b
loc_306e:
    add word [0x2e88], strict byte 0x10                                         ; 306e: 83 06 88 2e 10
loc_3073:
    cmp word [0x2e88], strict word 0x111                                        ; 3073: 81 3e 88 2e 11 01
loc_3079:
    jb loc_3028                                                                 ; 3079: 72 ad
loc_307b:
    inc word [0x2e8b]                                                           ; 307b: ff 06 8b 2e
loc_307f:
    sub byte [0x2e8a], strict byte 0x18                                         ; 307f: 80 2e 8a 2e 18
loc_3084:
    cmp byte [0x2e8a], strict byte 0x2f                                         ; 3084: 80 3e 8a 2e 2f
loc_3089:
    jae loc_3022                                                                ; 3089: 73 97
loc_308b:
    mov ax, 0xffff                                                              ; 308b: b8 ff ff
loc_308e:
    mov word [0x2e8d], ax                                                       ; 308e: a3 8d 2e
loc_3091:
    mov word [0x2e94], ax                                                       ; 3091: a3 94 2e
loc_3094:
    load16 sub, ax, ax                                                          ; 3094: 2b c0
loc_3096:
    mov word [0x2b72], ax                                                       ; 3096: a3 72 2b
loc_3099:
    mov word [0x2b74], ax                                                       ; 3099: a3 74 2b
loc_309c:
    mov word [0x2b76], ax                                                       ; 309c: a3 76 2b
loc_309f:
    mov word [0x2b78], ax                                                       ; 309f: a3 78 2b
loc_30a2:
    mov cx, word [completed_room_count]                                         ; 30a2: 8b 0e 14 04
loc_30a6:
    cmp cx, strict byte 0                                                       ; 30a6: 83 f9 00
loc_30a9:
    jne loc_30b0                                                                ; 30a9: 75 05
loc_30ab:
    inc cx                                                                      ; 30ab: 41
loc_30ac:
    mov word [completed_room_count], cx                                         ; 30ac: 89 0e 14 04
loc_30b0:
    cmp cx, strict byte 8                                                       ; 30b0: 83 f9 08
loc_30b3:
    jbe loc_30b8                                                                ; 30b3: 76 03
loc_30b5:
    mov cx, 8                                                                   ; 30b5: b9 08 00
loc_30b8:
    load16 mov, bx, cx                                                          ; 30b8: 8b d9
loc_30ba:
    dec bx                                                                      ; 30ba: 4b
loc_30bb:
    mov byte [bx + 0x2b72], 1                                                   ; 30bb: c6 87 72 2b 01
loc_30c0:
    mov dl, 0xb0                                                                ; 30c0: b2 b0
loc_30c2:
    mov byte [bx + 0x2b6a], dl                                                  ; 30c2: 88 97 6a 2b
loc_30c6:
    push cx                                                                     ; 30c6: 51
loc_30c7:
    shl bl, 1                                                                   ; 30c7: d0 e3
loc_30c9:
    mov cx, word [bx + 0x2b4a]                                                  ; 30c9: 8b 8f 4a 2b
loc_30cd:
    mov word [bx + 0x2b5a], cx                                                  ; 30cd: 89 8f 5a 2b
loc_30d1:
    call near calculate_cga_address                                             ; 30d1: e8 dc fb
loc_30d4:
    load16 mov, di, ax                                                          ; 30d4: 8b f8
loc_30d6:
    mov si, 0x2af0                                                              ; 30d6: be f0 2a
loc_30d9:
    mov cx, 0xf03                                                               ; 30d9: b9 03 0f
loc_30dc:
    call near copy_rectangle_to_cga                                             ; 30dc: e8 be fc
loc_30df:
    pop cx                                                                      ; 30df: 59
loc_30e0:
    loop loc_30b8                                                               ; 30e0: e2 d6
loc_30e2:
    ret                                                                         ; 30e2: c3
loc_30e3:
    push bx                                                                     ; 30e3: 53
loc_30e4:
    call near calculate_cga_address                                             ; 30e4: e8 c9 fb
loc_30e7:
    load16 mov, di, ax                                                          ; 30e7: 8b f8
loc_30e9:
    mov ax, 0xb800                                                              ; 30e9: b8 00 b8
loc_30ec:
    mov es, ax                                                                  ; 30ec: 8e c0
loc_30ee:
    pop bx                                                                      ; 30ee: 5b
loc_30ef:
    mov si, word [bx + 0x2e20]                                                  ; 30ef: 8b b7 20 2e
loc_30f3:
    mov cx, 0x802                                                               ; 30f3: b9 02 08
loc_30f6:
    call near copy_rectangle_to_cga                                             ; 30f6: e8 a4 fc
loc_30f9:
    ret                                                                         ; 30f9: c3
loc_30fa:
    mov al, byte [player_y]                                                     ; 30fa: a0 7b 05
loc_30fd:
    sub al, 5                                                                   ; 30fd: 2c 05
loc_30ff:
    and al, 0xf8                                                                ; 30ff: 24 f8
loc_3101:
    mov cx, 7                                                                   ; 3101: b9 07 00
loc_3104:
    load16 mov, bx, cx                                                          ; 3104: 8b d9
loc_3106:
    dec bx                                                                      ; 3106: 4b
loc_3107:
    cmp al, byte [bx + courtship_platform_y]                                                  ; 3107: 3a 87 d4 2b
loc_310b:
    je loc_3111                                                                 ; 310b: 74 04
loc_310d:
    loop loc_3104                                                               ; 310d: e2 f5
loc_310f:
    jmp short loc_314d                                                          ; 310f: eb 3c
loc_3111:
    load8 mov, ch, al                                                           ; 3111: 8a e8
loc_3113:
    mov ax, word [player_x]                                                     ; 3113: a1 79 05
loc_3116:
    add ax, strict word 7                                                       ; 3116: 05 07 00
loc_3119:
    mov cl, 4                                                                   ; 3119: b1 04
loc_311b:
    shr ax, cl                                                                  ; 311b: d3 e8
loc_311d:
    sub ax, strict word 2                                                       ; 311d: 2d 02 00
loc_3120:
    jae loc_3124                                                                ; 3120: 73 02
loc_3122:
    load16 sub, ax, ax                                                          ; 3122: 2b c0
loc_3124:
    cmp ax, strict word 0x12                                                    ; 3124: 3d 12 00
loc_3127:
    jb loc_312c                                                                 ; 3127: 72 03
loc_3129:
    mov ax, 0x11                                                                ; 3129: b8 11 00
loc_312c:
    mov dl, byte [bx + courtship_platform_row_offsets]                                                  ; 312c: 8a 97 db 2b
loc_3130:
    load8 sub, dh, dh                                                           ; 3130: 2a f6
loc_3132:
    load16 add, ax, dx                                                          ; 3132: 03 c2
loc_3134:
    load16 mov, si, ax                                                          ; 3134: 8b f0
loc_3136:
    cmp byte [si + courtship_platform_cells], strict byte 0                                       ; 3136: 80 bc e2 2b 00
loc_313b:
    jne loc_314d                                                                ; 313b: 75 10
loc_313d:
    add ch, strict byte 5                                                       ; 313d: 80 c5 05
loc_3140:
    mov byte [player_y], ch                                                     ; 3140: 88 2e 7b 05
loc_3144:
    add ch, strict byte 0x32                                                    ; 3144: 80 c5 32
loc_3147:
    mov byte [player_y_plus_50], ch                                             ; 3147: 88 2e 7c 05
loc_314b:
    stc                                                                         ; 314b: f9
loc_314c:
    ret                                                                         ; 314c: c3
loc_314d:
    clc                                                                         ; 314d: f8
loc_314e:
    ret                                                                         ; 314e: c3
    times 1 db 0 ; original zero fill at CS:314f
