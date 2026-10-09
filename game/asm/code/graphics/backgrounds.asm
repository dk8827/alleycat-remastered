; Scene backgrounds, tiles and status area.
; Original CS:2790..2CB0 (end exclusive).

; CS:2790 — draw_scene_background
; Dispatches background drawing by scene index; also initializes scene-specific object state on some branches.
draw_scene_background:
    mov ax, 0xb800                                                              ; 2790: b8 00 b8
loc_2793:
    mov es, ax                                                                  ; 2793: 8e c0
loc_2795:
    cmp word [scene_index], strict byte 2                                       ; 2795: 83 3e 04 00 02
loc_279a:
    jne loc_27ee                                                                ; 279a: 75 52
loc_279c:
    cld                                                                         ; 279c: fc
loc_279d:
    load16 sub, di, di                                                          ; 279d: 2b ff
loc_279f:
    mov ax, 0xaaaa                                                              ; 279f: b8 aa aa
loc_27a2:
    mov cx, 0x50                                                                ; 27a2: b9 50 00
loc_27a5:
    rep stosw                                                                   ; 27a5: f3 ab
loc_27a7:
    mov di, 0x2000                                                              ; 27a7: bf 00 20
loc_27aa:
    mov cx, 0x50                                                                ; 27aa: b9 50 00
loc_27ad:
    rep stosw                                                                   ; 27ad: f3 ab
loc_27af:
    mov word [0x2654], 0                                                        ; 27af: c7 06 54 26 00 00
loc_27b5:
    call near update_random_state                                               ; 27b5: e8 45 06
loc_27b8:
    and dx, strict word 0x18                                                    ; 27b8: 81 e2 18 00
loc_27bc:
    cmp dl, byte [0x2653]                                                       ; 27bc: 3a 16 53 26
loc_27c0:
    je loc_27b5                                                                 ; 27c0: 74 f3
loc_27c2:
    mov byte [0x2653], dl                                                       ; 27c2: 88 16 53 26
loc_27c6:
    mov bx, word [0x2654]                                                       ; 27c6: 8b 1e 54 26
loc_27ca:
    mov byte [bx + 0x2656], dl                                                  ; 27ca: 88 97 56 26
loc_27ce:
    add dx, strict word 0x2020                                                  ; 27ce: 81 c2 20 20
loc_27d2:
    load16 mov, si, dx                                                          ; 27d2: 8b f2
loc_27d4:
    load16 mov, di, bx                                                          ; 27d4: 8b fb
loc_27d6:
    shl di, 1                                                                   ; 27d6: d1 e7
loc_27d8:
    add di, strict word 0xa0                                                    ; 27d8: 81 c7 a0 00
loc_27dc:
    mov cx, 0x401                                                               ; 27dc: b9 01 04
loc_27df:
    call near copy_rectangle_to_cga                                             ; 27df: e8 bb 05
loc_27e2:
    inc word [0x2654]                                                           ; 27e2: ff 06 54 26
loc_27e6:
    cmp word [0x2654], strict byte 0x28                                         ; 27e6: 83 3e 54 26 28
loc_27eb:
    jb loc_27b5                                                                 ; 27eb: 72 c8
loc_27ed:
    ret                                                                         ; 27ed: c3
loc_27ee:
    cmp word [scene_index], strict byte 7                                       ; 27ee: 83 3e 04 00 07
loc_27f3:
    jne loc_27f9                                                                ; 27f3: 75 04
loc_27f5:
    call near loc_300f                                                          ; 27f5: e8 17 08
loc_27f8:
    ret                                                                         ; 27f8: c3
loc_27f9:
    cmp word [scene_index], strict byte 6                                       ; 27f9: 83 3e 04 00 06
loc_27fe:
    jne loc_283e                                                                ; 27fe: 75 3e
loc_2800:
    load16 sub, ax, ax                                                          ; 2800: 2b c0
loc_2802:
    call near loc_29a0                                                          ; 2802: e8 9b 01
loc_2805:
    mov bx, 0x2570                                                              ; 2805: bb 70 25
loc_2808:
    mov ax, 0x64a                                                               ; 2808: b8 4a 06
loc_280b:
    call near loc_2b24                                                          ; 280b: e8 16 03
loc_280e:
    mov word [0x2650], 0x48                                                     ; 280e: c7 06 50 26 48 00
loc_2814:
    mov byte [0x2652], 0x38                                                     ; 2814: c6 06 52 26 38
loc_2819:
    mov ax, 0xdd2                                                               ; 2819: b8 d2 0d
loc_281c:
    call near loc_2958                                                          ; 281c: e8 39 01
loc_281f:
    mov ax, 0xdf6                                                               ; 281f: b8 f6 0d
loc_2822:
    call near loc_2970                                                          ; 2822: e8 4b 01
loc_2825:
    mov si, 0x1fa0                                                              ; 2825: be a0 1f
loc_2828:
    mov di, 0x67e                                                               ; 2828: bf 7e 06
loc_282b:
    mov cx, 0x1002                                                              ; 282b: b9 02 10
loc_282e:
    call near copy_rectangle_to_cga                                             ; 282e: e8 6c 05
