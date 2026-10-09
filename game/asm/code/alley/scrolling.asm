; Moving window rows and support bitmaps.
; Original CS:04A0..070D (end exclusive).

; CS:04a0 — scroll_alley_window_row
; Moves a 16-scanline CGA strip by one byte, rotates its collision bitmap, inserts a generated column, and carries a supported player by four pixels; middle row moves in the opposite direction.
scroll_alley_window_row:
    dec byte [0x531]                                                            ; 04a0: fe 0e 31 05
loc_04a4:
    je loc_04a7                                                                 ; 04a4: 74 01
loc_04a6:
    ret                                                                         ; 04a6: c3
loc_04a7:
    inc byte [0x531]                                                            ; 04a7: fe 06 31 05
loc_04ab:
    call near read_cga_vertical_retrace_bit                                     ; 04ab: e8 2a 0f
loc_04ae:
    jne loc_04a6                                                                ; 04ae: 75 f6
loc_04b0:
    cmp byte [player_transition_blocked], strict byte 0                         ; 04b0: 80 3e 5a 05 00
loc_04b5:
    jne loc_04a6                                                                ; 04b5: 75 ef
loc_04b7:
    cmp byte [alley_projectile_y], strict byte 0                                ; 04b7: 80 3e 73 16 00
loc_04bc:
    jne loc_04a6                                                                ; 04bc: 75 e8
loc_04be:
    load8 sub, ah, ah                                                           ; 04be: 2a e4
loc_04c0:
    int 0x1a                                                                    ; 04c0: cd 1a
loc_04c2:
    cmp dx, word [0x544]                                                        ; 04c2: 3b 16 44 05
loc_04c6:
    je loc_04a6                                                                 ; 04c6: 74 de
loc_04c8:
    mov word [0x544], dx                                                        ; 04c8: 89 16 44 05
loc_04cc:
    mov bx, word [difficulty_level]                                             ; 04cc: 8b 1e 08 00
loc_04d0:
    mov al, byte [bx + 0x532]                                                   ; 04d0: 8a 87 32 05
loc_04d4:
    cmp byte [player_y], strict byte 0x60                                       ; 04d4: 80 3e 7b 05 60
loc_04d9:
    ja loc_04df                                                                 ; 04d9: 77 04
loc_04db:
    shr al, 1                                                                   ; 04db: d0 e8
loc_04dd:
    shr al, 1                                                                   ; 04dd: d0 e8
loc_04df:
    mov byte [0x531], al                                                        ; 04df: a2 31 05
loc_04e2:
    mov bx, word [moving_window_row]                                            ; 04e2: 8b 1e 2f 05
loc_04e6:
    call near classify_player_on_moving_row                                     ; 04e6: e8 6f 01
loc_04e9:
    je loc_050c                                                                 ; 04e9: 74 21
loc_04eb:
    mov al, byte [window_scroll_phase]                                          ; 04eb: a0 25 05
loc_04ee:
    add al, byte [bx + 0x529]                                                   ; 04ee: 02 87 29 05
loc_04f2:
    cmp al, 4                                                                   ; 04f2: 3c 04
loc_04f4:
    jb loc_04a6                                                                 ; 04f4: 72 b0
loc_04f6:
    call near update_random_state                                               ; 04f6: e8 04 29
loc_04f9:
    and dl, strict byte 3                                                       ; 04f9: 80 e2 03
loc_04fc:
    cmp dl, byte [moving_window_row]                                            ; 04fc: 3a 16 2f 05
loc_0500:
    je loc_04f6                                                                 ; 0500: 74 f4
loc_0502:
    cmp dl, strict byte 3                                                       ; 0502: 80 fa 03
loc_0505:
    je loc_04f6                                                                 ; 0505: 74 ef
loc_0507:
    load8 mov, bl, dl                                                           ; 0507: 8a da
loc_0509:
    jmp short loc_0535                                                          ; 0509: eb 2a
loc_050b:
    nop                                                                         ; 050b: 90
loc_050c:
    mov al, byte [bx + 0x529]                                                   ; 050c: 8a 87 29 05
loc_0510:
    add byte [window_scroll_phase], al                                          ; 0510: 00 06 25 05
loc_0514:
    cmp byte [window_scroll_phase], strict byte 4                               ; 0514: 80 3e 25 05 04
