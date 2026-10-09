; Trash, room platform, exit and window support predicates.
; Original CS:15D0..1830 (end exclusive).

loc_15d0:
    mov bx, word [difficulty_level]                                             ; 15d0: 8b 1e 08 00
loc_15d4:
    mov cl, byte [bx + 0x100e]                                                  ; 15d4: 8a 8f 0e 10
loc_15d8:
    call near update_random_state                                               ; 15d8: e8 22 18
loc_15db:
    and dl, strict byte 7                                                       ; 15db: 80 e2 07
loc_15de:
    load8 cmp, dl, cl                                                           ; 15de: 3a d1
loc_15e0:
    ja loc_15d8                                                                 ; 15e0: 77 f6
loc_15e2:
    add dl, byte [bx + 0x1006]                                                  ; 15e2: 02 97 06 10
loc_15e6:
    cmp dl, byte [0x1028]                                                       ; 15e6: 3a 16 28 10
loc_15ea:
    je loc_15d8                                                                 ; 15ea: 74 ec
loc_15ec:
    mov byte [0x1028], dl                                                       ; 15ec: 88 16 28 10
loc_15f0:
    load8 mov, bl, dl                                                           ; 15f0: 8a da
loc_15f2:
    mov cl, byte [bx + 0xff0]                                                   ; 15f2: 8a 8f f0 0f
loc_15f6:
    mov dl, 0x88                                                                ; 15f6: b2 88
loc_15f8:
    test cl, 0x80                                                               ; 15f8: f6 c1 80
loc_15fb:
    jne loc_15ff                                                                ; 15fb: 75 02
loc_15fd:
    mov dl, 0x90                                                                ; 15fd: b2 90
loc_15ff:
    and cx, strict word 0x7f                                                    ; 15ff: 81 e1 7f 00
loc_1603:
    shl cx, 1                                                                   ; 1603: d1 e1
loc_1605:
    shl cx, 1                                                                   ; 1605: d1 e1
loc_1607:
    ret                                                                         ; 1607: c3
; CS:1608 — check_player_support
; Dispatches support checks to courtship stairs, room platforms, or alley fence/trash/window geometry; CF indicates support.
check_player_support:
    cmp word [scene_index], strict byte 7                                       ; 1608: 83 3e 04 00 07
loc_160d:
    jne loc_1613                                                                ; 160d: 75 04
loc_160f:
    call near loc_30fa                                                          ; 160f: e8 e8 1a
loc_1612:
    ret                                                                         ; 1612: c3
loc_1613:
    cmp word [scene_index], strict byte 0                                       ; 1613: 83 3e 04 00 00
loc_1618:
    je loc_161e                                                                 ; 1618: 74 04
loc_161a:
    call near check_room_exit_and_platforms                                     ; 161a: e8 a9 00
loc_161d:
    ret                                                                         ; 161d: c3
loc_161e:
    mov al, byte [player_y]                                                     ; 161e: a0 7b 05
loc_1621:
    and al, 0xf8                                                                ; 1621: 24 f8
loc_1623:
    cmp al, 0x60                                                                ; 1623: 3c 60
loc_1625:
    je loc_1630                                                                 ; 1625: 74 09
loc_1627:
    call near check_alley_trash_support                                         ; 1627: e8 2d 00
loc_162a:
    jb loc_1656                                                                 ; 162a: 72 2a
loc_162c:
    call near check_window_row_support                                          ; 162c: e8 7e 01
loc_162f:
    ret                                                                         ; 162f: c3
loc_1630:
    cmp byte [player_alley_motion_mode], strict byte 2                          ; 1630: 80 3e 50 05 02
loc_1635:
    jae loc_1655                                                                ; 1635: 73 1e
loc_1637:
    mov byte [player_y], al                                                     ; 1637: a2 7b 05
loc_163a:
    add al, 0x32                                                                ; 163a: 04 32
loc_163c:
    mov byte [player_y_plus_50], al                                             ; 163c: a2 7c 05
loc_163f:
    cmp byte [player_alley_motion_mode], strict byte 1                          ; 163f: 80 3e 50 05 01
loc_1644:
    je loc_1653                                                                 ; 1644: 74 0d
