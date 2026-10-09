; Trash popups and three moving alley objects.
; Original CS:2210..2690 (end exclusive).

; CS:2210 — reset_trash_popup
; Clears only DS:1D59, the trash-popup animation phase.
reset_trash_popup:
    mov byte [0x1d59], 0                                                        ; 2210: c6 06 59 1d 00
loc_2215:
    ret                                                                         ; 2215: c3
; CS:2216 — update_trash_popup
; Chooses a trash location, animates the object at DS:1D5C/1D5F with a 27-phase rise/fall, and tests contact with the player.
update_trash_popup:
    load8 sub, ah, ah                                                           ; 2216: 2a e4
loc_2218:
    int 0x1a                                                                    ; 2218: cd 1a
loc_221a:
    cmp dx, word [0x1d5a]                                                       ; 221a: 3b 16 5a 1d
loc_221e:
    jne loc_2221                                                                ; 221e: 75 01
loc_2220:
    ret                                                                         ; 2220: c3
loc_2221:
    load16 mov, cx, dx                                                          ; 2221: 8b ca
loc_2223:
    call near read_cga_vertical_retrace_bit                                     ; 2223: e8 b2 f1
loc_2226:
    je loc_2220                                                                 ; 2226: 74 f8
loc_2228:
    mov word [0x1d5a], cx                                                       ; 2228: 89 0e 5a 1d
loc_222c:
    call near loc_22f7                                                          ; 222c: e8 c8 00
loc_222f:
    jb loc_2220                                                                 ; 222f: 72 ef
loc_2231:
    cmp byte [0x1d59], strict byte 0                                            ; 2231: 80 3e 59 1d 00
loc_2236:
    jne loc_226d                                                                ; 2236: 75 35
loc_2238:
    cmp byte [player_y], strict byte 0x86                                       ; 2238: 80 3e 7b 05 86
loc_223d:
    je loc_224e                                                                 ; 223d: 74 0f
loc_223f:
    cmp byte [player_y], strict byte 0x8e                                       ; 223f: 80 3e 7b 05 8e
loc_2244:
    je loc_224e                                                                 ; 2244: 74 08
loc_2246:
    call near update_random_state                                               ; 2246: e8 b4 0b
loc_2249:
    cmp dl, strict byte 5                                                       ; 2249: 80 fa 05
loc_224c:
    ja loc_2220                                                                 ; 224c: 77 d2
loc_224e:
    call near loc_15d0                                                          ; 224e: e8 7f f3
loc_2251:
    add dl, strict byte 3                                                       ; 2251: 80 c2 03
loc_2254:
    mov byte [0x1d5e], dl                                                       ; 2254: 88 16 5e 1d
loc_2258:
    call near update_random_state                                               ; 2258: e8 a2 0b
loc_225b:
    and dx, strict word 7                                                       ; 225b: 81 e2 07 00
loc_225f:
    load16 add, cx, dx                                                          ; 225f: 03 ca
loc_2261:
    add cx, strict byte 6                                                       ; 2261: 83 c1 06
loc_2264:
    mov word [0x1d5c], cx                                                       ; 2264: 89 0e 5c 1d
loc_2268:
    mov byte [0x1d59], 0x1b                                                     ; 2268: c6 06 59 1d 1b
loc_226d:
    dec byte [0x1d59]                                                           ; 226d: fe 0e 59 1d
loc_2271:
    mov cx, word [0x1d5c]                                                       ; 2271: 8b 0e 5c 1d
loc_2275:
    mov dl, byte [0x1d5e]                                                       ; 2275: 8a 16 5e 1d
loc_2279:
    cmp byte [0x1d59], strict byte 0xd                                          ; 2279: 80 3e 59 1d 0d
loc_227e:
    jbe loc_2291                                                                ; 227e: 76 11
loc_2280:
    add dl, byte [0x1d59]                                                       ; 2280: 02 16 59 1d
loc_2284:
    sub dl, strict byte 0xf                                                     ; 2284: 80 ea 0f
loc_2287:
    mov bx, 0x1b02                                                              ; 2287: bb 02 1b
loc_228a:
    sub bh, byte [0x1d59]                                                       ; 228a: 2a 3e 59 1d
loc_228e:
    jmp short loc_229f                                                          ; 228e: eb 0f
loc_2290:
    nop                                                                         ; 2290: 90
loc_2291:
    add dl, strict byte 0xc                                                     ; 2291: 80 c2 0c
loc_2294:
    sub dl, byte [0x1d59]                                                       ; 2294: 2a 16 59 1d
