; Courtship result animation and progression.
; Original CS:5060..53B0 (end exclusive).

loc_5060:
    mov ax, 0xb800                                                              ; 5060: b8 00 b8
loc_5063:
    mov es, ax                                                                  ; 5063: 8e c0
loc_5065:
    mov ax, word [player_x]                                                     ; 5065: a1 79 05
loc_5068:
    cmp ax, strict word 0x117                                                   ; 5068: 3d 17 01
loc_506b:
    jb loc_5070                                                                 ; 506b: 72 03
loc_506d:
    mov ax, 0x116                                                               ; 506d: b8 16 01
loc_5070:
    sub ax, strict word 0x10                                                    ; 5070: 2d 10 00
loc_5073:
    jae loc_5077                                                                ; 5073: 73 02
loc_5075:
    load16 sub, ax, ax                                                          ; 5075: 2b c0
loc_5077:
    and ax, strict word 0xff0                                                   ; 5077: 25 f0 0f
loc_507a:
    mov word [player_x], ax                                                     ; 507a: a3 79 05
loc_507d:
    mov byte [player_y], 0x14                                                   ; 507d: c6 06 7b 05 14
loc_5082:
    sub ax, strict word 0x80                                                    ; 5082: 2d 80 00
loc_5085:
    jae loc_5089                                                                ; 5085: 73 02
loc_5087:
    not ax                                                                      ; 5087: f7 d0
loc_5089:
    mov cl, 3                                                                   ; 5089: b1 03
loc_508b:
    shr ax, cl                                                                  ; 508b: d3 e8
loc_508d:
    cmp ax, strict word 0xd                                                     ; 508d: 3d 0d 00
loc_5090:
    jbe loc_5095                                                                ; 5090: 76 03
loc_5092:
    mov ax, 0xd                                                                 ; 5092: b8 0d 00
loc_5095:
    add ax, strict word 2                                                       ; 5095: 05 02 00
loc_5098:
    mov word [0x4d6a], ax                                                       ; 5098: a3 6a 4d
loc_509b:
    mov word [0x4dd6], 0xa                                                      ; 509b: c7 06 d6 4d 0a 00
loc_50a1:
    cmp word [0x4dd6], strict byte 0xa                                          ; 50a1: 83 3e d6 4d 0a
loc_50a6:
    je loc_50ab                                                                 ; 50a6: 74 03
loc_50a8:
    call near update_courtship_melody                                           ; 50a8: e8 b8 0a
loc_50ab:
    load8 sub, ah, ah                                                           ; 50ab: 2a e4
loc_50ad:
    int 0x1a                                                                    ; 50ad: cd 1a
loc_50af:
    mov word [0x4a80], dx                                                       ; 50af: 89 16 80 4a
loc_50b3:
    mov ax, word [player_x]                                                     ; 50b3: a1 79 05
loc_50b6:
    load16 mov, cx, ax                                                          ; 50b6: 8b c8
loc_50b8:
    and cx, strict word 0xff0                                                   ; 50b8: 81 e1 f0 0f
loc_50bc:
    cmp cx, strict word 0x80                                                    ; 50bc: 81 f9 80 00
loc_50c0:
    jne loc_50c6                                                                ; 50c0: 75 04
loc_50c2:
    load16 mov, ax, cx                                                          ; 50c2: 8b c1
loc_50c4:
    jmp short loc_50d2                                                          ; 50c4: eb 0c
loc_50c6:
    jb loc_50ce                                                                 ; 50c6: 72 06
loc_50c8:
    sub ax, word [0x4d6a]                                                       ; 50c8: 2b 06 6a 4d
loc_50cc:
    jmp short loc_50d2                                                          ; 50cc: eb 04
loc_50ce:
    add ax, word [0x4d6a]                                                       ; 50ce: 03 06 6a 4d
loc_50d2:
    mov word [player_x], ax                                                     ; 50d2: a3 79 05
loc_50d5:
    cmp byte [player_y], strict byte 0x54                                       ; 50d5: 80 3e 7b 05 54
loc_50da:
    jb loc_50dd                                                                 ; 50da: 72 01
loc_50dc:
    ret                                                                         ; 50dc: c3
loc_50dd:
    add byte [player_y], strict byte 8                                          ; 50dd: 80 06 7b 05 08
loc_50e2:
    mov cx, word [player_x]                                                     ; 50e2: 8b 0e 79 05
