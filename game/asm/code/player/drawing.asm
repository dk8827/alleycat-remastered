; Player clipping, animation, saved background and impact.
; Original CS:0F87..1200 (end exclusive).

; CS:0f87 — clip_player_at_alley_edge
; Crops the entering player to 3-AL words per row and copies rows through DS:000E; direction selects left or right screen clipping.
clip_player_at_alley_edge:
    mov cx, 0xb03                                                               ; 0f87: b9 03 0b
loc_0f8a:
    load8 sub, cl, al                                                           ; 0f8a: 2a c8
loc_0f8c:
    mov word [player_draw_dimensions], cx                                       ; 0f8c: 89 0e 65 05
loc_0f90:
    cmp ah, strict byte 0xff                                                    ; 0f90: 80 fc ff
loc_0f93:
    je loc_0fa6                                                                 ; 0f93: 74 11
loc_0f95:
    load8 sub, ah, ah                                                           ; 0f95: 2a e4
loc_0f97:
    shl al, 1                                                                   ; 0f97: d0 e0
loc_0f99:
    add word [player_sprite_pointer], ax                                        ; 0f99: 01 06 5d 05
loc_0f9d:
    mov word [player_x], 0                                                      ; 0f9d: c7 06 79 05 00 00
loc_0fa3:
    jmp short loc_0fb4                                                          ; 0fa3: eb 0f
loc_0fa5:
    nop                                                                         ; 0fa5: 90
loc_0fa6:
    load8 sub, ah, ah                                                           ; 0fa6: 2a e4
loc_0fa8:
    shl al, 1                                                                   ; 0fa8: d0 e0
loc_0faa:
    shl al, 1                                                                   ; 0faa: d0 e0
loc_0fac:
    shl al, 1                                                                   ; 0fac: d0 e0
loc_0fae:
    add ax, strict word 0x128                                                   ; 0fae: 05 28 01
loc_0fb1:
    mov word [player_x], ax                                                     ; 0fb1: a3 79 05
loc_0fb4:
    push ds                                                                     ; 0fb4: 1e
loc_0fb5:
    pop es                                                                      ; 0fb5: 07
loc_0fb6:
    mov si, word [player_sprite_pointer]                                        ; 0fb6: 8b 36 5d 05
loc_0fba:
    mov di, 0xe                                                                 ; 0fba: bf 0e 00
loc_0fbd:
    mov al, 3                                                                   ; 0fbd: b0 03
loc_0fbf:
    call near copy_rows_with_source_stride                                      ; 0fbf: e8 ae 1d
loc_0fc2:
    mov word [player_sprite_pointer], 0xe                                       ; 0fc2: c7 06 5d 05 0e 00
loc_0fc8:
    ret                                                                         ; 0fc8: c3
; CS:0fc9 — move_player_horizontally
; Adds or subtracts DS:0572 according to direction. Returns CF on clamping to 8..290, or 36..270 in scene seven; direction zero leaves X unchanged.
move_player_horizontally:
    mov word [0x5f6], 8                                                         ; 0fc9: c7 06 f6 05 08 00
loc_0fcf:
    mov word [0x5f8], 0x123                                                     ; 0fcf: c7 06 f8 05 23 01
loc_0fd5:
    cmp word [scene_index], strict byte 7                                       ; 0fd5: 83 3e 04 00 07
loc_0fda:
    jne loc_0fe8                                                                ; 0fda: 75 0c
loc_0fdc:
    mov word [0x5f6], 0x24                                                      ; 0fdc: c7 06 f6 05 24 00
loc_0fe2:
    mov word [0x5f8], 0x10f                                                     ; 0fe2: c7 06 f8 05 0f 01
loc_0fe8:
    mov ax, word [player_x]                                                     ; 0fe8: a1 79 05
loc_0feb:
    cmp byte [player_horizontal_direction], strict byte 1                       ; 0feb: 80 3e 6e 05 01
loc_0ff0:
    jb loc_101e                                                                 ; 0ff0: 72 2c
loc_0ff2:
    jne loc_1007                                                                ; 0ff2: 75 13
