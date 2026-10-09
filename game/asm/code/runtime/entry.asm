; Startup, main loop and scene dispatch.
; Original CS:0000..04A0 (end exclusive).

; CS:0000 — entry
; Saves PSP:0000 as a far-return destination, checks the display, loads relocated DS, initializes keyboard handling, and enters the scene loop.
entry:
    push ds                                                                     ; 0000: 1e
loc_0001:
    mov ax, 0                                                                   ; 0001: b8 00 00
loc_0004:
    push ax                                                                     ; 0004: 50
loc_0005:
    call near check_color_adapter                                               ; 0005: e8 58 5c
loc_0008:
    mov ax, DATA_PARAGRAPH                                                      ; 0008: b8 10 00
loc_000b:
    mov ds, ax                                                                  ; 000b: 8e d8
loc_000d:
    call near read_bios_model_byte                                              ; 000d: e8 9a 13
loc_0010:
    mov byte [0x690], 4                                                         ; 0010: c6 06 90 06 04
loc_0015:
    mov word [selected_difficulty], 0                                           ; 0015: c7 06 f8 6d 00 00
loc_001b:
    mov byte [joystick_enabled], 0                                              ; 001b: c6 06 9b 06 00
loc_0020:
    call near install_interrupt_vectors                                         ; 0020: e8 f6 13
loc_0023:
    call near reset_keyboard_state                                              ; 0023: e8 c2 13
loc_0026:
    mov ax, word [keyboard_event_counter]                                       ; 0026: a1 93 06
loc_0029:
    add ax, strict word 0x240                                                   ; 0029: 05 40 02
loc_002c:
    mov word [pause_keyboard_counter], ax                                       ; 002c: a3 00 6e
loc_002f:
    mov ax, 4                                                                   ; 002f: b8 04 00
loc_0032:
    int 0x10                                                                    ; 0032: cd 10
loc_0034:
    mov al, 4                                                                   ; 0034: b0 04
loc_0036:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 0036: 80 3e 97 06 fd
loc_003b:
    je loc_003f                                                                 ; 003b: 74 02
loc_003d:
    mov al, 6                                                                   ; 003d: b0 06
loc_003f:
    mov byte [0x690], al                                                        ; 003f: a2 90 06
loc_0042:
    mov ah, 0xb                                                                 ; 0042: b4 0b
loc_0044:
    mov bx, 0x101                                                               ; 0044: bb 01 01
loc_0047:
    int 0x10                                                                    ; 0047: cd 10
loc_0049:
    mov word [0x416], 0                                                         ; 0049: c7 06 16 04 00 00
loc_004f:
    mov word [scene_index], 0                                                   ; 004f: c7 06 04 00 00 00
loc_0055:
    call near configure_scene_palette                                           ; 0055: e8 d9 1c
loc_0058:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 0058: 80 3e 97 06 fd
loc_005d:
    je loc_0065                                                                 ; 005d: 74 06
loc_005f:
    mov dx, 0x3d9                                                               ; 005f: ba d9 03
loc_0062:
    mov al, 0x20                                                                ; 0062: b0 20
loc_0064:
    out dx, al                                                                  ; 0064: ee
loc_0065:
    call near seed_random_from_pit                                              ; 0065: e8 a8 2d
loc_0068:
    call near clear_high_score                                                  ; 0068: e8 76 26
loc_006b:
    call near clear_current_score                                               ; 006b: e8 6c 26
loc_006e:
    mov byte [0x41a], 0                                                         ; 006e: c6 06 1a 04 00
loc_0073:
    mov ax, 0xffff                                                              ; 0073: b8 ff ff
loc_0076:
    mov word [0x41d], ax                                                        ; 0076: a3 1d 04
loc_0079:
    mov word [0x41f], ax                                                        ; 0079: a3 1f 04
loc_007c:
    mov byte [sound_enabled], 0xff                                              ; 007c: c6 06 00 00 ff
loc_0081:
    call near update_high_score_if_greater                                      ; 0081: e8 0c 26
loc_0084:
    mov word [difficulty_level], 0                                              ; 0084: c7 06 08 00 00 00
loc_008a:
    mov word [scene_index], 0                                                   ; 008a: c7 06 04 00 00 00