loc_50e6:
    add cx, strict byte 4                                                       ; 50e6: 83 c1 04
loc_50e9:
    mov dl, byte [player_y]                                                     ; 50e9: 8a 16 7b 05
loc_50ed:
    call near calculate_cga_address                                             ; 50ed: e8 c0 db
loc_50f0:
    load16 mov, di, ax                                                          ; 50f0: 8b f8
loc_50f2:
    mov word [0x4dd8], di                                                       ; 50f2: 89 3e d8 4d
loc_50f6:
    mov si, 0x4b8a                                                              ; 50f6: be 8a 4b
loc_50f9:
    mov bp, 0xe                                                                 ; 50f9: bd 0e 00
loc_50fc:
    mov cx, 0x2007                                                              ; 50fc: b9 07 20
loc_50ff:
    call near blit_zero_transparent                                             ; 50ff: e8 ca db
loc_5102:
    mov di, word [0x4dd8]                                                       ; 5102: 8b 3e d8 4d
loc_5106:
    add di, strict word 0xf3                                                    ; 5106: 81 c7 f3 00
loc_510a:
    mov si, 0x4a82                                                              ; 510a: be 82 4a
loc_510d:
    mov cx, 0xd04                                                               ; 510d: b9 04 0d
loc_5110:
    call near copy_rectangle_to_cga                                             ; 5110: e8 8a dc
loc_5113:
    cmp word [0x4dd6], strict byte 0xa                                          ; 5113: 83 3e d6 4d 0a
loc_5118:
    jne loc_5120                                                                ; 5118: 75 06
loc_511a:
    call near loc_572e                                                          ; 511a: e8 11 06
loc_511d:
    call near initialize_courtship_melody                                       ; 511d: e8 34 0a
loc_5120:
    call near update_courtship_melody                                           ; 5120: e8 40 0a
loc_5123:
    load8 sub, ah, ah                                                           ; 5123: 2a e4
loc_5125:
    int 0x1a                                                                    ; 5125: cd 1a
loc_5127:
    sub dx, word [0x4a80]                                                       ; 5127: 2b 16 80 4a
loc_512b:
    cmp dx, word [0x4dd6]                                                       ; 512b: 3b 16 d6 4d
loc_512f:
    jb loc_5120                                                                 ; 512f: 72 ef
loc_5131:
    cmp word [0x4dd6], strict byte 0xa                                          ; 5131: 83 3e d6 4d 0a
loc_5136:
    jne loc_5141                                                                ; 5136: 75 09
loc_5138:
    call near award_scene_bonus                                                 ; 5138: e8 75 e7
loc_513b:
    load16 sub, bx, bx                                                          ; 513b: 2b db
loc_513d:
    mov ah, 0xb                                                                 ; 513d: b4 0b
loc_513f:
    int 0x10                                                                    ; 513f: cd 10
loc_5141:
    mov word [0x4dd6], 2                                                        ; 5141: c7 06 d6 4d 02 00
loc_5147:
    jmp near loc_50a1                                                           ; 5147: e9 57 ff
loc_514a:
    mov cx, 3                                                                   ; 514a: b9 03 00
loc_514d:
    mov bx, 3                                                                   ; 514d: bb 03 00
loc_5150:
    load16 sub, bx, cx                                                          ; 5150: 2b d9
loc_5152:
    shl bx, 1                                                                   ; 5152: d1 e3
loc_5154:
    mov ax, word [bx + 0x4da4]                                                  ; 5154: 8b 87 a4 4d
loc_5158:
    mov word [0x4d6a], ax                                                       ; 5158: a3 6a 4d
loc_515b:
    mov ax, word [bx + 0x4daa]                                                  ; 515b: 8b 87 aa 4d
loc_515f:
    mov word [0x4d6c], ax                                                       ; 515f: a3 6c 4d
loc_5162:
    mov ax, word [bx + 0x4d98]                                                  ; 5162: 8b 87 98 4d
loc_5166:
    mov word [0x4dcc], ax                                                       ; 5166: a3 cc 4d
loc_5169:
    mov ax, word [bx + 0x4d9e]                                                  ; 5169: 8b 87 9e 4d
loc_516d:
    mov word [0x4dce], ax                                                       ; 516d: a3 ce 4d
loc_5170:
    mov ax, word [bx + 0x4db0]                                                  ; 5170: 8b 87 b0 4d
loc_5174:
    mov word [0x4dd0], ax                                                       ; 5174: a3 d0 4d