loc_2831:
    mov bx, 0x2344                                                              ; 2831: bb 44 23
loc_2834:
    mov ax, 0xb84                                                               ; 2834: b8 84 0b
loc_2837:
    call near loc_2b24                                                          ; 2837: e8 ea 02
loc_283a:
    call near initialize_food_and_dogs                                          ; 283a: e8 0a 23
loc_283d:
    ret                                                                         ; 283d: c3
loc_283e:
    cmp word [scene_index], strict byte 5                                       ; 283e: 83 3e 04 00 05
loc_2843:
    jne loc_288d                                                                ; 2843: 75 48
loc_2845:
    mov ax, 0x640                                                               ; 2845: b8 40 06
loc_2848:
    call near loc_29a0                                                          ; 2848: e8 55 01
loc_284b:
    mov bx, 0x2570                                                              ; 284b: bb 70 25
loc_284e:
    mov ax, 0xcb6                                                               ; 284e: b8 b6 0c
loc_2851:
    call near loc_2b24                                                          ; 2851: e8 d0 02
loc_2854:
    mov word [0x2650], 0xf8                                                     ; 2854: c7 06 50 26 f8 00
loc_285a:
    mov byte [0x2652], 0x60                                                     ; 285a: c6 06 52 26 60
loc_285f:
    mov ax, 0x140e                                                              ; 285f: b8 0e 14
loc_2862:
    call near loc_2958                                                          ; 2862: e8 f3 00
loc_2865:
    mov ax, 0x1434                                                              ; 2865: b8 34 14
loc_2868:
    call near loc_2970                                                          ; 2868: e8 05 01
loc_286b:
    mov ax, 0x143e                                                              ; 286b: b8 3e 14
loc_286e:
    call near loc_2970                                                          ; 286e: e8 ff 00
loc_2871:
    mov ax, 0x16a0                                                              ; 2871: b8 a0 16
loc_2874:
    call near loc_2988                                                          ; 2874: e8 11 01
loc_2877:
    mov bx, 0x2344                                                              ; 2877: bb 44 23
loc_287a:
    mov ax, 0x1184                                                              ; 287a: b8 84 11
loc_287d:
    call near loc_2b24                                                          ; 287d: e8 a4 02
loc_2880:
    mov si, 0x1fe0                                                              ; 2880: be e0 1f
loc_2883:
    mov di, 0xdd6                                                               ; 2883: bf d6 0d
loc_2886:
    mov cx, 0x1002                                                              ; 2886: b9 02 10
loc_2889:
    call near copy_rectangle_to_cga                                             ; 2889: e8 11 05
loc_288c:
    ret                                                                         ; 288c: c3
loc_288d:
    cmp word [scene_index], strict byte 4                                       ; 288d: 83 3e 04 00 04
loc_2892:
    jne loc_28be                                                                ; 2892: 75 2a
loc_2894:
    mov ax, 0x640                                                               ; 2894: b8 40 06
loc_2897:
    call near loc_29a0                                                          ; 2897: e8 06 01
loc_289a:
    mov bx, 0x2570                                                              ; 289a: bb 70 25
loc_289d:
    mov ax, 0xcba                                                               ; 289d: b8 ba 0c
loc_28a0:
    call near loc_2b24                                                          ; 28a0: e8 81 02
loc_28a3:
    mov word [0x2650], 0x108                                                    ; 28a3: c7 06 50 26 08 01
loc_28a9:
    mov byte [0x2652], 0x60                                                     ; 28a9: c6 06 52 26 60
loc_28ae:
    mov ax, 0x1439                                                              ; 28ae: b8 39 14
loc_28b1:
    call near loc_2958                                                          ; 28b1: e8 a4 00
loc_28b4:
    mov ax, 0x16c0                                                              ; 28b4: b8 c0 16
loc_28b7:
    call near loc_2945                                                          ; 28b7: e8 8b 00
loc_28ba:
    call near loc_3f9e                                                          ; 28ba: e8 e1 16
loc_28bd:
    ret                                                                         ; 28bd: c3
loc_28be:
    cmp word [scene_index], strict byte 3                                       ; 28be: 83 3e 04 00 03
loc_28c3:
    jne loc_2909                                                                ; 28c3: 75 44
loc_28c5:
    mov ax, 0x640                                                               ; 28c5: b8 40 06
loc_28c8:
    call near loc_29a0                                                          ; 28c8: e8 d5 00
loc_28cb:
    mov bx, 0x2570                                                              ; 28cb: bb 70 25
loc_28ce:
    mov ax, 0xc90                                                               ; 28ce: b8 90 0c
loc_28d1:
    call near loc_2b24                                                          ; 28d1: e8 50 02
loc_28d4:
    mov word [0x2650], 0x60                                                     ; 28d4: c7 06 50 26 60 00
loc_28da:
    mov byte [0x2652], 0x60                                                     ; 28da: c6 06 52 26 60
loc_28df:
    mov ax, 0x140c                                                              ; 28df: b8 0c 14
loc_28e2:
    call near loc_2958                                                          ; 28e2: e8 73 00
loc_28e5:
    mov ax, 0x1418                                                              ; 28e5: b8 18 14