loc_0090:
    call near configure_scene_palette                                           ; 0090: e8 9e 1c
loc_0093:
    call near disable_speaker                                                   ; 0093: e8 8b 5a
loc_0096:
    call near run_title_screen                                                  ; 0096: e8 17 5c
loc_0099:
    call near disable_speaker                                                   ; 0099: e8 85 5a
loc_009c:
    cmp byte [0x41a], strict byte 0                                             ; 009c: 80 3e 1a 04 00
loc_00a1:
    jne loc_00ae                                                                ; 00a1: 75 0b
loc_00a3:
    call near disable_speaker                                                   ; 00a3: e8 7b 5a
loc_00a6:
    call near run_control_difficulty_menu                                       ; 00a6: e8 3c 5e
loc_00a9:
    mov byte [0x41a], 1                                                         ; 00a9: c6 06 1a 04 01
loc_00ae:
    mov ax, word [selected_difficulty]                                          ; 00ae: a1 f8 6d
loc_00b1:
    mov word [difficulty_level], ax                                             ; 00b1: a3 08 00
loc_00b4:
    mov byte [lives_remaining], 3                                               ; 00b4: c6 06 80 1f 03
loc_00b9:
    call near clear_current_score                                               ; 00b9: e8 1e 26
loc_00bc:
    mov word [scene_index], 0                                                   ; 00bc: c7 06 04 00 00 00
loc_00c2:
    call near configure_scene_palette                                           ; 00c2: e8 6c 1c
loc_00c5:
    call near disable_speaker                                                   ; 00c5: e8 59 5a
loc_00c8:
    mov word [0x1c30], 0                                                        ; 00c8: c7 06 30 1c 00 00
loc_00ce:
    load8 sub, ah, ah                                                           ; 00ce: 2a e4
loc_00d0:
    int 0x1a                                                                    ; 00d0: cd 1a
loc_00d2:
    mov word [courtship_cycle_start_tick], dx                                   ; 00d2: 89 16 12 04
loc_00d6:
    mov word [completed_room_count], 0                                          ; 00d6: c7 06 14 04 00 00
loc_00dc:
    mov byte [courtship_pending], 0                                             ; 00dc: c6 06 18 04 00
loc_00e1:
    mov byte [0x419], 0                                                         ; 00e1: c6 06 19 04 00
loc_00e6:
    mov byte [menu_requested], 0                                                ; 00e6: c6 06 1c 04 00
loc_00eb:
    mov byte [restart_requested], 0                                             ; 00eb: c6 06 1b 04 00
loc_00f0:
    call near disable_speaker                                                   ; 00f0: e8 2e 5a
loc_00f3:
    cmp byte [lives_remaining], strict byte 0                                   ; 00f3: 80 3e 80 1f 00
loc_00f8:
    je loc_0081                                                                 ; 00f8: 74 87
loc_00fa:
    cmp byte [restart_requested], strict byte 0                                 ; 00fa: 80 3e 1b 04 00
loc_00ff:
    jne loc_00ae                                                                ; 00ff: 75 ad
loc_0101:
    cmp byte [menu_requested], strict byte 0                                    ; 0101: 80 3e 1c 04 00
loc_0106:
    jne loc_00a3                                                                ; 0106: 75 9b
loc_0108:
    call near draw_alley_background_and_status                                  ; 0108: e8 f5 28
loc_010b:
    call near loc_5400                                                          ; 010b: e8 f2 52
loc_010e:
    mov byte [displayed_lives], 0xff                                            ; 010e: c6 06 81 1f ff
loc_0113:
    call near disable_speaker                                                   ; 0113: e8 0b 5a
loc_0116:
    mov word [scene_index], 0                                                   ; 0116: c7 06 04 00 00 00
loc_011c:
    cmp byte [0x419], strict byte 0                                             ; 011c: 80 3e 19 04 00
loc_0121:
    je loc_0137                                                                 ; 0121: 74 14
loc_0123:
    call near initialize_scene_player                                           ; 0123: e8 7b 06
loc_0126:
    mov byte [player_alley_motion_mode], 2                                      ; 0126: c6 06 50 05 02