loc_5177:
    mov ax, word [bx + 0x4db6]                                                  ; 5177: 8b 87 b6 4d
loc_517b:
    mov word [0x4dd2], ax                                                       ; 517b: a3 d2 4d
loc_517e:
    mov ax, word [bx + 0x4dbc]                                                  ; 517e: 8b 87 bc 4d
loc_5182:
    mov word [0x4dd4], ax                                                       ; 5182: a3 d4 4d
loc_5185:
    mov ax, word [bx + 0x4d92]                                                  ; 5185: 8b 87 92 4d
loc_5189:
    mov word [0x4dca], ax                                                       ; 5189: a3 ca 4d
loc_518c:
    mov ax, word [bx + 0x4dc2]                                                  ; 518c: 8b 87 c2 4d
loc_5190:
    mov word [0x4dc8], ax                                                       ; 5190: a3 c8 4d
loc_5193:
    push cx                                                                     ; 5193: 51
loc_5194:
    call near loc_519b                                                          ; 5194: e8 04 00
loc_5197:
    pop cx                                                                      ; 5197: 59
loc_5198:
    loop loc_514d                                                               ; 5198: e2 b3
loc_519a:
    ret                                                                         ; 519a: c3
loc_519b:
    mov cx, 8                                                                   ; 519b: b9 08 00
loc_519e:
    mov byte [0x4d91], 1                                                        ; 519e: c6 06 91 4d 01
loc_51a3:
    push cx                                                                     ; 51a3: 51
loc_51a4:
    call near update_courtship_melody                                           ; 51a4: e8 bc 09
loc_51a7:
    pop cx                                                                      ; 51a7: 59
loc_51a8:
    load16 mov, bx, cx                                                          ; 51a8: 8b d9
loc_51aa:
    dec bx                                                                      ; 51aa: 4b
loc_51ab:
    shl bx, 1                                                                   ; 51ab: d1 e3
loc_51ad:
    mov ax, word [0x4dcc]                                                       ; 51ad: a1 cc 4d
loc_51b0:
    mov word [bx + 0x4d4a], ax                                                  ; 51b0: 89 87 4a 4d
loc_51b4:
    mov ax, word [0x4dce]                                                       ; 51b4: a1 ce 4d
loc_51b7:
    mov word [bx + 0x4d5a], ax                                                  ; 51b7: 89 87 5a 4d
loc_51bb:
    loop loc_51a3                                                               ; 51bb: e2 e6
loc_51bd:
    mov ax, 0xb800                                                              ; 51bd: b8 00 b8
loc_51c0:
    mov es, ax                                                                  ; 51c0: 8e c0
loc_51c2:
    mov byte [0x4d6e], 0                                                        ; 51c2: c6 06 6e 4d 00
loc_51c7:
    load8 sub, ah, ah                                                           ; 51c7: 2a e4
loc_51c9:
    int 0x1a                                                                    ; 51c9: cd 1a
loc_51cb:
    mov word [0x4a80], dx                                                       ; 51cb: 89 16 80 4a
loc_51cf:
    mov cx, 8                                                                   ; 51cf: b9 08 00
loc_51d2:
    push cx                                                                     ; 51d2: 51
loc_51d3:
    call near update_courtship_melody                                           ; 51d3: e8 8d 09
loc_51d6:
    pop cx                                                                      ; 51d6: 59
loc_51d7:
    load16 mov, bx, cx                                                          ; 51d7: 8b d9
loc_51d9:
    dec bx                                                                      ; 51d9: 4b
loc_51da:
    shl bx, 1                                                                   ; 51da: d1 e3
loc_51dc:
    push cx                                                                     ; 51dc: 51
loc_51dd:
    push bx                                                                     ; 51dd: 53
loc_51de:
    cmp byte [0x4d91], strict byte 0                                            ; 51de: 80 3e 91 4d 00
loc_51e3:
    je loc_51ea                                                                 ; 51e3: 74 05
loc_51e5:
    cmp cx, strict byte 8                                                       ; 51e5: 83 f9 08
loc_51e8:
    jne loc_5205                                                                ; 51e8: 75 1b
loc_51ea:
    mov cx, word [bx + 0x4d4a]                                                  ; 51ea: 8b 8f 4a 4d
loc_51ee:
    mov dx, word [bx + 0x4d5a]                                                  ; 51ee: 8b 97 5a 4d
loc_51f2:
    call near calculate_cga_address                                             ; 51f2: e8 bb da
