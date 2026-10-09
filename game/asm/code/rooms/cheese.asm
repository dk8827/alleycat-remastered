; Cheese-hole transfers and four collectable targets.
; Original CS:3E90..4340 (end exclusive).

; CS:3e90 — update_cheese_hole_transfer
; Alt/action on a supported cheese hole starts a 14-step transfer animation; table-selected destination replaces player X/Y halfway through.
update_cheese_hole_transfer:
    cmp byte [0x39e1], strict byte 0                                            ; 3e90: 80 3e e1 39 00
loc_3e95:
    je loc_3ea4                                                                 ; 3e95: 74 0d
loc_3e97:
    load8 sub, ah, ah                                                           ; 3e97: 2a e4
loc_3e99:
    int 0x1a                                                                    ; 3e99: cd 1a
loc_3e9b:
    cmp dx, word [0x3d16]                                                       ; 3e9b: 3b 16 16 3d
loc_3e9f:
    je loc_3eb9                                                                 ; 3e9f: 74 18
loc_3ea1:
    jmp near loc_3f35                                                           ; 3ea1: e9 91 00
loc_3ea4:
    cmp byte [0x584], strict byte 0                                             ; 3ea4: 80 3e 84 05 00
loc_3ea9:
    jne loc_3eb9                                                                ; 3ea9: 75 0e
loc_3eab:
    cmp byte [action_button_state], strict byte 0                               ; 3eab: 80 3e 9a 06 00
loc_3eb0:
    jne loc_3eb9                                                                ; 3eb0: 75 07
loc_3eb2:
    cmp byte [0x39e0], strict byte 0                                            ; 3eb2: 80 3e e0 39 00
loc_3eb7:
    jne loc_3eba                                                                ; 3eb7: 75 01
loc_3eb9:
    ret                                                                         ; 3eb9: c3
loc_3eba:
    call near loc_4065                                                          ; 3eba: e8 a8 01
loc_3ebd:
    jb loc_3eb9                                                                 ; 3ebd: 72 fa
loc_3ebf:
    load8 sub, ah, ah                                                           ; 3ebf: 2a e4
loc_3ec1:
    int 0x1a                                                                    ; 3ec1: cd 1a
loc_3ec3:
    load16 mov, ax, dx                                                          ; 3ec3: 8b c2
loc_3ec5:
    sub ax, word [0x3d18]                                                       ; 3ec5: 2b 06 18 3d
loc_3ec9:
    cmp ax, strict word 0xc                                                     ; 3ec9: 3d 0c 00
loc_3ecc:
    jb loc_3eb9                                                                 ; 3ecc: 72 eb
loc_3ece:
    mov word [0x3d18], dx                                                       ; 3ece: 89 16 18 3d
loc_3ed2:
    mov byte [player_support_kind], 0                                           ; 3ed2: c6 06 5c 05 00
loc_3ed7:
    mov bl, byte [0x39e0]                                                       ; 3ed7: 8a 1e e0 39
loc_3edb:
    dec bl                                                                      ; 3edb: fe cb
loc_3edd:
    load8 sub, bh, bh                                                           ; 3edd: 2a ff
loc_3edf:
    load16 mov, si, bx                                                          ; 3edf: 8b f3
loc_3ee1:
    mov cl, 2                                                                   ; 3ee1: b1 02
loc_3ee3:
    shl si, cl                                                                  ; 3ee3: d3 e6
loc_3ee5:
    mov ax, word [si + 0x3c5a]                                                  ; 3ee5: 8b 84 5a 3c
loc_3ee9:
    mov word [0x39e2], ax                                                       ; 3ee9: a3 e2 39
loc_3eec:
    load16 sub, ax, ax                                                          ; 3eec: 2b c0
loc_3eee:
    cmp bl, strict byte 3                                                       ; 3eee: 80 fb 03
loc_3ef1:
    jae loc_3ef5                                                                ; 3ef1: 73 02
loc_3ef3:
    mov al, 0x80                                                                ; 3ef3: b0 80
loc_3ef5:
    mov word [0x39e4], ax                                                       ; 3ef5: a3 e4 39
loc_3ef8:
    mov bl, byte [bx + 0x3ce3]                                                  ; 3ef8: 8a 9f e3 3c
loc_3efc:
    load16 mov, si, bx                                                          ; 3efc: 8b f3
loc_3efe:
    mov cl, 2                                                                   ; 3efe: b1 02
loc_3f00:
    shl si, cl                                                                  ; 3f00: d3 e6
loc_3f02:
    mov ax, word [si + 0x3c5a]                                                  ; 3f02: 8b 84 5a 3c
loc_3f06:
    mov word [0x39e6], ax                                                       ; 3f06: a3 e6 39
loc_3f09:
    load16 sub, ax, ax                                                          ; 3f09: 2b c0
loc_3f0b:
    cmp bl, strict byte 3                                                       ; 3f0b: 80 fb 03
loc_3f0e:
    jae loc_3f12                                                                ; 3f0e: 73 02