loc_012b:
    mov byte [player_vertical_speed], 1                                         ; 012b: c6 06 76 05 01
loc_0130:
    mov byte [player_vertical_acceleration_step], 0x20                          ; 0130: c6 06 78 05 20
loc_0135:
    jmp short loc_0140                                                          ; 0135: eb 09
loc_0137:
    mov word [player_x], 0                                                      ; 0137: c7 06 79 05 00 00
loc_013d:
    call near initialize_alley_player                                           ; 013d: e8 cd 05
loc_0140:
    call near initialize_chasing_enemy                                          ; 0140: e8 fd 1c
loc_0143:
    call near reset_alley_window_event                                          ; 0143: e8 ea 16
loc_0146:
    call near reset_trash_popup                                                 ; 0146: e8 c7 20
loc_0149:
    call near initialize_alley_moving_objects                                   ; 0149: e8 e4 21
loc_014c:
    call near draw_high_score                                                   ; 014c: e8 a3 25
loc_014f:
    call near draw_current_score                                                ; 014f: e8 aa 25
loc_0152:
    call near initialize_game_sound                                             ; 0152: e8 68 57
loc_0155:
    cmp byte [lives_remaining], strict byte 0                                   ; 0155: 80 3e 80 1f 00
loc_015a:
    jne loc_015f                                                                ; 015a: 75 03
loc_015c:
    jmp near loc_0081                                                           ; 015c: e9 22 ff
loc_015f:
    call near process_keyboard_commands                                         ; 015f: e8 d6 11
loc_0162:
    cmp byte [menu_requested], strict byte 0                                    ; 0162: 80 3e 1c 04 00
loc_0167:
    je loc_016c                                                                 ; 0167: 74 03
loc_0169:
    jmp near loc_00a3                                                           ; 0169: e9 37 ff
loc_016c:
    cmp byte [restart_requested], strict byte 0                                 ; 016c: 80 3e 1b 04 00
loc_0171:
    je loc_0176                                                                 ; 0171: 74 03
loc_0173:
    jmp near loc_00ae                                                           ; 0173: e9 38 ff
loc_0176:
    call near poll_direction_controls                                           ; 0176: e8 87 10
loc_0179:
    call near update_player                                                     ; 0179: e8 69 07
loc_017c:
    call near update_chasing_enemy                                              ; 017c: e8 e4 1c
loc_017f:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 017f: 80 3e b8 1c 00
loc_0184:
    jne loc_0191                                                                ; 0184: 75 0b
loc_0186:
    inc byte [0x40f]                                                            ; 0186: fe 06 0f 04
loc_018a:
    test byte [0x40f], 3                                                        ; 018a: f6 06 0f 04 03
loc_018f:
    jne loc_0155                                                                ; 018f: 75 c4
loc_0191:
    call near update_game_sound                                                 ; 0191: e8 d9 52
loc_0194:
    call near scroll_alley_window_row                                           ; 0194: e8 09 03
loc_0197:
    call near update_alley_window_event                                         ; 0197: e8 9c 17
loc_019a:
    call near update_alley_projectile                                           ; 019a: e8 ae 16
loc_019d:
    call near update_trash_popup                                                ; 019d: e8 76 20
loc_01a0:
    call near loc_237b                                                          ; 01a0: e8 d8 21
loc_01a3:
    call near draw_lives_if_changed                                             ; 01a3: e8 0d 25
loc_01a6:
    cmp byte [scene_exit_requested], strict byte 0                              ; 01a6: 80 3e 51 05 00
loc_01ab:
    je loc_0155                                                                 ; 01ab: 74 a8
loc_01ad:
    cmp byte [lives_remaining], strict byte 0                                   ; 01ad: 80 3e 80 1f 00
loc_01b2:
    jne loc_01b7                                                                ; 01b2: 75 03
loc_01b4:
    jmp near loc_0081                                                           ; 01b4: e9 ca fe
loc_01b7:
    load8 sub, ah, ah                                                           ; 01b7: 2a e4
loc_01b9:
    int 0x1a                                                                    ; 01b9: cd 1a
loc_01bb:
    mov word [scene_entry_tick], dx                                             ; 01bb: 89 16 10 04