loc_51f5:
    load16 mov, di, ax                                                          ; 51f5: 8b f8
loc_51f7:
    mov si, word [0x4dca]                                                       ; 51f7: 8b 36 ca 4d
loc_51fb:
    mov bp, 0xe                                                                 ; 51fb: bd 0e 00
loc_51fe:
    mov cx, word [0x4dd4]                                                       ; 51fe: 8b 0e d4 4d
loc_5202:
    call near blit_zero_transparent                                             ; 5202: e8 c7 da
loc_5205:
    pop bx                                                                      ; 5205: 5b
loc_5206:
    pop cx                                                                      ; 5206: 59
loc_5207:
    call near loc_522a                                                          ; 5207: e8 20 00
loc_520a:
    loop loc_51d2                                                               ; 520a: e2 c6
loc_520c:
    call near update_courtship_melody                                           ; 520c: e8 54 09
loc_520f:
    load8 sub, ah, ah                                                           ; 520f: 2a e4
loc_5211:
    int 0x1a                                                                    ; 5211: cd 1a
loc_5213:
    sub dx, word [0x4a80]                                                       ; 5213: 2b 16 80 4a
loc_5217:
    cmp dx, word [0x4dc8]                                                       ; 5217: 3b 16 c8 4d
loc_521b:
    jb loc_520c                                                                 ; 521b: 72 ef
loc_521d:
    mov byte [0x4d91], 0                                                        ; 521d: c6 06 91 4d 00
loc_5222:
    cmp byte [0x4d6e], strict byte 0                                            ; 5222: 80 3e 6e 4d 00
loc_5227:
    je loc_51c7                                                                 ; 5227: 74 9e
loc_5229:
    ret                                                                         ; 5229: c3
loc_522a:
    mov ax, word [bx + 0x4d4a]                                                  ; 522a: 8b 87 4a 4d
loc_522e:
    cmp word [bx + 0x4d6f], strict byte 1                                       ; 522e: 83 bf 6f 4d 01
loc_5233:
    jb loc_525a                                                                 ; 5233: 72 25
loc_5235:
    jne loc_524a                                                                ; 5235: 75 13
loc_5237:
    add ax, word [0x4d6a]                                                       ; 5237: 03 06 6a 4d
loc_523b:
    cmp ax, word [0x4dd0]                                                       ; 523b: 3b 06 d0 4d
loc_523f:
    jbe loc_5256                                                                ; 523f: 76 15
loc_5241:
    mov ax, word [0x4dd0]                                                       ; 5241: a1 d0 4d
loc_5244:
    inc byte [0x4d6e]                                                           ; 5244: fe 06 6e 4d
loc_5248:
    jmp short loc_5256                                                          ; 5248: eb 0c
loc_524a:
    sub ax, word [0x4d6a]                                                       ; 524a: 2b 06 6a 4d
loc_524e:
    jae loc_5256                                                                ; 524e: 73 06
loc_5250:
    load16 sub, ax, ax                                                          ; 5250: 2b c0
loc_5252:
    inc byte [0x4d6e]                                                           ; 5252: fe 06 6e 4d
loc_5256:
    mov word [bx + 0x4d4a], ax                                                  ; 5256: 89 87 4a 4d
loc_525a:
    mov ax, word [bx + 0x4d5a]                                                  ; 525a: 8b 87 5a 4d
loc_525e:
    cmp word [bx + 0x4d7f], strict byte 1                                       ; 525e: 83 bf 7f 4d 01
loc_5263:
    jb loc_528a                                                                 ; 5263: 72 25
loc_5265:
    jne loc_527a                                                                ; 5265: 75 13
loc_5267:
    add ax, word [0x4d6c]                                                       ; 5267: 03 06 6c 4d
loc_526b:
    cmp ax, word [0x4dd2]                                                       ; 526b: 3b 06 d2 4d
loc_526f:
    jbe loc_5286                                                                ; 526f: 76 15
loc_5271:
    mov ax, word [0x4dd2]                                                       ; 5271: a1 d2 4d
loc_5274:
    inc byte [0x4d6e]                                                           ; 5274: fe 06 6e 4d
loc_5278:
    jmp short loc_5286                                                          ; 5278: eb 0c
loc_527a:
    sub ax, word [0x4d6c]                                                       ; 527a: 2b 06 6c 4d
loc_527e:
    jae loc_5286                                                                ; 527e: 73 06
