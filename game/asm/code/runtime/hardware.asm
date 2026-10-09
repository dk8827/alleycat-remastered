; BIOS model, clocks and interrupt handlers; includes writable CS storage.
; Original CS:13AA..15D0 (end exclusive).

; CS:13aa — read_bios_model_byte
; Reads F000:FFFE into DS:0697. Clobbers AX and ES; later code selects alternate handling for model byte FD.
read_bios_model_byte:
    mov ax, 0xf000                                                              ; 13aa: b8 00 f0
loc_13ad:
    mov es, ax                                                                  ; 13ad: 8e c0
loc_13af:
    mov al, byte [es:0xfffe]                                                    ; 13af: 26 a0 fe ff
loc_13b3:
    mov byte [machine_model_byte], al                                           ; 13b3: a2 97 06
loc_13b6:
    ret                                                                         ; 13b6: c3

; CS:13b7 — read_pit_channel_zero
; Writes zero to PIT control port 43h, reads two bytes from port 40h with delays, and exchanges AH/AL before returning AX.
read_pit_channel_zero:
    mov al, 0                                                                   ; 13b7: b0 00
loc_13b9:
    out 0x43, al                                                                ; 13b9: e6 43
loc_13bb:
    nop                                                                         ; 13bb: 90
loc_13bc:
    nop                                                                         ; 13bc: 90
loc_13bd:
    in al, 0x40                                                                 ; 13bd: e4 40
loc_13bf:
    load8 mov, ah, al                                                           ; 13bf: 8a e0
loc_13c1:
    nop                                                                         ; 13c1: 90
loc_13c2:
    in al, 0x40                                                                 ; 13c2: e4 40
loc_13c4:
    xchg al, ah                                                                 ; 13c4: 86 c4
loc_13c6:
    ret                                                                         ; 13c6: c3

; CS:13c7 — compare_pit_elapsed
; Samples the PIT, subtracts prior CX, updates CX, and compares with DX; one path forces ZF using CMP DX,DX. No incoming static call was found.
compare_pit_elapsed:
    call near read_pit_channel_zero                                             ; 13c7: e8 ed ff
loc_13ca:
    load16 mov, bx, ax                                                          ; 13ca: 8b d8
loc_13cc:
    load16 sub, ax, cx                                                          ; 13cc: 2b c1
loc_13ce:
    load16 mov, cx, bx                                                          ; 13ce: 8b cb
loc_13d0:
    load16 cmp, ax, dx                                                          ; 13d0: 3b c2
loc_13d2:
    jae loc_13d5                                                                ; 13d2: 73 01
loc_13d4:
    ret                                                                         ; 13d4: c3
loc_13d5:
    load16 cmp, dx, dx                                                          ; 13d5: 3b d2
loc_13d7:
    ret                                                                         ; 13d7: c3

; CS:13d8 — read_cga_vertical_retrace_bit
; Reads port 03DAh and masks AL with 08h. Returns the sampled bit and ZF; contains no waiting loop.
read_cga_vertical_retrace_bit:
    mov dx, 0x3da                                                               ; 13d8: ba da 03
loc_13db:
    in al, dx                                                                   ; 13db: ec
loc_13dc:
    and al, 8                                                                   ; 13dc: 24 08
loc_13de:
    ret                                                                         ; 13de: c3
saved_int09: dw 0, 0
saved_int48: dw 0, 0
saved_bios_keyboard_flags: db 0

; CS:13e8 — reset_keyboard_state
; Preserves AX/ES/DI/CX, fills 22 tracked key states with 80h via ES=game data, adjusts keyboard bookkeeping, and saves BIOS byte 0040:0012 in CS.
reset_keyboard_state:
    push ax                                                                     ; 13e8: 50
loc_13e9:
    push es                                                                     ; 13e9: 06
loc_13ea:
    push di                                                                     ; 13ea: 57
loc_13eb:
    push cx                                                                     ; 13eb: 51
loc_13ec:
    mov ax, DATA_PARAGRAPH                                                      ; 13ec: b8 10 00
loc_13ef:
    mov es, ax                                                                  ; 13ef: 8e c0