loc_01bf:
    mov ax, word [player_x]                                                     ; 01bf: a1 79 05
loc_01c2:
    mov word [saved_alley_player_x], ax                                         ; 01c2: a3 01 00
loc_01c5:
    mov al, byte [player_y]                                                     ; 01c5: a0 7b 05
loc_01c8:
    mov byte [saved_alley_player_y], al                                         ; 01c8: a2 03 00
loc_01cb:
    mov byte [0x419], 1                                                         ; 01cb: c6 06 19 04 01
loc_01d0:
    cmp byte [courtship_pending], strict byte 0                                 ; 01d0: 80 3e 18 04 00
loc_01d5:
    je loc_01e5                                                                 ; 01d5: 74 0e
loc_01d7:
    mov byte [courtship_pending], 0                                             ; 01d7: c6 06 18 04 00
loc_01dc:
    mov word [scene_index], 7                                                   ; 01dc: c7 06 04 00 07 00
loc_01e2:
    jmp short loc_0238                                                          ; 01e2: eb 54
loc_01e4:
    nop                                                                         ; 01e4: 90
loc_01e5:
    call near update_random_state                                               ; 01e5: e8 15 2c
loc_01e8:
    test dl, 0xa0                                                               ; 01e8: f6 c2 a0
loc_01eb:
    je loc_020a                                                                 ; 01eb: 74 1d
loc_01ed:
    mov bx, word [difficulty_level]                                             ; 01ed: 8b 1e 08 00
loc_01f1:
    and bx, strict word 3                                                       ; 01f1: 81 e3 03 00
loc_01f5:
    cmp bx, strict byte 3                                                       ; 01f5: 83 fb 03
loc_01f8:
    je loc_020a                                                                 ; 01f8: 74 10
loc_01fa:
    mov cl, 2                                                                   ; 01fa: b1 02
loc_01fc:
    shl bx, cl                                                                  ; 01fc: d3 e3
loc_01fe:
    and dx, strict word 3                                                       ; 01fe: 81 e2 03 00
loc_0202:
    load16 add, bx, dx                                                          ; 0202: 03 da
loc_0204:
    mov al, byte [bx + 0x421]                                                   ; 0204: 8a 87 21 04
loc_0208:
    jmp short loc_021c                                                          ; 0208: eb 12
loc_020a:
    call near update_random_state                                               ; 020a: e8 f0 2b
loc_020d:
    and dx, strict word 7                                                       ; 020d: 81 e2 07 00
loc_0211:
    cmp dx, strict byte 5                                                       ; 0211: 83 fa 05
loc_0214:
    jae loc_020a                                                                ; 0214: 73 f4
loc_0216:
    load16 mov, bx, dx                                                          ; 0216: 8b da
loc_0218:
    mov al, byte [bx + 0x42d]                                                   ; 0218: 8a 87 2d 04
loc_021c:
    load8 sub, ah, ah                                                           ; 021c: 2a e4
loc_021e:
    cmp ax, word [0x41d]                                                        ; 021e: 3b 06 1d 04
loc_0222:
    jne loc_022a                                                                ; 0222: 75 06
loc_0224:
    cmp ax, word [0x41f]                                                        ; 0224: 3b 06 1f 04
loc_0228:
    je loc_01e5                                                                 ; 0228: 74 bb
loc_022a:
    mov word [scene_index], ax                                                  ; 022a: a3 04 00
loc_022d:
    mov cx, word [0x41d]                                                        ; 022d: 8b 0e 1d 04
loc_0231:
    mov word [0x41f], cx                                                        ; 0231: 89 0e 1f 04
loc_0235:
    mov word [0x41d], ax                                                        ; 0235: a3 1d 04
loc_0238:
    mov word [previous_scene_index], 0                                          ; 0238: c7 06 06 00 00 00
loc_023e:
    mov bx, word [scene_index]                                                  ; 023e: 8b 1e 04 00
loc_0242:
    cmp bx, strict byte 7                                                       ; 0242: 83 fb 07
loc_0245:
    jbe loc_0249                                                                ; 0245: 76 02
loc_0247:
    load16 sub, bx, bx                                                          ; 0247: 2b db
