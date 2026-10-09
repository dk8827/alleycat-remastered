; Shared chasing enemy and capture.
; Original CS:1E40..2210 (end exclusive).

; CS:1e40 — initialize_chasing_enemy
; Resets DS:1CB8/1CBF/1CC0/1CC1 and enemy update state, sets enemy Y=177, and initializes its sound state; it is not solely a sound initializer.
initialize_chasing_enemy:
    mov byte [enemy_active], 0                                                  ; 1e40: c6 06 bf 1c 00
loc_1e45:
    mov word [enemy_update_counter], 0                                          ; 1e45: c7 06 e1 1c 00 00
loc_1e4b:
    mov byte [enemy_entry_phase], 0                                             ; 1e4b: c6 06 c0 1c 00
loc_1e50:
    mov byte [enemy_exit_phase], 0                                              ; 1e50: c6 06 c1 1c 00
loc_1e55:
    mov byte [enemy_capture_direction], 0                                       ; 1e55: c6 06 b8 1c 00
loc_1e5a:
    mov byte [enemy_y], 0xb1                                                    ; 1e5a: c6 06 c8 1c b1
loc_1e5f:
    call near loc_5450                                                          ; 1e5f: e8 ee 35
loc_1e62:
    ret                                                                         ; 1e62: c3
; CS:1e63 — update_chasing_enemy
; Alternates one/two-tick intervals and requires retrace; ground-level entry uses a strict difficulty threshold, pursuit uses an inclusive threshold, and forced entry bypasses both ground and entry probability. Capture completion loses a life in the alley or sets room failure DDh.
update_chasing_enemy:
    load8 sub, ah, ah                                                           ; 1e63: 2a e4
loc_1e65:
    int 0x1a                                                                    ; 1e65: cd 1a
loc_1e67:
    load16 mov, cx, dx                                                          ; 1e67: 8b ca
loc_1e69:
    sub dx, word [enemy_last_update_tick]                                       ; 1e69: 2b 16 c9 1c
loc_1e6d:
    mov ax, word [enemy_update_counter]                                         ; 1e6d: a1 e1 1c
loc_1e70:
    and ax, strict word 1                                                       ; 1e70: 25 01 00
loc_1e73:
    add ax, strict word 1                                                       ; 1e73: 05 01 00
loc_1e76:
    load16 cmp, dx, ax                                                          ; 1e76: 3b d0
loc_1e78:
    jae loc_1e7b                                                                ; 1e78: 73 01
loc_1e7a:
    ret                                                                         ; 1e7a: c3
loc_1e7b:
    call near read_cga_vertical_retrace_bit                                     ; 1e7b: e8 5a f5
loc_1e7e:
    je loc_1e7a                                                                 ; 1e7e: 74 fa
loc_1e80:
    mov word [enemy_last_update_tick], cx                                       ; 1e80: 89 0e c9 1c
loc_1e84:
    inc word [enemy_update_counter]                                             ; 1e84: ff 06 e1 1c
loc_1e88:
    cmp byte [enemy_exit_phase], strict byte 0                                  ; 1e88: 80 3e c1 1c 00
loc_1e8d:
    je loc_1ee2                                                                 ; 1e8d: 74 53
loc_1e8f:
    dec byte [enemy_exit_phase]                                                 ; 1e8f: fe 0e c1 1c
loc_1e93:
    jne loc_1ec9                                                                ; 1e93: 75 34
loc_1e95:
    call near disable_speaker                                                   ; 1e95: e8 89 3c
loc_1e98:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 1e98: 80 3e b8 1c 00
loc_1e9d:
    je loc_1ec2                                                                 ; 1e9d: 74 23
loc_1e9f:
    cmp word [scene_index], strict byte 0                                       ; 1e9f: 83 3e 04 00 00
loc_1ea4:
    je loc_1eb7                                                                 ; 1ea4: 74 11
loc_1ea6:
    mov byte [scene_failed], 0xdd                                               ; 1ea6: c6 06 52 05 dd
