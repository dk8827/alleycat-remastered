; Window events, room entry and thrown-object contact.
; Original CS:1830..1BF0 (end exclusive).

; CS:1830 — reset_alley_window_event
; Clears window animation phase, projectile Y, forced-target flag and lethal flag; sets window-open duration to nine. Does not initialize the player.
reset_alley_window_event:
    mov byte [window_event_phase], 0                                            ; 1830: c6 06 65 16 00
loc_1835:
    mov byte [alley_projectile_y], 0                                            ; 1835: c6 06 73 16 00
loc_183a:
    mov byte [0x1677], 0                                                        ; 183a: c6 06 77 16 00
loc_183f:
    mov byte [alley_projectile_lethal], 0                                       ; 183f: c6 06 78 16 00
loc_1844:
    mov word [0x166c], 9                                                        ; 1844: c7 06 6c 16 09 00
loc_184a:
    ret                                                                         ; 184a: c3
; CS:184b — update_alley_projectile
; Advances the projectile at DS:1671/1673 using separate horizontal and vertical accumulators, clips its sprite, checks player contact, and saves/restores its background.
update_alley_projectile:
    cmp byte [alley_projectile_y], strict byte 0                                ; 184b: 80 3e 73 16 00
loc_1850:
    je loc_185c                                                                 ; 1850: 74 0a
loc_1852:
    load8 sub, ah, ah                                                           ; 1852: 2a e4
loc_1854:
    int 0x1a                                                                    ; 1854: cd 1a
loc_1856:
    cmp dx, word [alley_projectile_last_tick]                                   ; 1856: 3b 16 ec 17
loc_185a:
    jne loc_185d                                                                ; 185a: 75 01
loc_185c:
    ret                                                                         ; 185c: c3
loc_185d:
    mov word [alley_projectile_last_tick], dx                                   ; 185d: 89 16 ec 17
loc_1861:
    cmp byte [0x1677], strict byte 0                                            ; 1861: 80 3e 77 16 00
loc_1866:
    je loc_187f                                                                 ; 1866: 74 17
loc_1868:
    mov ax, word [alley_projectile_x]                                           ; 1868: a1 71 16
loc_186b:
    and ax, strict word 0xfff8                                                  ; 186b: 25 f8 ff
loc_186e:
    mov bx, word [player_x]                                                     ; 186e: 8b 1e 79 05
loc_1872:
    and bx, strict word 0xfff8                                                  ; 1872: 81 e3 f8 ff
loc_1876:
    load16 cmp, ax, bx                                                          ; 1876: 3b c3
loc_1878:
    jne loc_187f                                                                ; 1878: 75 05
loc_187a:
    mov byte [alley_projectile_horizontal_direction], 0                         ; 187a: c6 06 74 16 00
loc_187f:
    inc byte [alley_projectile_age]                                             ; 187f: fe 06 e9 17
loc_1883:
    cmp word [0x17ea], strict byte 1                                            ; 1883: 83 3e ea 17 01
loc_1888:
    ja loc_188e                                                                 ; 1888: 77 04
loc_188a:
    dec word [0x17ea]                                                           ; 188a: ff 0e ea 17
loc_188e:
    mov ax, word [alley_projectile_x]                                           ; 188e: a1 71 16
loc_1891:
    mov dx, word [0x17ea]                                                       ; 1891: 8b 16 ea 17
loc_1895:
    mov cl, 3                                                                   ; 1895: b1 03
loc_1897:
    shr dl, cl                                                                  ; 1897: d2 ea
loc_1899:
    cmp byte [alley_projectile_horizontal_direction], strict byte 1             ; 1899: 80 3e 74 16 01
loc_189e:
    jb loc_18b5                                                                 ; 189e: 72 15
loc_18a0:
    jne loc_18af                                                                ; 18a0: 75 0d
loc_18a2:
    load16 add, ax, dx                                                          ; 18a2: 03 c2