loc_5280:
    load16 sub, ax, ax                                                          ; 5280: 2b c0
loc_5282:
    inc byte [0x4d6e]                                                           ; 5282: fe 06 6e 4d
loc_5286:
    mov word [bx + 0x4d5a], ax                                                  ; 5286: 89 87 5a 4d
loc_528a:
    ret                                                                         ; 528a: c3
loc_528b:
    call near initialize_courtship_melody                                       ; 528b: e8 c6 08
loc_528e:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 528e: 80 3e 97 06 fd
loc_5293:
    je loc_529c                                                                 ; 5293: 74 07
loc_5295:
    mov ah, 0xb                                                                 ; 5295: b4 0b
loc_5297:
    mov bx, 0x101                                                               ; 5297: bb 01 01
loc_529a:
    int 0x10                                                                    ; 529a: cd 10
loc_529c:
    call near loc_5060                                                          ; 529c: e8 c1 fd
loc_529f:
    call near loc_514a                                                          ; 529f: e8 a8 fe
loc_52a2:
    call near loc_5bbf                                                          ; 52a2: e8 1a 09
loc_52a5:
    cmp byte [lives_remaining], strict byte 9                                   ; 52a5: 80 3e 80 1f 09
loc_52aa:
    jae loc_52b0                                                                ; 52aa: 73 04
loc_52ac:
    inc byte [lives_remaining]                                                  ; 52ac: fe 06 80 1f
loc_52b0:
    cmp word [difficulty_level], strict byte 7                                  ; 52b0: 83 3e 08 00 07
loc_52b5:
    jae loc_52bb                                                                ; 52b5: 73 04
loc_52b7:
    inc word [difficulty_level]                                                 ; 52b7: ff 06 08 00
loc_52bb:
    mov word [completed_room_count], 0                                          ; 52bb: c7 06 14 04 00 00
loc_52c1:
    load8 sub, ah, ah                                                           ; 52c1: 2a e4
loc_52c3:
    int 0x1a                                                                    ; 52c3: cd 1a
loc_52c5:
    mov word [courtship_cycle_start_tick], dx                                   ; 52c5: 89 16 12 04
loc_52c9:
    call near disable_speaker                                                   ; 52c9: e8 55 08
loc_52cc:
    ret                                                                         ; 52cc: c3
    times 3 db 0 ; original zero fill at CS:52cd
loc_52d0:
    cmp byte [sound_enabled], strict byte 0                                     ; 52d0: 80 3e 00 00 00
loc_52d5:
    je loc_5312                                                                 ; 52d5: 74 3b
loc_52d7:
    load8 sub, ah, ah                                                           ; 52d7: 2a e4
loc_52d9:
    int 0x1a                                                                    ; 52d9: cd 1a
loc_52db:
    cmp dx, word [0x52c4]                                                       ; 52db: 3b 16 c4 52
loc_52df:
    je loc_5312                                                                 ; 52df: 74 31
loc_52e1:
    mov word [0x52c4], dx                                                       ; 52e1: 89 16 c4 52
loc_52e5:
    mov bx, word [0x52c6]                                                       ; 52e5: 8b 1e c6 52
loc_52e9:
    add word [0x52c6], strict byte 2                                            ; 52e9: 83 06 c6 52 02
loc_52ee:
    mov ax, word [bx + 0x52ca]                                                  ; 52ee: 8b 87 ca 52
loc_52f2:
    cmp ax, word [0x52c8]                                                       ; 52f2: 3b 06 c8 52
loc_52f6:
    jne loc_52fc                                                                ; 52f6: 75 04
loc_52f8:
    call near disable_speaker                                                   ; 52f8: e8 26 08
loc_52fb:
    ret                                                                         ; 52fb: c3
loc_52fc:
    mov word [0x52c8], ax                                                       ; 52fc: a3 c8 52
loc_52ff:
    mov al, 0xb6                                                                ; 52ff: b0 b6
loc_5301:
    out 0x43, al                                                                ; 5301: e6 43
loc_5303:
    mov ax, word [0x52c8]                                                       ; 5303: a1 c8 52
loc_5306:
    out 0x42, al                                                                ; 5306: e6 42
loc_5308:
    load8 mov, al, ah                                                           ; 5308: 8a c4
loc_530a:
    out 0x42, al                                                                ; 530a: e6 42
loc_530c:
    in al, 0x61                                                                 ; 530c: e4 61