loc_0ff4:
    add ax, word [player_horizontal_speed]                                      ; 0ff4: 03 06 72 05
loc_0ff8:
    cmp ax, word [0x5f8]                                                        ; 0ff8: 3b 06 f8 05
loc_0ffc:
    jb loc_101b                                                                 ; 0ffc: 72 1d
loc_0ffe:
    mov ax, word [0x5f8]                                                        ; 0ffe: a1 f8 05
loc_1001:
    dec ax                                                                      ; 1001: 48
loc_1002:
    mov word [player_x], ax                                                     ; 1002: a3 79 05
loc_1005:
    stc                                                                         ; 1005: f9
loc_1006:
    ret                                                                         ; 1006: c3
loc_1007:
    sub ax, word [player_horizontal_speed]                                      ; 1007: 2b 06 72 05
loc_100b:
    jb loc_1013                                                                 ; 100b: 72 06
loc_100d:
    cmp ax, word [0x5f6]                                                        ; 100d: 3b 06 f6 05
loc_1011:
    jae loc_101b                                                                ; 1011: 73 08
loc_1013:
    mov ax, word [0x5f6]                                                        ; 1013: a1 f6 05
loc_1016:
    mov word [player_x], ax                                                     ; 1016: a3 79 05
loc_1019:
    stc                                                                         ; 1019: f9
loc_101a:
    ret                                                                         ; 101a: c3
loc_101b:
    mov word [player_x], ax                                                     ; 101b: a3 79 05
loc_101e:
    clc                                                                         ; 101e: f8
loc_101f:
    ret                                                                         ; 101f: c3
; CS:1020 — select_walking_frame
; Resets speed on direction change, accelerates up to eight, cycles six frames, and selects the opposite six-frame bank for direction FF.
select_walking_frame:
    mov al, byte [player_horizontal_direction]                                  ; 1020: a0 6e 05
loc_1023:
    cmp al, byte [player_previous_horizontal_direction]                         ; 1023: 3a 06 6f 05
loc_1027:
    je loc_102f                                                                 ; 1027: 74 06
loc_1029:
    mov word [player_horizontal_speed], 2                                       ; 1029: c7 06 72 05 02 00
loc_102f:
    cmp word [player_horizontal_speed], strict byte 8                           ; 102f: 83 3e 72 05 08
loc_1034:
    jae loc_1045                                                                ; 1034: 73 0f
loc_1036:
    dec byte [player_motion_accumulator]                                        ; 1036: fe 0e 77 05
loc_103a:
    mov al, byte [player_motion_accumulator]                                    ; 103a: a0 77 05
loc_103d:
    and al, 3                                                                   ; 103d: 24 03
loc_103f:
    jne loc_1045                                                                ; 103f: 75 04
loc_1041:
    inc word [player_horizontal_speed]                                          ; 1041: ff 06 72 05
loc_1045:
    mov bl, byte [player_walk_frame]                                            ; 1045: 8a 1e 6b 05
loc_1049:
    inc bl                                                                      ; 1049: fe c3
loc_104b:
    cmp bl, strict byte 6                                                       ; 104b: 80 fb 06
loc_104e:
    jb loc_1052                                                                 ; 104e: 72 02
loc_1050:
    mov bl, 0                                                                   ; 1050: b3 00
loc_1052:
    mov byte [player_walk_frame], bl                                            ; 1052: 88 1e 6b 05
loc_1056:
    cmp byte [player_horizontal_direction], strict byte 0xff                    ; 1056: 80 3e 6e 05 ff
loc_105b:
    jne loc_1060                                                                ; 105b: 75 03
loc_105d:
    add bl, strict byte 6                                                       ; 105d: 80 c3 06
loc_1060:
    shl bl, 1                                                                   ; 1060: d0 e3
loc_1062:
    load8 sub, bh, bh                                                           ; 1062: 2a ff
loc_1064:
    mov bx, word [bx + 0xf7a]                                                   ; 1064: 8b 9f 7a 0f
loc_1068:
    ret                                                                         ; 1068: c3
loc_1069:
    mov word [player_horizontal_speed], 2                                       ; 1069: c7 06 72 05 02 00
