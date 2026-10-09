; Shared gameplay sound dispatcher and effects.
; Original CS:546D..5797 (end exclusive).

; CS:546d — update_game_sound
; Prioritizes chasing-enemy sounds, then a two-stage sound whose countdown advances on distinct BIOS ticks, then context-dependent background effects.
update_game_sound:
    cmp byte [sound_enabled], strict byte 0                                     ; 546d: 80 3e 00 00 00
loc_5472:
    je loc_54a5                                                                 ; 5472: 74 31
loc_5474:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 5474: 80 3e b8 1c 00
loc_5479:
    je loc_54f8                                                                 ; 5479: 74 7d
loc_547b:
    load8 sub, ah, ah                                                           ; 547b: 2a e4
loc_547d:
    int 0x1a                                                                    ; 547d: cd 1a
loc_547f:
    cmp byte [0x5b0f], strict byte 0                                            ; 547f: 80 3e 0f 5b 00
loc_5484:
    jne loc_54a6                                                                ; 5484: 75 20
loc_5486:
    cmp dx, word [0x5b10]                                                       ; 5486: 3b 16 10 5b
loc_548a:
    je loc_54a5                                                                 ; 548a: 74 19
loc_548c:
    mov word [0x5b10], dx                                                       ; 548c: 89 16 10 5b
loc_5490:
    mov al, 0xb6                                                                ; 5490: b0 b6
loc_5492:
    out 0x43, al                                                                ; 5492: e6 43
loc_5494:
    mov ax, word [0x5b12]                                                       ; 5494: a1 12 5b
loc_5497:
    and ax, strict word 0x1ff                                                   ; 5497: 25 ff 01
loc_549a:
    add ax, strict word 0xc8                                                    ; 549a: 05 c8 00
loc_549d:
    call near write_speaker_divisor_and_enable                                  ; 549d: e8 e9 03
loc_54a0:
    sub word [0x5b12], strict byte 0x4b                                         ; 54a0: 83 2e 12 5b 4b
loc_54a5:
    ret                                                                         ; 54a5: c3
loc_54a6:
    cmp dx, word [0x5b10]                                                       ; 54a6: 3b 16 10 5b
loc_54aa:
    je loc_54b4                                                                 ; 54aa: 74 08
loc_54ac:
    mov word [0x5b10], dx                                                       ; 54ac: 89 16 10 5b
loc_54b0:
    dec byte [0x5b0f]                                                           ; 54b0: fe 0e 0f 5b
loc_54b4:
    dec byte [0x5b0e]                                                           ; 54b4: fe 0e 0e 5b
loc_54b8:
    jne loc_54f7                                                                ; 54b8: 75 3d
loc_54ba:
    mov al, 1                                                                   ; 54ba: b0 01
loc_54bc:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 54bc: 80 3e 97 06 fd
loc_54c1:
    je loc_54c5                                                                 ; 54c1: 74 02
loc_54c3:
    shl al, 1                                                                   ; 54c3: d0 e0
loc_54c5:
    mov byte [0x5b0e], al                                                       ; 54c5: a2 0e 5b
loc_54c8:
    call near update_random_state                                               ; 54c8: e8 32 d9
loc_54cb:
    cmp dl, strict byte 4                                                       ; 54cb: 80 fa 04
loc_54ce:
    ja loc_54d4                                                                 ; 54ce: 77 04
loc_54d0:
    inc word [0x5b0c]                                                           ; 54d0: ff 06 0c 5b
loc_54d4:
    test word [0x5b0c], 1                                                       ; 54d4: f7 06 0c 5b 01 00
loc_54da:
    je loc_54e1                                                                 ; 54da: 74 05
loc_54dc:
    add word [0x5b0a], strict byte 7                                            ; 54dc: 83 06 0a 5b 07
loc_54e1:
    mov al, 0xb6                                                                ; 54e1: b0 b6
loc_54e3:
    out 0x43, al                                                                ; 54e3: e6 43
loc_54e5:
    call near update_random_state                                               ; 54e5: e8 15 d9
loc_54e8:
    load16 mov, ax, dx                                                          ; 54e8: 8b c2