loc_28e8:
    call near loc_2970                                                          ; 28e8: e8 85 00
loc_28eb:
    mov bx, 0x2344                                                              ; 28eb: bb 44 23
loc_28ee:
    mov ax, 0x1184                                                              ; 28ee: b8 84 11
loc_28f1:
    call near loc_2b24                                                          ; 28f1: e8 30 02
loc_28f4:
    mov bx, 0x2344                                                              ; 28f4: bb 44 23
loc_28f7:
    mov ax, 0x11a2                                                              ; 28f7: b8 a2 11
loc_28fa:
    call near loc_2b24                                                          ; 28fa: e8 27 02
loc_28fd:
    mov bx, 0x2624                                                              ; 28fd: bb 24 26
loc_2900:
    load16 sub, ax, ax                                                          ; 2900: 2b c0
loc_2902:
    call near loc_2b24                                                          ; 2902: e8 1f 02
loc_2905:
    call near loc_3bdb                                                          ; 2905: e8 d3 12
loc_2908:
    ret                                                                         ; 2908: c3
loc_2909:
    mov ax, 0x640                                                               ; 2909: b8 40 06
loc_290c:
    call near loc_29a0                                                          ; 290c: e8 91 00
loc_290f:
    mov bx, 0x2570                                                              ; 290f: bb 70 25
loc_2912:
    mov ax, 0xca0                                                               ; 2912: b8 a0 0c
loc_2915:
    call near loc_2b24                                                          ; 2915: e8 0c 02
loc_2918:
    mov word [0x2650], 0xa0                                                     ; 2918: c7 06 50 26 a0 00
loc_291e:
    mov byte [0x2652], 0x60                                                     ; 291e: c6 06 52 26 60
loc_2923:
    mov ax, 0x1406                                                              ; 2923: b8 06 14
loc_2926:
    call near loc_2958                                                          ; 2926: e8 2f 00
loc_2929:
    mov bx, 0x2344                                                              ; 2929: bb 44 23
loc_292c:
    mov ax, 0x11c4                                                              ; 292c: b8 c4 11
loc_292f:
    call near loc_2b24                                                          ; 292f: e8 f2 01
loc_2932:
    mov ax, 0x1422                                                              ; 2932: b8 22 14
loc_2935:
    call near loc_2970                                                          ; 2935: e8 38 00
loc_2938:
    mov ax, 0x1690                                                              ; 2938: b8 90 16
loc_293b:
    call near loc_2988                                                          ; 293b: e8 4a 00
loc_293e:
    mov ax, 0x16b6                                                              ; 293e: b8 b6 16
loc_2941:
    call near loc_2945                                                          ; 2941: e8 01 00
loc_2944:
    ret                                                                         ; 2944: c3
loc_2945:
    mov word [0x2634], ax                                                       ; 2945: a3 34 26
loc_2948:
    mov bx, 0x2384                                                              ; 2948: bb 84 23
loc_294b:
    call near loc_2b24                                                          ; 294b: e8 d6 01
loc_294e:
    mov ax, word [0x2634]                                                       ; 294e: a1 34 26
loc_2951:
    mov bx, 0x238c                                                              ; 2951: bb 8c 23
loc_2954:
    call near loc_2b24                                                          ; 2954: e8 cd 01
loc_2957:
    ret                                                                         ; 2957: c3
loc_2958:
    mov word [0x2634], ax                                                       ; 2958: a3 34 26
loc_295b:
    mov si, 8                                                                   ; 295b: be 08 00
loc_295e:
    mov ax, word [0x2634]                                                       ; 295e: a1 34 26
loc_2961:
    mov bx, word [si + 0x2634]                                                  ; 2961: 8b 9c 34 26
loc_2965:
    push si                                                                     ; 2965: 56
loc_2966:
    call near loc_2b24                                                          ; 2966: e8 bb 01
loc_2969:
    pop si                                                                      ; 2969: 5e
loc_296a:
    sub si, strict byte 2                                                       ; 296a: 83 ee 02
loc_296d:
    jne loc_295e                                                                ; 296d: 75 ef
loc_296f:
    ret                                                                         ; 296f: c3
loc_2970:
    mov word [0x2634], ax                                                       ; 2970: a3 34 26
loc_2973:
    mov si, 0xa                                                                 ; 2973: be 0a 00
loc_2976:
    mov ax, word [0x2634]                                                       ; 2976: a1 34 26
loc_2979:
    mov bx, word [si + 0x263c]                                                  ; 2979: 8b 9c 3c 26
loc_297d:
    push si                                                                     ; 297d: 56
loc_297e:
    call near loc_2b24                                                          ; 297e: e8 a3 01
loc_2981:
    pop si                                                                      ; 2981: 5e
loc_2982:
    sub si, strict byte 2                                                       ; 2982: 83 ee 02
loc_2985:
    jne loc_2976                                                                ; 2985: 75 ef
loc_2987:
    ret                                                                         ; 2987: c3
loc_2988:
    mov word [0x2634], ax                                                       ; 2988: a3 34 26
loc_298b:
    mov si, 8                                                                   ; 298b: be 08 00
loc_298e:
    mov ax, word [0x2634]                                                       ; 298e: a1 34 26