loc_2298:
    mov bx, 2                                                                   ; 2298: bb 02 00
loc_229b:
    add bh, byte [0x1d59]                                                       ; 229b: 02 3e 59 1d
loc_229f:
    mov word [0x1d64], bx                                                       ; 229f: 89 1e 64 1d
loc_22a3:
    mov byte [0x1d5f], dl                                                       ; 22a3: 88 16 5f 1d
loc_22a7:
    call near calculate_cga_address                                             ; 22a7: e8 06 0a
loc_22aa:
    mov word [0x1d62], ax                                                       ; 22aa: a3 62 1d
loc_22ad:
    call near loc_22dc                                                          ; 22ad: e8 2c 00
loc_22b0:
    call near loc_22f7                                                          ; 22b0: e8 44 00
loc_22b3:
    jb loc_22bc                                                                 ; 22b3: 72 07
loc_22b5:
    cmp byte [0x1d59], strict byte 0                                            ; 22b5: 80 3e 59 1d 00
loc_22ba:
    jne loc_22bd                                                                ; 22ba: 75 01
loc_22bc:
    ret                                                                         ; 22bc: c3
loc_22bd:
    mov ax, 0xb800                                                              ; 22bd: b8 00 b8
loc_22c0:
    mov es, ax                                                                  ; 22c0: 8e c0
loc_22c2:
    mov di, word [0x1d62]                                                       ; 22c2: 8b 3e 62 1d
loc_22c6:
    mov si, 0x1cf0                                                              ; 22c6: be f0 1c
loc_22c9:
    mov word [0x1d60], di                                                       ; 22c9: 89 3e 60 1d
loc_22cd:
    mov cx, word [0x1d64]                                                       ; 22cd: 8b 0e 64 1d
loc_22d1:
    mov word [0x1d66], cx                                                       ; 22d1: 89 0e 66 1d
loc_22d5:
    mov bp, 0x1d24                                                              ; 22d5: bd 24 1d
loc_22d8:
    call near blit_zero_transparent                                             ; 22d8: e8 f1 09
loc_22db:
    ret                                                                         ; 22db: c3
loc_22dc:
    cmp byte [0x1d59], strict byte 0x1a                                         ; 22dc: 80 3e 59 1d 1a
loc_22e1:
    je loc_22f6                                                                 ; 22e1: 74 13
loc_22e3:
    mov ax, 0xb800                                                              ; 22e3: b8 00 b8
loc_22e6:
    mov es, ax                                                                  ; 22e6: 8e c0
loc_22e8:
    mov di, word [0x1d60]                                                       ; 22e8: 8b 3e 60 1d
loc_22ec:
    mov si, 0x1d24                                                              ; 22ec: be 24 1d
loc_22ef:
    mov cx, word [0x1d66]                                                       ; 22ef: 8b 0e 66 1d
loc_22f3:
    call near copy_rectangle_to_cga                                             ; 22f3: e8 a7 0a
loc_22f6:
    ret                                                                         ; 22f6: c3
loc_22f7:
    cmp byte [0x1d59], strict byte 0                                            ; 22f7: 80 3e 59 1d 00
loc_22fc:
    jne loc_2300                                                                ; 22fc: 75 02
loc_22fe:
    clc                                                                         ; 22fe: f8
loc_22ff:
    ret                                                                         ; 22ff: c3
loc_2300:
    mov cx, word [0x1d64]                                                       ; 2300: 8b 0e 64 1d
loc_2304:
    xchg ch, cl                                                                 ; 2304: 86 e9
loc_2306:
    mov ax, word [0x1d5c]                                                       ; 2306: a1 5c 1d
loc_2309:
    mov dl, byte [0x1d5f]                                                       ; 2309: 8a 16 5f 1d
loc_230d:
    mov si, 0x10                                                                ; 230d: be 10 00
loc_2310:
    mov bx, word [player_x]                                                     ; 2310: 8b 1e 79 05
loc_2314:
    mov dh, byte [player_y]                                                     ; 2314: 8a 36 7b 05
loc_2318:
    mov di, 0x18                                                                ; 2318: bf 18 00
loc_231b:
    mov ch, 0xe                                                                 ; 231b: b5 0e
loc_231d:
    call near rectangles_overlap                                                ; 231d: e8 09 0b
loc_2320:
    jae loc_2327                                                                ; 2320: 73 05
loc_2322:
    mov byte [enemy_forced_entry], 1                                                        ; 2322: c6 06 58 1d 01