loc_3f10:
    mov al, 0x80                                                                ; 3f10: b0 80
loc_3f12:
    mov word [0x39e8], ax                                                       ; 3f12: a3 e8 39
loc_3f15:
    mov al, byte [bx + 0x1050]                                                  ; 3f15: 8a 87 50 10
loc_3f19:
    mov byte [0x3d05], al                                                       ; 3f19: a2 05 3d
loc_3f1c:
    shl bl, 1                                                                   ; 3f1c: d0 e3
loc_3f1e:
    mov ax, word [bx + 0x1137]                                                  ; 3f1e: 8b 87 37 11
loc_3f22:
    add ax, strict word 8                                                       ; 3f22: 05 08 00
loc_3f25:
    mov word [0x3d03], ax                                                       ; 3f25: a3 03 3d
loc_3f28:
    call near restore_player_background                                         ; 3f28: e8 b8 d2
loc_3f2b:
    mov byte [0x39e1], 0xe                                                      ; 3f2b: c6 06 e1 39 0e
loc_3f30:
    mov byte [action_button_state], 0x10                                        ; 3f30: c6 06 9a 06 10
loc_3f35:
    cmp byte [enemy_active], strict byte 0                                      ; 3f35: 80 3e bf 1c 00
loc_3f3a:
    jne loc_3f3f                                                                ; 3f3a: 75 03
loc_3f3c:
    call near erase_shared_room_object                                                          ; 3f3c: e8 61 f4
loc_3f3f:
    sub byte [0x39e1], strict byte 2                                            ; 3f3f: 80 2e e1 39 02
loc_3f44:
    load8 sub, bh, bh                                                           ; 3f44: 2a ff
loc_3f46:
    mov bl, byte [0x39e1]                                                       ; 3f46: 8a 1e e1 39
loc_3f4a:
    cmp bl, strict byte 8                                                       ; 3f4a: 80 fb 08
loc_3f4d:
    jb loc_3f58                                                                 ; 3f4d: 72 09
loc_3f4f:
    mov di, word [0x39e2]                                                       ; 3f4f: 8b 3e e2 39
loc_3f53:
    mov ax, word [0x39e4]                                                       ; 3f53: a1 e4 39
loc_3f56:
    jmp short loc_3f70                                                          ; 3f56: eb 18
loc_3f58:
    mov di, word [0x39e6]                                                       ; 3f58: 8b 3e e6 39
loc_3f5c:
    mov al, byte [0x3d05]                                                       ; 3f5c: a0 05 3d
loc_3f5f:
    mov byte [player_y], al                                                     ; 3f5f: a2 7b 05
loc_3f62:
    add al, 0x32                                                                ; 3f62: 04 32
loc_3f64:
    mov byte [player_y_plus_50], al                                             ; 3f64: a2 7c 05
loc_3f67:
    mov ax, word [0x3d03]                                                       ; 3f67: a1 03 3d
loc_3f6a:
    mov word [player_x], ax                                                     ; 3f6a: a3 79 05
loc_3f6d:
    mov ax, word [0x39e8]                                                       ; 3f6d: a1 e8 39
loc_3f70:
    add ax, word [bx + 0x3d06]                                                  ; 3f70: 03 87 06 3d
loc_3f74:
    load16 mov, si, ax                                                          ; 3f74: 8b f0
loc_3f76:
    mov ax, 0xb800                                                              ; 3f76: b8 00 b8
loc_3f79:
    mov es, ax                                                                  ; 3f79: 8e c0
loc_3f7b:
    mov cx, 0x1002                                                              ; 3f7b: b9 02 10
loc_3f7e:
    call near copy_rectangle_to_cga                                             ; 3f7e: e8 1c ee
loc_3f81:
    cmp byte [enemy_active], strict byte 0                                      ; 3f81: 80 3e bf 1c 00
loc_3f86:
    jne loc_3f8b                                                                ; 3f86: 75 03
loc_3f88:
    call near draw_shared_room_object                                                          ; 3f88: e8 ae f3
loc_3f8b:
    load8 sub, ah, ah                                                           ; 3f8b: 2a e4
loc_3f8d:
    int 0x1a                                                                    ; 3f8d: cd 1a
loc_3f8f:
    mov word [0x3d16], dx                                                       ; 3f8f: 89 16 16 3d
loc_3f93:
    cmp byte [0x39e1], strict byte 0                                            ; 3f93: 80 3e e1 39 00
loc_3f98:
    jne loc_3f9d                                                                ; 3f98: 75 03
loc_3f9a:
    call near save_player_background_at_position                                ; 3f9a: e8 75 d1
loc_3f9d:
    ret                                                                         ; 3f9d: c3
loc_3f9e:
    mov ax, 0xb800                                                              ; 3f9e: b8 00 b8
loc_3fa1:
    mov es, ax                                                                  ; 3fa1: 8e c0
loc_3fa3:
    mov byte [0x39e0], 0                                                        ; 3fa3: c6 06 e0 39 00