loc_54ea:
    and ax, word [0x5b0a]                                                       ; 54ea: 23 06 0a 5b
loc_54ee:
    and ax, strict word 0x1ff                                                   ; 54ee: 25 ff 01
loc_54f1:
    add ax, strict word 0x190                                                   ; 54f1: 05 90 01
loc_54f4:
    call near write_speaker_divisor_and_enable                                  ; 54f4: e8 92 03
loc_54f7:
    ret                                                                         ; 54f7: c3
loc_54f8:
    load8 sub, ah, ah                                                           ; 54f8: 2a e4
loc_54fa:
    int 0x1a                                                                    ; 54fa: cd 1a
loc_54fc:
    cmp byte [two_stage_sound_ticks], strict byte 0                             ; 54fc: 80 3e 20 59 00
loc_5501:
    je loc_5522                                                                 ; 5501: 74 1f
loc_5503:
    cmp dx, word [two_stage_sound_last_tick]                                    ; 5503: 3b 16 21 59
loc_5507:
    je loc_5562                                                                 ; 5507: 74 59
loc_5509:
    mov word [two_stage_sound_last_tick], dx                                    ; 5509: 89 16 21 59
loc_550d:
    dec byte [two_stage_sound_ticks]                                            ; 550d: fe 0e 20 59
loc_5511:
    je loc_551e                                                                 ; 5511: 74 0b
loc_5513:
    mov al, 0xb6                                                                ; 5513: b0 b6
loc_5515:
    out 0x43, al                                                                ; 5515: e6 43
loc_5517:
    mov ax, word [two_stage_sound_second_divisor]                               ; 5517: a1 23 59
loc_551a:
    call near write_speaker_divisor_and_enable                                  ; 551a: e8 6c 03
loc_551d:
    ret                                                                         ; 551d: c3
loc_551e:
    call near disable_speaker                                                   ; 551e: e8 00 06
loc_5521:
    ret                                                                         ; 5521: c3
loc_5522:
    cmp dx, word [0x5925]                                                       ; 5522: 3b 16 25 59
loc_5526:
    je loc_5562                                                                 ; 5526: 74 3a
loc_5528:
    mov si, 3                                                                   ; 5528: be 03 00
loc_552b:
    mov al, byte [enemy_active]                                                 ; 552b: a0 bf 1c
loc_552e:
    or al, byte [0x5b07]                                                        ; 552e: 0a 06 07 5b
loc_5532:
    jne loc_5549                                                                ; 5532: 75 15
loc_5534:
    mov si, 1                                                                   ; 5534: be 01 00
loc_5537:
    cmp word [scene_index], strict byte 0                                       ; 5537: 83 3e 04 00 00
loc_553c:
    jne loc_5549                                                                ; 553c: 75 0b
loc_553e:
    dec si                                                                      ; 553e: 4e
loc_553f:
    cmp byte [alley_projectile_y], strict byte 0                                ; 553f: 80 3e 73 16 00
loc_5544:
    je loc_5549                                                                 ; 5544: 74 03
loc_5546:
    mov si, 2                                                                   ; 5546: be 02 00
loc_5549:
    load16 mov, di, si                                                          ; 5549: 8b fe
loc_554b:
    shl di, 1                                                                   ; 554b: d1 e7
loc_554d:
    mov al, byte [0x584]                                                        ; 554d: a0 84 05
loc_5550:
    or al, byte [0x5b07]                                                        ; 5550: 0a 06 07 5b
loc_5554:
    jne loc_5563                                                                ; 5554: 75 0d
loc_5556:
    load16 mov, ax, dx                                                          ; 5556: 8b c2
loc_5558:
    sub ax, word [0x5925]                                                       ; 5558: 2b 06 25 59
loc_555c:
    cmp ax, word [di + 0x59f2]                                                  ; 555c: 3b 85 f2 59
loc_5560:
    jae loc_5563                                                                ; 5560: 73 01
loc_5562:
    ret                                                                         ; 5562: c3
loc_5563:
    mov word [0x5925], dx                                                       ; 5563: 89 16 25 59
loc_5567:
    cmp byte [enemy_active], strict byte 0                                      ; 5567: 80 3e bf 1c 00