loc_1646:
    mov byte [player_alley_motion_mode], 1                                      ; 1646: c6 06 50 05 01
loc_164b:
    load8 sub, ah, ah                                                           ; 164b: 2a e4
loc_164d:
    int 0x1a                                                                    ; 164d: cd 1a
loc_164f:
    mov word [0x556], dx                                                        ; 164f: 89 16 56 05
loc_1653:
    stc                                                                         ; 1653: f9
loc_1654:
    ret                                                                         ; 1654: c3
loc_1655:
    clc                                                                         ; 1655: f8
loc_1656:
    ret                                                                         ; 1656: c3
; CS:1657 — check_alley_trash_support
; Decodes difficulty-selected DS:0FF0 entries into horizontal positions and Y=134/142 support surfaces, snapping player Y and biased Y on contact.
check_alley_trash_support:
    mov cl, byte [player_y]                                                     ; 1657: 8a 0e 7b 05
loc_165b:
    add cl, strict byte 2                                                       ; 165b: 80 c1 02
loc_165e:
    and cl, strict byte 0xf8                                                    ; 165e: 80 e1 f8
loc_1661:
    mov bx, word [difficulty_level]                                             ; 1661: 8b 1e 08 00
loc_1665:
    mov bl, byte [bx + 0x1006]                                                  ; 1665: 8a 9f 06 10
loc_1669:
    mov al, byte [bx + 0xff0]                                                   ; 1669: 8a 87 f0 0f
loc_166d:
    cmp al, 0                                                                   ; 166d: 3c 00
loc_166f:
    jne loc_1678                                                                ; 166f: 75 07
loc_1671:
    mov byte [0x127c], 0                                                        ; 1671: c6 06 7c 12 00
loc_1676:
    clc                                                                         ; 1676: f8
loc_1677:
    ret                                                                         ; 1677: c3
loc_1678:
    inc bx                                                                      ; 1678: 43
loc_1679:
    mov ch, 0x88                                                                ; 1679: b5 88
loc_167b:
    test al, 0x80                                                               ; 167b: a8 80
loc_167d:
    jne loc_1681                                                                ; 167d: 75 02
loc_167f:
    mov ch, 0x90                                                                ; 167f: b5 90
loc_1681:
    load8 cmp, cl, ch                                                           ; 1681: 3a cd
loc_1683:
    jne loc_1669                                                                ; 1683: 75 e4
loc_1685:
    and ax, strict word 0x7f                                                    ; 1685: 25 7f 00
loc_1688:
    shl ax, 1                                                                   ; 1688: d1 e0
loc_168a:
    shl ax, 1                                                                   ; 168a: d1 e0
loc_168c:
    mov dx, word [player_x]                                                     ; 168c: 8b 16 79 05
loc_1690:
    and dx, strict word 0xfff8                                                  ; 1690: 81 e2 f8 ff
loc_1694:
    load16 cmp, dx, ax                                                          ; 1694: 3b d0
loc_1696:
    jb loc_1669                                                                 ; 1696: 72 d1
loc_1698:
    mov dx, word [player_x]                                                     ; 1698: 8b 16 79 05
loc_169c:
    sub dx, strict byte 0xf                                                     ; 169c: 83 ea 0f
loc_169f:
    and dx, strict word 0xfff8                                                  ; 169f: 81 e2 f8 ff
loc_16a3:
    load16 cmp, dx, ax                                                          ; 16a3: 3b d0
loc_16a5:
    ja loc_1669                                                                 ; 16a5: 77 c2
loc_16a7:
    sub ch, strict byte 2                                                       ; 16a7: 80 ed 02
loc_16aa:
    mov byte [player_y], ch                                                     ; 16aa: 88 2e 7b 05
loc_16ae:
    add ch, strict byte 0x32                                                    ; 16ae: 80 c5 32
loc_16b1:
    mov byte [player_y_plus_50], ch                                             ; 16b1: 88 2e 7c 05
loc_16b5:
    cmp byte [0x127c], strict byte 0                                            ; 16b5: 80 3e 7c 12 00
loc_16ba:
    jne loc_16c4                                                                ; 16ba: 75 08
loc_16bc:
    mov byte [0x127c], 1                                                        ; 16bc: c6 06 7c 12 01