loc_106f:
    mov byte [player_motion_accumulator], 8                                     ; 106f: c6 06 77 05 08
loc_1074:
    cmp word [player_saved_dimensions], strict word 0xc02                       ; 1074: 81 3e 61 05 02 0c
loc_107a:
    jne loc_1087                                                                ; 107a: 75 0b
loc_107c:
    inc byte [0x56d]                                                            ; 107c: fe 06 6d 05
loc_1080:
    test byte [0x56d], 7                                                        ; 1080: f6 06 6d 05 07
loc_1085:
    jne loc_10dc                                                                ; 1085: 75 55
loc_1087:
    call near restore_player_background                                         ; 1087: e8 59 01
loc_108a:
    call near check_alley_projectile_contact                                    ; 108a: e8 ed 0a
loc_108d:
    jb loc_10dc                                                                 ; 108d: 72 4d
loc_108f:
    call near check_chasing_enemy_contact                                       ; 108f: e8 63 10
loc_1092:
    jb loc_10dc                                                                 ; 1092: 72 48
loc_1094:
    call near update_random_state                                               ; 1094: e8 66 1d
loc_1097:
    load8 mov, bl, dl                                                           ; 1097: 8a da
loc_1099:
    and bx, strict word 0xe                                                     ; 1099: 81 e3 0e 00
loc_109d:
    mov si, word [bx + 0xf92]                                                   ; 109d: 8b b7 92 0f
loc_10a1:
    mov ax, 0xb800                                                              ; 10a1: b8 00 b8
loc_10a4:
    mov es, ax                                                                  ; 10a4: 8e c0
loc_10a6:
    mov di, word [player_video_offset]                                          ; 10a6: 8b 3e 5f 05
loc_10aa:
    mov bp, 0x5fa                                                               ; 10aa: bd fa 05
loc_10ad:
    mov word [player_saved_dimensions], 0xc02                                   ; 10ad: c7 06 61 05 02 0c
loc_10b3:
    mov cx, 0x602                                                               ; 10b3: b9 02 06
loc_10b6:
    call near blit_and_mask                                                     ; 10b6: e8 7c 1c
loc_10b9:
    call near update_random_state                                               ; 10b9: e8 41 1d
loc_10bc:
    load8 mov, bl, dl                                                           ; 10bc: 8a da
loc_10be:
    and bx, strict word 6                                                       ; 10be: 81 e3 06 00
loc_10c2:
    mov si, word [bx + 0xfa2]                                                   ; 10c2: 8b b7 a2 0f
loc_10c6:
    mov di, word [player_video_offset]                                          ; 10c6: 8b 3e 5f 05
loc_10ca:
    add di, strict word 0xf0                                                    ; 10ca: 81 c7 f0 00
loc_10ce:
    mov bp, 0x612                                                               ; 10ce: bd 12 06
loc_10d1:
    mov cx, 0x602                                                               ; 10d1: b9 02 06
loc_10d4:
    call near blit_and_mask                                                     ; 10d4: e8 5e 1c
loc_10d7:
    mov byte [0x583], 0                                                         ; 10d7: c6 06 83 05 00
loc_10dc:
    ret                                                                         ; 10dc: c3
loc_10dd:
    mov byte [player_support_kind], 0                                           ; 10dd: c6 06 5c 05 00
loc_10e2:
    mov byte [player_vertical_direction], 1                                     ; 10e2: c6 06 71 05 01
loc_10e7:
    mov byte [player_vertical_speed], 2                                         ; 10e7: c6 06 76 05 02
loc_10ec:
    mov byte [player_vertical_acceleration_step], 1                             ; 10ec: c6 06 78 05 01
loc_10f1:
    mov byte [player_motion_accumulator], 0xff                                  ; 10f1: c6 06 77 05 ff
loc_10f6:
    mov byte [player_horizontal_direction], 0                                   ; 10f6: c6 06 6e 05 00
loc_10fb:
    mov byte [player_transition_blocked], 1                                     ; 10fb: c6 06 5a 05 01
loc_1100:
    mov ax, word [0xfac]                                                        ; 1100: a1 ac 0f