loc_2327:
    ret                                                                         ; 2327: c3
    times 8 db 0 ; original zero fill at CS:2328
; CS:2330 — initialize_alley_moving_objects
; Initializes three X coordinates at DS:1F30 and three direction/phase/state arrays; spawn side depends on player X.
initialize_alley_moving_objects:
    mov word [0x1f6c], 0                                                        ; 2330: c7 06 6c 1f 00 00
loc_2336:
    load16 sub, ax, ax                                                          ; 2336: 2b c0
loc_2338:
    mov dl, 1                                                                   ; 2338: b2 01
loc_233a:
    cmp word [player_x], strict word 0xa0                                       ; 233a: 81 3e 79 05 a0 00
loc_2340:
    ja loc_2347                                                                 ; 2340: 77 05
loc_2342:
    mov ax, 0x12c                                                               ; 2342: b8 2c 01
loc_2345:
    mov dl, 0xff                                                                ; 2345: b2 ff
loc_2347:
    mov word [alley_object_x], ax                                               ; 2347: a3 30 1f
loc_234a:
    mov word [0x1f32], ax                                                       ; 234a: a3 32 1f
loc_234d:
    mov word [0x1f34], ax                                                       ; 234d: a3 34 1f
loc_2350:
    mov byte [alley_object_horizontal_direction], dl                            ; 2350: 88 16 3c 1f
loc_2354:
    mov byte [0x1f3d], dl                                                       ; 2354: 88 16 3d 1f
loc_2358:
    mov byte [0x1f3e], dl                                                       ; 2358: 88 16 3e 1f
loc_235c:
    mov byte [0x1f48], 1                                                        ; 235c: c6 06 48 1f 01
loc_2361:
    mov byte [0x1f49], 1                                                        ; 2361: c6 06 49 1f 01
loc_2366:
    mov byte [0x1f4a], 1                                                        ; 2366: c6 06 4a 1f 01
loc_236b:
    mov byte [0x1f50], 0                                                        ; 236b: c6 06 50 1f 00
loc_2370:
    mov byte [0x1f51], 0                                                        ; 2370: c6 06 51 1f 00
loc_2375:
    mov byte [0x1f52], 0                                                        ; 2375: c6 06 52 1f 00
loc_237a:
    ret                                                                         ; 237a: c3
loc_237b:
    load8 sub, ah, ah                                                           ; 237b: 2a e4
loc_237d:
    int 0x1a                                                                    ; 237d: cd 1a
loc_237f:
    cmp dx, word [0x1f65]                                                       ; 237f: 3b 16 65 1f
loc_2383:
    jne loc_2386                                                                ; 2383: 75 01
loc_2385:
    ret                                                                         ; 2385: c3
loc_2386:
    mov word [0x1f65], dx                                                       ; 2386: 89 16 65 1f
loc_238a:
    cmp byte [player_transition_blocked], strict byte 0                         ; 238a: 80 3e 5a 05 00
loc_238f:
    jne loc_2385                                                                ; 238f: 75 f4
loc_2391:
    mov bx, word [0x1f6c]                                                       ; 2391: 8b 1e 6c 1f
loc_2395:
    inc bx                                                                      ; 2395: 43
loc_2396:
    cmp bx, strict byte 3                                                       ; 2396: 83 fb 03
loc_2399:
    jb loc_239e                                                                 ; 2399: 72 03
loc_239b:
    mov bx, 0                                                                   ; 239b: bb 00 00
loc_239e:
    mov word [0x1f6c], bx                                                       ; 239e: 89 1e 6c 1f
loc_23a2:
    call near loc_265e                                                          ; 23a2: e8 b9 02
loc_23a5:
    jb loc_2385                                                                 ; 23a5: 72 de
loc_23a7:
    call near loc_2567                                                          ; 23a7: e8 bd 01
loc_23aa:
    jb loc_2385                                                                 ; 23aa: 72 d9
loc_23ac:
    mov bx, word [0x1f6c]                                                       ; 23ac: 8b 1e 6c 1f
loc_23b0:
    cmp byte [bx + 0x1f50], strict byte 0                                       ; 23b0: 80 bf 50 1f 00
loc_23b5:
    je loc_23eb                                                                 ; 23b5: 74 34
loc_23b7:
    load8 sub, ah, ah                                                           ; 23b7: 2a e4
loc_23b9:
    int 0x1a                                                                    ; 23b9: cd 1a
loc_23bb:
    mov bx, word [0x1f6c]                                                       ; 23bb: 8b 1e 6c 1f
loc_23bf:
    shl bl, 1                                                                   ; 23bf: d0 e3