loc_0519:
    jb loc_0583                                                                 ; 0519: 72 68
loc_051b:
    call near update_random_state                                               ; 051b: e8 df 28
loc_051e:
    cmp dl, strict byte 0x40                                                    ; 051e: 80 fa 40
loc_0521:
    ja loc_0539                                                                 ; 0521: 77 16
loc_0523:
    call near update_random_state                                               ; 0523: e8 d7 28
loc_0526:
    and dl, strict byte 3                                                       ; 0526: 80 e2 03
loc_0529:
    cmp dl, strict byte 3                                                       ; 0529: 80 fa 03
loc_052c:
    je loc_0523                                                                 ; 052c: 74 f5
loc_052e:
    load8 mov, bl, dl                                                           ; 052e: 8a da
loc_0530:
    call near classify_player_on_moving_row                                     ; 0530: e8 25 01
loc_0533:
    jne loc_0523                                                                ; 0533: 75 ee
loc_0535:
    mov word [moving_window_row], bx                                            ; 0535: 89 1e 2f 05
loc_0539:
    mov al, byte [bx + 0x526]                                                   ; 0539: 8a 87 26 05
loc_053d:
    mov byte [window_scroll_phase], al                                          ; 053d: a2 25 05
loc_0540:
    mov ax, DATA_PARAGRAPH                                                      ; 0540: b8 10 00
loc_0543:
    mov es, ax                                                                  ; 0543: 8e c0
loc_0545:
    mov di, 0x4d7                                                               ; 0545: bf d7 04
loc_0548:
    mov ah, byte [bx + 0x52c]                                                   ; 0548: 8a a7 2c 05
loc_054c:
    mov bx, word [difficulty_level]                                             ; 054c: 8b 1e 08 00
loc_0550:
    mov bl, byte [bx + 0x2aba]                                                  ; 0550: 8a 9f ba 2a
loc_0554:
    load8 mov, bh, ah                                                           ; 0554: 8a fc
loc_0556:
    call near generate_window_strip_column                                      ; 0556: e8 24 01
loc_0559:
    cmp word [moving_window_row], strict byte 1                                 ; 0559: 83 3e 2f 05 01
loc_055e:
    je loc_056e                                                                 ; 055e: 74 0e
loc_0560:
    shr byte [0x540], 1                                                         ; 0560: d0 2e 40 05
loc_0564:
    call near rotate_window_collision_bits                                      ; 0564: e8 cc 00
loc_0567:
    shr byte [0x540], 1                                                         ; 0567: d0 2e 40 05
loc_056b:
    jmp short loc_057c                                                          ; 056b: eb 0f
loc_056d:
    nop                                                                         ; 056d: 90
loc_056e:
    mov al, byte [0x540]                                                        ; 056e: a0 40 05
loc_0571:
    shr al, 1                                                                   ; 0571: d0 e8
loc_0573:
    shr al, 1                                                                   ; 0573: d0 e8
loc_0575:
    call near rotate_window_collision_bits                                      ; 0575: e8 bb 00
loc_0578:
    shr byte [0x540], 1                                                         ; 0578: d0 2e 40 05
loc_057c:
    call near rotate_window_collision_bits                                      ; 057c: e8 b4 00
loc_057f:
    mov bx, word [moving_window_row]                                            ; 057f: 8b 1e 2f 05
loc_0583:
    cmp byte [0x4d6], strict byte 0                                             ; 0583: 80 3e d6 04 00
loc_0588:
    je loc_05d0                                                                 ; 0588: 74 46
loc_058a:
    mov ax, word [player_x]                                                     ; 058a: a1 79 05
loc_058d:
    cmp bl, strict byte 1                                                       ; 058d: 80 fb 01
loc_0590:
    je loc_05bf                                                                 ; 0590: 74 2d
loc_0592:
    inc word [player_video_offset]                                              ; 0592: ff 06 5f 05
loc_0596:
    add ax, strict word 4                                                       ; 0596: 05 04 00
loc_0599:
    cmp ax, strict word 0x123                                                   ; 0599: 3d 23 01
loc_059c:
    jb loc_05cd                                                                 ; 059c: 72 2f
loc_059e:
    mov byte [0x55b], 0x11                                                      ; 059e: c6 06 5b 05 11
loc_05a3:
    mov byte [player_vertical_direction], 1                                     ; 05a3: c6 06 71 05 01
