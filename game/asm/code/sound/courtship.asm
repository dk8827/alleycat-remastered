; Courtship melody and associated effect helpers.
; Original CS:5B54..5C60 (end exclusive).

; CS:5b54 — initialize_courtship_melody
; Clears the courtship melody byte offset and records the BIOS tick.
initialize_courtship_melody:
    mov word [courtship_melody_byte_offset], 0                                  ; 5b54: c7 06 be 59 00 00
loc_5b5a:
    load8 sub, ah, ah                                                           ; 5b5a: 2a e4
loc_5b5c:
    int 0x1a                                                                    ; 5b5c: cd 1a
loc_5b5e:
    mov word [courtship_melody_last_tick], dx                                   ; 5b5e: 89 16 c0 59
loc_5b62:
    ret                                                                         ; 5b62: c3
; CS:5b63 — update_courtship_melody
; Every two elapsed BIOS ticks reads one of 67 divisor words, wraps the byte offset at 134, and inserts a rest when the divisor equals the previous word.
update_courtship_melody:
    cmp byte [sound_enabled], strict byte 0                                     ; 5b63: 80 3e 00 00 00
loc_5b68:
    je loc_5b79                                                                 ; 5b68: 74 0f
loc_5b6a:
    load8 sub, ah, ah                                                           ; 5b6a: 2a e4
loc_5b6c:
    int 0x1a                                                                    ; 5b6c: cd 1a
loc_5b6e:
    load16 mov, ax, dx                                                          ; 5b6e: 8b c2
loc_5b70:
    sub ax, word [courtship_melody_last_tick]                                   ; 5b70: 2b 06 c0 59
loc_5b74:
    cmp ax, strict word 2                                                       ; 5b74: 3d 02 00
loc_5b77:
    jae loc_5b7a                                                                ; 5b77: 73 01
loc_5b79:
    ret                                                                         ; 5b79: c3
loc_5b7a:
    mov word [courtship_melody_last_tick], dx                                   ; 5b7a: 89 16 c0 59
loc_5b7e:
    mov bx, word [courtship_melody_byte_offset]                                 ; 5b7e: 8b 1e be 59
loc_5b82:
    and bx, strict word 0xfe                                                    ; 5b82: 81 e3 fe 00
loc_5b86:
    cmp bx, strict word 0x86                                                    ; 5b86: 81 fb 86 00
loc_5b8a:
    jb loc_5b92                                                                 ; 5b8a: 72 06
loc_5b8c:
    load16 sub, bx, bx                                                          ; 5b8c: 2b db
loc_5b8e:
    mov word [courtship_melody_byte_offset], bx                                 ; 5b8e: 89 1e be 59
loc_5b92:
    add word [courtship_melody_byte_offset], strict byte 2                      ; 5b92: 83 06 be 59 02
loc_5b97:
    mov ax, word [bx + courtship_melody_divisors]                               ; 5b97: 8b 87 34 59
loc_5b9b:
    mov cx, word [courtship_previous_divisor]                                   ; 5b9b: 8b 0e bc 59
loc_5b9f:
    mov word [courtship_previous_divisor], ax                                   ; 5b9f: a3 bc 59
loc_5ba2:
    load16 cmp, ax, cx                                                          ; 5ba2: 3b c1
loc_5ba4:
    jne loc_5baa                                                                ; 5ba4: 75 04
loc_5ba6:
    call near disable_speaker                                                   ; 5ba6: e8 78 ff
loc_5ba9:
    ret                                                                         ; 5ba9: c3
loc_5baa:
    load16 mov, cx, ax                                                          ; 5baa: 8b c8
loc_5bac:
    mov al, 0xb6                                                                ; 5bac: b0 b6
loc_5bae:
    out 0x43, al                                                                ; 5bae: e6 43
loc_5bb0:
    load16 mov, ax, cx                                                          ; 5bb0: 8b c1
loc_5bb2:
    out 0x42, al                                                                ; 5bb2: e6 42
loc_5bb4:
    load8 mov, al, ah                                                           ; 5bb4: 8a c4
loc_5bb6:
    out 0x42, al                                                                ; 5bb6: e6 42
loc_5bb8:
    in al, 0x61                                                                 ; 5bb8: e4 61
loc_5bba:
    or al, 3                                                                    ; 5bba: 0c 03
loc_5bbc:
    out 0x61, al                                                                ; 5bbc: e6 61
loc_5bbe:
    ret                                                                         ; 5bbe: c3
loc_5bbf:
    cmp byte [sound_enabled], strict byte 0                                     ; 5bbf: 80 3e 00 00 00