loc_556c:
    jne loc_5579                                                                ; 556c: 75 0b
loc_556e:
    cmp byte [0x5b07], strict byte 0                                            ; 556e: 80 3e 07 5b 00
loc_5573:
    je loc_559e                                                                 ; 5573: 74 29
loc_5575:
    dec byte [0x5b07]                                                           ; 5575: fe 0e 07 5b
loc_5579:
    mov word [0x592e], 0x1200                                                   ; 5579: c7 06 2e 59 00 12
loc_557f:
    mov bx, word [0x59ba]                                                       ; 557f: 8b 1e ba 59
loc_5583:
    cmp bx, strict byte 6                                                       ; 5583: 83 fb 06
loc_5586:
    jb loc_558e                                                                 ; 5586: 72 06
loc_5588:
    load16 sub, bx, bx                                                          ; 5588: 2b db
loc_558a:
    mov word [0x59ba], bx                                                       ; 558a: 89 1e ba 59
loc_558e:
    add word [0x59ba], strict byte 2                                            ; 558e: 83 06 ba 59 02
loc_5593:
    mov ax, word [bx + 0x5a44]                                                  ; 5593: 8b 87 44 5a
loc_5597:
    mov word [0x592a], ax                                                       ; 5597: a3 2a 59
loc_559a:
    call near loc_5b28                                                          ; 559a: e8 8b 05
loc_559d:
    ret                                                                         ; 559d: c3
loc_559e:
    cmp si, strict byte 2                                                       ; 559e: 83 fe 02
loc_55a1:
    jne loc_55bb                                                                ; 55a1: 75 18
loc_55a3:
    mov al, byte [alley_projectile_y]                                           ; 55a3: a0 73 16
loc_55a6:
    load8 sub, ah, ah                                                           ; 55a6: 2a e4
loc_55a8:
    mov cl, 4                                                                   ; 55a8: b1 04
loc_55aa:
    shl ax, cl                                                                  ; 55aa: d3 e0
loc_55ac:
    add ax, strict word 0x200                                                   ; 55ac: 05 00 02
loc_55af:
    mov word [0x592a], ax                                                       ; 55af: a3 2a 59
loc_55b2:
    mov word [0x592e], 0x1800                                                   ; 55b2: c7 06 2e 59 00 18
loc_55b8:
    jmp near loc_568d                                                           ; 55b8: e9 d2 00
loc_55bb:
    mov ax, word [di + 0x5a02]                                                  ; 55bb: 8b 85 02 5a
loc_55bf:
    mov word [0x592e], ax                                                       ; 55bf: a3 2e 59
loc_55c2:
    shr byte [0x5927], 1                                                        ; 55c2: d0 2e 27 59
loc_55c6:
    jae loc_5623                                                                ; 55c6: 73 5b
loc_55c8:
    mov word [0x592e], 0x1000                                                   ; 55c8: c7 06 2e 59 00 10
loc_55ce:
    mov byte [0x5927], 0x80                                                     ; 55ce: c6 06 27 59 80
loc_55d3:
    inc byte [0x5928]                                                           ; 55d3: fe 06 28 59
loc_55d7:
    mov al, byte [0x5928]                                                       ; 55d7: a0 28 59
loc_55da:
    and al, byte [si + 0x59fa]                                                  ; 55da: 22 84 fa 59
loc_55de:
    jne loc_5616                                                                ; 55de: 75 36
loc_55e0:
    mov dl, byte [si + 0x5a0a]                                                  ; 55e0: 8a 94 0a 5a
loc_55e4:
    add byte [0x5929], dl                                                       ; 55e4: 00 16 29 59
loc_55e8:
    call near update_random_state                                               ; 55e8: e8 12 d8
loc_55eb:
    cmp dl, byte [si + 0x5a0c]                                                  ; 55eb: 3a 94 0c 5a
loc_55ef:
    ja loc_55f8                                                                 ; 55ef: 77 07
loc_55f1:
    and dl, strict byte 7                                                       ; 55f1: 80 e2 07
loc_55f4:
    mov byte [0x592d], dl                                                       ; 55f4: 88 16 2d 59