loc_2991:
    mov bx, word [si + 0x2646]                                                  ; 2991: 8b 9c 46 26
loc_2995:
    push si                                                                     ; 2995: 56
loc_2996:
    call near loc_2b24                                                          ; 2996: e8 8b 01
loc_2999:
    pop si                                                                      ; 2999: 5e
loc_299a:
    sub si, strict byte 2                                                       ; 299a: 83 ee 02
loc_299d:
    jne loc_298e                                                                ; 299d: 75 ef
loc_299f:
    ret                                                                         ; 299f: c3
loc_29a0:
    mov word [0x267e], ax                                                       ; 29a0: a3 7e 26
loc_29a3:
    mov bx, 0x251c                                                              ; 29a3: bb 1c 25
loc_29a6:
    call near loc_2b24                                                          ; 29a6: e8 7b 01
loc_29a9:
    load16 sub, ax, ax                                                          ; 29a9: 2b c0
loc_29ab:
    cld                                                                         ; 29ab: fc
loc_29ac:
    mov di, word [0x267e]                                                       ; 29ac: 8b 3e 7e 26
loc_29b0:
    add di, strict word 0x284                                                   ; 29b0: 81 c7 84 02
loc_29b4:
    mov cx, 0x24                                                                ; 29b4: b9 24 00
loc_29b7:
    rep stosw                                                                   ; 29b7: f3 ab
loc_29b9:
    mov di, word [0x267e]                                                       ; 29b9: 8b 3e 7e 26
loc_29bd:
    add di, strict word 0x1184                                                  ; 29bd: 81 c7 84 11
loc_29c1:
    mov cx, 0x24                                                                ; 29c1: b9 24 00
loc_29c4:
    rep stosw                                                                   ; 29c4: f3 ab
loc_29c6:
    mov di, word [0x267e]                                                       ; 29c6: 8b 3e 7e 26
loc_29ca:
    add di, strict word 0x2284                                                  ; 29ca: 81 c7 84 22
loc_29ce:
    mov al, 0x2a                                                                ; 29ce: b0 2a
loc_29d0:
    call near loc_29e1                                                          ; 29d0: e8 0e 00
loc_29d3:
    mov di, word [0x267e]                                                       ; 29d3: 8b 3e 7e 26
loc_29d7:
    add di, strict word 0x22cb                                                  ; 29d7: 81 c7 cb 22
loc_29db:
    mov al, 0xa8                                                                ; 29db: b0 a8
loc_29dd:
    call near loc_29e1                                                          ; 29dd: e8 01 00
loc_29e0:
    ret                                                                         ; 29e0: c3
loc_29e1:
    mov cx, 0x5f                                                                ; 29e1: b9 5f 00
loc_29e4:
    mov byte [es:di], al                                                        ; 29e4: 26 88 05
loc_29e7:
    xor di, strict word 0x2000                                                  ; 29e7: 81 f7 00 20
loc_29eb:
    test di, 0x2000                                                             ; 29eb: f7 c7 00 20
loc_29ef:
    jne loc_29f4                                                                ; 29ef: 75 03
loc_29f1:
    add di, strict byte 0x50                                                    ; 29f1: 83 c7 50
loc_29f4:
    loop loc_29e4                                                               ; 29f4: e2 ee
loc_29f6:
    ret                                                                         ; 29f6: c3
    times 9 db 0 ; original zero fill at CS:29f7
; CS:2a00 — draw_alley_background_and_status
; Fills CGA with AAAA, draws the alley and status decorations; more than a screen clear.
draw_alley_background_and_status:
    mov ax, 0xb800                                                              ; 2a00: b8 00 b8
loc_2a03:
    mov es, ax                                                                  ; 2a03: 8e c0
loc_2a05:
    cld                                                                         ; 2a05: fc
loc_2a06:
    load16 sub, di, di                                                          ; 2a06: 2b ff
loc_2a08:
    mov ax, 0xaaaa                                                              ; 2a08: b8 aa aa
loc_2a0b:
    mov cx, 0xfa0                                                               ; 2a0b: b9 a0 0f
loc_2a0e:
    rep stosw                                                                   ; 2a0e: f3 ab
loc_2a10:
    mov di, 0x2000                                                              ; 2a10: bf 00 20
loc_2a13:
    mov cx, 0xfa0                                                               ; 2a13: b9 a0 0f
loc_2a16:
    rep stosw                                                                   ; 2a16: f3 ab
loc_2a18:
    call near loc_2b9e                                                          ; 2a18: e8 83 01
loc_2a1b:
    mov bx, 0x28a0                                                              ; 2a1b: bb a0 28
loc_2a1e:
    load16 sub, ax, ax                                                          ; 2a1e: 2b c0
loc_2a20:
    call near loc_2b24                                                          ; 2a20: e8 01 01
loc_2a23:
    call near loc_2a68                                                          ; 2a23: e8 42 00
loc_2a26:
    call near loc_2c84                                                          ; 2a26: e8 5b 02
loc_2a29:
    call near loc_2b8b                                                          ; 2a29: e8 5f 01
loc_2a2c:
    call near loc_2a80                                                          ; 2a2c: e8 51 00
