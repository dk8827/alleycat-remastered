; Title melody byte-code player.
; Original CS:53B0..546D (end exclusive).

; CS:53b0 — update_title_melody
; On distinct BIOS ticks consumes byte-coded divisor offsets from DS:538C; zero rests, and the 66h terminator holds the sequence index while disabling the speaker.
update_title_melody:
    cmp byte [sound_enabled], strict byte 0                                     ; 53b0: 80 3e 00 00 00
loc_53b5:
    je loc_53f5                                                                 ; 53b5: 74 3e
loc_53b7:
    load8 sub, ah, ah                                                           ; 53b7: 2a e4
loc_53b9:
    int 0x1a                                                                    ; 53b9: cd 1a
loc_53bb:
    cmp dx, word [title_melody_last_tick]                                       ; 53bb: 3b 16 22 53
loc_53bf:
    je loc_53f5                                                                 ; 53bf: 74 34
loc_53c1:
    mov word [title_melody_last_tick], dx                                       ; 53c1: 89 16 22 53
loc_53c5:
    mov bx, word [title_melody_byte_offset]                                     ; 53c5: 8b 1e 20 53
loc_53c9:
    mov bl, byte [bx + title_note_codes]                                        ; 53c9: 8a 9f 8c 53
loc_53cd:
    cmp bl, strict byte 0x66                                                    ; 53cd: 80 fb 66
loc_53d0:
    je loc_53dd                                                                 ; 53d0: 74 0b
loc_53d2:
    load8 sub, bh, bh                                                           ; 53d2: 2a ff
loc_53d4:
    inc word [title_melody_byte_offset]                                         ; 53d4: ff 06 20 53
loc_53d8:
    cmp bx, strict byte 0                                                       ; 53d8: 83 fb 00
loc_53db:
    jne loc_53e1                                                                ; 53db: 75 04
loc_53dd:
    call near disable_speaker                                                   ; 53dd: e8 41 07
loc_53e0:
    ret                                                                         ; 53e0: c3
loc_53e1:
    mov al, 0xb6                                                                ; 53e1: b0 b6
loc_53e3:
    out 0x43, al                                                                ; 53e3: e6 43
loc_53e5:
    mov ax, word [bx + title_note_divisors]                                     ; 53e5: 8b 87 24 53
loc_53e9:
    out 0x42, al                                                                ; 53e9: e6 42
loc_53eb:
    load8 mov, al, ah                                                           ; 53eb: 8a c4
loc_53ed:
    out 0x42, al                                                                ; 53ed: e6 42
loc_53ef:
    in al, 0x61                                                                 ; 53ef: e4 61
loc_53f1:
    or al, 3                                                                    ; 53f1: 0c 03
loc_53f3:
    out 0x61, al                                                                ; 53f3: e6 61
loc_53f5:
    ret                                                                         ; 53f5: c3
    times 10 db 0 ; original zero fill at CS:53f6
loc_5400:
    mov ax, 0xb800                                                              ; 5400: b8 00 b8
loc_5403:
    mov es, ax                                                                  ; 5403: 8e c0
loc_5405:
    mov bx, word [difficulty_level]                                             ; 5405: 8b 1e 08 00
loc_5409:
    and bx, strict word 7                                                       ; 5409: 81 e3 07 00
loc_540d:
    shl bx, 1                                                                   ; 540d: d1 e3
loc_540f:
    load16 mov, ax, bx                                                          ; 540f: 8b c3
loc_5411:
    mov bx, word [bx + 0x5908]                                                  ; 5411: 8b 9f 08 59
loc_5415:
    mov cl, 3                                                                   ; 5415: b1 03
loc_5417:
    shl ax, cl                                                                  ; 5417: d3 e0
loc_5419:
    mov word [0x5918], ax                                                       ; 5419: a3 18 59
loc_541c:
    mov di, word [bx]                                                           ; 541c: 8b 3f
loc_541e:
    cmp di, strict word 0xffff                                                  ; 541e: 81 ff ff ff
loc_5422:
    je loc_5447                                                                 ; 5422: 74 23
loc_5424:
    call near update_random_state                                               ; 5424: e8 d6 d9
loc_5427:
    and dx, strict word 0xe                                                     ; 5427: 81 e2 0e 00
loc_542b:
    add dx, word [0x5918]                                                       ; 542b: 03 16 18 59
loc_542f:
    load16 mov, si, dx                                                          ; 542f: 8b f2
loc_5431:
    mov si, word [si + 0x5888]                                                  ; 5431: 8b b4 88 58
loc_5435:
    mov cx, word [si + 0x5858]                                                  ; 5435: 8b 8c 58 58
loc_5439:
    mov si, word [si + 0x584c]                                                  ; 5439: 8b b4 4c 58
loc_543d:
    push bx                                                                     ; 543d: 53
loc_543e:
    call near copy_rectangle_to_cga                                             ; 543e: e8 5c d9
loc_5441:
    pop bx                                                                      ; 5441: 5b
loc_5442:
    add bx, strict byte 2                                                       ; 5442: 83 c3 02
loc_5445:
    jmp short loc_541c                                                          ; 5445: eb d5
loc_5447:
    ret                                                                         ; 5447: c3
    times 8 db 0 ; original zero fill at CS:5448
loc_5450:
    mov byte [0x5b0f], 0xc                                                      ; 5450: c6 06 0f 5b 0c
loc_5455:
    mov word [0x5b0c], 1                                                        ; 5455: c7 06 0c 5b 01 00
loc_545b:
    mov word [0x5b12], 0x1ff                                                    ; 545b: c7 06 12 5b ff 01
loc_5461:
    mov word [0x5b0a], 0xf                                                      ; 5461: c7 06 0a 5b 0f 00
loc_5467:
    mov byte [0x5b0e], 1                                                        ; 5467: c6 06 0e 5b 01
loc_546c:
    ret                                                                         ; 546c: c3