loc_13f1:
    cld                                                                         ; 13f1: fc
loc_13f2:
    mov di, 0x6b7                                                               ; 13f2: bf b7 06
loc_13f5:
    mov cx, 0x16                                                                ; 13f5: b9 16 00
loc_13f8:
    mov al, 0x80                                                                ; 13f8: b0 80
loc_13fa:
    rep stosb                                                                   ; 13fa: f3 aa
loc_13fc:
    mov ax, word [es:keyboard_event_counter]                                    ; 13fc: 26 a1 93 06
loc_1400:
    sub ax, strict word 0x70                                                    ; 1400: 2d 70 00
loc_1403:
    mov word [es:processed_keyboard_counter], ax                                ; 1403: 26 a3 91 06
loc_1407:
    mov ax, 0x40                                                                ; 1407: b8 40 00
loc_140a:
    mov es, ax                                                                  ; 140a: 8e c0
loc_140c:
    mov al, byte [es:0x12]                                                      ; 140c: 26 a0 12 00
loc_1410:
    mov byte [cs:saved_bios_keyboard_flags], al                                 ; 1410: 2e a2 e7 13
loc_1414:
    pop cx                                                                      ; 1414: 59
loc_1415:
    pop di                                                                      ; 1415: 5f
loc_1416:
    pop es                                                                      ; 1416: 07
loc_1417:
    pop ax                                                                      ; 1417: 58
loc_1418:
    ret                                                                         ; 1418: c3

; CS:1419 — install_interrupt_vectors
; Saves IVT vectors 09h and 48h in CS storage. With interrupts disabled, installs the selected keyboard handler; the FD branch also installs INT 48h.
install_interrupt_vectors:
    load16 sub, ax, ax                                                          ; 1419: 2b c0
loc_141b:
    mov es, ax                                                                  ; 141b: 8e c0
loc_141d:
    mov ax, word [es:0x24]                                                      ; 141d: 26 a1 24 00
loc_1421:
    mov bx, word [es:0x26]                                                      ; 1421: 26 8b 1e 26 00
loc_1426:
    mov cx, word [es:0x120]                                                     ; 1426: 26 8b 0e 20 01
loc_142b:
    mov dx, word [es:0x122]                                                     ; 142b: 26 8b 16 22 01
loc_1430:
    mov word [cs:saved_int09], ax                                               ; 1430: 2e a3 df 13
loc_1434:
    mov word [cs:saved_int09 + 2], bx                                           ; 1434: 2e 89 1e e1 13
loc_1439:
    mov word [cs:saved_int48], cx                                               ; 1439: 2e 89 0e e3 13
loc_143e:
    mov word [cs:saved_int48 + 2], dx                                           ; 143e: 2e 89 16 e5 13
loc_1443:
    mov bx, 0x14b3                                                              ; 1443: bb b3 14
loc_1446:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 1446: 80 3e 97 06 fd
loc_144b:
    jne loc_1450                                                                ; 144b: 75 03
loc_144d:
    mov bx, 0x14fb                                                              ; 144d: bb fb 14
loc_1450:
    cli                                                                         ; 1450: fa
loc_1451:
    mov word [es:0x24], bx                                                      ; 1451: 26 89 1e 24 00
loc_1456:
    mov word [es:0x26], cs                                                      ; 1456: 26 8c 0e 26 00
loc_145b:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 145b: 80 3e 97 06 fd
loc_1460:
    jne loc_147d                                                                ; 1460: 75 1b
loc_1462:
    mov word [es:0x120], 0x1554                                                 ; 1462: 26 c7 06 20 01 54 15
loc_1469:
    mov word [es:0x122], cs                                                     ; 1469: 26 8c 0e 22 01
loc_146e:
    mov ax, 0x40                                                                ; 146e: b8 40 00
loc_1471:
    mov es, ax                                                                  ; 1471: 8e c0
loc_1473:
    mov al, byte [es:0x18]                                                      ; 1473: 26 a0 18 00
loc_1477:
    or al, 1                                                                    ; 1477: 0c 01