loc_05a8:
    mov byte [player_vertical_speed], 1                                         ; 05a8: c6 06 76 05 01
loc_05ad:
    mov byte [player_vertical_acceleration_step], 0x18                          ; 05ad: c6 06 78 05 18
loc_05b2:
    mov byte [player_horizontal_speed], 1                                       ; 05b2: c6 06 72 05 01
loc_05b7:
    mov byte [player_support_kind], 0                                           ; 05b7: c6 06 5c 05 00
loc_05bc:
    jmp short loc_05d0                                                          ; 05bc: eb 12
loc_05be:
    nop                                                                         ; 05be: 90
loc_05bf:
    dec word [player_video_offset]                                              ; 05bf: ff 0e 5f 05
loc_05c3:
    sub ax, strict word 4                                                       ; 05c3: 2d 04 00
loc_05c6:
    jb loc_059e                                                                 ; 05c6: 72 d6
loc_05c8:
    cmp ax, strict word 8                                                       ; 05c8: 3d 08 00
loc_05cb:
    jb loc_059e                                                                 ; 05cb: 72 d1
loc_05cd:
    mov word [player_x], ax                                                     ; 05cd: a3 79 05
loc_05d0:
    push ds                                                                     ; 05d0: 1e
loc_05d1:
    shl bx, 1                                                                   ; 05d1: d1 e3
loc_05d3:
    mov ax, word [bx + 0x51d]                                                   ; 05d3: 8b 87 1d 05
loc_05d7:
    mov word [0x523], ax                                                        ; 05d7: a3 23 05
loc_05da:
    mov si, word [bx + 0x517]                                                   ; 05da: 8b b7 17 05
loc_05de:
    mov ax, 0xb800                                                              ; 05de: b8 00 b8
loc_05e1:
    mov ds, ax                                                                  ; 05e1: 8e d8
loc_05e3:
    mov es, ax                                                                  ; 05e3: 8e c0
loc_05e5:
    load16 mov, di, si                                                          ; 05e5: 8b fe
loc_05e7:
    cmp bx, strict byte 2                                                       ; 05e7: 83 fb 02
loc_05ea:
    jne loc_05f1                                                                ; 05ea: 75 05
loc_05ec:
    cld                                                                         ; 05ec: fc
loc_05ed:
    dec di                                                                      ; 05ed: 4f
loc_05ee:
    jmp short loc_05f3                                                          ; 05ee: eb 03
loc_05f0:
    nop                                                                         ; 05f0: 90
loc_05f1:
    std                                                                         ; 05f1: fd
loc_05f2:
    inc di                                                                      ; 05f2: 47
loc_05f3:
    mov cx, 0x27f                                                               ; 05f3: b9 7f 02
loc_05f6:
    push di                                                                     ; 05f6: 57
loc_05f7:
    push si                                                                     ; 05f7: 56
loc_05f8:
    rep movsb                                                                   ; 05f8: f3 a4
loc_05fa:
    pop si                                                                      ; 05fa: 5e
loc_05fb:
    pop di                                                                      ; 05fb: 5f
loc_05fc:
    add si, strict word 0x2000                                                  ; 05fc: 81 c6 00 20
loc_0600:
    add di, strict word 0x2000                                                  ; 0600: 81 c7 00 20
loc_0604:
    mov cx, 0x280                                                               ; 0604: b9 80 02
loc_0607:
    rep movsb                                                                   ; 0607: f3 a4
loc_0609:
    pop ds                                                                      ; 0609: 1f
loc_060a:
    mov di, word [0x523]                                                        ; 060a: 8b 3e 23 05
loc_060e:
    mov bl, byte [window_scroll_phase]                                          ; 060e: 8a 1e 25 05
loc_0612:
    load8 sub, bh, bh                                                           ; 0612: 2a ff
loc_0614:
    add bx, strict word 0x4d7                                                   ; 0614: 81 c3 d7 04
loc_0618:
    mov cx, 0x10                                                                ; 0618: b9 10 00
loc_061b:
    mov al, byte [bx]                                                           ; 061b: 8a 07
loc_061d:
    mov byte [es:di], al                                                        ; 061d: 26 88 05
loc_0620:
    add bx, strict byte 4                                                       ; 0620: 83 c3 04