loc_55f8:
    call near update_random_state                                               ; 55f8: e8 02 d8
loc_55fb:
    and dx, strict word 0xff                                                    ; 55fb: 81 e2 ff 00
loc_55ff:
    shl dx, 1                                                                   ; 55ff: d1 e2
loc_5601:
    mov cl, 1                                                                   ; 5601: b1 01
loc_5603:
    test dl, 2                                                                  ; 5603: f6 c2 02
loc_5606:
    je loc_560e                                                                 ; 5606: 74 06
loc_5608:
    mov cl, 0xff                                                                ; 5608: b1 ff
loc_560a:
    add dx, strict word 0x300                                                   ; 560a: 81 c2 00 03
loc_560e:
    mov word [0x592a], dx                                                       ; 560e: 89 16 2a 59
loc_5612:
    mov byte [0x592c], cl                                                       ; 5612: 88 0e 2c 59
loc_5616:
    mov ah, byte [0x5929]                                                       ; 5616: 8a 26 29 59
loc_561a:
    and ah, byte [si + 0x59fc]                                                  ; 561a: 22 a4 fc 59
loc_561e:
    load8 or, al, ah                                                            ; 561e: 0a c4
loc_5620:
    mov byte [0x5928], al                                                       ; 5620: a2 28 59
loc_5623:
    cmp byte [0x592c], strict byte 0xff                                         ; 5623: 80 3e 2c 59 ff
loc_5628:
    je loc_5640                                                                 ; 5628: 74 16
loc_562a:
    add word [0x5a54], strict byte 2                                            ; 562a: 83 06 54 5a 02
loc_562f:
    mov bx, word [0x5a54]                                                       ; 562f: 8b 1e 54 5a
loc_5633:
    and bx, strict word 0xe                                                     ; 5633: 81 e3 0e 00
loc_5637:
    mov ax, word [bx + 0x5a44]                                                  ; 5637: 8b 87 44 5a
loc_563b:
    mov word [0x592a], ax                                                       ; 563b: a3 2a 59
loc_563e:
    jmp short loc_5653                                                          ; 563e: eb 13
loc_5640:
    cmp word [0x592a], strict word 0xc8                                         ; 5640: 81 3e 2a 59 c8 00
loc_5646:
    ja loc_564e                                                                 ; 5646: 77 06
loc_5648:
    mov word [0x592a], 0x500                                                    ; 5648: c7 06 2a 59 00 05
loc_564e:
    sub word [0x592a], strict byte 0x19                                         ; 564e: 83 2e 2a 59 19
loc_5653:
    cmp byte [0x584], strict byte 0                                             ; 5653: 80 3e 84 05 00
loc_5658:
    je loc_5667                                                                 ; 5658: 74 0d
loc_565a:
    mov word [0x592e], 0x2000                                                   ; 565a: c7 06 2e 59 00 20
loc_5660:
    mov byte [0x592c], 0xff                                                     ; 5660: c6 06 2c 59 ff
loc_5665:
    jne loc_568d                                                                ; 5665: 75 26
loc_5667:
    mov bl, byte [0x5928]                                                       ; 5667: 8a 1e 28 59
loc_566b:
    load8 sub, bh, bh                                                           ; 566b: 2a ff
loc_566d:
    add bx, word [di + 0x59fe]                                                  ; 566d: 03 9d fe 59
loc_5671:
    mov al, byte [bx + 0x59c2]                                                  ; 5671: 8a 87 c2 59
loc_5675:
    and al, byte [0x5927]                                                       ; 5675: 22 06 27 59
loc_5679:
    jne loc_568d                                                                ; 5679: 75 12
loc_567b:
    cmp byte [0x592d], strict byte 0                                            ; 567b: 80 3e 2d 59 00
loc_5680:
    je loc_5690                                                                 ; 5680: 74 0e
loc_5682:
    dec byte [0x592d]                                                           ; 5682: fe 0e 2d 59
loc_5686:
    mov ax, word [di + 0x5a06]                                                  ; 5686: 8b 85 06 5a
loc_568a:
    mov word [0x592e], ax                                                       ; 568a: a3 2e 59