loc_23c1:
    sub dx, word [bx + 0x1f53]                                                  ; 23c1: 2b 97 53 1f
loc_23c5:
    cmp dx, strict byte 0x36                                                    ; 23c5: 83 fa 36
loc_23c8:
    jb loc_2385                                                                 ; 23c8: 72 bb
loc_23ca:
    mov dl, 1                                                                   ; 23ca: b2 01
loc_23cc:
    mov ax, 0                                                                   ; 23cc: b8 00 00
loc_23cf:
    cmp word [player_x], strict word 0xa0                                       ; 23cf: 81 3e 79 05 a0 00
loc_23d5:
    ja loc_23dc                                                                 ; 23d5: 77 05
loc_23d7:
    mov ax, 0x12c                                                               ; 23d7: b8 2c 01
loc_23da:
    mov dl, 0xff                                                                ; 23da: b2 ff
loc_23dc:
    mov word [bx + alley_object_x], ax                                          ; 23dc: 89 87 30 1f
loc_23e0:
    shr bl, 1                                                                   ; 23e0: d0 eb
loc_23e2:
    mov byte [bx + 0x1f50], 0                                                   ; 23e2: c6 87 50 1f 00
loc_23e7:
    mov byte [bx + alley_object_horizontal_direction], dl                       ; 23e7: 88 97 3c 1f
loc_23eb:
    mov dl, byte [bx + alley_object_horizontal_direction]                       ; 23eb: 8a 97 3c 1f
loc_23ef:
    mov byte [bx + 0x1f3f], dl                                                  ; 23ef: 88 97 3f 1f
loc_23f3:
    cmp byte [0x1664], strict byte 0                                            ; 23f3: 80 3e 64 16 00
loc_23f8:
    je loc_2403                                                                 ; 23f8: 74 09
loc_23fa:
    mov word [0x1f69], 0xc                                                      ; 23fa: c7 06 69 1f 0c 00
loc_2400:
    jmp short loc_2418                                                          ; 2400: eb 16
loc_2402:
    nop                                                                         ; 2402: 90
loc_2403:
    mov ax, 8                                                                   ; 2403: b8 08 00
loc_2406:
    cmp byte [player_y], strict byte 0x60                                       ; 2406: 80 3e 7b 05 60
loc_240b:
    jbe loc_240f                                                                ; 240b: 76 02
loc_240d:
    shr al, 1                                                                   ; 240d: d0 e8
loc_240f:
    mov word [0x1f69], ax                                                       ; 240f: a3 69 1f
loc_2412:
    cmp bx, word [moving_window_row]                                            ; 2412: 3b 1e 2f 05
loc_2416:
    jne loc_2425                                                                ; 2416: 75 0d
loc_2418:
    cmp byte [bx + alley_object_horizontal_direction], strict byte 0            ; 2418: 80 bf 3c 1f 00
loc_241d:
    jne loc_2425                                                                ; 241d: 75 06
loc_241f:
    call near update_random_state                                               ; 241f: e8 db 09
loc_2422:
    jmp short loc_248a                                                          ; 2422: eb 66
loc_2424:
    nop                                                                         ; 2424: 90
loc_2425:
    cmp byte [player_support_kind], strict byte 0                               ; 2425: 80 3e 5c 05 00
loc_242a:
    je loc_2466                                                                 ; 242a: 74 3a
loc_242c:
    mov al, byte [bx + 0x1f36]                                                  ; 242c: 8a 87 36 1f
loc_2430:
    cmp al, byte [player_y]                                                     ; 2430: 3a 06 7b 05
loc_2434:
    ja loc_2466                                                                 ; 2434: 77 30
loc_2436:
    add al, 0x10                                                                ; 2436: 04 10
loc_2438:
    cmp al, byte [player_y]                                                     ; 2438: 3a 06 7b 05
loc_243c:
    jb loc_2466                                                                 ; 243c: 72 28
loc_243e:
    call near update_random_state                                               ; 243e: e8 bc 09
loc_2441:
    mov si, word [difficulty_level]                                             ; 2441: 8b 36 08 00
loc_2445:
    cmp dl, byte [si + 0x1f6e]                                                  ; 2445: 3a 94 6e 1f
loc_2449:
    ja loc_2466                                                                 ; 2449: 77 1b
loc_244b:
    mov word [0x1f69], 0xc                                                      ; 244b: c7 06 69 1f 0c 00
loc_2451:
    mov al, 1                                                                   ; 2451: b0 01