loc_1eab:
    mov word [player_x], 0xa0                                                   ; 1eab: c7 06 79 05 a0 00
loc_1eb1:
    mov byte [player_y], 0x60                                                   ; 1eb1: c6 06 7b 05 60
loc_1eb6:
    ret                                                                         ; 1eb6: c3
loc_1eb7:
    cmp byte [lives_remaining], strict byte 0                                   ; 1eb7: 80 3e 80 1f 00
loc_1ebc:
    je loc_1ec2                                                                 ; 1ebc: 74 04
loc_1ebe:
    dec byte [lives_remaining]                                                  ; 1ebe: fe 0e 80 1f
loc_1ec2:
    call near loc_20e1                                                          ; 1ec2: e8 1c 02
loc_1ec5:
    call near initialize_chasing_enemy                                          ; 1ec5: e8 78 ff
loc_1ec8:
    ret                                                                         ; 1ec8: c3
loc_1ec9:
    call near loc_2022                                                          ; 1ec9: e8 56 01
loc_1ecc:
    mov ax, 0x104                                                               ; 1ecc: b8 04 01
loc_1ecf:
    sub al, byte [enemy_exit_phase]                                             ; 1ecf: 2a 06 c1 1c
loc_1ed3:
    cmp byte [enemy_horizontal_direction], strict byte 0xff                     ; 1ed3: 80 3e d0 1c ff
loc_1ed8:
    je loc_1edc                                                                 ; 1ed8: 74 02
loc_1eda:
    mov ah, 0xff                                                                ; 1eda: b4 ff
loc_1edc:
    call near loc_2059                                                          ; 1edc: e8 7a 01
loc_1edf:
    jmp near loc_1ffb                                                           ; 1edf: e9 19 01
loc_1ee2:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 1ee2: 80 3e b8 1c 00
loc_1ee7:
    je loc_1f0c                                                                 ; 1ee7: 74 23
loc_1ee9:
    mov dl, byte [enemy_capture_direction]                                      ; 1ee9: 8a 16 b8 1c
loc_1eed:
    cmp word [enemy_capture_delay], strict byte 0                               ; 1eed: 83 3e b9 1c 00
loc_1ef2:
    je loc_1f02                                                                 ; 1ef2: 74 0e
loc_1ef4:
    dec word [enemy_capture_delay]                                              ; 1ef4: ff 0e b9 1c
loc_1ef8:
    call near update_random_state                                               ; 1ef8: e8 02 0f
loc_1efb:
    and dl, strict byte 1                                                       ; 1efb: 80 e2 01
loc_1efe:
    jne loc_1f02                                                                ; 1efe: 75 02
loc_1f00:
    mov dl, 0xff                                                                ; 1f00: b2 ff
loc_1f02:
    mov byte [enemy_horizontal_direction], dl                                   ; 1f02: 88 16 d0 1c
loc_1f06:
    mov ax, word [enemy_x]                                                      ; 1f06: a1 c6 1c
loc_1f09:
    jmp near loc_1fab                                                           ; 1f09: e9 9f 00
loc_1f0c:
    cmp byte [enemy_active], strict byte 0                                      ; 1f0c: 80 3e bf 1c 00
loc_1f11:
    jne loc_1f75                                                                ; 1f11: 75 62
loc_1f13:
    cmp byte [enemy_entry_phase], strict byte 0                                 ; 1f13: 80 3e c0 1c 00
loc_1f18:
    jne loc_1f57                                                                ; 1f18: 75 3d
loc_1f1a:
    cmp byte [enemy_forced_entry], strict byte 0                                            ; 1f1a: 80 3e 58 1d 00
loc_1f1f:
    jne loc_1f3d                                                                ; 1f1f: 75 1c
loc_1f21:
    cmp byte [player_y], strict byte 0xb4                                       ; 1f21: 80 3e 7b 05 b4
loc_1f26:
    jb loc_1f3c                                                                 ; 1f26: 72 14
loc_1f28:
    cmp byte [0x558], strict byte 0                                             ; 1f28: 80 3e 58 05 00
