; Direction polling and keyboard commands.
; Original CS:1200..13AA (end exclusive).

; CS:1200 — poll_direction_controls
; Branches on DS:069B: zero calls keyboard decoding; nonzero samples game port 0201. Updates 0698..069A.
poll_direction_controls:
    load8 sub, ah, ah                                                           ; 1200: 2a e4
loc_1202:
    int 0x1a                                                                    ; 1202: cd 1a
loc_1204:
    load16 mov, ax, dx                                                          ; 1204: 8b c2
loc_1206:
    sub ax, word [last_control_poll_tick]                                       ; 1206: 2b 06 9f 06
loc_120a:
    cmp ax, strict word 2                                                       ; 120a: 3d 02 00
loc_120d:
    jae loc_1210                                                                ; 120d: 73 01
loc_120f:
    ret                                                                         ; 120f: c3
loc_1210:
    mov word [last_control_poll_tick], dx                                       ; 1210: 89 16 9f 06
loc_1214:
    cmp byte [joystick_enabled], strict byte 0                                  ; 1214: 80 3e 9b 06 00
loc_1219:
    jne loc_122e                                                                ; 1219: 75 13
loc_121b:
    call near decode_keyboard_directions                                        ; 121b: e8 a3 00
loc_121e:
    call near read_pit_channel_zero                                             ; 121e: e8 96 01
loc_1221:
    load16 mov, dx, ax                                                          ; 1221: 8b d0
loc_1223:
    call near read_pit_channel_zero                                             ; 1223: e8 91 01
loc_1226:
    load16 sub, ax, dx                                                          ; 1226: 2b c2
loc_1228:
    cmp ax, strict word 0xf8ed                                                  ; 1228: 3d ed f8
loc_122b:
    jb loc_1223                                                                 ; 122b: 72 f6
loc_122d:
    ret                                                                         ; 122d: c3
loc_122e:
    mov dx, 0x201                                                               ; 122e: ba 01 02
loc_1231:
    in al, dx                                                                   ; 1231: ec
loc_1232:
    and al, 0x10                                                                ; 1232: 24 10
loc_1234:
    mov byte [action_button_state], al                                          ; 1234: a2 9a 06
loc_1237:
    mov byte [joystick_pending_axes], 3                                         ; 1237: c6 06 9e 06 03
loc_123c:
    call near read_pit_channel_zero                                             ; 123c: e8 78 01
loc_123f:
    mov word [joystick_pit_start], ax                                           ; 123f: a3 9c 06
loc_1242:
    out dx, al                                                                  ; 1242: ee
loc_1243:
    mov cx, 0x7d0                                                               ; 1243: b9 d0 07
loc_1246:
    in al, dx                                                                   ; 1246: ec
loc_1247:
    test al, 1                                                                  ; 1247: a8 01
loc_1249:
    jne loc_125e                                                                ; 1249: 75 13
loc_124b:
    test byte [joystick_pending_axes], 1                                        ; 124b: f6 06 9e 06 01
loc_1250:
    je loc_125e                                                                 ; 1250: 74 0c
loc_1252:
    and byte [joystick_pending_axes], strict byte 0xfe                          ; 1252: 80 26 9e 06 fe
loc_1257:
    call near classify_joystick_interval                                        ; 1257: e8 47 00
loc_125a:
    mov byte [input_horizontal], bl                                             ; 125a: 88 1e 98 06
loc_125e:
    test al, 2                                                                  ; 125e: a8 02
loc_1260:
    jne loc_1275                                                                ; 1260: 75 13
loc_1262:
    test byte [joystick_pending_axes], 2                                        ; 1262: f6 06 9e 06 02
loc_1267:
    je loc_1275                                                                 ; 1267: 74 0c
loc_1269:
    and byte [joystick_pending_axes], strict byte 0xfd                          ; 1269: 80 26 9e 06 fd
loc_126e:
    call near classify_joystick_interval                                        ; 126e: e8 30 00
loc_1271:
    mov byte [input_vertical], bl                                               ; 1271: 88 1e 99 06
loc_1275:
    test byte [joystick_pending_axes], 3                                        ; 1275: f6 06 9e 06 03
loc_127a:
    je loc_12a0                                                                 ; 127a: 74 24
loc_127c:
    call near read_pit_channel_zero                                             ; 127c: e8 38 01
loc_127f:
    sub ax, word [joystick_pit_start]                                           ; 127f: 2b 06 9c 06
loc_1283:
    cmp ax, strict word 0x1964                                                  ; 1283: 3d 64 19
loc_1286:
    loopne loc_1246                                                             ; 1286: e0 be
loc_1288:
    test byte [joystick_pending_axes], 1                                        ; 1288: f6 06 9e 06 01