loc_2a2f:
    ret                                                                         ; 2a2f: c3
loc_2a30:
    mov ax, 0xb800                                                              ; 2a30: b8 00 b8
loc_2a33:
    mov es, ax                                                                  ; 2a33: 8e c0
loc_2a35:
    cld                                                                         ; 2a35: fc
loc_2a36:
    load16 sub, di, di                                                          ; 2a36: 2b ff
loc_2a38:
    mov ax, 0xaaaa                                                              ; 2a38: b8 aa aa
loc_2a3b:
    mov cx, 0xfa0                                                               ; 2a3b: b9 a0 0f
loc_2a3e:
    rep stosw                                                                   ; 2a3e: f3 ab
loc_2a40:
    mov di, 0x2000                                                              ; 2a40: bf 00 20
loc_2a43:
    mov cx, 0xfa0                                                               ; 2a43: b9 a0 0f
loc_2a46:
    rep stosw                                                                   ; 2a46: f3 ab
loc_2a48:
    call near loc_2b9e                                                          ; 2a48: e8 53 01
loc_2a4b:
    mov bx, 0x28a0                                                              ; 2a4b: bb a0 28
loc_2a4e:
    load16 sub, ax, ax                                                          ; 2a4e: 2b c0
loc_2a50:
    call near loc_2b24                                                          ; 2a50: e8 d1 00
loc_2a53:
    call near loc_2a68                                                          ; 2a53: e8 12 00
loc_2a56:
    mov ax, word [difficulty_level]                                             ; 2a56: a1 08 00
loc_2a59:
    push ax                                                                     ; 2a59: 50
loc_2a5a:
    mov word [difficulty_level], 1                                              ; 2a5a: c7 06 08 00 01 00
loc_2a60:
    call near loc_2c84                                                          ; 2a60: e8 21 02
loc_2a63:
    pop ax                                                                      ; 2a63: 58
loc_2a64:
    mov word [difficulty_level], ax                                             ; 2a64: a3 08 00
loc_2a67:
    ret                                                                         ; 2a67: c3
loc_2a68:
    mov bx, word [selected_difficulty]                                          ; 2a68: 8b 1e f8 6d
loc_2a6c:
    and bx, strict word 3                                                       ; 2a6c: 81 e3 03 00
loc_2a70:
    shl bl, 1                                                                   ; 2a70: d0 e3
loc_2a72:
    mov si, word [bx + 0x2ad1]                                                  ; 2a72: 8b b7 d1 2a
loc_2a76:
    mov di, 0x1902                                                              ; 2a76: bf 02 19
loc_2a79:
    mov cx, 0x801                                                               ; 2a79: b9 01 08
loc_2a7c:
    call near copy_rectangle_to_cga                                             ; 2a7c: e8 1e 03
loc_2a7f:
    ret                                                                         ; 2a7f: c3
loc_2a80:
    mov bx, 0xf                                                                 ; 2a80: bb 0f 00
loc_2a83:
    mov byte [bx + 0x1015], 0                                                   ; 2a83: c6 87 15 10 00
loc_2a88:
    dec bx                                                                      ; 2a88: 4b
loc_2a89:
    jne loc_2a83                                                                ; 2a89: 75 f8
loc_2a8b:
    mov di, 0x140                                                               ; 2a8b: bf 40 01
loc_2a8e:
    mov bh, 0x80                                                                ; 2a8e: b7 80
loc_2a90:
    mov word [0x2aca], 0                                                        ; 2a90: c7 06 ca 2a 00 00
loc_2a96:
    call near loc_2ac6                                                          ; 2a96: e8 2d 00
loc_2a99:
    mov di, 0x640                                                               ; 2a99: bf 40 06
loc_2a9c:
    mov bh, 0x30                                                                ; 2a9c: b7 30
loc_2a9e:
    mov word [0x2aca], 5                                                        ; 2a9e: c7 06 ca 2a 05 00
loc_2aa4:
    call near loc_2ac6                                                          ; 2aa4: e8 1f 00
loc_2aa7:
    mov di, 0xb40                                                               ; 2aa7: bf 40 0b
loc_2aaa:
    mov bh, 0                                                                   ; 2aaa: b7 00
loc_2aac:
    mov word [0x2aca], 0xa                                                      ; 2aac: c7 06 ca 2a 0a 00
loc_2ab2:
    call near loc_2ac6                                                          ; 2ab2: e8 11 00
loc_2ab5:
    mov byte [window_scroll_phase], 0x10                                        ; 2ab5: c6 06 25 05 10
loc_2aba:
    mov word [moving_window_row], 0                                             ; 2aba: c7 06 2f 05 00 00
loc_2ac0:
    mov byte [0x531], 1                                                         ; 2ac0: c6 06 31 05 01
loc_2ac5:
    ret                                                                         ; 2ac5: c3
loc_2ac6:
    mov byte [0x2ac9], bh                                                       ; 2ac6: 88 3e c9 2a
loc_2aca:
    mov byte [0x2ac4], 0                                                        ; 2aca: c6 06 c4 2a 00
loc_2acf:
    push di                                                                     ; 2acf: 57
loc_2ad0:
    push es                                                                     ; 2ad0: 06