loc_2453:
    shl bl, 1                                                                   ; 2453: d0 e3
loc_2455:
    mov cx, word [bx + alley_object_x]                                          ; 2455: 8b 8f 30 1f
loc_2459:
    shr bl, 1                                                                   ; 2459: d0 eb
loc_245b:
    cmp cx, word [player_x]                                                     ; 245b: 3b 0e 79 05
loc_245f:
    jb loc_2463                                                                 ; 245f: 72 02
loc_2461:
    mov al, 0xff                                                                ; 2461: b0 ff
loc_2463:
    jmp short loc_2492                                                          ; 2463: eb 2d
loc_2465:
    nop                                                                         ; 2465: 90
loc_2466:
    mov cl, 0x18                                                                ; 2466: b1 18
loc_2468:
    cmp byte [player_y], strict byte 0x60                                       ; 2468: 80 3e 7b 05 60
loc_246d:
    jbe loc_247a                                                                ; 246d: 76 0b
loc_246f:
    mov cl, 0x28                                                                ; 246f: b1 28
loc_2471:
    cmp byte [bx + alley_object_horizontal_direction], strict byte 0            ; 2471: 80 bf 3c 1f 00
loc_2476:
    jne loc_247a                                                                ; 2476: 75 02
loc_2478:
    mov cl, 0x10                                                                ; 2478: b1 10
loc_247a:
    call near update_random_state                                               ; 247a: e8 80 09
loc_247d:
    load8 cmp, dl, cl                                                           ; 247d: 3a d1
loc_247f:
    ja loc_2496                                                                 ; 247f: 77 15
loc_2481:
    mov al, 0                                                                   ; 2481: b0 00
loc_2483:
    cmp byte [bx + alley_object_horizontal_direction], strict byte 0            ; 2483: 80 bf 3c 1f 00
loc_2488:
    jne loc_2492                                                                ; 2488: 75 08
loc_248a:
    load8 mov, al, dl                                                           ; 248a: 8a c2
loc_248c:
    and al, 1                                                                   ; 248c: 24 01
loc_248e:
    jne loc_2492                                                                ; 248e: 75 02
loc_2490:
    mov al, 0xff                                                                ; 2490: b0 ff
loc_2492:
    mov byte [bx + alley_object_horizontal_direction], al                       ; 2492: 88 87 3c 1f
loc_2496:
    mov dl, byte [bx + alley_object_horizontal_direction]                       ; 2496: 8a 97 3c 1f
loc_249a:
    shl bl, 1                                                                   ; 249a: d0 e3
loc_249c:
    mov ax, word [bx + alley_object_x]                                          ; 249c: 8b 87 30 1f
loc_24a0:
    cmp dl, strict byte 1                                                       ; 24a0: 80 fa 01
loc_24a3:
    jb loc_24c2                                                                 ; 24a3: 72 1d
loc_24a5:
    jne loc_24b8                                                                ; 24a5: 75 11
loc_24a7:
    add ax, word [0x1f69]                                                       ; 24a7: 03 06 69 1f
loc_24ab:
    cmp ax, strict word 0x12f                                                   ; 24ab: 3d 2f 01
loc_24ae:
    jb loc_24c2                                                                 ; 24ae: 72 12
loc_24b0:
    mov ax, 0x12e                                                               ; 24b0: b8 2e 01
loc_24b3:
    mov dl, 0xff                                                                ; 24b3: b2 ff
loc_24b5:
    jmp short loc_24c2                                                          ; 24b5: eb 0b
loc_24b7:
    nop                                                                         ; 24b7: 90
loc_24b8:
    sub ax, word [0x1f69]                                                       ; 24b8: 2b 06 69 1f
loc_24bc:
    jae loc_24c2                                                                ; 24bc: 73 04
loc_24be:
    load16 sub, ax, ax                                                          ; 24be: 2b c0
loc_24c0:
    mov dl, 1                                                                   ; 24c0: b2 01
loc_24c2:
    mov word [bx + alley_object_x], ax                                          ; 24c2: 89 87 30 1f
loc_24c6:
    shr bl, 1                                                                   ; 24c6: d0 eb
loc_24c8:
    mov byte [bx + alley_object_horizontal_direction], dl                       ; 24c8: 88 97 3c 1f
loc_24cc:
    mov dl, byte [bx + 0x1f36]                                                  ; 24cc: 8a 97 36 1f
loc_24d0:
    load16 mov, cx, ax                                                          ; 24d0: 8b c8
loc_24d2:
    call near calculate_cga_address                                             ; 24d2: e8 db 07