loc_16c1:
    call near loc_590e                                                          ; 16c1: e8 4a 42
loc_16c4:
    stc                                                                         ; 16c4: f9
loc_16c5:
    ret                                                                         ; 16c5: c3
; CS:16c6 — check_room_exit_and_platforms
; Falling contact with the room exit rectangle sets DS:0551; otherwise scans per-scene platform tables and returns CF on support.
check_room_exit_and_platforms:
    mov byte [0x39e0], 0                                                        ; 16c6: c6 06 e0 39 00
loc_16cb:
    cmp byte [player_vertical_direction], strict byte 1                         ; 16cb: 80 3e 71 05 01
loc_16d0:
    jne loc_16fc                                                                ; 16d0: 75 2a
loc_16d2:
    mov ax, word [0x2650]                                                       ; 16d2: a1 50 26
loc_16d5:
    sub ax, strict word 4                                                       ; 16d5: 2d 04 00
loc_16d8:
    mov dl, byte [0x2652]                                                       ; 16d8: 8a 16 52 26
loc_16dc:
    sub dl, strict byte 8                                                       ; 16dc: 80 ea 08
loc_16df:
    mov si, 0xc                                                                 ; 16df: be 0c 00
loc_16e2:
    mov bx, word [player_x]                                                     ; 16e2: 8b 1e 79 05
loc_16e6:
    mov dh, byte [player_y]                                                     ; 16e6: 8a 36 7b 05
loc_16ea:
    mov di, 0x18                                                                ; 16ea: bf 18 00
loc_16ed:
    mov cx, 0xe10                                                               ; 16ed: b9 10 0e
loc_16f0:
    call near rectangles_overlap                                                ; 16f0: e8 36 17
loc_16f3:
    jae loc_16fc                                                                ; 16f3: 73 07
loc_16f5:
    mov byte [scene_exit_requested], 1                                          ; 16f5: c6 06 51 05 01
loc_16fa:
    clc                                                                         ; 16fa: f8
loc_16fb:
    ret                                                                         ; 16fb: c3
loc_16fc:
    cmp word [scene_index], strict byte 3                                       ; 16fc: 83 3e 04 00 03
loc_1701:
    jne loc_170e                                                                ; 1701: 75 0b
loc_1703:
    call near loc_3c43                                                          ; 1703: e8 3d 25
loc_1706:
    jae loc_170e                                                                ; 1706: 73 06
loc_1708:
    mov byte [player_support_kind], 1                                           ; 1708: c6 06 5c 05 01
loc_170d:
    ret                                                                         ; 170d: c3
loc_170e:
    mov cl, byte [player_y]                                                     ; 170e: 8a 0e 7b 05
loc_1712:
    and cl, strict byte 0xf8                                                    ; 1712: 80 e1 f8
loc_1715:
    mov bx, word [scene_index]                                                  ; 1715: 8b 1e 04 00
loc_1719:
    shl bx, 1                                                                   ; 1719: d1 e3
loc_171b:
    mov bx, word [bx + 0x1269]                                                  ; 171b: 8b 9f 69 12
loc_171f:
    mov ch, byte [bx + 0x1029]                                                  ; 171f: 8a af 29 10
loc_1723:
    cmp ch, strict byte 0                                                       ; 1723: 80 fd 00
loc_1726:
    jne loc_172a                                                                ; 1726: 75 02
loc_1728:
    clc                                                                         ; 1728: f8
loc_1729:
    ret                                                                         ; 1729: c3
loc_172a:
    mov al, byte [bx + 0x1089]                                                  ; 172a: 8a 87 89 10
loc_172e:
    mov byte [0x127b], al                                                       ; 172e: a2 7b 12
loc_1731:
    shl bl, 1                                                                   ; 1731: d0 e3
loc_1733:
    mov ax, word [bx + 0x11a9]                                                  ; 1733: 8b 87 a9 11
loc_1737:
    mov word [0x1279], ax                                                       ; 1737: a3 79 12
loc_173a:
    mov ax, word [bx + 0x10e9]                                                  ; 173a: 8b 87 e9 10
loc_173e:
    shr bl, 1                                                                   ; 173e: d0 eb