loc_3fa8:
    mov byte [0x39e1], 0                                                        ; 3fa8: c6 06 e1 39 00
loc_3fad:
    mov word [0x3cbf], 0x506                                                    ; 3fad: c7 06 bf 3c 06 05
loc_3fb3:
    mov word [0x3cc1], 0                                                        ; 3fb3: c7 06 c1 3c 00 00
loc_3fb9:
    mov bx, word [0x3cc1]                                                       ; 3fb9: 8b 1e c1 3c
loc_3fbd:
    mov cl, byte [bx + 0x3cae]                                                  ; 3fbd: 8a 8f ae 3c
loc_3fc1:
    load16 sub, bx, bx                                                          ; 3fc1: 2b db
loc_3fc3:
    load8 mov, ch, bl                                                           ; 3fc3: 8a eb
loc_3fc5:
    mov si, 0x3aea                                                              ; 3fc5: be ea 3a
loc_3fc8:
    call near update_random_state                                               ; 3fc8: e8 32 ee
loc_3fcb:
    cmp dl, strict byte 0x30                                                    ; 3fcb: 80 fa 30
loc_3fce:
    ja loc_3fdb                                                                 ; 3fce: 77 0b
loc_3fd0:
    mov si, 0x3af8                                                              ; 3fd0: be f8 3a
loc_3fd3:
    test dl, 4                                                                  ; 3fd3: f6 c2 04
loc_3fd6:
    jne loc_3fdb                                                                ; 3fd6: 75 03
loc_3fd8:
    mov si, 0x3b02                                                              ; 3fd8: be 02 3b
loc_3fdb:
    mov di, word [0x3cbf]                                                       ; 3fdb: 8b 3e bf 3c
loc_3fdf:
    load16 add, di, bx                                                          ; 3fdf: 03 fb
loc_3fe1:
    push cx                                                                     ; 3fe1: 51
loc_3fe2:
    push bx                                                                     ; 3fe2: 53
loc_3fe3:
    mov cx, 0x801                                                               ; 3fe3: b9 01 08
loc_3fe6:
    call near copy_rectangle_to_cga                                             ; 3fe6: e8 b4 ed
loc_3fe9:
    pop bx                                                                      ; 3fe9: 5b
loc_3fea:
    pop cx                                                                      ; 3fea: 59
loc_3feb:
    add bx, strict byte 2                                                       ; 3feb: 83 c3 02
loc_3fee:
    loop loc_3fc5                                                               ; 3fee: e2 d5
loc_3ff0:
    add word [0x3cbf], strict word 0x140                                        ; 3ff0: 81 06 bf 3c 40 01
loc_3ff6:
    inc word [0x3cc1]                                                           ; 3ff6: ff 06 c1 3c
loc_3ffa:
    cmp word [0x3cc1], strict byte 0x11                                         ; 3ffa: 83 3e c1 3c 11
loc_3fff:
    jb loc_3fb9                                                                 ; 3fff: 72 b8
loc_4001:
    mov bx, 0x3c22                                                              ; 4001: bb 22 3c
loc_4004:
    load16 sub, ax, ax                                                          ; 4004: 2b c0
loc_4006:
    call near loc_2b24                                                          ; 4006: e8 1b eb
loc_4009:
    mov bx, 0x3c3e                                                              ; 4009: bb 3e 3c
loc_400c:
    load16 sub, ax, ax                                                          ; 400c: 2b c0
loc_400e:
    call near loc_2b24                                                          ; 400e: e8 13 eb
loc_4011:
    mov bx, 0x3c9a                                                              ; 4011: bb 9a 3c
loc_4014:
    load16 sub, ax, ax                                                          ; 4014: 2b c0
loc_4016:
    call near loc_2b24                                                          ; 4016: e8 0b eb
loc_4019:
    mov bx, 0x3c56                                                              ; 4019: bb 56 3c
loc_401c:
    load16 sub, ax, ax                                                          ; 401c: 2b c0
loc_401e:
    call near loc_2b24                                                          ; 401e: e8 03 eb
loc_4021:
    mov si, 0x3caa                                                              ; 4021: be aa 3c
loc_4024:
    mov di, 0x8ec                                                               ; 4024: bf ec 08
loc_4027:
    mov cx, 0x102                                                               ; 4027: b9 02 01
loc_402a:
    mov bp, 0xe                                                                 ; 402a: bd 0e 00
loc_402d:
    call near blit_and_mask                                                     ; 402d: e8 05 ed
loc_4030:
    load16 sub, si, si                                                          ; 4030: 2b f6
loc_4032:
    mov bx, word [difficulty_level]                                             ; 4032: 8b 1e 08 00
loc_4036:
    mov cl, 3                                                                   ; 4036: b1 03
loc_4038:
    load8 and, bl, cl                                                           ; 4038: 22 d9
loc_403a:
    shl bl, cl                                                                  ; 403a: d2 e3
loc_403c:
    mov al, byte [bx + 0x3cc3]                                                  ; 403c: 8a 87 c3 3c