loc_1f2d:
    jne loc_1f3c                                                                ; 1f2d: 75 0d
loc_1f2f:
    call near update_random_state                                               ; 1f2f: e8 cb 0e
loc_1f32:
    mov bx, word [difficulty_level]                                             ; 1f32: 8b 1e 08 00
loc_1f36:
    cmp dl, byte [bx + enemy_spawn_thresholds]                                                  ; 1f36: 3a 97 d1 1c
loc_1f3a:
    jb loc_1f3d                                                                 ; 1f3a: 72 01
loc_1f3c:
    ret                                                                         ; 1f3c: c3
loc_1f3d:
    mov al, 1                                                                   ; 1f3d: b0 01
loc_1f3f:
    mov word [0x59ba], 0                                                        ; 1f3f: c7 06 ba 59 00 00
loc_1f45:
    cmp word [player_x], strict word 0xa0                                       ; 1f45: 81 3e 79 05 a0 00
loc_1f4b:
    jae loc_1f4f                                                                ; 1f4b: 73 02
loc_1f4d:
    mov al, 0xff                                                                ; 1f4d: b0 ff
loc_1f4f:
    mov byte [enemy_horizontal_direction], al                                   ; 1f4f: a2 d0 1c
loc_1f52:
    mov byte [enemy_entry_phase], 4                                             ; 1f52: c6 06 c0 1c 04
loc_1f57:
    dec byte [enemy_entry_phase]                                                ; 1f57: fe 0e c0 1c
loc_1f5b:
    jne loc_1f65                                                                ; 1f5b: 75 08
loc_1f5d:
    mov byte [enemy_active], 1                                                  ; 1f5d: c6 06 bf 1c 01
loc_1f62:
    jmp short loc_1f75                                                          ; 1f62: eb 11
loc_1f64:
    nop                                                                         ; 1f64: 90
loc_1f65:
    call near loc_2022                                                          ; 1f65: e8 ba 00
loc_1f68:
    mov al, byte [enemy_entry_phase]                                            ; 1f68: a0 c0 1c
loc_1f6b:
    mov ah, byte [enemy_horizontal_direction]                                   ; 1f6b: 8a 26 d0 1c
loc_1f6f:
    call near loc_2059                                                          ; 1f6f: e8 e7 00
loc_1f72:
    jmp near loc_1ffb                                                           ; 1f72: e9 86 00
loc_1f75:
    mov byte [enemy_forced_entry], 0                                                        ; 1f75: c6 06 58 1d 00
loc_1f7a:
    mov ax, word [enemy_x]                                                      ; 1f7a: a1 c6 1c
loc_1f7d:
    cmp byte [player_y], strict byte 0xb4                                       ; 1f7d: 80 3e 7b 05 b4
loc_1f82:
    jb loc_1fab                                                                 ; 1f82: 72 27
loc_1f84:
    cmp byte [0x558], strict byte 0                                             ; 1f84: 80 3e 58 05 00
loc_1f89:
    jne loc_1fab                                                                ; 1f89: 75 20
loc_1f8b:
    call near update_random_state                                               ; 1f8b: e8 6f 0e
loc_1f8e:
    mov bx, word [difficulty_level]                                             ; 1f8e: 8b 1e 08 00
loc_1f92:
    cmp dl, byte [bx + enemy_pursuit_thresholds]                                                  ; 1f92: 3a 97 d9 1c
loc_1f96:
    ja loc_1fab                                                                 ; 1f96: 77 13
loc_1f98:
    cmp ax, word [player_x]                                                     ; 1f98: 3b 06 79 05
loc_1f9c:
    ja loc_1fa6                                                                 ; 1f9c: 77 08
loc_1f9e:
    mov byte [enemy_horizontal_direction], 1                                    ; 1f9e: c6 06 d0 1c 01
loc_1fa3:
    jmp short loc_1fab                                                          ; 1fa3: eb 06
loc_1fa5:
    nop                                                                         ; 1fa5: 90
loc_1fa6:
    mov byte [enemy_horizontal_direction], 0xff                                 ; 1fa6: c6 06 d0 1c ff