loc_128d:
    je loc_1294                                                                 ; 128d: 74 05
loc_128f:
    mov byte [input_horizontal], 0xff                                           ; 128f: c6 06 98 06 ff
loc_1294:
    test byte [joystick_pending_axes], 2                                        ; 1294: f6 06 9e 06 02
loc_1299:
    je loc_12a0                                                                 ; 1299: 74 05
loc_129b:
    mov byte [input_vertical], 0xff                                             ; 129b: c6 06 99 06 ff
loc_12a0:
    ret                                                                         ; 12a0: c3

; CS:12a1 — classify_joystick_interval
; Subtracts saved PIT count at 069C; compares unsigned intervals F5E6 and FAFA; returns BL = 1, 0, or FF.
classify_joystick_interval:
    push ax                                                                     ; 12a1: 50
loc_12a2:
    call near read_pit_channel_zero                                             ; 12a2: e8 12 01
loc_12a5:
    sub ax, word [joystick_pit_start]                                           ; 12a5: 2b 06 9c 06
loc_12a9:
    load16 mov, bx, ax                                                          ; 12a9: 8b d8
loc_12ab:
    pop ax                                                                      ; 12ab: 58
loc_12ac:
    cmp bx, strict word 0xf5e6                                                  ; 12ac: 81 fb e6 f5
loc_12b0:
    jae loc_12b5                                                                ; 12b0: 73 03
loc_12b2:
    mov bl, 1                                                                   ; 12b2: b3 01
loc_12b4:
    ret                                                                         ; 12b4: c3
loc_12b5:
    cmp bx, strict word 0xfafa                                                  ; 12b5: 81 fb fa fa
loc_12b9:
    jae loc_12be                                                                ; 12b9: 73 03
loc_12bb:
    load8 sub, bl, bl                                                           ; 12bb: 2a db
loc_12bd:
    ret                                                                         ; 12bd: c3
loc_12be:
    mov bl, 0xff                                                                ; 12be: b3 ff
loc_12c0:
    ret                                                                         ; 12c0: c3

; CS:12c1 — decode_keyboard_directions
; Combines tracked scan-code states into 0698/0699 and shifts the Alt state into 069A. The FD model branch ignores diagonal keys.
decode_keyboard_directions:
    mov al, byte [0x6ba]                                                        ; 12c1: a0 ba 06
loc_12c4:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 12c4: 80 3e 97 06 fd
loc_12c9:
    je loc_12d3                                                                 ; 12c9: 74 08
loc_12cb:
    and al, byte [0x6bd]                                                        ; 12cb: 22 06 bd 06
loc_12cf:
    and al, byte [0x6be]                                                        ; 12cf: 22 06 be 06
loc_12d3:
    xor al, 0x80                                                                ; 12d3: 34 80
loc_12d5:
    je loc_12d9                                                                 ; 12d5: 74 02
loc_12d7:
    mov al, 1                                                                   ; 12d7: b0 01
loc_12d9:
    mov byte [input_vertical], al                                               ; 12d9: a2 99 06
loc_12dc:
    mov al, byte [0x6b8]                                                        ; 12dc: a0 b8 06
loc_12df:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 12df: 80 3e 97 06 fd
loc_12e4:
    je loc_12ee                                                                 ; 12e4: 74 08
loc_12e6:
    and al, byte [0x6bc]                                                        ; 12e6: 22 06 bc 06
loc_12ea:
    and al, byte [0x6bf]                                                        ; 12ea: 22 06 bf 06
loc_12ee:
    xor al, 0x80                                                                ; 12ee: 34 80
loc_12f0:
    je loc_12f7                                                                 ; 12f0: 74 05
loc_12f2:
    mov byte [input_vertical], 0xff                                             ; 12f2: c6 06 99 06 ff
loc_12f7:
    mov al, byte [0x6b9]                                                        ; 12f7: a0 b9 06
loc_12fa:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 12fa: 80 3e 97 06 fd
loc_12ff:
    je loc_1309                                                                 ; 12ff: 74 08
loc_1301:
    and al, byte [0x6bc]                                                        ; 1301: 22 06 bc 06
loc_1305:
    and al, byte [0x6bd]                                                        ; 1305: 22 06 bd 06
loc_1309:
    xor al, 0x80                                                                ; 1309: 34 80
loc_130b:
    je loc_130f                                                                 ; 130b: 74 02
loc_130d:
    mov al, 1                                                                   ; 130d: b0 01
loc_130f:
    mov byte [input_horizontal], al                                             ; 130f: a2 98 06
loc_1312:
    mov al, byte [0x6bb]                                                        ; 1312: a0 bb 06
