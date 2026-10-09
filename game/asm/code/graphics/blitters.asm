; CGA addressing, rectangle copies and mask compositing.
; Original CS:2CB0..2DFD (end exclusive).

; CS:2cb0 — calculate_cga_address
; AX = 40*y + (y odd ? 1FD8 : 0) + floor(x/4), for CX=x and DL=y. CL returns 2*(x mod 4). 1FD8 is a numeric correction, not a table pointer.
calculate_cga_address:
    load8 mov, al, dl                                                           ; 2cb0: 8a c2
loc_2cb2:
    mov ah, 0x28                                                                ; 2cb2: b4 28
loc_2cb4:
    mul ah                                                                      ; 2cb4: f6 e4
loc_2cb6:
    test dl, 1                                                                  ; 2cb6: f6 c2 01
loc_2cb9:
    je loc_2cbe                                                                 ; 2cb9: 74 03
loc_2cbb:
    add ax, strict word CGA_ODD_ROW_CORRECTION                                  ; 2cbb: 05 d8 1f
loc_2cbe:
    load16 mov, dx, cx                                                          ; 2cbe: 8b d1
loc_2cc0:
    shr dx, 1                                                                   ; 2cc0: d1 ea
loc_2cc2:
    shr dx, 1                                                                   ; 2cc2: d1 ea
loc_2cc4:
    load16 add, ax, dx                                                          ; 2cc4: 03 c2
loc_2cc6:
    and cl, strict byte 3                                                       ; 2cc6: 80 e1 03
loc_2cc9:
    shl cl, 1                                                                   ; 2cc9: d0 e1
loc_2ccb:
    ret                                                                         ; 2ccb: c3

; CS:2ccc — blit_zero_transparent
; Builds a mask per 2-bit source pixel, saves destination words at DS:BP, then writes (destination AND mask) OR source. Source index zero is transparent.
blit_zero_transparent:
    cld                                                                         ; 2ccc: fc
loc_2ccd:
    mov byte [blit_width_words], cl                                             ; 2ccd: 88 0e e0 2a
loc_2cd1:
    mov byte [blit_height_rows], ch                                             ; 2cd1: 88 2e e2 2a
loc_2cd5:
    load8 sub, ch, ch                                                           ; 2cd5: 2a ed
loc_2cd7:
    mov dx, 0xff0                                                               ; 2cd7: ba f0 0f
loc_2cda:
    mov cl, byte [blit_width_words]                                             ; 2cda: 8a 0e e0 2a
loc_2cde:
    mov dx, 0x30c0                                                              ; 2cde: ba c0 30
loc_2ce1:
    mov bx, word [es:di]                                                        ; 2ce1: 26 8b 1d
loc_2ce4:
    mov word [ds:bp], bx                                                        ; 2ce4: 3e 89 5e 00
loc_2ce8:
    lodsw                                                                       ; 2ce8: ad
loc_2ce9:
    mov word [blit_source_word], ax                                             ; 2ce9: a3 e3 2a
loc_2cec:
    test dl, ah                                                                 ; 2cec: 84 e2
loc_2cee:
    jne loc_2cf2                                                                ; 2cee: 75 02
loc_2cf0:
    load8 or, ah, dl                                                            ; 2cf0: 0a e2
loc_2cf2:
    test dh, ah                                                                 ; 2cf2: 84 e6
loc_2cf4:
    jne loc_2cf8                                                                ; 2cf4: 75 02
loc_2cf6:
    load8 or, ah, dh                                                            ; 2cf6: 0a e6
loc_2cf8:
    test dl, al                                                                 ; 2cf8: 84 c2
loc_2cfa:
    jne loc_2cfe                                                                ; 2cfa: 75 02
loc_2cfc:
    load8 or, al, dl                                                            ; 2cfc: 0a c2
loc_2cfe:
    test dh, al                                                                 ; 2cfe: 84 c6
loc_2d00:
    jne loc_2d04                                                                ; 2d00: 75 02
loc_2d02:
    load8 or, al, dh                                                            ; 2d02: 0a c6
loc_2d04:
    xor dx, strict word 0x33cc                                                  ; 2d04: 81 f2 cc 33
loc_2d08:
    test dh, 3                                                                  ; 2d08: f6 c6 03
loc_2d0b:
    jne loc_2cec                                                                ; 2d0b: 75 df