loc_0623:
    xor di, strict word 0x2000                                                  ; 0623: 81 f7 00 20
loc_0627:
    test di, 0x2000                                                             ; 0627: f7 c7 00 20
loc_062b:
    jne loc_0630                                                                ; 062b: 75 03
loc_062d:
    add di, strict byte 0x50                                                    ; 062d: 83 c7 50
loc_0630:
    loop loc_061b                                                               ; 0630: e2 e9
loc_0632:
    ret                                                                         ; 0632: c3
; CS:0633 — rotate_window_collision_bits
; Propagates incoming carry through five bytes of DS:1016 collision bits; uses RCL in reverse byte order for the middle row and RCR forward for the others.
rotate_window_collision_bits:
    lahf                                                                        ; 0633: 9f
loc_0634:
    mov bx, word [moving_window_row]                                            ; 0634: 8b 1e 2f 05
loc_0638:
    mov bl, byte [bx + 0x541]                                                   ; 0638: 8a 9f 41 05
loc_063c:
    mov cx, 5                                                                   ; 063c: b9 05 00
loc_063f:
    cmp bl, strict byte 9                                                       ; 063f: 80 fb 09
loc_0642:
    je loc_064e                                                                 ; 0642: 74 0a
loc_0644:
    sahf                                                                        ; 0644: 9e
loc_0645:
    rcr byte [bx + 0x1016], 1                                                   ; 0645: d0 9f 16 10
loc_0649:
    lahf                                                                        ; 0649: 9f
loc_064a:
    inc bx                                                                      ; 064a: 43
loc_064b:
    loop loc_0644                                                               ; 064b: e2 f7
loc_064d:
    ret                                                                         ; 064d: c3
loc_064e:
    sahf                                                                        ; 064e: 9e
loc_064f:
    rcl byte [bx + 0x1016], 1                                                   ; 064f: d0 97 16 10
loc_0653:
    lahf                                                                        ; 0653: 9f
loc_0654:
    dec bx                                                                      ; 0654: 4b
loc_0655:
    loop loc_064e                                                               ; 0655: e2 f7
loc_0657:
    ret                                                                         ; 0657: c3
; CS:0658 — classify_player_on_moving_row
; Compares biased player Y with per-row bounds and sets DS:04D6 when the player is supported; communicates the separate motion-blocking condition through ZF.
classify_player_on_moving_row:
    mov byte [0x4d6], 0                                                         ; 0658: c6 06 d6 04 00
loc_065d:
    mov al, byte [player_y_plus_50]                                             ; 065d: a0 7c 05
loc_0660:
    cmp al, byte [bx + 0x53d]                                                   ; 0660: 3a 87 3d 05
loc_0664:
    jb loc_0679                                                                 ; 0664: 72 13
loc_0666:
    cmp al, byte [bx + 0x53a]                                                   ; 0666: 3a 87 3a 05
loc_066a:
    jae loc_0679                                                                ; 066a: 73 0d
loc_066c:
    cmp byte [player_support_kind], strict byte 1                               ; 066c: 80 3e 5c 05 01
loc_0671:
    jae loc_0674                                                                ; 0671: 73 01
loc_0673:
    ret                                                                         ; 0673: c3
loc_0674:
    mov byte [0x4d6], 1                                                         ; 0674: c6 06 d6 04 01
loc_0679:
    load8 cmp, al, al                                                           ; 0679: 3a c0
loc_067b:
    ret                                                                         ; 067b: c3
loc_067c:
    ret                                                                         ; 067c: c3
; CS:067d — generate_window_strip_column
; Fills 64 bytes at ES:DI, chooses tile fragments using random values and BL/BH thresholds, and returns new support bits in DS:0540.
generate_window_strip_column:
    mov byte [0x540], 0                                                         ; 067d: c6 06 40 05 00
loc_0682:
    cld                                                                         ; 0682: fc
loc_0683:
    mov cx, 0x20                                                                ; 0683: b9 20 00
loc_0686:
    mov ax, 0xaaaa                                                              ; 0686: b8 aa aa
loc_0689:
    rep stosw                                                                   ; 0689: f3 ab
loc_068b:
    sub di, strict byte 0x40                                                    ; 068b: 83 ef 40
loc_068e:
    mov ax, 0x4444                                                              ; 068e: b8 44 44
loc_0691:
    mov word [es:di + 4], ax                                                    ; 0691: 26 89 45 04