loc_4040:
    load8 mov, ah, al                                                           ; 4040: 8a e0
loc_4042:
    mov cl, 4                                                                   ; 4042: b1 04
loc_4044:
    shr al, cl                                                                  ; 4044: d2 e8
loc_4046:
    mov byte [si + 0x3ce3], al                                                  ; 4046: 88 84 e3 3c
loc_404a:
    mov byte [si + 0x3cf3], 0                                                   ; 404a: c6 84 f3 3c 00
loc_404f:
    and ah, strict byte 0xf                                                     ; 404f: 80 e4 0f
loc_4052:
    mov byte [si + 0x3ce4], ah                                                  ; 4052: 88 a4 e4 3c
loc_4056:
    mov byte [si + 0x3cf4], 0                                                   ; 4056: c6 84 f4 3c 00
loc_405b:
    add si, strict byte 2                                                       ; 405b: 83 c6 02
loc_405e:
    inc bx                                                                      ; 405e: 43
loc_405f:
    cmp si, strict byte 0x10                                                    ; 405f: 83 fe 10
loc_4062:
    jb loc_403c                                                                 ; 4062: 72 d8
loc_4064:
    ret                                                                         ; 4064: c3
loc_4065:
    mov ax, word [shared_object_x]                                                       ; 4065: a1 7d 32
loc_4068:
    mov dl, byte [shared_object_y]                                                       ; 4068: 8a 16 7f 32
loc_406c:
    mov si, 0x10                                                                ; 406c: be 10 00
loc_406f:
    mov bx, word [player_x]                                                     ; 406f: 8b 1e 79 05
loc_4073:
    mov dh, byte [player_y]                                                     ; 4073: 8a 36 7b 05
loc_4077:
    mov di, 0x18                                                                ; 4077: bf 18 00
loc_407a:
    mov cx, 0xe1e                                                               ; 407a: b9 1e 0e
loc_407d:
    call near rectangles_overlap                                                ; 407d: e8 a9 ed
loc_4080:
    ret                                                                         ; 4080: c3
    times 15 db 0 ; original zero fill at CS:4081
; CS:4090 — initialize_cheese_targets
; Initializes four target active/collected/countdown arrays and remaining count=4.
initialize_cheese_targets:
    mov cx, 4                                                                   ; 4090: b9 04 00
loc_4093:
    load16 mov, bx, cx                                                          ; 4093: 8b d9
loc_4095:
    dec bx                                                                      ; 4095: 4b
loc_4096:
    load16 mov, si, bx                                                          ; 4096: 8b f3
loc_4098:
    shl si, 1                                                                   ; 4098: d1 e6
loc_409a:
    mov byte [bx + cheese_target_hidden], 1                                     ; 409a: c6 87 ae 3e 01
loc_409f:
    mov byte [bx + cheese_target_collected], 0                                  ; 409f: c6 87 b2 3e 00
loc_40a4:
    call near loc_4277                                                          ; 40a4: e8 d0 01
loc_40a7:
    call near update_random_state                                               ; 40a7: e8 53 ed
loc_40aa:
    and dl, strict byte 0xf                                                     ; 40aa: 80 e2 0f
loc_40ad:
    add dl, strict byte 0x14                                                    ; 40ad: 80 c2 14
loc_40b0:
    mov byte [bx + cheese_target_countdown], dl                                 ; 40b0: 88 97 b6 3e
loc_40b4:
    loop loc_4093                                                               ; 40b4: e2 dd
loc_40b6:
    mov word [cheese_update_slot], 0                                            ; 40b6: c7 06 da 3e 00 00
loc_40bc:
    mov byte [cheese_targets_remaining], 4                                      ; 40bc: c6 06 d8 3e 04
loc_40c1:
    ret                                                                         ; 40c1: c3
; CS:40c2 — update_cheese_targets
; Schedules four targets, tests contact and exposure/countdown conditions, marks collected slots, and sets scene_complete when remaining count reaches zero.
update_cheese_targets:
    load8 sub, ah, ah                                                           ; 40c2: 2a e4
loc_40c4:
    int 0x1a                                                                    ; 40c4: cd 1a
loc_40c6:
    cmp dx, word [cheese_last_batch_tick]                                       ; 40c6: 3b 16 dc 3e
loc_40ca:
    jne loc_40cd                                                                ; 40ca: 75 01
loc_40cc:
    ret                                                                         ; 40cc: c3
loc_40cd:
    inc word [cheese_update_slot]                                               ; 40cd: ff 06 da 3e
loc_40d1:
    mov bx, word [cheese_update_slot]                                           ; 40d1: 8b 1e da 3e
loc_40d5:
    cmp bx, strict byte 2                                                       ; 40d5: 83 fb 02
loc_40d8:
    jbe loc_40e5                                                                ; 40d8: 76 0b
loc_40da:
    cmp bx, strict byte 4                                                       ; 40da: 83 fb 04
loc_40dd:
    jb loc_40e9                                                                 ; 40dd: 72 0a