loc_530e:
    or al, 3                                                                    ; 530e: 0c 03
loc_5310:
    out 0x61, al                                                                ; 5310: e6 61
loc_5312:
    ret                                                                         ; 5312: c3
loc_5313:
    cmp word [difficulty_level], strict byte 2                                  ; 5313: 83 3e 08 00 02
loc_5318:
    jb loc_5367                                                                 ; 5318: 72 4d
loc_531a:
    mov word [0x5016], 0                                                        ; 531a: c7 06 16 50 00 00
loc_5320:
    load8 sub, ah, ah                                                           ; 5320: 2a e4
loc_5322:
    int 0x1a                                                                    ; 5322: cd 1a
loc_5324:
    mov word [0x52c0], dx                                                       ; 5324: 89 16 c0 52
loc_5328:
    mov word [0x52c2], dx                                                       ; 5328: 89 16 c2 52
loc_532c:
    mov word [0x52c4], dx                                                       ; 532c: 89 16 c4 52
loc_5330:
    mov word [0x52c6], 0                                                        ; 5330: c7 06 c6 52 00 00
loc_5336:
    mov word [0x52c8], 0                                                        ; 5336: c7 06 c8 52 00 00
loc_533c:
    call near loc_5368                                                          ; 533c: e8 29 00
loc_533f:
    xor word [0x5016], strict word 2                                            ; 533f: 81 36 16 50 02 00
loc_5345:
    call near loc_52d0                                                          ; 5345: e8 88 ff
loc_5348:
    load8 sub, ah, ah                                                           ; 5348: 2a e4
loc_534a:
    int 0x1a                                                                    ; 534a: cd 1a
loc_534c:
    load16 mov, ax, dx                                                          ; 534c: 8b c2
loc_534e:
    sub ax, word [0x52c0]                                                       ; 534e: 2b 06 c0 52
loc_5352:
    cmp ax, strict word 5                                                       ; 5352: 3d 05 00
loc_5355:
    jb loc_5345                                                                 ; 5355: 72 ee
loc_5357:
    mov word [0x52c0], dx                                                       ; 5357: 89 16 c0 52
loc_535b:
    sub dx, word [0x52c2]                                                       ; 535b: 2b 16 c2 52
loc_535f:
    cmp dx, strict byte 0x28                                                    ; 535f: 83 fa 28
loc_5362:
    jb loc_533c                                                                 ; 5362: 72 d8
loc_5364:
    call near disable_speaker                                                   ; 5364: e8 ba 07
loc_5367:
    ret                                                                         ; 5367: c3
loc_5368:
    mov ax, 0xb800                                                              ; 5368: b8 00 b8
loc_536b:
    mov es, ax                                                                  ; 536b: 8e c0
loc_536d:
    mov bx, word [difficulty_level]                                             ; 536d: 8b 1e 08 00
loc_5371:
    shl bx, 1                                                                   ; 5371: d1 e3
loc_5373:
    mov ax, word [bx + 0x52ae]                                                  ; 5373: 8b 87 ae 52
loc_5377:
    mov word [0x5010], ax                                                       ; 5377: a3 10 50
loc_537a:
    mov bx, word [0x5010]                                                       ; 537a: 8b 1e 10 50
loc_537e:
    mov di, word [bx]                                                           ; 537e: 8b 3f
loc_5380:
    cmp di, strict byte 0                                                       ; 5380: 83 ff 00
loc_5383:
    jne loc_5386                                                                ; 5383: 75 01
loc_5385:
    ret                                                                         ; 5385: c3
loc_5386:
    mov bx, word [bx + 2]                                                       ; 5386: 8b 5f 02
loc_5389:
    xor bx, word [0x5016]                                                       ; 5389: 33 1e 16 50
loc_538d:
    and bx, strict word 2                                                       ; 538d: 81 e3 02 00
loc_5391:
    mov si, word [bx + 0x5012]                                                  ; 5391: 8b b7 12 50
loc_5395:
    mov cx, 0x2304                                                              ; 5395: b9 04 23
loc_5398:
    call near copy_rectangle_to_cga                                             ; 5398: e8 02 da
loc_539b:
    call near loc_52d0                                                          ; 539b: e8 32 ff
loc_539e:
    add word [0x5010], strict byte 4                                            ; 539e: 83 06 10 50 04
loc_53a3:
    jmp short loc_537a                                                          ; 53a3: eb d5
    times 11 db 0 ; original zero fill at CS:53a5