loc_0249:
    shl bx, 1                                                                   ; 0249: d1 e3
loc_024b:
    jmp word [cs:bx + 0x250]                                                    ; 024b: 2e ff a7 50 02
game_dispatch_table:
    dw loc_03e2, loc_03e2, loc_0459, loc_0394, loc_0349, loc_02fe, loc_02aa, loc_0260
loc_0260:
    mov word [scene_index], 7                                                   ; 0260: c7 06 04 00 07 00
loc_0266:
    call near run_scene_transition                                              ; 0266: e8 87 19
loc_0269:
    call near draw_scene_background                                             ; 0269: e8 24 25
loc_026c:
    call near initialize_scene_player                                           ; 026c: e8 32 05
loc_026f:
    call near initialize_chasing_enemy                                          ; 026f: e8 ce 1b
loc_0272:
    call near initialize_shared_room_object                                                          ; 0272: e8 90 31
loc_0275:
    call near initialize_courtship_moving_object                                                          ; 0275: e8 88 5e
loc_0278:
    call near initialize_courtship_cats                                         ; 0278: e8 de 4c
loc_027b:
    call near initialize_game_sound                                             ; 027b: e8 3f 56
loc_027e:
    call near process_keyboard_commands                                         ; 027e: e8 b7 10
loc_0281:
    call near poll_direction_controls                                           ; 0281: e8 7c 0f
loc_0284:
    call near update_game_sound                                                 ; 0284: e8 e6 51
loc_0287:
    call near update_player                                                     ; 0287: e8 5b 06
loc_028a:
    call near update_courtship_moving_object                                                          ; 028a: e8 79 5e
loc_028d:
    call near loc_2f66                                                          ; 028d: e8 d6 2c
loc_0290:
    call near loc_2e60                                                          ; 0290: e8 cd 2b
loc_0293:
    call near loc_4c10                                                          ; 0293: e8 7a 49
loc_0296:
    mov al, byte [scene_exit_requested]                                         ; 0296: a0 51 05
loc_0299:
    or al, byte [scene_complete]                                                ; 0299: 0a 06 53 05
loc_029d:
    or al, byte [menu_requested]                                                ; 029d: 0a 06 1c 04
loc_02a1:
    or al, byte [restart_requested]                                             ; 02a1: 0a 06 1b 04
loc_02a5:
    je loc_027e                                                                 ; 02a5: 74 d7
loc_02a7:
    jmp near loc_0427                                                           ; 02a7: e9 7d 01
loc_02aa:
    mov word [scene_index], 6                                                   ; 02aa: c7 06 04 00 06 00
loc_02b0:
    call near run_scene_transition                                              ; 02b0: e8 3d 19
loc_02b3:
    call near draw_scene_background                                             ; 02b3: e8 da 24
loc_02b6:
    call near loc_4c00                                                          ; 02b6: e8 47 49
loc_02b9:
    call near initialize_scene_player                                           ; 02b9: e8 e5 04
loc_02bc:
    call near initialize_shared_room_object                                                          ; 02bc: e8 46 31
loc_02bf:
    call near initialize_chasing_enemy                                          ; 02bf: e8 7e 1b
loc_02c2:
    call near initialize_game_sound                                             ; 02c2: e8 f8 55
loc_02c5:
    call near process_keyboard_commands                                         ; 02c5: e8 70 10
loc_02c8:
    call near poll_direction_controls                                           ; 02c8: e8 35 0f
loc_02cb:
    call near update_game_sound                                                 ; 02cb: e8 9f 51
loc_02ce:
    call near update_food_action                                                ; 02ce: e8 72 46
loc_02d1:
    call near loc_47d6                                                          ; 02d1: e8 02 45
loc_02d4:
    call near update_player                                                     ; 02d4: e8 0e 06
loc_02d7:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 02d7: 80 3e b8 1c 00
loc_02dc:
    je loc_02e3                                                                 ; 02dc: 74 05
loc_02de:
    call near update_chasing_enemy                                              ; 02de: e8 82 1b
loc_02e1:
    jmp short loc_02e6                                                          ; 02e1: eb 03
loc_02e3:
    call near update_shared_room_object                                                          ; 02e3: e8 6a 2e