loc_2d0d:
    load16 and, ax, bx                                                          ; 2d0d: 23 c3
loc_2d0f:
    or ax, word [blit_source_word]                                              ; 2d0f: 0b 06 e3 2a
loc_2d13:
    stosw                                                                       ; 2d13: ab
loc_2d14:
    add bp, strict byte 2                                                       ; 2d14: 83 c5 02
loc_2d17:
    loop loc_2cde                                                               ; 2d17: e2 c5
loc_2d19:
    sub di, word [blit_width_words]                                             ; 2d19: 2b 3e e0 2a
loc_2d1d:
    sub di, word [blit_width_words]                                             ; 2d1d: 2b 3e e0 2a
loc_2d21:
    xor di, strict word 0x2000                                                  ; 2d21: 81 f7 00 20
loc_2d25:
    test di, 0x2000                                                             ; 2d25: f7 c7 00 20
loc_2d29:
    jne loc_2d2e                                                                ; 2d29: 75 03
loc_2d2b:
    add di, strict byte 0x50                                                    ; 2d2b: 83 c7 50
loc_2d2e:
    dec byte [blit_height_rows]                                                 ; 2d2e: fe 0e e2 2a
loc_2d32:
    jne loc_2cda                                                                ; 2d32: 75 a6
loc_2d34:
    ret                                                                         ; 2d34: c3

; CS:2d35 — blit_and_mask
; Saves destination words at DS:BP, writes destination AND source to ES:DI, and advances through alternating CGA banks.
blit_and_mask:
    cld                                                                         ; 2d35: fc
loc_2d36:
    mov byte [blit_width_words], cl                                             ; 2d36: 88 0e e0 2a
loc_2d3a:
    mov byte [blit_height_rows], ch                                             ; 2d3a: 88 2e e2 2a
loc_2d3e:
    load8 sub, ch, ch                                                           ; 2d3e: 2a ed
loc_2d40:
    mov cl, byte [blit_width_words]                                             ; 2d40: 8a 0e e0 2a
loc_2d44:
    mov bx, word [es:di]                                                        ; 2d44: 26 8b 1d
loc_2d47:
    mov word [ds:bp], bx                                                        ; 2d47: 3e 89 5e 00
loc_2d4b:
    lodsw                                                                       ; 2d4b: ad
loc_2d4c:
    load16 and, ax, bx                                                          ; 2d4c: 23 c3
loc_2d4e:
    stosw                                                                       ; 2d4e: ab
loc_2d4f:
    add bp, strict byte 2                                                       ; 2d4f: 83 c5 02
loc_2d52:
    loop loc_2d44                                                               ; 2d52: e2 f0
loc_2d54:
    sub di, word [blit_width_words]                                             ; 2d54: 2b 3e e0 2a
loc_2d58:
    sub di, word [blit_width_words]                                             ; 2d58: 2b 3e e0 2a
loc_2d5c:
    xor di, strict word 0x2000                                                  ; 2d5c: 81 f7 00 20
loc_2d60:
    test di, 0x2000                                                             ; 2d60: f7 c7 00 20
loc_2d64:
    jne loc_2d69                                                                ; 2d64: 75 03
loc_2d66:
    add di, strict byte 0x50                                                    ; 2d66: 83 c7 50
loc_2d69:
    dec byte [blit_height_rows]                                                 ; 2d69: fe 0e e2 2a
loc_2d6d:
    jne loc_2d40                                                                ; 2d6d: 75 d1
loc_2d6f:
    ret                                                                         ; 2d6f: c3

; CS:2d70 — copy_rows_with_source_stride
; Copies CL words per row for CH rows. Source starts advance by 2*AL bytes; destination is contiguous.
copy_rows_with_source_stride:
    cld                                                                         ; 2d70: fc
loc_2d71:
    mov word [blit_row_source], si                                              ; 2d71: 89 36 e9 2a
loc_2d75:
    mov byte [blit_width_words], cl                                             ; 2d75: 88 0e e0 2a
loc_2d79:
    mov byte [blit_height_rows], ch                                             ; 2d79: 88 2e e2 2a
loc_2d7d:
    shl al, 1                                                                   ; 2d7d: d0 e0
loc_2d7f:
    mov byte [blit_source_stride_bytes], al                                     ; 2d7f: a2 eb 2a