loc_24d5:
    mov word [0x1f4b], ax                                                       ; 24d5: a3 4b 1f
loc_24d8:
    mov bx, word [0x1f6c]                                                       ; 24d8: 8b 1e 6c 1f
loc_24dc:
    cmp byte [bx + 0x1f48], strict byte 0                                       ; 24dc: 80 bf 48 1f 00
loc_24e1:
    jne loc_24f0                                                                ; 24e1: 75 0d
loc_24e3:
    mov al, byte [bx + alley_object_horizontal_direction]                       ; 24e3: 8a 87 3c 1f
loc_24e7:
    or al, byte [bx + 0x1f3f]                                                   ; 24e7: 0a 87 3f 1f
loc_24eb:
    je loc_24f0                                                                 ; 24eb: 74 03
loc_24ed:
    call near loc_254d                                                          ; 24ed: e8 5d 00
loc_24f0:
    call near loc_265e                                                          ; 24f0: e8 6b 01
loc_24f3:
    jb loc_24fa                                                                 ; 24f3: 72 05
loc_24f5:
    call near loc_2567                                                          ; 24f5: e8 6f 00
loc_24f8:
    jae loc_24fb                                                                ; 24f8: 73 01
loc_24fa:
    ret                                                                         ; 24fa: c3
loc_24fb:
    mov bx, word [0x1f6c]                                                       ; 24fb: 8b 1e 6c 1f
loc_24ff:
    mov byte [bx + 0x1f48], 0                                                   ; 24ff: c6 87 48 1f 00
loc_2504:
    cmp byte [bx + alley_object_horizontal_direction], strict byte 0            ; 2504: 80 bf 3c 1f 00
loc_2509:
    jne loc_2518                                                                ; 2509: 75 0d
loc_250b:
    cmp byte [bx + 0x1f3f], strict byte 0                                       ; 250b: 80 bf 3f 1f 00
loc_2510:
    je loc_254c                                                                 ; 2510: 74 3a
loc_2512:
    mov si, 0x1e30                                                              ; 2512: be 30 1e
loc_2515:
    jmp short loc_2533                                                          ; 2515: eb 1c
loc_2517:
    nop                                                                         ; 2517: 90
loc_2518:
    mov si, 0x1e50                                                              ; 2518: be 50 1e
loc_251b:
    inc byte [bx + 0x1f4d]                                                      ; 251b: fe 87 4d 1f
loc_251f:
    test byte [bx + 0x1f4d], 1                                                  ; 251f: f6 87 4d 1f 01
loc_2524:
    jne loc_2529                                                                ; 2524: 75 03
loc_2526:
    add si, strict byte 0x20                                                    ; 2526: 83 c6 20
loc_2529:
    cmp byte [bx + alley_object_horizontal_direction], strict byte 1            ; 2529: 80 bf 3c 1f 01
loc_252e:
    je loc_2533                                                                 ; 252e: 74 03
loc_2530:
    add si, strict byte 0x40                                                    ; 2530: 83 c6 40
loc_2533:
    shl bl, 1                                                                   ; 2533: d0 e3
loc_2535:
    mov di, word [0x1f4b]                                                       ; 2535: 8b 3e 4b 1f
loc_2539:
    mov word [bx + 0x1f42], di                                                  ; 2539: 89 bf 42 1f
loc_253d:
    mov ax, 0xb800                                                              ; 253d: b8 00 b8
loc_2540:
    mov es, ax                                                                  ; 2540: 8e c0
loc_2542:
    mov bp, word [bx + 0x1f59]                                                  ; 2542: 8b af 59 1f
loc_2546:
    mov cx, 0x802                                                               ; 2546: b9 02 08
loc_2549:
    call near blit_and_mask                                                     ; 2549: e8 e9 07
loc_254c:
    ret                                                                         ; 254c: c3
loc_254d:
    mov bx, word [0x1f6c]                                                       ; 254d: 8b 1e 6c 1f
loc_2551:
    shl bl, 1                                                                   ; 2551: d0 e3
loc_2553:
    mov ax, 0xb800                                                              ; 2553: b8 00 b8
loc_2556:
    mov es, ax                                                                  ; 2556: 8e c0
loc_2558:
    mov di, word [bx + 0x1f42]                                                  ; 2558: 8b bf 42 1f
loc_255c:
    mov si, word [bx + 0x1f59]                                                  ; 255c: 8b b7 59 1f
loc_2560:
    mov cx, 0x802                                                               ; 2560: b9 02 08