loc_02e6:
    mov al, byte [scene_exit_requested]                                         ; 02e6: a0 51 05
loc_02e9:
    or al, byte [scene_failed]                                                  ; 02e9: 0a 06 52 05
loc_02ed:
    or al, byte [scene_complete]                                                ; 02ed: 0a 06 53 05
loc_02f1:
    or al, byte [restart_requested]                                             ; 02f1: 0a 06 1b 04
loc_02f5:
    or al, byte [menu_requested]                                                ; 02f5: 0a 06 1c 04
loc_02f9:
    je loc_02c5                                                                 ; 02f9: 74 ca
loc_02fb:
    jmp near loc_0427                                                           ; 02fb: e9 29 01
loc_02fe:
    mov word [scene_index], 5                                                   ; 02fe: c7 06 04 00 05 00
loc_0304:
    call near run_scene_transition                                              ; 0304: e8 e9 18
loc_0307:
    call near draw_scene_background                                             ; 0307: e8 86 24
loc_030a:
    call near initialize_bird_cage                                              ; 030a: e8 6d 42
loc_030d:
    call near initialize_scene_player                                           ; 030d: e8 91 04
loc_0310:
    call near initialize_shared_room_object                                                          ; 0310: e8 f2 30
loc_0313:
    call near initialize_chasing_enemy                                          ; 0313: e8 2a 1b
loc_0316:
    call near initialize_game_sound                                             ; 0316: e8 a4 55
loc_0319:
    call near process_keyboard_commands                                         ; 0319: e8 1c 10
loc_031c:
    call near poll_direction_controls                                           ; 031c: e8 e1 0e
loc_031f:
    call near update_game_sound                                                 ; 031f: e8 4b 51
loc_0322:
    call near update_bird_cage                                                          ; 0322: e8 86 42
loc_0325:
    call near update_released_bird                                                          ; 0325: e8 18 40
loc_0328:
    call near update_player                                                     ; 0328: e8 ba 05
loc_032b:
    call near update_shared_room_object                                                          ; 032b: e8 22 2e
loc_032e:
    call near update_chasing_enemy                                              ; 032e: e8 32 1b
loc_0331:
    mov al, byte [scene_failed]                                                 ; 0331: a0 52 05
loc_0334:
    or al, byte [scene_complete]                                                ; 0334: 0a 06 53 05
loc_0338:
    or al, byte [scene_exit_requested]                                          ; 0338: 0a 06 51 05
loc_033c:
    or al, byte [menu_requested]                                                ; 033c: 0a 06 1c 04
loc_0340:
    or al, byte [restart_requested]                                             ; 0340: 0a 06 1b 04
loc_0344:
    je loc_0319                                                                 ; 0344: 74 d3
loc_0346:
    jmp near loc_0427                                                           ; 0346: e9 de 00
loc_0349:
    mov word [scene_index], 4                                                   ; 0349: c7 06 04 00 04 00
loc_034f:
    call near run_scene_transition                                              ; 034f: e8 9e 18
loc_0352:
    call near draw_scene_background                                             ; 0352: e8 3b 24
loc_0355:
    call near initialize_scene_player                                           ; 0355: e8 49 04
loc_0358:
    call near initialize_shared_room_object                                                          ; 0358: e8 aa 30
loc_035b:
    call near initialize_chasing_enemy                                          ; 035b: e8 e2 1a
loc_035e:
    call near initialize_cheese_targets                                         ; 035e: e8 2f 3d
loc_0361:
    call near initialize_game_sound                                             ; 0361: e8 59 55
loc_0364:
    call near process_keyboard_commands                                         ; 0364: e8 d1 0f
loc_0367:
    call near poll_direction_controls                                           ; 0367: e8 96 0e
loc_036a:
    call near update_game_sound                                                 ; 036a: e8 00 51
loc_036d:
    call near update_player                                                     ; 036d: e8 75 05
loc_0370:
    call near update_cheese_hole_transfer                                       ; 0370: e8 1d 3b
loc_0373:
    call near update_cheese_targets                                             ; 0373: e8 4c 3d
loc_0376:
    call near update_shared_room_object                                                          ; 0376: e8 d7 2d