loc_40df:
    load16 sub, bx, bx                                                          ; 40df: 2b db
loc_40e1:
    mov word [cheese_update_slot], bx                                           ; 40e1: 89 1e da 3e
loc_40e5:
    mov word [cheese_last_batch_tick], dx                                       ; 40e5: 89 16 dc 3e
loc_40e9:
    load16 mov, si, bx                                                          ; 40e9: 8b f3
loc_40eb:
    shl si, 1                                                                   ; 40eb: d1 e6
loc_40ed:
    cmp byte [bx + cheese_target_collected], strict byte 0                      ; 40ed: 80 bf b2 3e 00
loc_40f2:
    jne loc_40cc                                                                ; 40f2: 75 d8
loc_40f4:
    call near loc_42db                                                          ; 40f4: e8 e4 01
loc_40f7:
    jae loc_40fc                                                                ; 40f7: 73 03
loc_40f9:
    jmp short loc_4124                                                          ; 40f9: eb 29
loc_40fb:
    nop                                                                         ; 40fb: 90
loc_40fc:
    call near loc_42fc                                                          ; 40fc: e8 fd 01
loc_40ff:
    jb loc_40cc                                                                 ; 40ff: 72 cb
loc_4101:
    cmp byte [bx + cheese_target_countdown], strict byte 0                      ; 4101: 80 bf b6 3e 00
loc_4106:
    jne loc_4118                                                                ; 4106: 75 10
loc_4108:
    call near loc_4277                                                          ; 4108: e8 6c 01
loc_410b:
    call near update_random_state                                               ; 410b: e8 ef ec
loc_410e:
    and dl, strict byte 7                                                       ; 410e: 80 e2 07
loc_4111:
    add dl, strict byte 0x14                                                    ; 4111: 80 c2 14
loc_4114:
    mov byte [bx + cheese_target_countdown], dl                                 ; 4114: 88 97 b6 3e
loc_4118:
    dec byte [bx + cheese_target_countdown]                                     ; 4118: fe 8f b6 3e
loc_411c:
    call near loc_42db                                                          ; 411c: e8 bc 01
loc_411f:
    jb loc_4124                                                                 ; 411f: 72 03
loc_4121:
    jmp short loc_4181                                                          ; 4121: eb 5e
loc_4123:
    nop                                                                         ; 4123: 90
loc_4124:
    cmp byte [bx + cheese_target_hidden], strict byte 0                         ; 4124: 80 bf ae 3e 00
loc_4129:
    jne loc_4132                                                                ; 4129: 75 07
loc_412b:
    cmp byte [bx + cheese_target_countdown], strict byte 0x14                   ; 412b: 80 bf b6 3e 14
loc_4130:
    jb loc_4133                                                                 ; 4130: 72 01
loc_4132:
    ret                                                                         ; 4132: c3
loc_4133:
    call near restore_player_background                                         ; 4133: e8 ad d0
loc_4136:
    call near loc_4254                                                          ; 4136: e8 1b 01
loc_4139:
    mov bx, word [cheese_update_slot]                                           ; 4139: 8b 1e da 3e
loc_413d:
    mov byte [bx + cheese_target_collected], 1                                  ; 413d: c6 87 b2 3e 01
loc_4142:
    call near save_player_background                                            ; 4142: e8 df cf
loc_4145:
    mov byte [player_support_kind], 0                                           ; 4145: c6 06 5c 05 00
loc_414a:
    dec byte [cheese_targets_remaining]                                         ; 414a: fe 0e d8 3e
loc_414e:
    jne loc_4155                                                                ; 414e: 75 05
loc_4150:
    mov byte [scene_complete], 1                                                ; 4150: c6 06 53 05 01
loc_4155:
    mov al, 4                                                                   ; 4155: b0 04
loc_4157:
    sub al, byte [cheese_targets_remaining]                                     ; 4157: 2a 06 d8 3e
loc_415b:
    mov cl, 2                                                                   ; 415b: b1 02
loc_415d:
    shl al, cl                                                                  ; 415d: d2 e0
loc_415f:
    load8 sub, ah, ah                                                           ; 415f: 2a e4
loc_4161:
    add ax, strict word 0x51                                                    ; 4161: 05 51 00
loc_4164:
    load16 mov, di, ax                                                          ; 4164: 8b f8
loc_4166:
    mov bp, 0xe                                                                 ; 4166: bd 0e 00
loc_4169:
    mov si, 0x3d20                                                              ; 4169: be 20 3d
loc_416c:
    mov ax, 0xb800                                                              ; 416c: b8 00 b8
loc_416f:
    mov es, ax                                                                  ; 416f: 8e c0
loc_4171:
    mov cx, 0xc02                                                               ; 4171: b9 02 0c
loc_4174:
    call near blit_and_mask                                                     ; 4174: e8 be eb
loc_4177:
    mov ax, 0x3e8                                                               ; 4177: b8 e8 03
loc_417a:
    mov bx, 0x2ee                                                               ; 417a: bb ee 02