loc_568d:
    call near loc_5b28                                                          ; 568d: e8 98 04
loc_5690:
    ret                                                                         ; 5690: c3
loc_5691:
    call near disable_speaker                                                   ; 5691: e8 8d 04
loc_5694:
    mov ah, 0xb                                                                 ; 5694: b4 0b
loc_5696:
    mov bx, 4                                                                   ; 5696: bb 04 00
loc_5699:
    int 0x10                                                                    ; 5699: cd 10
loc_569b:
    load8 sub, ah, ah                                                           ; 569b: 2a e4
loc_569d:
    int 0x1a                                                                    ; 569d: cd 1a
loc_569f:
    mov word [0x5ae2], dx                                                       ; 569f: 89 16 e2 5a
loc_56a3:
    mov word [0x5ae4], 0                                                        ; 56a3: c7 06 e4 5a 00 00
loc_56a9:
    mov al, 2                                                                   ; 56a9: b0 02
loc_56ab:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 56ab: 80 3e 97 06 fd
loc_56b0:
    jne loc_56b4                                                                ; 56b0: 75 02
loc_56b2:
    shr al, 1                                                                   ; 56b2: d0 e8
loc_56b4:
    mov byte [0x5b06], al                                                       ; 56b4: a2 06 5b
loc_56b7:
    cmp byte [sound_enabled], strict byte 0                                     ; 56b7: 80 3e 00 00 00
loc_56bc:
    je loc_56d8                                                                 ; 56bc: 74 1a
loc_56be:
    inc word [0x5ae4]                                                           ; 56be: ff 06 e4 5a
loc_56c2:
    mov bx, word [0x5ae4]                                                       ; 56c2: 8b 1e e4 5a
loc_56c6:
    mov cl, byte [0x5b06]                                                       ; 56c6: 8a 0e 06 5b
loc_56ca:
    shr bx, cl                                                                  ; 56ca: d3 eb
loc_56cc:
    and bx, strict word 0x1f                                                    ; 56cc: 81 e3 1f 00
loc_56d0:
    in al, 0x61                                                                 ; 56d0: e4 61
loc_56d2:
    xor al, byte [bx + 0x5ae6]                                                  ; 56d2: 32 87 e6 5a
loc_56d6:
    out 0x61, al                                                                ; 56d6: e6 61
loc_56d8:
    load8 sub, ah, ah                                                           ; 56d8: 2a e4
loc_56da:
    int 0x1a                                                                    ; 56da: cd 1a
loc_56dc:
    sub dx, word [0x5ae2]                                                       ; 56dc: 2b 16 e2 5a
loc_56e0:
    cmp dx, strict byte 2                                                       ; 56e0: 83 fa 02
loc_56e3:
    jb loc_56b7                                                                 ; 56e3: 72 d2
loc_56e5:
    mov ah, 0xb                                                                 ; 56e5: b4 0b
loc_56e7:
    load16 sub, bx, bx                                                          ; 56e7: 2b db
loc_56e9:
    int 0x10                                                                    ; 56e9: cd 10
loc_56eb:
    mov byte [0x5b07], 0xc                                                      ; 56eb: c6 06 07 5b 0c
loc_56f0:
    call near disable_speaker                                                   ; 56f0: e8 2e 04
loc_56f3:
    ret                                                                         ; 56f3: c3
loc_56f4:
    mov ax, 0x200                                                               ; 56f4: b8 00 02
loc_56f7:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 56f7: 80 3e 97 06 fd
loc_56fc:
    jne loc_5700                                                                ; 56fc: 75 02
loc_56fe:
    shl ax, 1                                                                   ; 56fe: d1 e0
loc_5700:
    mov word [0x5ad0], ax                                                       ; 5700: a3 d0 5a
loc_5703:
    ret                                                                         ; 5703: c3
loc_5704:
    inc word [0x5ad0]                                                           ; 5704: ff 06 d0 5a
loc_5708:
    mov bx, word [0x5ad0]                                                       ; 5708: 8b 1e d0 5a
loc_570c:
    load16 mov, dx, bx                                                          ; 570c: 8b d3