loc_2ad1:
    mov bx, word [difficulty_level]                                             ; 2ad1: 8b 1e 08 00
loc_2ad5:
    mov bl, byte [bx + 0x2aba]                                                  ; 2ad5: 8a 9f ba 2a
loc_2ad9:
    mov bh, byte [0x2ac9]                                                       ; 2ad9: 8a 3e c9 2a
loc_2add:
    mov ax, DATA_PARAGRAPH                                                      ; 2add: b8 10 00
loc_2ae0:
    mov es, ax                                                                  ; 2ae0: 8e c0
loc_2ae2:
    mov di, 0x4d7                                                               ; 2ae2: bf d7 04
loc_2ae5:
    call near generate_window_strip_column                                      ; 2ae5: e8 95 db
loc_2ae8:
    pop es                                                                      ; 2ae8: 07
loc_2ae9:
    pop di                                                                      ; 2ae9: 5f
loc_2aea:
    push di                                                                     ; 2aea: 57
loc_2aeb:
    mov si, 0x4d7                                                               ; 2aeb: be d7 04
loc_2aee:
    mov cx, 0x1002                                                              ; 2aee: b9 02 10
loc_2af1:
    call near copy_rectangle_to_cga                                             ; 2af1: e8 a9 02
loc_2af4:
    load8 sub, bh, bh                                                           ; 2af4: 2a ff
loc_2af6:
    mov bl, byte [0x2ac4]                                                       ; 2af6: 8a 1e c4 2a
loc_2afa:
    load8 mov, cl, bl                                                           ; 2afa: 8a cb
loc_2afc:
    shr bl, 1                                                                   ; 2afc: d0 eb
loc_2afe:
    shr bl, 1                                                                   ; 2afe: d0 eb
loc_2b00:
    not cl                                                                      ; 2b00: f6 d1
loc_2b02:
    and cl, strict byte 3                                                       ; 2b02: 80 e1 03
loc_2b05:
    shl cl, 1                                                                   ; 2b05: d0 e1
loc_2b07:
    mov al, byte [0x540]                                                        ; 2b07: a0 40 05
loc_2b0a:
    shl al, cl                                                                  ; 2b0a: d2 e0
loc_2b0c:
    mov si, word [0x2aca]                                                       ; 2b0c: 8b 36 ca 2a
loc_2b10:
    or byte [bx + si + 0x1016], al                                              ; 2b10: 08 80 16 10
loc_2b14:
    pop di                                                                      ; 2b14: 5f
loc_2b15:
    add di, strict byte 4                                                       ; 2b15: 83 c7 04
loc_2b18:
    inc byte [0x2ac4]                                                           ; 2b18: fe 06 c4 2a
loc_2b1c:
    cmp byte [0x2ac4], strict byte 0x14                                         ; 2b1c: 80 3e c4 2a 14
loc_2b21:
    jb loc_2acf                                                                 ; 2b21: 72 ac
loc_2b23:
    ret                                                                         ; 2b23: c3
loc_2b24:
    mov cx, word [bx]                                                           ; 2b24: 8b 0f
loc_2b26:
    mov word [0x2ac7], cx                                                       ; 2b26: 89 0e c7 2a
loc_2b2a:
    mov word [0x2acc], ax                                                       ; 2b2a: a3 cc 2a
loc_2b2d:
    add bx, strict byte 2                                                       ; 2b2d: 83 c3 02
loc_2b30:
    mov si, word [bx]                                                           ; 2b30: 8b 37
loc_2b32:
    cmp si, strict word 0xffff                                                  ; 2b32: 81 fe ff ff
loc_2b36:
    jne loc_2b39                                                                ; 2b36: 75 01
loc_2b38:
    ret                                                                         ; 2b38: c3
loc_2b39:
    mov di, word [bx + 2]                                                       ; 2b39: 8b 7f 02
loc_2b3c:
    add di, word [0x2acc]                                                       ; 2b3c: 03 3e cc 2a
loc_2b40:
    cld                                                                         ; 2b40: fc
loc_2b41:
    mov byte [0x2ad0], ch                                                       ; 2b41: 88 2e d0 2a
loc_2b45:
    load8 sub, ch, ch                                                           ; 2b45: 2a ed
loc_2b47:
    mov word [0x2ace], cx                                                       ; 2b47: 89 0e ce 2a
loc_2b4b:
    mov cx, word [0x2ace]                                                       ; 2b4b: 8b 0e ce 2a
loc_2b4f:
    rep movsb                                                                   ; 2b4f: f3 a4
loc_2b51:
    sub di, word [0x2ace]                                                       ; 2b51: 2b 3e ce 2a
loc_2b55:
    xor di, strict word 0x2000                                                  ; 2b55: 81 f7 00 20
loc_2b59:
    test di, 0x2000                                                             ; 2b59: f7 c7 00 20
loc_2b5d:
    jne loc_2b62                                                                ; 2b5d: 75 03
loc_2b5f:
    add di, strict byte 0x50                                                    ; 2b5f: 83 c7 50
loc_2b62:
    dec byte [0x2ad0]                                                           ; 2b62: fe 0e d0 2a