loc_18a4:
    cmp ax, strict word 0x12f                                                   ; 18a4: 3d 2f 01
loc_18a7:
    jb loc_18b5                                                                 ; 18a7: 72 0c
loc_18a9:
    mov ax, 0x12e                                                               ; 18a9: b8 2e 01
loc_18ac:
    jmp short loc_18b5                                                          ; 18ac: eb 07
loc_18ae:
    nop                                                                         ; 18ae: 90
loc_18af:
    load16 sub, ax, dx                                                          ; 18af: 2b c2
loc_18b1:
    jae loc_18b5                                                                ; 18b1: 73 02
loc_18b3:
    load16 sub, ax, ax                                                          ; 18b3: 2b c0
loc_18b5:
    mov word [alley_projectile_x], ax                                           ; 18b5: a3 71 16
loc_18b8:
    mov bx, word [0x17df]                                                       ; 18b8: 8b 1e df 17
loc_18bc:
    mov al, byte [alley_projectile_age]                                         ; 18bc: a0 e9 17
loc_18bf:
    shr al, 1                                                                   ; 18bf: d0 e8
loc_18c1:
    add al, byte [alley_projectile_y]                                           ; 18c1: 02 06 73 16
loc_18c5:
    load8 mov, dl, al                                                           ; 18c5: 8a d0
loc_18c7:
    sub al, byte [0x1676]                                                       ; 18c7: 2a 06 76 16
loc_18cb:
    jb loc_18e1                                                                 ; 18cb: 72 14
loc_18cd:
    load8 sub, bh, al                                                           ; 18cd: 2a f8
loc_18cf:
    je loc_18d3                                                                 ; 18cf: 74 02
loc_18d1:
    jae loc_18e1                                                                ; 18d1: 73 0e
loc_18d3:
    mov byte [alley_projectile_y], 0                                            ; 18d3: c6 06 73 16 00
loc_18d8:
    mov byte [alley_projectile_lethal], 0                                       ; 18d8: c6 06 78 16 00
loc_18dd:
    call near loc_1922                                                          ; 18dd: e8 42 00
loc_18e0:
    ret                                                                         ; 18e0: c3
loc_18e1:
    mov byte [alley_projectile_y], dl                                           ; 18e1: 88 16 73 16
loc_18e5:
    mov cx, word [alley_projectile_x]                                           ; 18e5: 8b 0e 71 16
loc_18e9:
    mov word [0x17e1], bx                                                       ; 18e9: 89 1e e1 17
loc_18ed:
    call near calculate_cga_address                                             ; 18ed: e8 c0 13
loc_18f0:
    mov word [0x17e7], ax                                                       ; 18f0: a3 e7 17
loc_18f3:
    cmp byte [alley_projectile_age], strict byte 2                              ; 18f3: 80 3e e9 17 02
loc_18f8:
    je loc_18fd                                                                 ; 18f8: 74 03
loc_18fa:
    call near loc_1922                                                          ; 18fa: e8 25 00
loc_18fd:
    call near check_alley_projectile_contact                                    ; 18fd: e8 7a 02
loc_1900:
    jb loc_18e0                                                                 ; 1900: 72 de
loc_1902:
    mov di, word [0x17e7]                                                       ; 1902: 8b 3e e7 17
loc_1906:
    mov word [0x17e5], di                                                       ; 1906: 89 3e e5 17
loc_190a:
    mov cx, word [0x17e1]                                                       ; 190a: 8b 0e e1 17
loc_190e:
    mov word [0x17e3], cx                                                       ; 190e: 89 0e e3 17
loc_1912:
    mov ax, 0xb800                                                              ; 1912: b8 00 b8
loc_1915:
    mov es, ax                                                                  ; 1915: 8e c0
loc_1917:
    mov si, word [0x17dd]                                                       ; 1917: 8b 36 dd 17
loc_191b:
    mov bp, 0x17ee                                                              ; 191b: bd ee 17