loc_1fab:
    cmp byte [enemy_horizontal_direction], strict byte 1                        ; 1fab: 80 3e d0 1c 01
loc_1fb0:
    jb loc_1fef                                                                 ; 1fb0: 72 3d
loc_1fb2:
    je loc_1fe2                                                                 ; 1fb2: 74 2e
loc_1fb4:
    sub ax, strict word 8                                                       ; 1fb4: 2d 08 00
loc_1fb7:
    jae loc_1fef                                                                ; 1fb7: 73 36
loc_1fb9:
    load16 sub, ax, ax                                                          ; 1fb9: 2b c0
loc_1fbb:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 1fbb: 80 3e b8 1c 00
loc_1fc0:
    je loc_1fcc                                                                 ; 1fc0: 74 0a
loc_1fc2:
    cmp word [enemy_capture_delay], strict byte 0                               ; 1fc2: 83 3e b9 1c 00
loc_1fc7:
    jne loc_1fef                                                                ; 1fc7: 75 26
loc_1fc9:
    jmp short loc_1fda                                                          ; 1fc9: eb 0f
loc_1fcb:
    nop                                                                         ; 1fcb: 90
loc_1fcc:
    cmp byte [player_y], strict byte 0xb4                                       ; 1fcc: 80 3e 7b 05 b4
loc_1fd1:
    jb loc_1fda                                                                 ; 1fd1: 72 07
loc_1fd3:
    cmp byte [0x558], strict byte 0                                             ; 1fd3: 80 3e 58 05 00
loc_1fd8:
    je loc_1fef                                                                 ; 1fd8: 74 15
loc_1fda:
    mov byte [enemy_exit_phase], 4                                              ; 1fda: c6 06 c1 1c 04
loc_1fdf:
    jmp short loc_1fef                                                          ; 1fdf: eb 0e
loc_1fe1:
    nop                                                                         ; 1fe1: 90
loc_1fe2:
    add ax, strict word 8                                                       ; 1fe2: 05 08 00
loc_1fe5:
    cmp ax, strict word 0x11e                                                   ; 1fe5: 3d 1e 01
loc_1fe8:
    jb loc_1fef                                                                 ; 1fe8: 72 05
loc_1fea:
    mov ax, 0x11e                                                               ; 1fea: b8 1e 01
loc_1fed:
    jmp short loc_1fbb                                                          ; 1fed: eb cc
loc_1fef:
    mov word [enemy_x], ax                                                      ; 1fef: a3 c6 1c
loc_1ff2:
    call near loc_2022                                                          ; 1ff2: e8 2d 00
loc_1ff5:
    mov word [enemy_draw_dimensions], 0xf04                                     ; 1ff5: c7 06 c4 1c 04 0f
loc_1ffb:
    mov cx, word [enemy_x]                                                      ; 1ffb: 8b 0e c6 1c
loc_1fff:
    mov dl, byte [enemy_y]                                                      ; 1fff: 8a 16 c8 1c
loc_2003:
    call near calculate_cga_address                                             ; 2003: e8 aa 0c
loc_2006:
    mov word [0x1ccd], ax                                                       ; 2006: a3 cd 1c
loc_2009:
    cmp byte [enemy_entry_phase], strict byte 3                                 ; 2009: 80 3e c0 1c 03
loc_200e:
    je loc_2013                                                                 ; 200e: 74 03
loc_2010:
    call near loc_20e1                                                          ; 2010: e8 ce 00
loc_2013:
    call near check_chasing_enemy_contact                                       ; 2013: e8 df 00
loc_2016:
    jb loc_2021                                                                 ; 2016: 72 09
loc_2018:
    mov ax, word [0x1ccd]                                                       ; 2018: a1 cd 1c
loc_201b:
    mov word [enemy_video_offset], ax                                           ; 201b: a3 bd 1c
loc_201e:
    call near loc_209b                                                          ; 201e: e8 7a 00
loc_2021:
    ret                                                                         ; 2021: c3
loc_2022:
    load8 sub, bh, bh                                                           ; 2022: 2a ff