loc_1740:
    inc bx                                                                      ; 1740: 43
loc_1741:
    load8 cmp, cl, ch                                                           ; 1741: 3a cd
loc_1743:
    jne loc_171f                                                                ; 1743: 75 da
loc_1745:
    mov dx, word [player_x]                                                     ; 1745: 8b 16 79 05
loc_1749:
    and dx, strict word 0xfff8                                                  ; 1749: 81 e2 f8 ff
loc_174d:
    load16 cmp, dx, ax                                                          ; 174d: 3b d0
loc_174f:
    jb loc_171f                                                                 ; 174f: 72 ce
loc_1751:
    mov dx, word [player_x]                                                     ; 1751: 8b 16 79 05
loc_1755:
    sub dx, word [0x1279]                                                       ; 1755: 2b 16 79 12
loc_1759:
    jae loc_175d                                                                ; 1759: 73 02
loc_175b:
    load16 sub, dx, dx                                                          ; 175b: 2b d2
loc_175d:
    and dx, strict word 0xfffc                                                  ; 175d: 81 e2 fc ff
loc_1761:
    load16 cmp, dx, ax                                                          ; 1761: 3b d0
loc_1763:
    ja loc_171f                                                                 ; 1763: 77 ba
loc_1765:
    mov byte [player_y], ch                                                     ; 1765: 88 2e 7b 05
loc_1769:
    add ch, strict byte 0x32                                                    ; 1769: 80 c5 32
loc_176c:
    mov byte [player_y_plus_50], ch                                             ; 176c: 88 2e 7c 05
loc_1770:
    mov al, byte [0x127b]                                                       ; 1770: a0 7b 12
loc_1773:
    mov byte [player_support_kind], al                                          ; 1773: a2 5c 05
loc_1776:
    cmp al, 0                                                                   ; 1776: 3c 00
loc_1778:
    je loc_1780                                                                 ; 1778: 74 06
loc_177a:
    and word [player_x], strict word 0xfffc                                     ; 177a: 81 26 79 05 fc ff
loc_1780:
    cmp word [scene_index], strict byte 4                                       ; 1780: 83 3e 04 00 04
loc_1785:
    jne loc_1797                                                                ; 1785: 75 10
loc_1787:
    dec bx                                                                      ; 1787: 4b
loc_1788:
    sub bx, strict byte 0x27                                                    ; 1788: 83 eb 27
loc_178b:
    jb loc_1797                                                                 ; 178b: 72 0a
loc_178d:
    cmp bx, strict byte 0x10                                                    ; 178d: 83 fb 10
loc_1790:
    jae loc_1797                                                                ; 1790: 73 05
loc_1792:
    inc bx                                                                      ; 1792: 43
loc_1793:
    mov byte [0x39e0], bl                                                       ; 1793: 88 1e e0 39
loc_1797:
    stc                                                                         ; 1797: f9
loc_1798:
    ret                                                                         ; 1798: c3
loc_1799:
    mov cl, 3                                                                   ; 1799: b1 03
loc_179b:
    shr bx, cl                                                                  ; 179b: d3 eb
loc_179d:
    load8 mov, ch, bl                                                           ; 179d: 8a eb
loc_179f:
    mov cl, 3                                                                   ; 179f: b1 03
loc_17a1:
    shr bx, cl                                                                  ; 17a1: d3 eb
loc_17a3:
    load8 mov, cl, ch                                                           ; 17a3: 8a cd
loc_17a5:
    and cl, strict byte 7                                                       ; 17a5: 80 e1 07
loc_17a8:
    mov ch, 0x80                                                                ; 17a8: b5 80
loc_17aa:
    shr ch, cl                                                                  ; 17aa: d2 ed
loc_17ac:
    ret                                                                         ; 17ac: c3
; CS:17ad — check_window_row_support
; Tests Y bands 8,40,72 and the scrolling support bitmap; contact snaps X to an eight-pixel boundary and sets DS:055C=1 and biased Y=Y+50.
check_window_row_support:
    mov dl, byte [player_y]                                                     ; 17ad: 8a 16 7b 05
loc_17b1:
    and dl, strict byte 0xf8                                                    ; 17b1: 80 e2 f8