loc_191e:
    call near blit_zero_transparent                                             ; 191e: e8 ab 13
loc_1921:
    ret                                                                         ; 1921: c3
loc_1922:
    mov ax, 0xb800                                                              ; 1922: b8 00 b8
loc_1925:
    mov es, ax                                                                  ; 1925: 8e c0
loc_1927:
    mov di, word [0x17e5]                                                       ; 1927: 8b 3e e5 17
loc_192b:
    mov si, 0x17ee                                                              ; 192b: be ee 17
loc_192e:
    mov cx, word [0x17e3]                                                       ; 192e: 8b 0e e3 17
loc_1932:
    call near copy_rectangle_to_cga                                             ; 1932: e8 68 14
loc_1935:
    ret                                                                         ; 1935: c3
; CS:1936 — update_alley_window_event
; Selects and animates an opening window, holds phase 15 for a difficulty-selected duration, launches a projectile once, and checks player entry contact.
update_alley_window_event:
    dec byte [0x166a]                                                           ; 1936: fe 0e 6a 16
loc_193a:
    je loc_193d                                                                 ; 193a: 74 01
loc_193c:
    ret                                                                         ; 193c: c3
loc_193d:
    mov byte [0x166a], 0xd                                                      ; 193d: c6 06 6a 16 0d
loc_1942:
    call near read_cga_vertical_retrace_bit                                     ; 1942: e8 93 fa
loc_1945:
    jne loc_193c                                                                ; 1945: 75 f5
loc_1947:
    cmp byte [window_event_phase], strict byte 0                                ; 1947: 80 3e 65 16 00
loc_194c:
    je loc_1951                                                                 ; 194c: 74 03
loc_194e:
    call near check_open_window_entry                                           ; 194e: e8 b4 01
loc_1951:
    cmp byte [alley_projectile_y], strict byte 0                                ; 1951: 80 3e 73 16 00
loc_1956:
    jne loc_193c                                                                ; 1956: 75 e4
loc_1958:
    cmp byte [window_event_phase], strict byte 0                                ; 1958: 80 3e 65 16 00
loc_195d:
    jne loc_19cd                                                                ; 195d: 75 6e
loc_195f:
    cmp byte [player_y], strict byte 0x60                                       ; 195f: 80 3e 7b 05 60
loc_1964:
    ja loc_193c                                                                 ; 1964: 77 d6
loc_1966:
    mov byte [0x1677], 0                                                        ; 1966: c6 06 77 16 00
loc_196b:
    cmp byte [player_alley_motion_mode], strict byte 1                          ; 196b: 80 3e 50 05 01
loc_1970:
    jne loc_198a                                                                ; 1970: 75 18
loc_1972:
    cmp byte [courtship_pending], strict byte 0                                 ; 1972: 80 3e 18 04 00
loc_1977:
    jne loc_198a                                                                ; 1977: 75 11
loc_1979:
    load8 sub, ah, ah                                                           ; 1979: 2a e4
loc_197b:
    int 0x1a                                                                    ; 197b: cd 1a
loc_197d:
    sub dx, word [0x556]                                                        ; 197d: 2b 16 56 05
loc_1981:
    cmp dx, strict byte 0x48                                                    ; 1981: 83 fa 48
loc_1984:
    jb loc_198a                                                                 ; 1984: 72 04
loc_1986:
    inc byte [0x1677]                                                           ; 1986: fe 06 77 16
loc_198a:
    call near update_random_state                                               ; 198a: e8 70 14
loc_198d:
    cmp byte [0x1677], strict byte 0                                            ; 198d: 80 3e 77 16 00
loc_1992:
    je loc_199a                                                                 ; 1992: 74 06
loc_1994:
    and dl, strict byte 3                                                       ; 1994: 80 e2 03
loc_1997:
    jmp short loc_19a2                                                          ; 1997: eb 09
loc_1999:
    nop                                                                         ; 1999: 90
loc_199a:
    and dl, strict byte 0xf                                                     ; 199a: 80 e2 0f
