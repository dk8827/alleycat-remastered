; Fishbowl contact and aquarium entry.
; Original CS:3850..38B0 (end exclusive).

; CS:3850 — update_fishbowl_entry
; Every six BIOS ticks animates the bowl and tests a rectangle at X=228,Y=138; contact sets enter_aquarium_requested.
update_fishbowl_entry:
    load8 sub, ah, ah                                                           ; 3850: 2a e4
loc_3852:
    int 0x1a                                                                    ; 3852: cd 1a
loc_3854:
    load16 mov, ax, dx                                                          ; 3854: 8b c2
loc_3856:
    sub ax, word [0x35da]                                                       ; 3856: 2b 06 da 35
loc_385a:
    cmp ax, strict word 6                                                       ; 385a: 3d 06 00
loc_385d:
    jae loc_3860                                                                ; 385d: 73 01
loc_385f:
    ret                                                                         ; 385f: c3
loc_3860:
    mov word [0x35da], dx                                                       ; 3860: 89 16 da 35
loc_3864:
    add word [0x35d8], strict byte 2                                            ; 3864: 83 06 d8 35 02
loc_3869:
    mov bx, word [0x35d8]                                                       ; 3869: 8b 1e d8 35
loc_386d:
    and bx, strict word 6                                                       ; 386d: 81 e3 06 00
loc_3871:
    mov si, word [bx + 0x35d0]                                                  ; 3871: 8b b7 d0 35
loc_3875:
    mov di, 0x15c9                                                              ; 3875: bf c9 15
loc_3878:
    mov ax, 0xb800                                                              ; 3878: b8 00 b8
loc_387b:
    mov es, ax                                                                  ; 387b: 8e c0
loc_387d:
    mov cx, 0xa02                                                               ; 387d: b9 02 0a
loc_3880:
    call near copy_rectangle_to_cga                                             ; 3880: e8 1a f5
loc_3883:
    mov ax, 0xe4                                                                ; 3883: b8 e4 00
loc_3886:
    mov dl, 0x8a                                                                ; 3886: b2 8a
loc_3888:
    mov si, 0x10                                                                ; 3888: be 10 00
loc_388b:
    mov bx, word [player_x]                                                     ; 388b: 8b 1e 79 05
loc_388f:
    mov dh, byte [player_y]                                                     ; 388f: 8a 36 7b 05
loc_3893:
    mov di, 0x18                                                                ; 3893: bf 18 00
loc_3896:
    mov cx, 0xe0a                                                               ; 3896: b9 0a 0e
loc_3899:
    call near rectangles_overlap                                                ; 3899: e8 8d f5
loc_389c:
    jae loc_38a3                                                                ; 389c: 73 05
loc_389e:
    mov byte [enter_aquarium_requested], 1                                      ; 389e: c6 06 54 05 01
loc_38a3:
    ret                                                                         ; 38a3: c3
    times 12 db 0 ; original zero fill at CS:38a4