loc_2d82:
    load8 sub, ch, ch                                                           ; 2d82: 2a ed
loc_2d84:
    mov cl, byte [blit_width_words]                                             ; 2d84: 8a 0e e0 2a
loc_2d88:
    rep movsw                                                                   ; 2d88: f3 a5
loc_2d8a:
    mov cl, byte [blit_source_stride_bytes]                                     ; 2d8a: 8a 0e eb 2a
loc_2d8e:
    add word [blit_row_source], cx                                              ; 2d8e: 01 0e e9 2a
loc_2d92:
    mov si, word [blit_row_source]                                              ; 2d92: 8b 36 e9 2a
loc_2d96:
    dec byte [blit_height_rows]                                                 ; 2d96: fe 0e e2 2a
loc_2d9a:
    jne loc_2d84                                                                ; 2d9a: 75 e8
loc_2d9c:
    ret                                                                         ; 2d9c: c3

; CS:2d9d — copy_rectangle_to_cga
; Copies CL words by CH rows from DS:SI to ES:DI; toggles CGA bank bit 13 and advances 80 bytes after the lower-bank transition.
copy_rectangle_to_cga:
    cld                                                                         ; 2d9d: fc
loc_2d9e:
    mov byte [blit_width_words], cl                                             ; 2d9e: 88 0e e0 2a
loc_2da2:
    mov byte [blit_height_rows], ch                                             ; 2da2: 88 2e e2 2a
loc_2da6:
    load8 sub, ch, ch                                                           ; 2da6: 2a ed
loc_2da8:
    mov cl, byte [blit_width_words]                                             ; 2da8: 8a 0e e0 2a
loc_2dac:
    rep movsw                                                                   ; 2dac: f3 a5
loc_2dae:
    sub di, word [blit_width_words]                                             ; 2dae: 2b 3e e0 2a
loc_2db2:
    sub di, word [blit_width_words]                                             ; 2db2: 2b 3e e0 2a
loc_2db6:
    xor di, strict word 0x2000                                                  ; 2db6: 81 f7 00 20
loc_2dba:
    test di, 0x2000                                                             ; 2dba: f7 c7 00 20
loc_2dbe:
    jne loc_2dc3                                                                ; 2dbe: 75 03
loc_2dc0:
    add di, strict byte 0x50                                                    ; 2dc0: 83 c7 50
loc_2dc3:
    dec byte [blit_height_rows]                                                 ; 2dc3: fe 0e e2 2a
loc_2dc7:
    jne loc_2da8                                                                ; 2dc7: 75 df
loc_2dc9:
    ret                                                                         ; 2dc9: c3

; CS:2dca — copy_rectangle_from_cga
; Copies CGA rows from DS:SI into packed ES:DI. Width/height scratch is addressed via ES.
copy_rectangle_from_cga:
    cld                                                                         ; 2dca: fc
loc_2dcb:
    mov byte [es:blit_width_words], cl                                          ; 2dcb: 26 88 0e e0 2a
loc_2dd0:
    mov byte [es:blit_height_rows], ch                                          ; 2dd0: 26 88 2e e2 2a
loc_2dd5:
    load8 sub, ch, ch                                                           ; 2dd5: 2a ed
loc_2dd7:
    mov cl, byte [es:blit_width_words]                                          ; 2dd7: 26 8a 0e e0 2a
loc_2ddc:
    rep movsw                                                                   ; 2ddc: f3 a5
loc_2dde:
    sub si, word [es:blit_width_words]                                          ; 2dde: 26 2b 36 e0 2a
loc_2de3:
    sub si, word [es:blit_width_words]                                          ; 2de3: 26 2b 36 e0 2a
loc_2de8:
    xor si, strict word 0x2000                                                  ; 2de8: 81 f6 00 20
loc_2dec:
    test si, 0x2000                                                             ; 2dec: f7 c6 00 20
loc_2df0:
    jne loc_2df5                                                                ; 2df0: 75 03
loc_2df2:
    add si, strict byte 0x50                                                    ; 2df2: 83 c6 50
loc_2df5:
    dec byte [es:blit_height_rows]                                              ; 2df5: 26 fe 0e e2 2a
loc_2dfa:
    jne loc_2dd7                                                                ; 2dfa: 75 db
loc_2dfc:
    ret                                                                         ; 2dfc: c3