loc_2563:
    call near copy_rectangle_to_cga                                             ; 2563: e8 37 08
loc_2566:
    ret                                                                         ; 2566: c3
loc_2567:
    mov bx, word [0x1f6c]                                                       ; 2567: 8b 1e 6c 1f
loc_256b:
    mov dl, byte [bx + 0x1f36]                                                  ; 256b: 8a 97 36 1f
loc_256f:
    shl bl, 1                                                                   ; 256f: d0 e3
loc_2571:
    mov ax, word [bx + alley_object_x]                                          ; 2571: 8b 87 30 1f
loc_2575:
    mov si, 0x10                                                                ; 2575: be 10 00
loc_2578:
    mov bx, word [player_x]                                                     ; 2578: 8b 1e 79 05
loc_257c:
    mov dh, byte [player_y]                                                     ; 257c: 8a 36 7b 05
loc_2580:
    mov di, 0x18                                                                ; 2580: bf 18 00
loc_2583:
    mov cx, 0xe08                                                               ; 2583: b9 08 0e
loc_2586:
    call near rectangles_overlap                                                ; 2586: e8 a0 08
loc_2589:
    jb loc_258e                                                                 ; 2589: 72 03
loc_258b:
    jmp near loc_265d                                                           ; 258b: e9 cf 00
loc_258e:
    mov bx, word [0x1f6c]                                                       ; 258e: 8b 1e 6c 1f
loc_2592:
    cmp byte [bx + 0x1f50], strict byte 0                                       ; 2592: 80 bf 50 1f 00
loc_2597:
    jne loc_260c                                                                ; 2597: 75 73
loc_2599:
    cmp byte [player_y_plus_50], strict byte 0x26                               ; 2599: 80 3e 7c 05 26
loc_259e:
    jb loc_260c                                                                 ; 259e: 72 6c
loc_25a0:
    cmp byte [player_support_kind], strict byte 0                               ; 25a0: 80 3e 5c 05 00
loc_25a5:
    je loc_260e                                                                 ; 25a5: 74 67
loc_25a7:
    mov byte [player_support_kind], 0                                           ; 25a7: c6 06 5c 05 00
loc_25ac:
    mov byte [0x55b], 0x11                                                      ; 25ac: c6 06 5b 05 11
loc_25b1:
    mov byte [player_vertical_direction], 1                                     ; 25b1: c6 06 71 05 01
loc_25b6:
    mov byte [player_horizontal_direction], 0                                   ; 25b6: c6 06 6e 05 00
loc_25bb:
    mov bx, word [0x1f6c]                                                       ; 25bb: 8b 1e 6c 1f
loc_25bf:
    shl bl, 1                                                                   ; 25bf: d0 e3
loc_25c1:
    mov di, word [bx + 0x1f42]                                                  ; 25c1: 8b bf 42 1f
loc_25c5:
    cmp word [bx + alley_object_x], strict byte 0x10                            ; 25c5: 83 bf 30 1f 10
loc_25ca:
    jb loc_25cf                                                                 ; 25ca: 72 03
loc_25cc:
    sub di, strict byte 4                                                       ; 25cc: 83 ef 04
loc_25cf:
    mov word [0x1f67], di                                                       ; 25cf: 89 3e 67 1f
loc_25d3:
    mov ax, 0xb800                                                              ; 25d3: b8 00 b8
loc_25d6:
    mov es, ax                                                                  ; 25d6: 8e c0
loc_25d8:
    mov si, 0x1d70                                                              ; 25d8: be 70 1d
loc_25db:
    mov bp, 0xe                                                                 ; 25db: bd 0e 00
loc_25de:
    mov cx, 0x806                                                               ; 25de: b9 06 08
loc_25e1:
    call near blit_zero_transparent                                             ; 25e1: e8 e8 06
loc_25e4:
    load8 sub, ah, ah                                                           ; 25e4: 2a e4
loc_25e6:
    int 0x1a                                                                    ; 25e6: cd 1a
loc_25e8:
    mov word [0x1f65], dx                                                       ; 25e8: 89 16 65 1f
loc_25ec:
    call near loc_5a90                                                          ; 25ec: e8 a1 34
loc_25ef:
    load8 sub, ah, ah                                                           ; 25ef: 2a e4
loc_25f1:
    int 0x1a                                                                    ; 25f1: cd 1a
loc_25f3:
    sub dx, word [0x1f65]                                                       ; 25f3: 2b 16 65 1f
loc_25f7:
    cmp dx, strict byte 8                                                       ; 25f7: 83 fa 08