loc_1479:
    mov byte [es:0x18], al                                                      ; 1479: 26 a2 18 00
loc_147d:
    sti                                                                         ; 147d: fb
loc_147e:
    ret                                                                         ; 147e: c3

; CS:147f — restore_interrupt_vectors
; Restores saved vector 09h, and vector 48h on the FD branch, with interrupts disabled during IVT writes.
restore_interrupt_vectors:
    load16 sub, ax, ax                                                          ; 147f: 2b c0
loc_1481:
    mov es, ax                                                                  ; 1481: 8e c0
loc_1483:
    mov ax, word [cs:saved_int09]                                               ; 1483: 2e a1 df 13
loc_1487:
    mov bx, word [cs:saved_int09 + 2]                                           ; 1487: 2e 8b 1e e1 13
loc_148c:
    mov cx, word [cs:saved_int48]                                               ; 148c: 2e 8b 0e e3 13
loc_1491:
    mov dx, word [cs:saved_int48 + 2]                                           ; 1491: 2e 8b 16 e5 13
loc_1496:
    cli                                                                         ; 1496: fa
loc_1497:
    mov word [es:0x24], ax                                                      ; 1497: 26 a3 24 00
loc_149b:
    mov word [es:0x26], bx                                                      ; 149b: 26 89 1e 26 00
loc_14a0:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 14a0: 80 3e 97 06 fd
loc_14a5:
    jne loc_14b1                                                                ; 14a5: 75 0a
loc_14a7:
    mov word [es:0x120], cx                                                     ; 14a7: 26 89 0e 20 01
loc_14ac:
    mov word [es:0x122], dx                                                     ; 14ac: 26 89 16 22 01
loc_14b1:
    sti                                                                         ; 14b1: fb
loc_14b2:
    ret                                                                         ; 14b2: c3

; CS:14b3 — keyboard_irq_handler
; Reads port 60h, searches the scan-code table, records pressed/released state, acknowledges via port 61h, and sends PIC EOI via port 20h before IRET.
keyboard_irq_handler:
    push ax                                                                     ; 14b3: 50
loc_14b4:
    push es                                                                     ; 14b4: 06
loc_14b5:
    push di                                                                     ; 14b5: 57
loc_14b6:
    push cx                                                                     ; 14b6: 51
loc_14b7:
    mov di, DATA_PARAGRAPH                                                      ; 14b7: bf 10 00
loc_14ba:
    mov es, di                                                                  ; 14ba: 8e c7
loc_14bc:
    in al, 0x60                                                                 ; 14bc: e4 60
loc_14be:
    load8 mov, ah, al                                                           ; 14be: 8a e0
loc_14c0:
    and al, 0x7f                                                                ; 14c0: 24 7f
loc_14c2:
    test ah, 0x80                                                               ; 14c2: f6 c4 80
loc_14c5:
    jne loc_14cc                                                                ; 14c5: 75 05
loc_14c7:
    inc word [es:keyboard_event_counter]                                        ; 14c7: 26 ff 06 93 06
loc_14cc:
    mov di, 0x6a1                                                               ; 14cc: bf a1 06
loc_14cf:
    mov cx, 0x16                                                                ; 14cf: b9 16 00
loc_14d2:
    cld                                                                         ; 14d2: fc
loc_14d3:
    repne scasb                                                                 ; 14d3: f2 ae
loc_14d5:
    jne loc_14e3                                                                ; 14d5: 75 0c
loc_14d7:
    sub di, strict word 0x6a2                                                   ; 14d7: 81 ef a2 06
loc_14db:
    and ah, strict byte 0x80                                                    ; 14db: 80 e4 80
loc_14de:
    mov byte [es:di + keyboard_key_states], ah                                  ; 14de: 26 88 a5 b7 06
loc_14e3:
    in al, 0x61                                                                 ; 14e3: e4 61
loc_14e5:
    load8 mov, ah, al                                                           ; 14e5: 8a e0
loc_14e7:
    or al, 0x80                                                                 ; 14e7: 0c 80
loc_14e9:
    out 0x61, al                                                                ; 14e9: e6 61