loc_417d:
    call near start_two_stage_sound                                             ; 417d: e8 bb 17
loc_4180:
    ret                                                                         ; 4180: c3
loc_4181:
    call near loc_42b4                                                          ; 4181: e8 30 01
loc_4184:
    mov di, word [difficulty_level]                                             ; 4184: 8b 3e 08 00
loc_4188:
    shl di, 1                                                                   ; 4188: d1 e7
loc_418a:
    mov bp, word [di + 0x3ede]                                                  ; 418a: 8b ad de 3e
loc_418e:
    call near loc_431c                                                          ; 418e: e8 8b 01
loc_4191:
    jae loc_41b0                                                                ; 4191: 73 1d
loc_4193:
    cmp byte [bx + cheese_target_countdown], strict byte 2                      ; 4193: 80 bf b6 3e 02
loc_4198:
    jb loc_41b0                                                                 ; 4198: 72 16
loc_419a:
    mov al, 1                                                                   ; 419a: b0 01
loc_419c:
    cmp byte [bx + cheese_target_countdown], strict byte 0x11                   ; 419c: 80 bf b6 3e 11
loc_41a1:
    jbe loc_41ac                                                                ; 41a1: 76 09
loc_41a3:
    cmp byte [bx + cheese_target_countdown], strict byte 0x14                   ; 41a3: 80 bf b6 3e 14
loc_41a8:
    jae loc_41b0                                                                ; 41a8: 73 06
loc_41aa:
    dec al                                                                      ; 41aa: fe c8
loc_41ac:
    mov byte [bx + cheese_target_countdown], al                                 ; 41ac: 88 87 b6 3e
loc_41b0:
    mov al, byte [bx + cheese_target_countdown]                                 ; 41b0: 8a 87 b6 3e
loc_41b4:
    cmp al, 1                                                                   ; 41b4: 3c 01
loc_41b6:
    jbe loc_41d8                                                                ; 41b6: 76 20
loc_41b8:
    cmp al, 0x12                                                                ; 41b8: 3c 12
loc_41ba:
    jb loc_41f8                                                                 ; 41ba: 72 3c
loc_41bc:
    mov al, 1                                                                   ; 41bc: b0 01
loc_41be:
    cmp word [si + 0x3eba], strict byte 3                                       ; 41be: 83 bc ba 3e 03
loc_41c3:
    jae loc_41c7                                                                ; 41c3: 73 02
loc_41c5:
    mov al, 3                                                                   ; 41c5: b0 03
loc_41c7:
    add byte [bx + cheese_target_y], al                                         ; 41c7: 00 87 d4 3e
loc_41cb:
    cmp byte [bx + cheese_target_countdown], strict byte 0x13                   ; 41cb: 80 bf b6 3e 13
loc_41d0:
    jb loc_41f3                                                                 ; 41d0: 72 21
loc_41d2:
    je loc_41ee                                                                 ; 41d2: 74 1a
loc_41d4:
    load16 sub, ax, ax                                                          ; 41d4: 2b c0
loc_41d6:
    jmp short loc_4204                                                          ; 41d6: eb 2c
loc_41d8:
    mov al, 1                                                                   ; 41d8: b0 01
loc_41da:
    cmp word [si + 0x3eba], strict byte 3                                       ; 41da: 83 bc ba 3e 03
loc_41df:
    jae loc_41e3                                                                ; 41df: 73 02
loc_41e1:
    mov al, 3                                                                   ; 41e1: b0 03
loc_41e3:
    add byte [bx + cheese_target_y], al                                         ; 41e3: 00 87 d4 3e
loc_41e7:
    cmp byte [bx + cheese_target_countdown], strict byte 1                      ; 41e7: 80 bf b6 3e 01
loc_41ec:
    jae loc_41f3                                                                ; 41ec: 73 05
loc_41ee:
    mov ax, 0x3db0                                                              ; 41ee: b8 b0 3d
loc_41f1:
    jmp short loc_4204                                                          ; 41f1: eb 11
loc_41f3:
    mov ax, 0x3d80                                                              ; 41f3: b8 80 3d
loc_41f6:
    jmp short loc_4204                                                          ; 41f6: eb 0c
loc_41f8:
    shl al, 1                                                                   ; 41f8: d0 e0
loc_41fa:
    load16 mov, di, ax                                                          ; 41fa: 8b f8
loc_41fc:
    and di, strict word 2                                                       ; 41fc: 81 e7 02 00
loc_4200:
    mov ax, word [di + 0x3de0]                                                  ; 4200: 8b 85 e0 3d
loc_4204:
    mov word [0x3eca], ax                                                       ; 4204: a3 ca 3e
loc_4207:
    mov dl, byte [bx + cheese_target_y]                                         ; 4207: 8a 97 d4 3e
loc_420b:
    mov cx, word [si + cheese_target_x]                                         ; 420b: 8b 8c cc 3e
loc_420f:
    call near calculate_cga_address                                             ; 420f: e8 9e ea