loc_2b66:
    jne loc_2b4b                                                                ; 2b66: 75 e3
loc_2b68:
    add bx, strict byte 4                                                       ; 2b68: 83 c3 04
loc_2b6b:
    mov cx, word [0x2ac7]                                                       ; 2b6b: 8b 0e c7 2a
loc_2b6f:
    jmp short loc_2b30                                                          ; 2b6f: eb bf
loc_2b71:
    mov byte [0x2ac4], 4                                                        ; 2b71: c6 06 c4 2a 04
loc_2b76:
    mov si, 0x2680                                                              ; 2b76: be 80 26
loc_2b79:
    mov cx, 0x1005                                                              ; 2b79: b9 05 10
loc_2b7c:
    push di                                                                     ; 2b7c: 57
loc_2b7d:
    call near copy_rectangle_to_cga                                             ; 2b7d: e8 1d 02
loc_2b80:
    pop di                                                                      ; 2b80: 5f
loc_2b81:
    add di, strict byte 0x14                                                    ; 2b81: 83 c7 14
loc_2b84:
    dec byte [0x2ac4]                                                           ; 2b84: fe 0e c4 2a
loc_2b88:
    jne loc_2b76                                                                ; 2b88: 75 ec
loc_2b8a:
    ret                                                                         ; 2b8a: c3
loc_2b8b:
    mov di, 0x3c5                                                               ; 2b8b: bf c5 03
loc_2b8e:
    call near loc_2b71                                                          ; 2b8e: e8 e0 ff
loc_2b91:
    mov di, 0x8c5                                                               ; 2b91: bf c5 08
loc_2b94:
    call near loc_2b71                                                          ; 2b94: e8 da ff
loc_2b97:
    mov di, 0xdc5                                                               ; 2b97: bf c5 0d
loc_2b9a:
    call near loc_2b71                                                          ; 2b9a: e8 d4 ff
loc_2b9d:
    ret                                                                         ; 2b9d: c3
loc_2b9e:
    mov word [0x2ac2], 0x103e                                                   ; 2b9e: c7 06 c2 2a 3e 10
loc_2ba4:
    add word [0x2ac2], strict byte 2                                            ; 2ba4: 83 06 c2 2a 02
loc_2ba9:
    mov di, word [0x2ac2]                                                       ; 2ba9: 8b 3e c2 2a
loc_2bad:
    cmp di, strict word 0x1090                                                  ; 2bad: 81 ff 90 10
loc_2bb1:
    jae loc_2bd2                                                                ; 2bb1: 73 1f
loc_2bb3:
    call near update_random_state                                               ; 2bb3: e8 47 02
loc_2bb6:
    and dx, strict word 0x30                                                    ; 2bb6: 81 e2 30 00
loc_2bba:
    cmp dl, byte [0x2ac4]                                                       ; 2bba: 3a 16 c4 2a
loc_2bbe:
    je loc_2bb3                                                                 ; 2bbe: 74 f3
loc_2bc0:
    mov byte [0x2ac4], dl                                                       ; 2bc0: 88 16 c4 2a
loc_2bc4:
    add dx, strict word 0x2904                                                  ; 2bc4: 81 c2 04 29
loc_2bc8:
    load16 mov, si, dx                                                          ; 2bc8: 8b f2
loc_2bca:
    mov cx, 0x801                                                               ; 2bca: b9 01 08
loc_2bcd:
    call near copy_rectangle_to_cga                                             ; 2bcd: e8 cd 01
loc_2bd0:
    jmp short loc_2ba4                                                          ; 2bd0: eb d2
loc_2bd2:
    mov di, 0x1180                                                              ; 2bd2: bf 80 11
loc_2bd5:
    mov ax, 0x5655                                                              ; 2bd5: b8 55 56
loc_2bd8:
    mov cx, 0x500                                                               ; 2bd8: b9 00 05
loc_2bdb:
    cld                                                                         ; 2bdb: fc
loc_2bdc:
    rep stosw                                                                   ; 2bdc: f3 ab
loc_2bde:
    mov di, 0x3180                                                              ; 2bde: bf 80 31
loc_2be1:
    mov cx, 0x500                                                               ; 2be1: b9 00 05
loc_2be4:
    rep stosw                                                                   ; 2be4: f3 ab
loc_2be6:
    mov word [0x2ac2], 0x2944                                                   ; 2be6: c7 06 c2 2a 44 29
loc_2bec:
    mov byte [0x2ac4], 9                                                        ; 2bec: c6 06 c4 2a 09
loc_2bf1:
    call near update_random_state                                               ; 2bf1: e8 09 02
loc_2bf4:
    and dx, strict word 0x776                                                   ; 2bf4: 81 e2 76 07
loc_2bf8:
    add dx, strict word 0x12c0                                                  ; 2bf8: 81 c2 c0 12
loc_2bfc:
    load16 mov, di, dx                                                          ; 2bfc: 8b fa
loc_2bfe:
    mov si, word [0x2ac2]                                                       ; 2bfe: 8b 36 c2 2a
loc_2c02:
    mov cx, 0x501                                                               ; 2c02: b9 01 05
loc_2c05:
    call near copy_rectangle_to_cga                                             ; 2c05: e8 95 01