loc_25fa:
    jb loc_25ec                                                                 ; 25fa: 72 f0
loc_25fc:
    call near disable_speaker                                                   ; 25fc: e8 22 35
loc_25ff:
    mov di, word [0x1f67]                                                       ; 25ff: 8b 3e 67 1f
loc_2603:
    mov si, 0xe                                                                 ; 2603: be 0e 00
loc_2606:
    mov cx, 0x806                                                               ; 2606: b9 06 08
loc_2609:
    call near copy_rectangle_to_cga                                             ; 2609: e8 91 07
loc_260c:
    stc                                                                         ; 260c: f9
loc_260d:
    ret                                                                         ; 260d: c3
loc_260e:
    load8 sub, ah, ah                                                           ; 260e: 2a e4
loc_2610:
    int 0x1a                                                                    ; 2610: cd 1a
loc_2612:
    mov bx, word [0x1f6c]                                                       ; 2612: 8b 1e 6c 1f
loc_2616:
    mov byte [bx + 0x1f50], 1                                                   ; 2616: c6 87 50 1f 01
loc_261b:
    mov byte [bx + alley_object_horizontal_direction], 1                        ; 261b: c6 87 3c 1f 01
loc_2620:
    shl bl, 1                                                                   ; 2620: d0 e3
loc_2622:
    mov word [bx + 0x1f53], dx                                                  ; 2622: 89 97 53 1f
loc_2626:
    call near restore_player_background                                         ; 2626: e8 ba eb
loc_2629:
    mov bx, word [0x1f6c]                                                       ; 2629: 8b 1e 6c 1f
loc_262d:
    shl bl, 1                                                                   ; 262d: d0 e3
loc_262f:
    mov si, word [bx + 0x1f5f]                                                  ; 262f: 8b b7 5f 1f
loc_2633:
    mov di, word [bx + 0x1f42]                                                  ; 2633: 8b bf 42 1f
loc_2637:
    mov ax, 0xb800                                                              ; 2637: b8 00 b8
loc_263a:
    mov es, ax                                                                  ; 263a: 8e c0
loc_263c:
    mov bp, 0xe                                                                 ; 263c: bd 0e 00
loc_263f:
    mov cx, 0x802                                                               ; 263f: b9 02 08
loc_2642:
    call near blit_zero_transparent                                             ; 2642: e8 87 06
loc_2645:
    call near save_player_background                                            ; 2645: e8 dc ea
loc_2648:
    mov bx, word [0x1f6c]                                                       ; 2648: 8b 1e 6c 1f
loc_264c:
    mov al, byte [bx + 0x1f39]                                                  ; 264c: 8a 87 39 1f
loc_2650:
    call near add_score_tens                                                    ; 2650: e8 b3 00
loc_2653:
    mov ax, 0x3e8                                                               ; 2653: b8 e8 03
loc_2656:
    mov bx, 0x2ee                                                               ; 2656: bb ee 02
loc_2659:
    call near start_two_stage_sound                                             ; 2659: e8 df 32
loc_265c:
    stc                                                                         ; 265c: f9
loc_265d:
    ret                                                                         ; 265d: c3
loc_265e:
    cmp byte [alley_projectile_y], strict byte 0                                ; 265e: 80 3e 73 16 00
loc_2663:
    jne loc_2667                                                                ; 2663: 75 02
loc_2665:
    clc                                                                         ; 2665: f8
loc_2666:
    ret                                                                         ; 2666: c3
loc_2667:
    mov bx, word [0x1f6c]                                                       ; 2667: 8b 1e 6c 1f
loc_266b:
    mov dl, byte [bx + 0x1f36]                                                  ; 266b: 8a 97 36 1f
loc_266f:
    shl bl, 1                                                                   ; 266f: d0 e3
loc_2671:
    mov ax, word [bx + alley_object_x]                                          ; 2671: 8b 87 30 1f
loc_2675:
    mov si, 0x10                                                                ; 2675: be 10 00
loc_2678:
    load16 mov, di, si                                                          ; 2678: 8b fe
loc_267a:
    mov bx, word [alley_projectile_x]                                           ; 267a: 8b 1e 71 16
loc_267e:
    mov dh, byte [alley_projectile_y]                                           ; 267e: 8a 36 73 16
loc_2682:
    mov cx, 0xc08                                                               ; 2682: b9 08 0c
loc_2685:
    call near rectangles_overlap                                                ; 2685: e8 a1 07
loc_2688:
    ret                                                                         ; 2688: c3
    times 7 db 0 ; original zero fill at CS:2689