loc_5bc4:
    je loc_5bd0                                                                 ; 5bc4: 74 0a
loc_5bc6:
    call near update_courtship_melody                                           ; 5bc6: e8 9a ff
loc_5bc9:
    cmp word [courtship_melody_byte_offset], strict byte 0x7c                   ; 5bc9: 83 3e be 59 7c
loc_5bce:
    jb loc_5bbf                                                                 ; 5bce: 72 ef
loc_5bd0:
    ret                                                                         ; 5bd0: c3
    times 15 db 0 ; original zero fill at CS:5bd1
loc_5be0:
    load8 sub, ah, ah                                                           ; 5be0: 2a e4
loc_5be2:
    int 0x1a                                                                    ; 5be2: cd 1a
loc_5be4:
    mov word [0x5f66], dx                                                       ; 5be4: 89 16 66 5f
loc_5be8:
    mov word [0x5f60], 0                                                        ; 5be8: c7 06 60 5f 00 00
loc_5bee:
    mov ax, 0xb800                                                              ; 5bee: b8 00 b8
loc_5bf1:
    mov es, ax                                                                  ; 5bf1: 8e c0
loc_5bf3:
    mov bx, word [0x5f60]                                                       ; 5bf3: 8b 1e 60 5f
loc_5bf7:
    add word [0x5f60], strict byte 2                                            ; 5bf7: 83 06 60 5f 02
loc_5bfc:
    and bx, strict word 2                                                       ; 5bfc: 81 e3 02 00
loc_5c00:
    mov si, word [bx + 0x5f62]                                                  ; 5c00: 8b b7 62 5f
loc_5c04:
    mov di, 0xa74                                                               ; 5c04: bf 74 0a
loc_5c07:
    mov cx, 0x4404                                                              ; 5c07: b9 04 44
loc_5c0a:
    call near copy_rectangle_to_cga                                             ; 5c0a: e8 90 d1
loc_5c0d:
    call near update_result_melody                                              ; 5c0d: e8 d4 fb
loc_5c10:
    load8 sub, ah, ah                                                           ; 5c10: 2a e4
loc_5c12:
    int 0x1a                                                                    ; 5c12: cd 1a
loc_5c14:
    load16 mov, ax, dx                                                          ; 5c14: 8b c2
loc_5c16:
    sub ax, word [0x5f66]                                                       ; 5c16: 2b 06 66 5f
loc_5c1a:
    cmp ax, strict word 4                                                       ; 5c1a: 3d 04 00
loc_5c1d:
    jb loc_5c0d                                                                 ; 5c1d: 72 ee
loc_5c1f:
    mov word [0x5f66], dx                                                       ; 5c1f: 89 16 66 5f
loc_5c23:
    cmp word [0x5f60], strict byte 4                                            ; 5c23: 83 3e 60 5f 04
loc_5c28:
    jne loc_5c36                                                                ; 5c28: 75 0c
loc_5c2a:
    mov si, 0x5f68                                                              ; 5c2a: be 68 5f
loc_5c2d:
    mov di, 0x668                                                               ; 5c2d: bf 68 06
loc_5c30:
    mov cx, 0x1004                                                              ; 5c30: b9 04 10
loc_5c33:
    call near copy_rectangle_to_cga                                             ; 5c33: e8 67 d1
loc_5c36:
    mov bx, word [0x5f60]                                                       ; 5c36: 8b 1e 60 5f
loc_5c3a:
    sub bx, strict byte 8                                                       ; 5c3a: 83 eb 08
loc_5c3d:
    jb loc_5c51                                                                 ; 5c3d: 72 12
loc_5c3f:
    cmp bx, strict byte 6                                                       ; 5c3f: 83 fb 06
loc_5c42:
    jae loc_5c51                                                                ; 5c42: 73 0d
loc_5c44:
    mov si, 0x5fe8                                                              ; 5c44: be e8 5f
loc_5c47:
    mov di, word [bx + 0x60e4]                                                  ; 5c47: 8b bf e4 60
loc_5c4b:
    mov cx, 0x1506                                                              ; 5c4b: b9 06 15
loc_5c4e:
    call near copy_rectangle_to_cga                                             ; 5c4e: e8 4c d1
loc_5c51:
    cmp word [0x5f60], strict byte 0x10                                         ; 5c51: 83 3e 60 5f 10
loc_5c56:
    jb loc_5bee                                                                 ; 5c56: 72 96
loc_5c58:
    call near disable_speaker                                                   ; 5c58: e8 c6 fe
loc_5c5b:
    ret                                                                         ; 5c5b: c3
    times 4 db 0 ; original zero fill at CS:5c5c