loc_1315:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 1315: 80 3e 97 06 fd
loc_131a:
    je loc_1324                                                                 ; 131a: 74 08
loc_131c:
    and al, byte [0x6be]                                                        ; 131c: 22 06 be 06
loc_1320:
    and al, byte [0x6bf]                                                        ; 1320: 22 06 bf 06
loc_1324:
    xor al, 0x80                                                                ; 1324: 34 80
loc_1326:
    je loc_132d                                                                 ; 1326: 74 05
loc_1328:
    mov byte [input_horizontal], 0xff                                           ; 1328: c6 06 98 06 ff
loc_132d:
    mov al, byte [keyboard_key_states]                                          ; 132d: a0 b7 06
loc_1330:
    mov cl, 3                                                                   ; 1330: b1 03
loc_1332:
    shr al, cl                                                                  ; 1332: d2 e8
loc_1334:
    mov byte [action_button_state], al                                          ; 1334: a2 9a 06
loc_1337:
    ret                                                                         ; 1337: c3

; CS:1338 — process_keyboard_commands
; Checks tracked keys, toggles sound at DS:0000, sets 041B/041C, enters pause, or restores vectors and exits via RETF.
process_keyboard_commands:
    mov ax, word [keyboard_event_counter]                                       ; 1338: a1 93 06
loc_133b:
    cmp ax, word [processed_keyboard_counter]                                   ; 133b: 3b 06 91 06
loc_133f:
    je loc_1357                                                                 ; 133f: 74 16
loc_1341:
    mov word [processed_keyboard_counter], ax                                   ; 1341: a3 91 06
loc_1344:
    test byte [0x6c0], 0x80                                                     ; 1344: f6 06 c0 06 80
loc_1349:
    jne loc_1358                                                                ; 1349: 75 0d
loc_134b:
    mov ax, word [keyboard_event_counter]                                       ; 134b: a1 93 06
loc_134e:
    cmp ax, word [pause_keyboard_counter]                                       ; 134e: 3b 06 00 6e
loc_1352:
    je loc_1357                                                                 ; 1352: 74 03
loc_1354:
    call near loc_5e70                                                          ; 1354: e8 19 4b
loc_1357:
    ret                                                                         ; 1357: c3
loc_1358:
    test byte [0x6c9], 0x80                                                     ; 1358: f6 06 c9 06 80
loc_135d:
    je loc_1360                                                                 ; 135d: 74 01
loc_135f:
    ret                                                                         ; 135f: c3
loc_1360:
    test byte [0x6cc], 0x80                                                     ; 1360: f6 06 cc 06 80
loc_1365:
    jne loc_136d                                                                ; 1365: 75 06
loc_1367:
    mov byte [lives_remaining], 9                                               ; 1367: c6 06 80 1f 09
loc_136c:
    ret                                                                         ; 136c: c3
loc_136d:
    test byte [0x6c1], 0x80                                                     ; 136d: f6 06 c1 06 80
loc_1372:
    je loc_13a5                                                                 ; 1372: 74 31
loc_1374:
    test byte [0x6cb], 0x80                                                     ; 1374: f6 06 cb 06 80
loc_1379:
    jne loc_1381                                                                ; 1379: 75 06
loc_137b:
    mov byte [menu_requested], 0xff                                             ; 137b: c6 06 1c 04 ff
loc_1380:
    ret                                                                         ; 1380: c3
loc_1381:
    test byte [0x6c8], 0x80                                                     ; 1381: f6 06 c8 06 80
loc_1386:
    jne loc_138e                                                                ; 1386: 75 06
loc_1388:
    mov byte [restart_requested], 0xff                                          ; 1388: c6 06 1b 04 ff
loc_138d:
    ret                                                                         ; 138d: c3
loc_138e:
    test byte [0x6c7], 0x80                                                     ; 138e: f6 06 c7 06 80
loc_1393:
    jne loc_13a4                                                                ; 1393: 75 0f
loc_1395:
    not byte [sound_enabled]                                                    ; 1395: f6 16 00 00
loc_1399:
    cmp byte [sound_enabled], strict byte 0                                     ; 1399: 80 3e 00 00 00
loc_139e:
    jne loc_13a3                                                                ; 139e: 75 03
loc_13a0:
    call near disable_speaker                                                   ; 13a0: e8 7e 47
loc_13a3:
    ret                                                                         ; 13a3: c3
loc_13a4:
    ret                                                                         ; 13a4: c3
loc_13a5:
    call near restore_interrupt_vectors                                         ; 13a5: e8 d7 00
loc_13a8:
    pop ax                                                                      ; 13a8: 58
loc_13a9:
    retf                                                                        ; 13a9: cb