loc_4212:
    mov word [0x3de4], ax                                                       ; 4212: a3 e4 3d
loc_4215:
    call near loc_4254                                                          ; 4215: e8 3c 00
loc_4218:
    mov bx, word [cheese_update_slot]                                           ; 4218: 8b 1e da 3e
loc_421c:
    load16 mov, si, bx                                                          ; 421c: 8b f3
loc_421e:
    shl si, 1                                                                   ; 421e: d1 e6
loc_4220:
    call near loc_42fc                                                          ; 4220: e8 d9 00
loc_4223:
    jae loc_4226                                                                ; 4223: 73 01
loc_4225:
    ret                                                                         ; 4225: c3
loc_4226:
    cmp word [0x3eca], strict byte 0                                            ; 4226: 83 3e ca 3e 00
loc_422b:
    jne loc_4233                                                                ; 422b: 75 06
loc_422d:
    mov byte [bx + cheese_target_hidden], 1                                     ; 422d: c6 87 ae 3e 01
loc_4232:
    ret                                                                         ; 4232: c3
loc_4233:
    mov byte [bx + cheese_target_hidden], 0                                     ; 4233: c6 87 ae 3e 00
loc_4238:
    mov di, word [0x3de4]                                                       ; 4238: 8b 3e e4 3d
loc_423c:
    mov word [si + 0x3ea6], di                                                  ; 423c: 89 bc a6 3e
loc_4240:
    mov ax, 0xb800                                                              ; 4240: b8 00 b8
loc_4243:
    mov es, ax                                                                  ; 4243: 8e c0
loc_4245:
    mov bp, word [si + 0x3ec2]                                                  ; 4245: 8b ac c2 3e
loc_4249:
    mov cx, 0xc02                                                               ; 4249: b9 02 0c
loc_424c:
    mov si, word [0x3eca]                                                       ; 424c: 8b 36 ca 3e
loc_4250:
    call near blit_and_mask                                                     ; 4250: e8 e2 ea
loc_4253:
    ret                                                                         ; 4253: c3
loc_4254:
    mov bx, word [cheese_update_slot]                                           ; 4254: 8b 1e da 3e
loc_4258:
    load16 mov, si, bx                                                          ; 4258: 8b f3
loc_425a:
    shl si, 1                                                                   ; 425a: d1 e6
loc_425c:
    cmp byte [bx + cheese_target_hidden], strict byte 0                         ; 425c: 80 bf ae 3e 00
loc_4261:
    jne loc_4276                                                                ; 4261: 75 13
loc_4263:
    mov di, word [si + 0x3ea6]                                                  ; 4263: 8b bc a6 3e
loc_4267:
    mov cx, 0xc02                                                               ; 4267: b9 02 0c
loc_426a:
    mov si, word [si + 0x3ec2]                                                  ; 426a: 8b b4 c2 3e
loc_426e:
    mov ax, 0xb800                                                              ; 426e: b8 00 b8
loc_4271:
    mov es, ax                                                                  ; 4271: 8e c0
loc_4273:
    call near copy_rectangle_to_cga                                             ; 4273: e8 27 eb
loc_4276:
    ret                                                                         ; 4276: c3
loc_4277:
    mov byte [0x3ed9], 0x20                                                     ; 4277: c6 06 d9 3e 20
loc_427c:
    call near update_random_state                                               ; 427c: e8 7e eb
loc_427f:
    and dx, strict word 0xf                                                     ; 427f: 81 e2 0f 00
loc_4283:
    load16 sub, di, di                                                          ; 4283: 2b ff
loc_4285:
    load16 cmp, di, si                                                          ; 4285: 3b fe
loc_4287:
    je loc_428f                                                                 ; 4287: 74 06
loc_4289:
    cmp dx, word [di + 0x3eba]                                                  ; 4289: 3b 95 ba 3e
loc_428d:
    je loc_427c                                                                 ; 428d: 74 ed
loc_428f:
    add di, strict byte 2                                                       ; 428f: 83 c7 02
loc_4292:
    cmp di, strict byte 8                                                       ; 4292: 83 ff 08
loc_4295:
    jb loc_4285                                                                 ; 4295: 72 ee
loc_4297:
    mov word [si + 0x3eba], dx                                                  ; 4297: 89 94 ba 3e
loc_429b:
    call near loc_42b4                                                          ; 429b: e8 16 00
loc_429e:
    cmp byte [0x3ed9], strict byte 0                                            ; 429e: 80 3e d9 3e 00
loc_42a3:
    je loc_42b3                                                                 ; 42a3: 74 0e
loc_42a5:
    mov bp, 0x32                                                                ; 42a5: bd 32 00
loc_42a8:
    call near loc_431c                                                          ; 42a8: e8 71 00
loc_42ab:
    jae loc_42b3                                                                ; 42ab: 73 06
loc_42ad:
    dec byte [0x3ed9]                                                           ; 42ad: fe 0e d9 3e
loc_42b1:
    jmp short loc_427c                                                          ; 42b1: eb c9