loc_1103:
    mov word [0x569], ax                                                        ; 1103: a3 69 05
loc_1106:
    mov ax, word [0xfb8]                                                        ; 1106: a1 b8 0f
loc_1109:
    mov word [0x567], ax                                                        ; 1109: a3 67 05
loc_110c:
    mov byte [player_alley_motion_mode], 2                                      ; 110c: c6 06 50 05 02
loc_1111:
    ret                                                                         ; 1111: c3
; CS:1112 — save_player_background_at_position
; Computes the CGA address from player X/Y, stores it at DS:055F, and calls the player background saver.
save_player_background_at_position:
    mov cx, word [player_x]                                                     ; 1112: 8b 0e 79 05
loc_1116:
    mov dl, byte [player_y]                                                     ; 1116: 8a 16 7b 05
loc_111a:
    call near calculate_cga_address                                             ; 111a: e8 93 1b
loc_111d:
    mov word [player_video_offset], ax                                          ; 111d: a3 5f 05
loc_1120:
    call near save_player_background                                            ; 1120: e8 01 00
loc_1123:
    ret                                                                         ; 1123: c3
; CS:1124 — save_player_background
; Copies the rectangle at B800:DS[055F] to DS:05FA using packed dimensions DS:0561; clears DS:0583.
save_player_background:
    mov ax, DATA_PARAGRAPH                                                      ; 1124: b8 10 00
loc_1127:
    mov es, ax                                                                  ; 1127: 8e c0
loc_1129:
    mov di, 0x5fa                                                               ; 1129: bf fa 05
loc_112c:
    push ds                                                                     ; 112c: 1e
loc_112d:
    mov si, word [player_video_offset]                                          ; 112d: 8b 36 5f 05
loc_1131:
    mov ax, 0xb800                                                              ; 1131: b8 00 b8
loc_1134:
    mov ds, ax                                                                  ; 1134: 8e d8
loc_1136:
    mov cx, word [es:0x561]                                                     ; 1136: 26 8b 0e 61 05
loc_113b:
    call near copy_rectangle_from_cga                                           ; 113b: e8 8c 1c
loc_113e:
    pop ds                                                                      ; 113e: 1f
loc_113f:
    mov byte [0x583], 0                                                         ; 113f: c6 06 83 05 00
loc_1144:
    ret                                                                         ; 1144: c3
; CS:1145 — draw_player_mask
; AND-blits the sprite at DS[055D] to B800:DS[055F], with dimensions DS:0565, saving overwritten bytes at DS:05FA.
draw_player_mask:
    mov ax, 0xb800                                                              ; 1145: b8 00 b8
loc_1148:
    mov es, ax                                                                  ; 1148: 8e c0
loc_114a:
    mov di, word [player_video_offset]                                          ; 114a: 8b 3e 5f 05
loc_114e:
    mov bp, 0x5fa                                                               ; 114e: bd fa 05
loc_1151:
    mov si, word [player_sprite_pointer]                                        ; 1151: 8b 36 5d 05
loc_1155:
    mov cx, word [player_draw_dimensions]                                       ; 1155: 8b 0e 65 05
loc_1159:
    mov word [player_saved_dimensions], cx                                      ; 1159: 89 0e 61 05
loc_115d:
    mov byte [0x583], 0                                                         ; 115d: c6 06 83 05 00
loc_1162:
    call near blit_and_mask                                                     ; 1162: e8 d0 1b
loc_1165:
    ret                                                                         ; 1165: c3
; CS:1166 — show_alley_impact
; Displays an 18-row impact sprite for ten BIOS ticks, restores the background, and decrements lives only if DS:1678 is nonzero and lives remain.
show_alley_impact:
    mov dl, byte [player_y]                                                     ; 1166: 8a 16 7b 05
loc_116a:
    mov cx, word [player_x]                                                     ; 116a: 8b 0e 79 05
loc_116e:
    sub cx, strict byte 0xc                                                     ; 116e: 83 e9 0c
loc_1171:
    jae loc_1175                                                                ; 1171: 73 02
loc_1173:
    load16 sub, cx, cx                                                          ; 1173: 2b c9