loc_0379:
    call near update_chasing_enemy                                              ; 0379: e8 e7 1a
loc_037c:
    mov al, byte [scene_failed]                                                 ; 037c: a0 52 05
loc_037f:
    or al, byte [scene_complete]                                                ; 037f: 0a 06 53 05
loc_0383:
    or al, byte [scene_exit_requested]                                          ; 0383: 0a 06 51 05
loc_0387:
    or al, byte [menu_requested]                                                ; 0387: 0a 06 1c 04
loc_038b:
    or al, byte [restart_requested]                                             ; 038b: 0a 06 1b 04
loc_038f:
    je loc_0364                                                                 ; 038f: 74 d3
loc_0391:
    jmp near loc_0427                                                           ; 0391: e9 93 00
loc_0394:
    mov word [scene_index], 3                                                   ; 0394: c7 06 04 00 03 00
loc_039a:
    call near run_scene_transition                                              ; 039a: e8 53 18
loc_039d:
    call near draw_scene_background                                             ; 039d: e8 f0 23
loc_03a0:
    call near initialize_scene_player                                           ; 03a0: e8 fe 03
loc_03a3:
    call near initialize_shared_room_object                                                          ; 03a3: e8 5f 30
loc_03a6:
    call near initialize_chasing_enemy                                          ; 03a6: e8 97 1a
loc_03a9:
    call near initialize_bookshelf_targets                                      ; 03a9: e8 84 37
loc_03ac:
    call near loc_3c90                                                          ; 03ac: e8 e1 38
loc_03af:
    call near initialize_game_sound                                             ; 03af: e8 0b 55
loc_03b2:
    call near process_keyboard_commands                                         ; 03b2: e8 83 0f
loc_03b5:
    call near poll_direction_controls                                           ; 03b5: e8 48 0e
loc_03b8:
    call near update_game_sound                                                 ; 03b8: e8 b2 50
loc_03bb:
    call near update_player                                                     ; 03bb: e8 27 05
loc_03be:
    call near loc_3cb1                                                          ; 03be: e8 f0 38
loc_03c1:
    call near check_bookshelf_target_contacts                                   ; 03c1: e8 7e 37
loc_03c4:
    call near update_shared_room_object                                                          ; 03c4: e8 89 2d
loc_03c7:
    call near update_chasing_enemy                                              ; 03c7: e8 99 1a
loc_03ca:
    mov al, byte [scene_failed]                                                 ; 03ca: a0 52 05
loc_03cd:
    or al, byte [scene_complete]                                                ; 03cd: 0a 06 53 05
loc_03d1:
    or al, byte [scene_exit_requested]                                          ; 03d1: 0a 06 51 05
loc_03d5:
    or al, byte [menu_requested]                                                ; 03d5: 0a 06 1c 04
loc_03d9:
    or al, byte [restart_requested]                                             ; 03d9: 0a 06 1b 04
loc_03dd:
    je loc_03b2                                                                 ; 03dd: 74 d3
loc_03df:
    jmp short loc_0427                                                          ; 03df: eb 46
loc_03e1:
    nop                                                                         ; 03e1: 90
loc_03e2:
    mov word [scene_index], 1                                                   ; 03e2: c7 06 04 00 01 00
loc_03e8:
    call near run_scene_transition                                              ; 03e8: e8 05 18
loc_03eb:
    call near draw_scene_background                                             ; 03eb: e8 a2 23
loc_03ee:
    call near initialize_scene_player                                           ; 03ee: e8 b0 03
loc_03f1:
    call near initialize_shared_room_object                                                          ; 03f1: e8 11 30
loc_03f4:
    call near initialize_chasing_enemy                                          ; 03f4: e8 49 1a
loc_03f7:
    call near initialize_game_sound                                             ; 03f7: e8 c3 54
loc_03fa:
    call near process_keyboard_commands                                         ; 03fa: e8 3b 0f
loc_03fd:
    call near poll_direction_controls                                           ; 03fd: e8 00 0e
loc_0400:
    call near update_game_sound                                                 ; 0400: e8 6a 50
loc_0403:
    call near update_player                                                     ; 0403: e8 df 04