loc_199d:
    cmp dl, strict byte 0xc                                                     ; 199d: 80 fa 0c
loc_19a0:
    jae loc_193c                                                                ; 19a0: 73 9a
loc_19a2:
    mov byte [0x1669], dl                                                       ; 19a2: 88 16 69 16
loc_19a6:
    call near loc_1aea                                                          ; 19a6: e8 41 01
loc_19a9:
    mov word [open_window_x], cx                                                ; 19a9: 89 0e 66 16
loc_19ad:
    mov byte [open_window_y], dl                                                ; 19ad: 88 16 68 16
loc_19b1:
    call near check_open_window_entry                                           ; 19b1: e8 51 01
loc_19b4:
    jb loc_198a                                                                 ; 19b4: 72 d4
loc_19b6:
    mov byte [window_event_phase], 0x1d                                         ; 19b6: c6 06 65 16 1d
loc_19bb:
    mov bx, word [difficulty_level]                                             ; 19bb: 8b 1e 08 00
loc_19bf:
    shl bl, 1                                                                   ; 19bf: d0 e3
loc_19c1:
    mov ax, word [bx + 0x181e]                                                  ; 19c1: 8b 87 1e 18
loc_19c5:
    mov word [0x166c], ax                                                       ; 19c5: a3 6c 16
loc_19c8:
    mov byte [0x1670], 1                                                        ; 19c8: c6 06 70 16 01
loc_19cd:
    call near check_open_window_entry                                           ; 19cd: e8 35 01
loc_19d0:
    jb loc_19e0                                                                 ; 19d0: 72 0e
loc_19d2:
    mov byte [0x1664], 0                                                        ; 19d2: c6 06 64 16 00
loc_19d7:
    call near loc_1b4c                                                          ; 19d7: e8 72 01
loc_19da:
    jae loc_19e1                                                                ; 19da: 73 05
loc_19dc:
    inc byte [0x1664]                                                           ; 19dc: fe 06 64 16
loc_19e0:
    ret                                                                         ; 19e0: c3
loc_19e1:
    cmp byte [window_event_phase], strict byte 0x10                             ; 19e1: 80 3e 65 16 10
loc_19e6:
    jne loc_19f0                                                                ; 19e6: 75 08
loc_19e8:
    load8 sub, ah, ah                                                           ; 19e8: 2a e4
loc_19ea:
    int 0x1a                                                                    ; 19ea: cd 1a
loc_19ec:
    mov word [0x166e], dx                                                       ; 19ec: 89 16 6e 16
loc_19f0:
    cmp byte [window_event_phase], strict byte 0xf                              ; 19f0: 80 3e 65 16 0f
loc_19f5:
    jne loc_1a76                                                                ; 19f5: 75 7f
loc_19f7:
    load8 sub, ah, ah                                                           ; 19f7: 2a e4
loc_19f9:
    int 0x1a                                                                    ; 19f9: cd 1a
loc_19fb:
    sub dx, word [0x166e]                                                       ; 19fb: 2b 16 6e 16
loc_19ff:
    cmp dx, word [0x166c]                                                       ; 19ff: 3b 16 6c 16
loc_1a03:
    jae loc_1a76                                                                ; 1a03: 73 71
loc_1a05:
    cmp byte [0x1670], strict byte 0                                            ; 1a05: 80 3e 70 16 00
loc_1a0a:
    je loc_1a75                                                                 ; 1a0a: 74 69
loc_1a0c:
    cmp byte [alley_projectile_y], strict byte 0                                ; 1a0c: 80 3e 73 16 00
loc_1a11:
    jne loc_1a75                                                                ; 1a11: 75 62
loc_1a13:
    cmp byte [courtship_pending], strict byte 0                                 ; 1a13: 80 3e 18 04 00
loc_1a18:
    jne loc_1a75                                                                ; 1a18: 75 5b