loc_1175:
    cmp cx, strict word 0x10f                                                   ; 1175: 81 f9 0f 01
loc_1179:
    jb loc_117e                                                                 ; 1179: 72 03
loc_117b:
    mov cx, 0x10e                                                               ; 117b: b9 0e 01
loc_117e:
    call near calculate_cga_address                                             ; 117e: e8 2f 1b
loc_1181:
    mov word [0x581], ax                                                        ; 1181: a3 81 05
loc_1184:
    load16 mov, di, ax                                                          ; 1184: 8b f8
loc_1186:
    mov ax, 0xb800                                                              ; 1186: b8 00 b8
loc_1189:
    mov es, ax                                                                  ; 1189: 8e c0
loc_118b:
    mov bp, 0xe                                                                 ; 118b: bd 0e 00
loc_118e:
    mov si, 0x1679                                                              ; 118e: be 79 16
loc_1191:
    mov cx, 0x1205                                                              ; 1191: b9 05 12
loc_1194:
    call near blit_zero_transparent                                             ; 1194: e8 35 1b
loc_1197:
    load8 sub, ah, ah                                                           ; 1197: 2a e4
loc_1199:
    int 0x1a                                                                    ; 1199: cd 1a
loc_119b:
    mov word [0x57f], dx                                                        ; 119b: 89 16 7f 05
loc_119f:
    mov word [0x5a3c], 0                                                        ; 119f: c7 06 3c 5a 00 00
loc_11a5:
    mov word [0x5a3e], 0                                                        ; 11a5: c7 06 3e 5a 00 00
loc_11ab:
    call near loc_5a1c                                                          ; 11ab: e8 6e 48
loc_11ae:
    load8 sub, ah, ah                                                           ; 11ae: 2a e4
loc_11b0:
    int 0x1a                                                                    ; 11b0: cd 1a
loc_11b2:
    sub dx, word [0x57f]                                                        ; 11b2: 2b 16 7f 05
loc_11b6:
    cmp dx, strict byte 0xa                                                     ; 11b6: 83 fa 0a
loc_11b9:
    jb loc_11ab                                                                 ; 11b9: 72 f0
loc_11bb:
    call near disable_speaker                                                   ; 11bb: e8 63 49
loc_11be:
    mov di, word [0x581]                                                        ; 11be: 8b 3e 81 05
loc_11c2:
    mov si, 0xe                                                                 ; 11c2: be 0e 00
loc_11c5:
    mov cx, 0x1205                                                              ; 11c5: b9 05 12
loc_11c8:
    mov byte [0x583], 0                                                         ; 11c8: c6 06 83 05 00
loc_11cd:
    call near copy_rectangle_to_cga                                             ; 11cd: e8 cd 1b
loc_11d0:
    cmp byte [alley_projectile_lethal], strict byte 0                           ; 11d0: 80 3e 78 16 00
loc_11d5:
    je loc_11e2                                                                 ; 11d5: 74 0b
loc_11d7:
    cmp byte [lives_remaining], strict byte 0                                   ; 11d7: 80 3e 80 1f 00
loc_11dc:
    je loc_11e2                                                                 ; 11dc: 74 04
loc_11de:
    dec byte [lives_remaining]                                                  ; 11de: fe 0e 80 1f
loc_11e2:
    ret                                                                         ; 11e2: c3
; CS:11e3 — restore_player_background
; Restores DS:05FA to the saved player video address using dimensions DS:0561.
restore_player_background:
    mov ax, 0xb800                                                              ; 11e3: b8 00 b8
loc_11e6:
    mov es, ax                                                                  ; 11e6: 8e c0
loc_11e8:
    mov di, word [player_video_offset]                                          ; 11e8: 8b 3e 5f 05
loc_11ec:
    mov si, 0x5fa                                                               ; 11ec: be fa 05
loc_11ef:
    mov cx, word [player_saved_dimensions]                                      ; 11ef: 8b 0e 61 05
loc_11f3:
    call near copy_rectangle_to_cga                                             ; 11f3: e8 a7 1b
loc_11f6:
    ret                                                                         ; 11f6: c3
    times 9 db 0 ; original zero fill at CS:11f7