loc_17b4:
    load16 sub, bx, bx                                                          ; 17b4: 2b db
loc_17b6:
    cmp dl, strict byte 8                                                       ; 17b6: 80 fa 08
loc_17b9:
    je loc_17c9                                                                 ; 17b9: 74 0e
loc_17bb:
    inc bl                                                                      ; 17bb: fe c3
loc_17bd:
    cmp dl, strict byte 0x28                                                    ; 17bd: 80 fa 28
loc_17c0:
    je loc_17c9                                                                 ; 17c0: 74 07
loc_17c2:
    inc bl                                                                      ; 17c2: fe c3
loc_17c4:
    cmp dl, strict byte 0x48                                                    ; 17c4: 80 fa 48
loc_17c7:
    jne loc_1810                                                                ; 17c7: 75 47
loc_17c9:
    mov ax, word [player_x]                                                     ; 17c9: a1 79 05
loc_17cc:
    cmp bx, word [moving_window_row]                                            ; 17cc: 3b 1e 2f 05
loc_17d0:
    jne loc_17fc                                                                ; 17d0: 75 2a
loc_17d2:
    cmp byte [window_scroll_phase], strict byte 3                               ; 17d2: 80 3e 25 05 03
loc_17d7:
    ja loc_17fc                                                                 ; 17d7: 77 23
loc_17d9:
    cmp bl, strict byte 1                                                       ; 17d9: 80 fb 01
loc_17dc:
    je loc_17ee                                                                 ; 17dc: 74 10
loc_17de:
    mov cx, 4                                                                   ; 17de: b9 04 00
loc_17e1:
    sub cl, byte [window_scroll_phase]                                          ; 17e1: 2a 0e 25 05
loc_17e5:
    shl cl, 1                                                                   ; 17e5: d0 e1
loc_17e7:
    shl cl, 1                                                                   ; 17e7: d0 e1
loc_17e9:
    load16 add, ax, cx                                                          ; 17e9: 03 c1
loc_17eb:
    jmp short loc_17fc                                                          ; 17eb: eb 0f
loc_17ed:
    nop                                                                         ; 17ed: 90
loc_17ee:
    load8 sub, ch, ch                                                           ; 17ee: 2a ed
loc_17f0:
    mov cl, byte [window_scroll_phase]                                          ; 17f0: 8a 0e 25 05
loc_17f4:
    inc cl                                                                      ; 17f4: fe c1
loc_17f6:
    shl cl, 1                                                                   ; 17f6: d0 e1
loc_17f8:
    shl cl, 1                                                                   ; 17f8: d0 e1
loc_17fa:
    load16 sub, ax, cx                                                          ; 17fa: 2b c1
loc_17fc:
    mov bl, byte [bx + 0x1025]                                                  ; 17fc: 8a 9f 25 10
loc_1800:
    load16 mov, si, bx                                                          ; 1800: 8b f3
loc_1802:
    load16 mov, bx, ax                                                          ; 1802: 8b d8
loc_1804:
    add bx, strict byte 0xa                                                     ; 1804: 83 c3 0a
loc_1807:
    call near loc_1799                                                          ; 1807: e8 8f ff
loc_180a:
    test byte [bx + si + 0x1016], ch                                            ; 180a: 84 a8 16 10
loc_180e:
    jne loc_1812                                                                ; 180e: 75 02
loc_1810:
    clc                                                                         ; 1810: f8
loc_1811:
    ret                                                                         ; 1811: c3
loc_1812:
    mov byte [player_y], dl                                                     ; 1812: 88 16 7b 05
loc_1816:
    add dl, strict byte 0x32                                                    ; 1816: 80 c2 32
loc_1819:
    mov byte [player_y_plus_50], dl                                             ; 1819: 88 16 7c 05
loc_181d:
    and word [player_x], strict word 0xfff8                                     ; 181d: 81 26 79 05 f8 ff
loc_1823:
    mov byte [player_support_kind], 1                                           ; 1823: c6 06 5c 05 01
loc_1828:
    stc                                                                         ; 1828: f9
loc_1829:
    ret                                                                         ; 1829: c3
    times 6 db 0 ; original zero fill at CS:182a