loc_2024:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 2024: 80 3e b8 1c 00
loc_2029:
    je loc_203b                                                                 ; 2029: 74 10
loc_202b:
    inc byte [0x1ccf]                                                           ; 202b: fe 06 cf 1c
loc_202f:
    mov bl, byte [0x1ccf]                                                       ; 202f: 8a 1e cf 1c
loc_2033:
    and bl, strict byte 6                                                       ; 2033: 80 e3 06
loc_2036:
    or bl, strict byte 8                                                        ; 2036: 80 cb 08
loc_2039:
    jne loc_2051                                                                ; 2039: 75 16
loc_203b:
    add byte [0x1ccf], strict byte 2                                            ; 203b: 80 06 cf 1c 02
loc_2040:
    mov bl, byte [0x1ccf]                                                       ; 2040: 8a 1e cf 1c
loc_2044:
    and bl, strict byte 2                                                       ; 2044: 80 e3 02
loc_2047:
    cmp byte [enemy_horizontal_direction], strict byte 1                        ; 2047: 80 3e d0 1c 01
loc_204c:
    jne loc_2051                                                                ; 204c: 75 03
loc_204e:
    or bl, strict byte 4                                                        ; 204e: 80 cb 04
loc_2051:
    mov ax, word [bx + 0x15c8]                                                  ; 2051: 8b 87 c8 15
loc_2055:
    mov word [enemy_sprite_pointer], ax                                         ; 2055: a3 bb 1c
loc_2058:
    ret                                                                         ; 2058: c3
loc_2059:
    mov cx, 0xf04                                                               ; 2059: b9 04 0f
loc_205c:
    load8 sub, cl, al                                                           ; 205c: 2a c8
loc_205e:
    mov word [enemy_draw_dimensions], cx                                        ; 205e: 89 0e c4 1c
loc_2062:
    cmp ah, strict byte 0xff                                                    ; 2062: 80 fc ff
loc_2065:
    je loc_2078                                                                 ; 2065: 74 11
loc_2067:
    load8 sub, ah, ah                                                           ; 2067: 2a e4
loc_2069:
    shl al, 1                                                                   ; 2069: d0 e0
loc_206b:
    add word [enemy_sprite_pointer], ax                                         ; 206b: 01 06 bb 1c
loc_206f:
    mov word [enemy_x], 0                                                       ; 206f: c7 06 c6 1c 00 00
loc_2075:
    jmp short loc_2086                                                          ; 2075: eb 0f
loc_2077:
    nop                                                                         ; 2077: 90
loc_2078:
    load8 sub, ah, ah                                                           ; 2078: 2a e4
loc_207a:
    shl al, 1                                                                   ; 207a: d0 e0
loc_207c:
    shl al, 1                                                                   ; 207c: d0 e0
loc_207e:
    shl al, 1                                                                   ; 207e: d0 e0
loc_2080:
    add ax, strict word 0x120                                                   ; 2080: 05 20 01
loc_2083:
    mov word [enemy_x], ax                                                      ; 2083: a3 c6 1c
loc_2086:
    push ds                                                                     ; 2086: 1e
loc_2087:
    pop es                                                                      ; 2087: 07
loc_2088:
    mov si, word [enemy_sprite_pointer]                                         ; 2088: 8b 36 bb 1c
loc_208c:
    mov di, 0xe                                                                 ; 208c: bf 0e 00
loc_208f:
    mov al, 4                                                                   ; 208f: b0 04
loc_2091:
    call near copy_rows_with_source_stride                                      ; 2091: e8 dc 0c
loc_2094:
    mov word [enemy_sprite_pointer], 0xe                                        ; 2094: c7 06 bb 1c 0e 00
loc_209a:
    ret                                                                         ; 209a: c3
loc_209b:
    mov cx, word [enemy_draw_dimensions]                                        ; 209b: 8b 0e c4 1c
loc_209f:
    mov word [enemy_saved_dimensions], cx                                       ; 209f: 89 0e c2 1c