loc_42b3:
    ret                                                                         ; 42b3: c3
loc_42b4:
    mov di, word [si + 0x3eba]                                                  ; 42b4: 8b bc ba 3e
loc_42b8:
    mov al, byte [di + 0x1050]                                                  ; 42b8: 8a 85 50 10
loc_42bc:
    mov dl, 0xa                                                                 ; 42bc: b2 0a
loc_42be:
    cmp di, strict byte 3                                                       ; 42be: 83 ff 03
loc_42c1:
    jae loc_42c5                                                                ; 42c1: 73 02
loc_42c3:
    load8 sub, dl, dl                                                           ; 42c3: 2a d2
loc_42c5:
    load8 sub, al, dl                                                           ; 42c5: 2a c2
loc_42c7:
    add al, 3                                                                   ; 42c7: 04 03
loc_42c9:
    mov byte [bx + cheese_target_y], al                                         ; 42c9: 88 87 d4 3e
loc_42cd:
    shl di, 1                                                                   ; 42cd: d1 e7
loc_42cf:
    mov ax, word [di + 0x1137]                                                  ; 42cf: 8b 85 37 11
loc_42d3:
    add ax, strict word 8                                                       ; 42d3: 05 08 00
loc_42d6:
    mov word [si + cheese_target_x], ax                                         ; 42d6: 89 84 cc 3e
loc_42da:
    ret                                                                         ; 42da: c3
loc_42db:
    push si                                                                     ; 42db: 56
loc_42dc:
    push bx                                                                     ; 42dc: 53
loc_42dd:
    mov ax, word [si + cheese_target_x]                                         ; 42dd: 8b 84 cc 3e
loc_42e1:
    mov dl, byte [bx + cheese_target_y]                                         ; 42e1: 8a 97 d4 3e
loc_42e5:
    mov si, 0x10                                                                ; 42e5: be 10 00
loc_42e8:
    mov bx, word [player_x]                                                     ; 42e8: 8b 1e 79 05
loc_42ec:
    mov dh, byte [player_y]                                                     ; 42ec: 8a 36 7b 05
loc_42f0:
    mov di, 0x18                                                                ; 42f0: bf 18 00
loc_42f3:
    mov cx, 0xe0c                                                               ; 42f3: b9 0c 0e
loc_42f6:
    call near rectangles_overlap                                                ; 42f6: e8 30 eb
loc_42f9:
    pop bx                                                                      ; 42f9: 5b
loc_42fa:
    pop si                                                                      ; 42fa: 5e
loc_42fb:
    ret                                                                         ; 42fb: c3
loc_42fc:
    push si                                                                     ; 42fc: 56
loc_42fd:
    push bx                                                                     ; 42fd: 53
loc_42fe:
    mov ax, word [si + cheese_target_x]                                         ; 42fe: 8b 84 cc 3e
loc_4302:
    mov dl, byte [bx + cheese_target_y]                                         ; 4302: 8a 97 d4 3e
loc_4306:
    mov si, 0x10                                                                ; 4306: be 10 00
loc_4309:
    mov bx, word [shared_object_x]                                                       ; 4309: 8b 1e 7d 32
loc_430d:
    mov dh, byte [shared_object_y]                                                       ; 430d: 8a 36 7f 32
loc_4311:
    load16 mov, di, si                                                          ; 4311: 8b fe
loc_4313:
    mov cx, 0x1e0c                                                              ; 4313: b9 0c 1e
loc_4316:
    call near rectangles_overlap                                                ; 4316: e8 10 eb
loc_4319:
    pop bx                                                                      ; 4319: 5b
loc_431a:
    pop si                                                                      ; 431a: 5e
loc_431b:
    ret                                                                         ; 431b: c3
loc_431c:
    mov ax, word [si + cheese_target_x]                                         ; 431c: 8b 84 cc 3e
loc_4320:
    sub ax, word [player_x]                                                     ; 4320: 2b 06 79 05
loc_4324:
    jae loc_4328                                                                ; 4324: 73 02
loc_4326:
    not ax                                                                      ; 4326: f7 d0
loc_4328:
    mov dl, byte [bx + cheese_target_y]                                         ; 4328: 8a 97 d4 3e
loc_432c:
    sub dl, byte [player_y]                                                     ; 432c: 2a 16 7b 05
loc_4330:
    jae loc_4334                                                                ; 4330: 73 02
loc_4332:
    not dl                                                                      ; 4332: f6 d2
loc_4334:
    load8 sub, dh, dh                                                           ; 4334: 2a f6
loc_4336:
    load16 add, ax, dx                                                          ; 4336: 03 c2
loc_4338:
    load16 cmp, ax, bp                                                          ; 4338: 3b c5
loc_433a:
    jb loc_433e                                                                 ; 433a: 72 02
loc_433c:
    clc                                                                         ; 433c: f8
loc_433d:
    ret                                                                         ; 433d: c3
loc_433e:
    stc                                                                         ; 433e: f9
loc_433f:
    ret                                                                         ; 433f: c3