loc_1a1a:
    dec byte [0x1670]                                                           ; 1a1a: fe 0e 70 16
loc_1a1e:
    mov byte [alley_projectile_lethal], 1                                       ; 1a1e: c6 06 78 16 01
loc_1a23:
    mov al, byte [open_window_y]                                                ; 1a23: a0 68 16
loc_1a26:
    mov byte [alley_projectile_y], al                                           ; 1a26: a2 73 16
loc_1a29:
    call near update_random_state                                               ; 1a29: e8 d1 13
loc_1a2c:
    and dx, strict word 0xf                                                     ; 1a2c: 81 e2 0f 00
loc_1a30:
    add dx, word [open_window_x]                                                ; 1a30: 03 16 66 16
loc_1a34:
    mov word [alley_projectile_x], dx                                           ; 1a34: 89 16 71 16
loc_1a38:
    mov al, 1                                                                   ; 1a38: b0 01
loc_1a3a:
    cmp dx, word [player_x]                                                     ; 1a3a: 3b 16 79 05
loc_1a3e:
    jb loc_1a42                                                                 ; 1a3e: 72 02
loc_1a40:
    mov al, 0xff                                                                ; 1a40: b0 ff
loc_1a42:
    mov byte [alley_projectile_horizontal_direction], al                        ; 1a42: a2 74 16
loc_1a45:
    call near update_random_state                                               ; 1a45: e8 b5 13
loc_1a48:
    load8 mov, bl, dl                                                           ; 1a48: 8a da
loc_1a4a:
    and bx, strict word 6                                                       ; 1a4a: 81 e3 06 00
loc_1a4e:
    mov ax, word [bx + 0x17c9]                                                  ; 1a4e: 8b 87 c9 17
loc_1a52:
    mov word [0x17dd], ax                                                       ; 1a52: a3 dd 17
loc_1a55:
    mov ax, word [bx + 0x17d1]                                                  ; 1a55: 8b 87 d1 17
loc_1a59:
    mov word [0x17df], ax                                                       ; 1a59: a3 df 17
loc_1a5c:
    shr bl, 1                                                                   ; 1a5c: d0 eb
loc_1a5e:
    mov al, byte [bx + 0x17d9]                                                  ; 1a5e: 8a 87 d9 17
loc_1a62:
    mov byte [0x1676], al                                                       ; 1a62: a2 76 16
loc_1a65:
    mov word [0x17ea], 0x20                                                     ; 1a65: c7 06 ea 17 20 00
loc_1a6b:
    mov byte [alley_projectile_age], 1                                          ; 1a6b: c6 06 e9 17 01
loc_1a70:
    mov byte [0x1675], 0                                                        ; 1a70: c6 06 75 16 00
loc_1a75:
    ret                                                                         ; 1a75: c3
loc_1a76:
    dec byte [window_event_phase]                                               ; 1a76: fe 0e 65 16
loc_1a7a:
    mov cx, word [open_window_x]                                                ; 1a7a: 8b 0e 66 16
loc_1a7e:
    mov dl, byte [open_window_y]                                                ; 1a7e: 8a 16 68 16
loc_1a82:
    cmp byte [window_event_phase], strict byte 0xe                              ; 1a82: 80 3e 65 16 0e
loc_1a87:
    jbe loc_1a93                                                                ; 1a87: 76 0a
loc_1a89:
    add dl, byte [window_event_phase]                                           ; 1a89: 02 16 65 16
loc_1a8d:
    sub dl, strict byte 0xe                                                     ; 1a8d: 80 ea 0e
loc_1a90:
    jmp short loc_1a9a                                                          ; 1a90: eb 08
loc_1a92:
    nop                                                                         ; 1a92: 90
loc_1a93:
    add dl, strict byte 0xe                                                     ; 1a93: 80 c2 0e
loc_1a96:
    sub dl, byte [window_event_phase]                                           ; 1a96: 2a 16 65 16
loc_1a9a:
    mov byte [0x166b], dl                                                       ; 1a9a: 88 16 6b 16