loc_570e:
    mov cl, 9                                                                   ; 570e: b1 09
loc_5710:
    shr dx, cl                                                                  ; 5710: d3 ea
loc_5712:
    load8 mov, cl, dl                                                           ; 5712: 8a ca
loc_5714:
    and cl, strict byte 0xf                                                     ; 5714: 80 e1 0f
loc_5717:
    shr bx, cl                                                                  ; 5717: d3 eb
loc_5719:
    and bx, strict word 0xf                                                     ; 5719: 81 e3 0f 00
loc_571d:
    mov dl, byte [bx + 0x5ad2]                                                  ; 571d: 8a 97 d2 5a
loc_5721:
    and dl, byte [sound_enabled]                                                ; 5721: 22 16 00 00
loc_5725:
    in al, 0x61                                                                 ; 5725: e4 61
loc_5727:
    and al, 0xfc                                                                ; 5727: 24 fc
loc_5729:
    load8 or, al, dl                                                            ; 5729: 0a c2
loc_572b:
    out 0x61, al                                                                ; 572b: e6 61
loc_572d:
    ret                                                                         ; 572d: c3
loc_572e:
    mov word [0x5acb], 0x1f4                                                    ; 572e: c7 06 cb 5a f4 01
loc_5734:
    call near loc_576e                                                          ; 5734: e8 37 00
loc_5737:
    sub word [0x5acb], strict byte 0x1e                                         ; 5737: 83 2e cb 5a 1e
loc_573c:
    cmp word [0x5acb], strict word 0xc8                                         ; 573c: 81 3e cb 5a c8 00
loc_5742:
    ja loc_5734                                                                 ; 5742: 77 f0
loc_5744:
    mov word [0x5acb], 0x1f4                                                    ; 5744: c7 06 cb 5a f4 01
loc_574a:
    call near loc_576e                                                          ; 574a: e8 21 00
loc_574d:
    sub word [0x5acb], strict byte 0x14                                         ; 574d: 83 2e cb 5a 14
loc_5752:
    cmp word [0x5acb], strict word 0x12c                                        ; 5752: 81 3e cb 5a 2c 01
loc_5758:
    ja loc_574a                                                                 ; 5758: 77 f0
loc_575a:
    call near loc_576e                                                          ; 575a: e8 11 00
loc_575d:
    add word [0x5acb], strict byte 0x1e                                         ; 575d: 83 06 cb 5a 1e
loc_5762:
    cmp word [0x5acb], strict word 0x320                                        ; 5762: 81 3e cb 5a 20 03
loc_5768:
    jb loc_575a                                                                 ; 5768: 72 f0
loc_576a:
    call near disable_speaker                                                   ; 576a: e8 b4 03
loc_576d:
    ret                                                                         ; 576d: c3
loc_576e:
    mov cx, 0x1000                                                              ; 576e: b9 00 10
loc_5771:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 5771: 80 3e 97 06 fd
loc_5776:
    jne loc_577a                                                                ; 5776: 75 02
loc_5778:
    shr cx, 1                                                                   ; 5778: d1 e9
loc_577a:
    loop loc_577a                                                               ; 577a: e2 fe
loc_577c:
    cmp byte [sound_enabled], strict byte 0                                     ; 577c: 80 3e 00 00 00
loc_5781:
    je loc_5796                                                                 ; 5781: 74 13
loc_5783:
    mov al, 0xb6                                                                ; 5783: b0 b6
loc_5785:
    out 0x43, al                                                                ; 5785: e6 43
loc_5787:
    mov ax, word [0x5acb]                                                       ; 5787: a1 cb 5a
loc_578a:
    out 0x42, al                                                                ; 578a: e6 42
loc_578c:
    load8 mov, al, ah                                                           ; 578c: 8a c4
loc_578e:
    out 0x42, al                                                                ; 578e: e6 42
loc_5790:
    in al, 0x61                                                                 ; 5790: e4 61
loc_5792:
    or al, 3                                                                    ; 5792: 0c 03
loc_5794:
    out 0x61, al                                                                ; 5794: e6 61
loc_5796:
    ret                                                                         ; 5796: c3