loc_20a3:
    mov ax, 0xb800                                                              ; 20a3: b8 00 b8
loc_20a6:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 20a6: 80 3e b8 1c 00
loc_20ab:
    jne loc_20be                                                                ; 20ab: 75 11
loc_20ad:
    mov es, ax                                                                  ; 20ad: 8e c0
loc_20af:
    mov di, word [enemy_video_offset]                                           ; 20af: 8b 3e bd 1c
loc_20b3:
    mov si, word [enemy_sprite_pointer]                                         ; 20b3: 8b 36 bb 1c
loc_20b7:
    mov bp, 0x1c40                                                              ; 20b7: bd 40 1c
loc_20ba:
    call near blit_zero_transparent                                             ; 20ba: e8 0f 0c
loc_20bd:
    ret                                                                         ; 20bd: c3
loc_20be:
    push ds                                                                     ; 20be: 1e
loc_20bf:
    mov ds, ax                                                                  ; 20bf: 8e d8
loc_20c1:
    pop es                                                                      ; 20c1: 07
loc_20c2:
    push es                                                                     ; 20c2: 06
loc_20c3:
    push ds                                                                     ; 20c3: 1e
loc_20c4:
    mov si, word [es:enemy_video_offset]                                        ; 20c4: 26 8b 36 bd 1c
loc_20c9:
    mov di, 0x1c40                                                              ; 20c9: bf 40 1c
loc_20cc:
    call near copy_rectangle_from_cga                                           ; 20cc: e8 fb 0c
loc_20cf:
    pop es                                                                      ; 20cf: 07
loc_20d0:
    pop ds                                                                      ; 20d0: 1f
loc_20d1:
    mov si, word [enemy_sprite_pointer]                                         ; 20d1: 8b 36 bb 1c
loc_20d5:
    mov di, word [enemy_video_offset]                                           ; 20d5: 8b 3e bd 1c
loc_20d9:
    mov cx, word [enemy_draw_dimensions]                                        ; 20d9: 8b 0e c4 1c
loc_20dd:
    call near copy_rectangle_to_cga                                             ; 20dd: e8 bd 0c
loc_20e0:
    ret                                                                         ; 20e0: c3
loc_20e1:
    mov ax, 0xb800                                                              ; 20e1: b8 00 b8
loc_20e4:
    mov es, ax                                                                  ; 20e4: 8e c0
loc_20e6:
    mov di, word [enemy_video_offset]                                           ; 20e6: 8b 3e bd 1c
loc_20ea:
    mov si, 0x1c40                                                              ; 20ea: be 40 1c
loc_20ed:
    mov cx, word [enemy_saved_dimensions]                                       ; 20ed: 8b 0e c2 1c
loc_20f1:
    call near copy_rectangle_to_cga                                             ; 20f1: e8 a9 0c
loc_20f4:
    ret                                                                         ; 20f4: c3
; CS:20f5 — check_chasing_enemy_contact
; Requires an active or animating enemy, uncaptured player at Y>=163 and clear DS:0558; tests horizontal overlap before starting capture.
check_chasing_enemy_contact:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 20f5: 80 3e b8 1c 00
loc_20fa:
    jne loc_2134                                                                ; 20fa: 75 38
loc_20fc:
    mov al, byte [enemy_active]                                                 ; 20fc: a0 bf 1c
loc_20ff:
    or al, byte [enemy_entry_phase]                                             ; 20ff: 0a 06 c0 1c
loc_2103:
    or al, byte [enemy_exit_phase]                                              ; 2103: 0a 06 c1 1c
loc_2107:
    je loc_2134                                                                 ; 2107: 74 2b
loc_2109:
    cmp byte [player_y], strict byte 0xa3                                       ; 2109: 80 3e 7b 05 a3
loc_210e:
    jb loc_2134                                                                 ; 210e: 72 24
loc_2110:
    cmp byte [0x558], strict byte 0                                             ; 2110: 80 3e 58 05 00
loc_2115:
    jne loc_2134                                                                ; 2115: 75 1d