loc_1a9e:
    call near calculate_cga_address                                             ; 1a9e: e8 0f 12
loc_1aa1:
    load16 mov, di, ax                                                          ; 1aa1: 8b f8
loc_1aa3:
    mov ax, 0xb800                                                              ; 1aa3: b8 00 b8
loc_1aa6:
    mov es, ax                                                                  ; 1aa6: 8e c0
loc_1aa8:
    cld                                                                         ; 1aa8: fc
loc_1aa9:
    mov cx, 4                                                                   ; 1aa9: b9 04 00
loc_1aac:
    cmp byte [window_event_phase], strict byte 0xe                              ; 1aac: 80 3e 65 16 0e
loc_1ab1:
    jbe loc_1ad7                                                                ; 1ab1: 76 24
loc_1ab3:
    cmp byte [courtship_pending], strict byte 0                                 ; 1ab3: 80 3e 18 04 00
loc_1ab8:
    je loc_1ad2                                                                 ; 1ab8: 74 18
loc_1aba:
    mov al, byte [0x166b]                                                       ; 1aba: a0 6b 16
loc_1abd:
    sub al, byte [open_window_y]                                                ; 1abd: 2a 06 68 16
loc_1ac1:
    load8 sub, ah, ah                                                           ; 1ac1: 2a e4
loc_1ac3:
    mov cl, 3                                                                   ; 1ac3: b1 03
loc_1ac5:
    shl ax, cl                                                                  ; 1ac5: d3 e0
loc_1ac7:
    add ax, strict word 0x15e0                                                  ; 1ac7: 05 e0 15
loc_1aca:
    load16 mov, si, ax                                                          ; 1aca: 8b f0
loc_1acc:
    mov cx, 4                                                                   ; 1acc: b9 04 00
loc_1acf:
    rep movsw                                                                   ; 1acf: f3 a5
loc_1ad1:
    ret                                                                         ; 1ad1: c3
loc_1ad2:
    load16 sub, ax, ax                                                          ; 1ad2: 2b c0
loc_1ad4:
    rep stosw                                                                   ; 1ad4: f3 ab
loc_1ad6:
    ret                                                                         ; 1ad6: c3
loc_1ad7:
    mov al, byte [0x166b]                                                       ; 1ad7: a0 6b 16
loc_1ada:
    sub al, byte [open_window_y]                                                ; 1ada: 2a 06 68 16
loc_1ade:
    mov ah, 0xa                                                                 ; 1ade: b4 0a
loc_1ae0:
    mul ah                                                                      ; 1ae0: f6 e4
loc_1ae2:
    add ax, strict word 0x2681                                                  ; 1ae2: 05 81 26
loc_1ae5:
    load16 mov, si, ax                                                          ; 1ae5: 8b f0
loc_1ae7:
    rep movsw                                                                   ; 1ae7: f3 a5
loc_1ae9:
    ret                                                                         ; 1ae9: c3
loc_1aea:
    load8 sub, bh, bh                                                           ; 1aea: 2a ff
loc_1aec:
    load8 mov, bl, dl                                                           ; 1aec: 8a da
loc_1aee:
    and bl, strict byte 3                                                       ; 1aee: 80 e3 03
loc_1af1:
    shl bl, 1                                                                   ; 1af1: d0 e3
loc_1af3:
    mov cx, word [bx + 0x1658]                                                  ; 1af3: 8b 8f 58 16
loc_1af7:
    load8 mov, bl, dl                                                           ; 1af7: 8a da
loc_1af9:
    shr bl, 1                                                                   ; 1af9: d0 eb
loc_1afb:
    shr bl, 1                                                                   ; 1afb: d0 eb
loc_1afd:
    and bl, strict byte 3                                                       ; 1afd: 80 e3 03
loc_1b00:
    mov dl, byte [bx + 0x1660]                                                  ; 1b00: 8a 97 60 16