loc_2c08:
    dec byte [0x2ac4]                                                           ; 2c08: fe 0e c4 2a
loc_2c0c:
    jne loc_2bf1                                                                ; 2c0c: 75 e3
loc_2c0e:
    add word [0x2ac2], strict byte 0xa                                          ; 2c0e: 83 06 c2 2a 0a
loc_2c13:
    cmp word [0x2ac2], strict word 0x296c                                       ; 2c13: 81 3e c2 2a 6c 29
loc_2c19:
    jb loc_2bec                                                                 ; 2c19: 72 d1
loc_2c1b:
    mov byte [0x2ac4], 5                                                        ; 2c1b: c6 06 c4 2a 05
loc_2c20:
    call near update_random_state                                               ; 2c20: e8 da 01
loc_2c23:
    and dx, strict word 0x3e                                                    ; 2c23: 81 e2 3e 00
loc_2c27:
    add dx, strict word 0x3a98                                                  ; 2c27: 81 c2 98 3a
loc_2c2b:
    load16 mov, di, dx                                                          ; 2c2b: 8b fa
loc_2c2d:
    mov si, 0x296c                                                              ; 2c2d: be 6c 29
loc_2c30:
    mov cx, 0x501                                                               ; 2c30: b9 01 05
loc_2c33:
    call near copy_rectangle_to_cga                                             ; 2c33: e8 67 01
loc_2c36:
    dec byte [0x2ac4]                                                           ; 2c36: fe 0e c4 2a
loc_2c3a:
    jne loc_2c20                                                                ; 2c3a: 75 e4
loc_2c3c:
    ret                                                                         ; 2c3c: c3
loc_2c3d:
    mov word [0x2ac2], di                                                       ; 2c3d: 89 3e c2 2a
loc_2c41:
    mov al, 3                                                                   ; 2c41: b0 03
loc_2c43:
    cmp di, strict word 0x1720                                                  ; 2c43: 81 ff 20 17
loc_2c47:
    jb loc_2c4b                                                                 ; 2c47: 72 02
loc_2c49:
    dec al                                                                      ; 2c49: fe c8
loc_2c4b:
    mov byte [0x2ac4], al                                                       ; 2c4b: a2 c4 2a
loc_2c4e:
    add word [0x2ac2], strict word 0x1e0                                        ; 2c4e: 81 06 c2 2a e0 01
loc_2c54:
    mov si, 0x2976                                                              ; 2c54: be 76 29
loc_2c57:
    mov cx, 0xc05                                                               ; 2c57: b9 05 0c
loc_2c5a:
    call near copy_rectangle_to_cga                                             ; 2c5a: e8 40 01
loc_2c5d:
    mov di, word [0x2ac2]                                                       ; 2c5d: 8b 3e c2 2a
loc_2c61:
    add word [0x2ac2], strict word 0x140                                        ; 2c61: 81 06 c2 2a 40 01
loc_2c67:
    mov si, 0x29ee                                                              ; 2c67: be ee 29
loc_2c6a:
    mov cx, 0x804                                                               ; 2c6a: b9 04 08
loc_2c6d:
    call near copy_rectangle_to_cga                                             ; 2c6d: e8 2d 01
loc_2c70:
    dec byte [0x2ac4]                                                           ; 2c70: fe 0e c4 2a
loc_2c74:
    jne loc_2c5d                                                                ; 2c74: 75 e7
loc_2c76:
    mov di, word [0x2ac2]                                                       ; 2c76: 8b 3e c2 2a
loc_2c7a:
    mov si, 0x2a2e                                                              ; 2c7a: be 2e 2a
loc_2c7d:
    mov cx, 0xb04                                                               ; 2c7d: b9 04 0b
loc_2c80:
    call near copy_rectangle_to_cga                                             ; 2c80: e8 1a 01
loc_2c83:
    ret                                                                         ; 2c83: c3
loc_2c84:
    mov bx, word [difficulty_level]                                             ; 2c84: 8b 1e 08 00
loc_2c88:
    mov bl, byte [bx + 0x2ab2]                                                  ; 2c88: 8a 9f b2 2a
loc_2c8c:
    mov word [0x2ac5], bx                                                       ; 2c8c: 89 1e c5 2a
loc_2c90:
    mov di, word [bx + 0x2a86]                                                  ; 2c90: 8b bf 86 2a
loc_2c94:
    cmp di, strict byte 0                                                       ; 2c94: 83 ff 00
loc_2c97:
    jne loc_2c9a                                                                ; 2c97: 75 01
loc_2c99:
    ret                                                                         ; 2c99: c3
loc_2c9a:
    call near loc_2c3d                                                          ; 2c9a: e8 a0 ff
loc_2c9d:
    mov bx, word [0x2ac5]                                                       ; 2c9d: 8b 1e c5 2a
loc_2ca1:
    add bx, strict byte 2                                                       ; 2ca1: 83 c3 02
loc_2ca4:
    jmp short loc_2c8c                                                          ; 2ca4: eb e6
loc_2ca6:
    ret                                                                         ; 2ca6: c3
    times 9 db 0 ; original zero fill at CS:2ca7