loc_0406:
    call near update_shared_room_object                                                          ; 0406: e8 47 2d
loc_0409:
    call near update_chasing_enemy                                              ; 0409: e8 57 1a
loc_040c:
    call near update_fishbowl_entry                                             ; 040c: e8 41 34
loc_040f:
    cmp byte [enter_aquarium_requested], strict byte 0                          ; 040f: 80 3e 54 05 00
loc_0414:
    jne loc_0459                                                                ; 0414: 75 43
loc_0416:
    mov al, byte [scene_failed]                                                 ; 0416: a0 52 05
loc_0419:
    or al, byte [scene_exit_requested]                                          ; 0419: 0a 06 51 05
loc_041d:
    or al, byte [restart_requested]                                             ; 041d: 0a 06 1b 04
loc_0421:
    or al, byte [menu_requested]                                                ; 0421: 0a 06 1c 04
loc_0425:
    je loc_03fa                                                                 ; 0425: 74 d3
loc_0427:
    cmp byte [restart_requested], strict byte 0                                 ; 0427: 80 3e 1b 04 00
loc_042c:
    je loc_0431                                                                 ; 042c: 74 03
loc_042e:
    jmp near loc_00ae                                                           ; 042e: e9 7d fc
loc_0431:
    cmp byte [menu_requested], strict byte 0                                    ; 0431: 80 3e 1c 04 00
loc_0436:
    je loc_043b                                                                 ; 0436: 74 03
loc_0438:
    jmp near loc_00a3                                                           ; 0438: e9 68 fc
loc_043b:
    cmp byte [scene_failed], strict byte 0                                      ; 043b: 80 3e 52 05 00
loc_0440:
    je loc_0447                                                                 ; 0440: 74 05
loc_0442:
    mov byte [0x419], 0                                                         ; 0442: c6 06 19 04 00
loc_0447:
    mov ax, word [scene_index]                                                  ; 0447: a1 04 00
loc_044a:
    mov word [previous_scene_index], ax                                         ; 044a: a3 06 00
loc_044d:
    mov word [scene_index], 0                                                   ; 044d: c7 06 04 00 00 00
loc_0453:
    call near run_scene_transition                                              ; 0453: e8 9a 17
loc_0456:
    jmp near loc_00f3                                                           ; 0456: e9 9a fc
loc_0459:
    mov word [scene_index], 2                                                   ; 0459: c7 06 04 00 02 00
loc_045f:
    call near run_scene_transition                                              ; 045f: e8 8e 17
loc_0462:
    call near draw_scene_background                                             ; 0462: e8 2b 23
loc_0465:
    call near initialize_aquarium_objects                                       ; 0465: e8 61 31
loc_0468:
    call near initialize_scene_player                                           ; 0468: e8 36 03
loc_046b:
    mov byte [enemy_active], 0                                                  ; 046b: c6 06 bf 1c 00
loc_0470:
    mov byte [enemy_capture_direction], 0                                       ; 0470: c6 06 b8 1c 00
loc_0475:
    call near initialize_game_sound                                             ; 0475: e8 45 54
loc_0478:
    call near process_keyboard_commands                                         ; 0478: e8 bd 0e
loc_047b:
    call near poll_direction_controls                                           ; 047b: e8 82 0d
loc_047e:
    call near update_game_sound                                                 ; 047e: e8 ec 4f
loc_0481:
    call near update_player                                                     ; 0481: e8 61 04
loc_0484:
    call near loc_3675                                                          ; 0484: e8 ee 31
loc_0487:
    call near loc_37e5                                                          ; 0487: e8 5b 33
loc_048a:
    mov al, byte [scene_failed]                                                 ; 048a: a0 52 05
loc_048d:
    or al, byte [scene_complete]                                                ; 048d: 0a 06 53 05
loc_0491:
    or al, byte [menu_requested]                                                ; 0491: 0a 06 1c 04
loc_0495:
    or al, byte [restart_requested]                                             ; 0495: 0a 06 1b 04
loc_0499:
    je loc_0478                                                                 ; 0499: 74 dd
loc_049b:
    jmp short loc_0427                                                          ; 049b: eb 8a
    times 3 db 0 ; original zero fill at CS:049d