loc_1b04:
    ret                                                                         ; 1b04: c3
; CS:1b05 — check_open_window_entry
; Overlapping player enters only while descending, not transition-blocked, above Y=96, and window phase in 5..24; sets scene_exit_requested rather than death.
check_open_window_entry:
    mov ax, word [open_window_x]                                                ; 1b05: a1 66 16
loc_1b08:
    mov dl, byte [open_window_y]                                                ; 1b08: 8a 16 68 16
loc_1b0c:
    mov bx, word [player_x]                                                     ; 1b0c: 8b 1e 79 05
loc_1b10:
    mov dh, byte [player_y]                                                     ; 1b10: 8a 36 7b 05
loc_1b14:
    mov si, 0x20                                                                ; 1b14: be 20 00
loc_1b17:
    mov di, 0x18                                                                ; 1b17: bf 18 00
loc_1b1a:
    mov cx, 0xe0f                                                               ; 1b1a: b9 0f 0e
loc_1b1d:
    call near rectangles_overlap                                                ; 1b1d: e8 09 13
loc_1b20:
    jae loc_1b4b                                                                ; 1b20: 73 29
loc_1b22:
    cmp byte [player_vertical_direction], strict byte 1                         ; 1b22: 80 3e 71 05 01
loc_1b27:
    jne loc_1b4a                                                                ; 1b27: 75 21
loc_1b29:
    cmp byte [player_transition_blocked], strict byte 0                         ; 1b29: 80 3e 5a 05 00
loc_1b2e:
    jne loc_1b4a                                                                ; 1b2e: 75 1a
loc_1b30:
    cmp byte [player_y], strict byte 0x60                                       ; 1b30: 80 3e 7b 05 60
loc_1b35:
    jae loc_1b4a                                                                ; 1b35: 73 13
loc_1b37:
    cmp byte [window_event_phase], strict byte 5                                ; 1b37: 80 3e 65 16 05
loc_1b3c:
    jb loc_1b4a                                                                 ; 1b3c: 72 0c
loc_1b3e:
    cmp byte [window_event_phase], strict byte 0x19                             ; 1b3e: 80 3e 65 16 19
loc_1b43:
    jae loc_1b4a                                                                ; 1b43: 73 05
loc_1b45:
    mov byte [scene_exit_requested], 1                                          ; 1b45: c6 06 51 05 01
loc_1b4a:
    stc                                                                         ; 1b4a: f9
loc_1b4b:
    ret                                                                         ; 1b4b: c3
loc_1b4c:
    mov al, byte [0x1669]                                                       ; 1b4c: a0 69 16
loc_1b4f:
    cmp al, 8                                                                   ; 1b4f: 3c 08
loc_1b51:
    jae loc_1b78                                                                ; 1b51: 73 25
loc_1b53:
    mov bx, 2                                                                   ; 1b53: bb 02 00
loc_1b56:
    test al, 4                                                                  ; 1b56: a8 04
loc_1b58:
    je loc_1b5c                                                                 ; 1b58: 74 02
loc_1b5a:
    shl bl, 1                                                                   ; 1b5a: d0 e3
loc_1b5c:
    mov ax, word [bx + alley_object_x]                                          ; 1b5c: 8b 87 30 1f
loc_1b60:
    add ax, strict word 0x10                                                    ; 1b60: 05 10 00
loc_1b63:
    cmp ax, word [open_window_x]                                                ; 1b63: 3b 06 66 16
loc_1b67:
    jb loc_1b78                                                                 ; 1b67: 72 0f
loc_1b69:
    sub ax, strict word 0x30                                                    ; 1b69: 2d 30 00
loc_1b6c:
    jae loc_1b70                                                                ; 1b6c: 73 02
loc_1b6e:
    load16 sub, ax, ax                                                          ; 1b6e: 2b c0
loc_1b70:
    cmp ax, word [open_window_x]                                                ; 1b70: 3b 06 66 16