loc_14eb:
    load8 mov, al, ah                                                           ; 14eb: 8a c4
loc_14ed:
    out 0x61, al                                                                ; 14ed: e6 61
loc_14ef:
    call near loc_1572                                                          ; 14ef: e8 80 00
loc_14f2:
    pop cx                                                                      ; 14f2: 59
loc_14f3:
    pop di                                                                      ; 14f3: 5f
loc_14f4:
    pop es                                                                      ; 14f4: 07
loc_14f5:
    mov al, 0x20                                                                ; 14f5: b0 20
loc_14f7:
    out 0x20, al                                                                ; 14f7: e6 20
loc_14f9:
    pop ax                                                                      ; 14f9: 58
loc_14fa:
    iret                                                                        ; 14fa: cf

; CS:14fb — alternate_keyboard_handler
; Selected for BIOS model byte FD. Consumes scan code in AL, checks BIOS state changes, updates tracked keys, and returns with IRET.
alternate_keyboard_handler:
    sti                                                                         ; 14fb: fb
loc_14fc:
    push ax                                                                     ; 14fc: 50
loc_14fd:
    push es                                                                     ; 14fd: 06
loc_14fe:
    push di                                                                     ; 14fe: 57
loc_14ff:
    push cx                                                                     ; 14ff: 51
loc_1500:
    mov di, DATA_PARAGRAPH                                                      ; 1500: bf 10 00
loc_1503:
    mov es, di                                                                  ; 1503: 8e c7
loc_1505:
    load8 mov, ah, al                                                           ; 1505: 8a e0
loc_1507:
    and al, 0x7f                                                                ; 1507: 24 7f
loc_1509:
    test ah, 0x80                                                               ; 1509: f6 c4 80
loc_150c:
    jne loc_1513                                                                ; 150c: 75 05
loc_150e:
    inc word [es:keyboard_event_counter]                                        ; 150e: 26 ff 06 93 06
loc_1513:
    cmp ah, strict byte 0xff                                                    ; 1513: 80 fc ff
loc_1516:
    je loc_1530                                                                 ; 1516: 74 18
loc_1518:
    cmp ah, strict byte 0x55                                                    ; 1518: 80 fc 55
loc_151b:
    je loc_1530                                                                 ; 151b: 74 13
loc_151d:
    push es                                                                     ; 151d: 06
loc_151e:
    mov di, 0x40                                                                ; 151e: bf 40 00
loc_1521:
    mov es, di                                                                  ; 1521: 8e c7
loc_1523:
    mov cl, byte [es:0x12]                                                      ; 1523: 26 8a 0e 12 00
loc_1528:
    pop es                                                                      ; 1528: 07
loc_1529:
    cmp cl, byte [cs:saved_bios_keyboard_flags]                                 ; 1529: 2e 3a 0e e7 13
loc_152e:
    je loc_1535                                                                 ; 152e: 74 05
loc_1530:
    call near reset_keyboard_state                                              ; 1530: e8 b5 fe
loc_1533:
    jmp short loc_154c                                                          ; 1533: eb 17
loc_1535:
    mov di, 0x6a1                                                               ; 1535: bf a1 06
loc_1538:
    mov cx, 0x16                                                                ; 1538: b9 16 00
loc_153b:
    cld                                                                         ; 153b: fc
loc_153c:
    repne scasb                                                                 ; 153c: f2 ae
loc_153e:
    jne loc_154c                                                                ; 153e: 75 0c
loc_1540:
    sub di, strict word 0x6a2                                                   ; 1540: 81 ef a2 06
loc_1544:
    and ah, strict byte 0x80                                                    ; 1544: 80 e4 80
loc_1547:
    mov byte [es:di + keyboard_key_states], ah                                  ; 1547: 26 88 a5 b7 06
loc_154c:
    call near loc_1572                                                          ; 154c: e8 23 00
loc_154f:
    pop cx                                                                      ; 154f: 59
loc_1550:
    pop di                                                                      ; 1550: 5f
loc_1551:
    pop es                                                                      ; 1551: 07
loc_1552:
    pop ax                                                                      ; 1552: 58