loc_2117:
    mov ax, word [enemy_x]                                                      ; 2117: a1 c6 1c
loc_211a:
    add ax, strict word 0x20                                                    ; 211a: 05 20 00
loc_211d:
    cmp ax, word [player_x]                                                     ; 211d: 3b 06 79 05
loc_2121:
    jb loc_2134                                                                 ; 2121: 72 11
loc_2123:
    sub ax, strict word 0x38                                                    ; 2123: 2d 38 00
loc_2126:
    jae loc_212a                                                                ; 2126: 73 02
loc_2128:
    load16 sub, ax, ax                                                          ; 2128: 2b c0
loc_212a:
    cmp ax, word [player_x]                                                     ; 212a: 3b 06 79 05
loc_212e:
    ja loc_2134                                                                 ; 212e: 77 04
loc_2130:
    call near start_chasing_enemy_capture                                       ; 2130: e8 03 00
loc_2133:
    ret                                                                         ; 2133: c3
loc_2134:
    clc                                                                         ; 2134: f8
loc_2135:
    ret                                                                         ; 2135: c3
; CS:2136 — start_chasing_enemy_capture
; Sets capture direction and distance delay, moves the player to the opposite edge, and initializes special food-room capture graphics; alley capture respawns the player immediately.
start_chasing_enemy_capture:
    cmp word [scene_index], strict byte 6                                       ; 2136: 83 3e 04 00 06
loc_213b:
    jne loc_2149                                                                ; 213b: 75 0c
loc_213d:
    mov al, byte [player_y]                                                     ; 213d: a0 7b 05
loc_2140:
    mov byte [enemy_y], al                                                      ; 2140: a2 c8 1c
loc_2143:
    mov ax, word [player_x]                                                     ; 2143: a1 79 05
loc_2146:
    mov word [enemy_x], ax                                                      ; 2146: a3 c6 1c
loc_2149:
    mov ax, word [enemy_x]                                                      ; 2149: a1 c6 1c
loc_214c:
    add ax, word [player_x]                                                     ; 214c: 03 06 79 05
loc_2150:
    shr ax, 1                                                                   ; 2150: d1 e8
loc_2152:
    cmp ax, strict word 0x118                                                   ; 2152: 3d 18 01
loc_2155:
    jb loc_215a                                                                 ; 2155: 72 03
loc_2157:
    mov ax, 0x117                                                               ; 2157: b8 17 01
loc_215a:
    mov word [enemy_x], ax                                                      ; 215a: a3 c6 1c
loc_215d:
    mov bl, 1                                                                   ; 215d: b3 01
loc_215f:
    cmp ax, strict word 0xa0                                                    ; 215f: 3d a0 00
loc_2162:
    ja loc_216e                                                                 ; 2162: 77 0a
loc_2164:
    mov bl, 0xff                                                                ; 2164: b3 ff
loc_2166:
    mov dx, 0xa1                                                                ; 2166: ba a1 00
loc_2169:
    load16 sub, dx, ax                                                          ; 2169: 2b d0
loc_216b:
    jmp short loc_2173                                                          ; 216b: eb 06
loc_216d:
    nop                                                                         ; 216d: 90
loc_216e:
    sub ax, strict word 0x9f                                                    ; 216e: 2d 9f 00
loc_2171:
    load16 mov, dx, ax                                                          ; 2171: 8b d0
loc_2173:
    mov byte [enemy_capture_direction], bl                                      ; 2173: 88 1e b8 1c
loc_2177:
    mov byte [enemy_active], 1                                                  ; 2177: c6 06 bf 1c 01
loc_217c:
    mov byte [enemy_exit_phase], 0                                              ; 217c: c6 06 c1 1c 00
loc_2181:
    mov cl, 3                                                                   ; 2181: b1 03
loc_2183:
    shr dx, cl                                                                  ; 2183: d3 ea
loc_2185:
    mov word [enemy_capture_delay], dx                                          ; 2185: 89 16 b9 1c
loc_2189:
    cmp word [scene_index], strict byte 6                                       ; 2189: 83 3e 04 00 06