loc_1b74:
    ja loc_1b78                                                                 ; 1b74: 77 02
loc_1b76:
    stc                                                                         ; 1b76: f9
loc_1b77:
    ret                                                                         ; 1b77: c3
loc_1b78:
    clc                                                                         ; 1b78: f8
loc_1b79:
    ret                                                                         ; 1b79: c3
; CS:1b7a — check_alley_projectile_contact
; In scene zero only, tests active projectile against player, redraws both, triggers one impact, reverses projectile direction, and clears player support.
check_alley_projectile_contact:
    cmp word [scene_index], strict byte 0                                       ; 1b7a: 83 3e 04 00 00
loc_1b7f:
    jne loc_1be1                                                                ; 1b7f: 75 60
loc_1b81:
    mov dl, byte [alley_projectile_y]                                           ; 1b81: 8a 16 73 16
loc_1b85:
    cmp dl, strict byte 0                                                       ; 1b85: 80 fa 00
loc_1b88:
    je loc_1be1                                                                 ; 1b88: 74 57
loc_1b8a:
    mov cx, word [0x17df]                                                       ; 1b8a: 8b 0e df 17
loc_1b8e:
    xchg cl, ch                                                                 ; 1b8e: 86 cd
loc_1b90:
    mov si, 0x10                                                                ; 1b90: be 10 00
loc_1b93:
    mov ax, word [alley_projectile_x]                                           ; 1b93: a1 71 16
loc_1b96:
    mov bx, word [player_x]                                                     ; 1b96: 8b 1e 79 05
loc_1b9a:
    mov dh, byte [player_y]                                                     ; 1b9a: 8a 36 7b 05
loc_1b9e:
    mov di, 0x18                                                                ; 1b9e: bf 18 00
loc_1ba1:
    mov ch, 0xe                                                                 ; 1ba1: b5 0e
loc_1ba3:
    call near rectangles_overlap                                                ; 1ba3: e8 83 12
loc_1ba6:
    jae loc_1be2                                                                ; 1ba6: 73 3a
loc_1ba8:
    call near restore_player_background                                         ; 1ba8: e8 38 f6
loc_1bab:
    call near loc_1922                                                          ; 1bab: e8 74 fd
loc_1bae:
    call near loc_10dd                                                          ; 1bae: e8 2c f5
loc_1bb1:
    cmp byte [0x1675], strict byte 0                                            ; 1bb1: 80 3e 75 16 00
loc_1bb6:
    jne loc_1bdf                                                                ; 1bb6: 75 27
loc_1bb8:
    mov byte [0x1675], 1                                                        ; 1bb8: c6 06 75 16 01
loc_1bbd:
    call near show_alley_impact                                                 ; 1bbd: e8 a6 f5
loc_1bc0:
    mov dl, 1                                                                   ; 1bc0: b2 01
loc_1bc2:
    cmp byte [alley_projectile_horizontal_direction], strict byte 0xff          ; 1bc2: 80 3e 74 16 ff
loc_1bc7:
    je loc_1bcb                                                                 ; 1bc7: 74 02
loc_1bc9:
    mov dl, 0xff                                                                ; 1bc9: b2 ff
loc_1bcb:
    mov byte [alley_projectile_horizontal_direction], dl                        ; 1bcb: 88 16 74 16
loc_1bcf:
    mov word [0x17ea], 0x60                                                     ; 1bcf: c7 06 ea 17 60 00
loc_1bd5:
    mov byte [alley_projectile_age], 1                                          ; 1bd5: c6 06 e9 17 01
loc_1bda:
    mov byte [player_support_kind], 0                                           ; 1bda: c6 06 5c 05 00
loc_1bdf:
    stc                                                                         ; 1bdf: f9
loc_1be0:
    ret                                                                         ; 1be0: c3
loc_1be1:
    clc                                                                         ; 1be1: f8
loc_1be2:
    ret                                                                         ; 1be2: c3
    times 13 db 0 ; original zero fill at CS:1be3