loc_1553:
    iret                                                                        ; 1553: cf

; CS:1554 — interrupt_48_handler
; Executes INT 09h followed by IRET.
interrupt_48_handler:
    int 9                                                                       ; 1554: cd 09
loc_1556:
    iret                                                                        ; 1556: cf

; CS:1557 — bios_warm_reboot
; Writes warm-boot marker 1234h at 0040:0072 and jumps outside the game to BIOS F000:E05B.
bios_warm_reboot:
    mov ax, 0xf000                                                              ; 1557: b8 00 f0
loc_155a:
    mov ss, ax                                                                  ; 155a: 8e d0
loc_155c:
    mov ax, 0x40                                                                ; 155c: b8 40 00
loc_155f:
    mov ds, ax                                                                  ; 155f: 8e d8
loc_1561:
    mov bx, 0x72                                                                ; 1561: bb 72 00
loc_1564:
    mov word [bx], 0x1234                                                       ; 1564: c7 07 34 12
loc_1568:
    mov ax, 0                                                                   ; 1568: b8 00 00
loc_156b:
    mov es, ax                                                                  ; 156b: 8e c0
loc_156d:
    jmp 0xf000:0xe05b                                                           ; 156d: ea 5b e0 00 f0
loc_1572:
    mov al, byte [es:0x6c9]                                                     ; 1572: 26 a0 c9 06
loc_1576:
    or al, byte [es:keyboard_key_states]                                        ; 1576: 26 0a 06 b7 06
loc_157b:
    cmp al, 0                                                                   ; 157b: 3c 00
loc_157d:
    jne loc_15c9                                                                ; 157d: 75 4a
loc_157f:
    test byte [es:0x6ca], 0x80                                                  ; 157f: 26 f6 06 ca 06 80
loc_1585:
    jne loc_158d                                                                ; 1585: 75 06
loc_1587:
    mov al, 0x20                                                                ; 1587: b0 20
loc_1589:
    out 0x20, al                                                                ; 1589: e6 20
loc_158b:
    jmp short bios_warm_reboot                                                  ; 158b: eb ca
loc_158d:
    test byte [es:0x6b9], 0x80                                                  ; 158d: 26 f6 06 b9 06 80
loc_1593:
    jne loc_15a4                                                                ; 1593: 75 0f
loc_1595:
    cmp byte [es:0x690], 1                                                      ; 1595: 26 80 3e 90 06 01
loc_159b:
    jb loc_15c9                                                                 ; 159b: 72 2c
loc_159d:
    dec byte [es:0x690]                                                         ; 159d: 26 fe 0e 90 06
loc_15a2:
    jmp short loc_15b9                                                          ; 15a2: eb 15
loc_15a4:
    test byte [es:0x6bb], 0x80                                                  ; 15a4: 26 f6 06 bb 06 80
loc_15aa:
    jne loc_15c9                                                                ; 15aa: 75 1d
loc_15ac:
    cmp byte [es:0x690], 7                                                      ; 15ac: 26 80 3e 90 06 07
loc_15b2:
    jae loc_15c9                                                                ; 15b2: 73 15
loc_15b4:
    inc byte [es:0x690]                                                         ; 15b4: 26 fe 06 90 06
loc_15b9:
    push dx                                                                     ; 15b9: 52
loc_15ba:
    mov al, 2                                                                   ; 15ba: b0 02
loc_15bc:
    mov dx, 0x3d4                                                               ; 15bc: ba d4 03
loc_15bf:
    out dx, al                                                                  ; 15bf: ee
loc_15c0:
    mov al, byte [es:0x690]                                                     ; 15c0: 26 a0 90 06
loc_15c4:
    add al, 0x27                                                                ; 15c4: 04 27
loc_15c6:
    inc dx                                                                      ; 15c6: 42
loc_15c7:
    out dx, al                                                                  ; 15c7: ee
loc_15c8:
    pop dx                                                                      ; 15c8: 5a
loc_15c9:
    ret                                                                         ; 15c9: c3
    times 6 db 0 ; original zero fill at CS:15ca