loc_218e:
    jne loc_21bd                                                                ; 218e: 75 2d
loc_2190:
    call near restore_player_background                                         ; 2190: e8 50 f0
loc_2193:
    mov al, byte [enemy_capture_direction]                                      ; 2193: a0 b8 1c
loc_2196:
    push ax                                                                     ; 2196: 50
loc_2197:
    mov byte [enemy_capture_direction], 0                                       ; 2197: c6 06 b8 1c 00
loc_219c:
    mov word [enemy_draw_dimensions], 0xf04                                     ; 219c: c7 06 c4 1c 04 0f
loc_21a2:
    mov ax, word [0x15c8]                                                       ; 21a2: a1 c8 15
loc_21a5:
    mov word [enemy_sprite_pointer], ax                                         ; 21a5: a3 bb 1c
loc_21a8:
    mov cx, word [enemy_x]                                                      ; 21a8: 8b 0e c6 1c
loc_21ac:
    mov dl, byte [enemy_y]                                                      ; 21ac: 8a 16 c8 1c
loc_21b0:
    call near calculate_cga_address                                             ; 21b0: e8 fd 0a
loc_21b3:
    mov word [enemy_video_offset], ax                                           ; 21b3: a3 bd 1c
loc_21b6:
    call near loc_209b                                                          ; 21b6: e8 e2 fe
loc_21b9:
    pop ax                                                                      ; 21b9: 58
loc_21ba:
    mov byte [enemy_capture_direction], al                                      ; 21ba: a2 b8 1c
loc_21bd:
    call near loc_20e1                                                          ; 21bd: e8 21 ff
loc_21c0:
    call near restore_player_background                                         ; 21c0: e8 20 f0
loc_21c3:
    mov ax, 0                                                                   ; 21c3: b8 00 00
loc_21c6:
    cmp word [player_x], strict word 0xa0                                       ; 21c6: 81 3e 79 05 a0 00
loc_21cc:
    jae loc_21d1                                                                ; 21cc: 73 03
loc_21ce:
    mov ax, 0x122                                                               ; 21ce: b8 22 01
loc_21d1:
    mov word [player_x], ax                                                     ; 21d1: a3 79 05
loc_21d4:
    cmp word [scene_index], strict byte 0                                       ; 21d4: 83 3e 04 00 00
loc_21d9:
    jne loc_21de                                                                ; 21d9: 75 03
loc_21db:
    call near initialize_alley_player                                           ; 21db: e8 2f e5
loc_21de:
    stc                                                                         ; 21de: f9
loc_21df:
    ret                                                                         ; 21df: c3
loc_21e0:
    mov al, byte [enemy_active]                                                 ; 21e0: a0 bf 1c
loc_21e3:
    or al, byte [enemy_entry_phase]                                             ; 21e3: 0a 06 c0 1c
loc_21e7:
    or al, byte [enemy_exit_phase]                                              ; 21e7: 0a 06 c1 1c
loc_21eb:
    je loc_2209                                                                 ; 21eb: 74 1c
loc_21ed:
    mov ax, word [shared_object_x]                                                       ; 21ed: a1 7d 32
loc_21f0:
    mov dl, byte [shared_object_y]                                                       ; 21f0: 8a 16 7f 32
loc_21f4:
    mov si, 0x10                                                                ; 21f4: be 10 00
loc_21f7:
    mov bx, word [enemy_x]                                                      ; 21f7: 8b 1e c6 1c
loc_21fb:
    mov dh, byte [enemy_y]                                                      ; 21fb: 8a 36 c8 1c
loc_21ff:
    mov di, 0x20                                                                ; 21ff: bf 20 00
loc_2202:
    mov cx, 0xf1e                                                               ; 2202: b9 1e 0f
loc_2205:
    call near rectangles_overlap                                                ; 2205: e8 21 0c
loc_2208:
    ret                                                                         ; 2208: c3
loc_2209:
    clc                                                                         ; 2209: f8
loc_220a:
    ret                                                                         ; 220a: c3
    times 5 db 0 ; original zero fill at CS:220b