loc_0695:
    mov word [es:di + 6], ax                                                    ; 0695: 26 89 45 06
loc_0699:
    call near update_random_state                                               ; 0699: e8 61 27
loc_069c:
    load8 cmp, dl, bl                                                           ; 069c: 3a d3
loc_069e:
    jb loc_06a4                                                                 ; 069e: 72 04
loc_06a0:
    load8 cmp, dh, bh                                                           ; 06a0: 3a f7
loc_06a2:
    ja loc_06a5                                                                 ; 06a2: 77 01
loc_06a4:
    ret                                                                         ; 06a4: c3
loc_06a5:
    call near update_random_state                                               ; 06a5: e8 55 27
loc_06a8:
    cmp dl, strict byte 0x18                                                    ; 06a8: 80 fa 18
loc_06ab:
    jb loc_06c7                                                                 ; 06ab: 72 1a
loc_06ad:
    cmp dl, strict byte 0x60                                                    ; 06ad: 80 fa 60
loc_06b0:
    jb loc_06d0                                                                 ; 06b0: 72 1e
loc_06b2:
    push di                                                                     ; 06b2: 57
loc_06b3:
    call near loc_06de                                                          ; 06b3: e8 28 00
loc_06b6:
    shl al, 1                                                                   ; 06b6: d0 e0
loc_06b8:
    mov byte [0x540], al                                                        ; 06b8: a2 40 05
loc_06bb:
    pop di                                                                      ; 06bb: 5f
loc_06bc:
    add di, strict byte 2                                                       ; 06bc: 83 c7 02
loc_06bf:
    call near loc_06de                                                          ; 06bf: e8 1c 00
loc_06c2:
    or byte [0x540], al                                                         ; 06c2: 08 06 40 05
loc_06c6:
    ret                                                                         ; 06c6: c3
loc_06c7:
    mov cx, 0x20                                                                ; 06c7: b9 20 00
loc_06ca:
    mov si, 0x490                                                               ; 06ca: be 90 04
loc_06cd:
    jmp short loc_06d6                                                          ; 06cd: eb 07
loc_06cf:
    nop                                                                         ; 06cf: 90
loc_06d0:
    mov cx, 0x10                                                                ; 06d0: b9 10 00
loc_06d3:
    mov si, 0x460                                                               ; 06d3: be 60 04
loc_06d6:
    rep movsw                                                                   ; 06d6: f3 a5
loc_06d8:
    mov byte [0x540], 3                                                         ; 06d8: c6 06 40 05 03
loc_06dd:
    ret                                                                         ; 06dd: c3
loc_06de:
    call near update_random_state                                               ; 06de: e8 1c 27
loc_06e1:
    and dx, strict word 6                                                       ; 06e1: 81 e2 06 00
loc_06e5:
    cmp dl, strict byte 6                                                       ; 06e5: 80 fa 06
loc_06e8:
    jne loc_06ed                                                                ; 06e8: 75 03
loc_06ea:
    load8 sub, al, al                                                           ; 06ea: 2a c0
loc_06ec:
    ret                                                                         ; 06ec: c3
loc_06ed:
    load16 mov, bx, dx                                                          ; 06ed: 8b da
loc_06ef:
    mov si, word [bx + 0x4d0]                                                   ; 06ef: 8b b7 d0 04
loc_06f3:
    mov cx, 8                                                                   ; 06f3: b9 08 00
loc_06f6:
    lodsw                                                                       ; 06f6: ad
loc_06f7:
    stosw                                                                       ; 06f7: ab
loc_06f8:
    add di, strict byte 2                                                       ; 06f8: 83 c7 02
loc_06fb:
    loop loc_06f6                                                               ; 06fb: e2 f9
loc_06fd:
    mov al, 1                                                                   ; 06fd: b0 01
loc_06ff:
    ret                                                                         ; 06ff: c3
; CS:0700 — reset_player_update_clock
; Clears DS:057D and DS:0684 only; these gate player updates and are not window state.
reset_player_update_clock:
    mov word [player_last_update_tick], 0                                       ; 0700: c7 06 7d 05 00 00
loc_0706:
    mov word [player_same_tick_countdown], 0                                    ; 0706: c7 06 84 06 00 00
loc_070c:
    ret                                                                         ; 070c: c3
