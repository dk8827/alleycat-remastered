; Lives display and seven-digit score arithmetic.
; Original CS:2690..2790 (end exclusive).

; CS:2690 — update_high_score_if_greater
; Compares seven bytes at 1F82 against 1F89, most significant first; copies 1F82 to 1F89 only when greater.
update_high_score_if_greater:
    push ds                                                                     ; 2690: 1e
loc_2691:
    pop es                                                                      ; 2691: 07
loc_2692:
    mov cx, 7                                                                   ; 2692: b9 07 00
loc_2695:
    mov si, current_score_digits                                                ; 2695: be 82 1f
loc_2698:
    lodsb                                                                       ; 2698: ac
loc_2699:
    mov bx, 7                                                                   ; 2699: bb 07 00
loc_269c:
    load16 sub, bx, cx                                                          ; 269c: 2b d9
loc_269e:
    cmp al, byte [bx + high_score_digits]                                       ; 269e: 3a 87 89 1f
loc_26a2:
    loope loc_2698                                                              ; 26a2: e1 f4
loc_26a4:
    ja loc_26a7                                                                 ; 26a4: 77 01
loc_26a6:
    ret                                                                         ; 26a6: c3
loc_26a7:
    mov si, current_score_digits                                                ; 26a7: be 82 1f
loc_26aa:
    mov di, high_score_digits                                                   ; 26aa: bf 89 1f
loc_26ad:
    mov cx, 7                                                                   ; 26ad: b9 07 00
loc_26b0:
    rep movsb                                                                   ; 26b0: f3 a4
loc_26b2:
    ret                                                                         ; 26b2: c3

; CS:26b3 — draw_lives_if_changed
; Reads 1F80, compares/cache-writes 1F81, uses value*16 + 2720 as an 8x8 glyph, and draws at CGA offset 1260.
draw_lives_if_changed:
    mov al, byte [lives_remaining]                                              ; 26b3: a0 80 1f
loc_26b6:
    cmp al, byte [displayed_lives]                                              ; 26b6: 3a 06 81 1f
loc_26ba:
    jne loc_26bd                                                                ; 26ba: 75 01
loc_26bc:
    ret                                                                         ; 26bc: c3
loc_26bd:
    mov byte [displayed_lives], al                                              ; 26bd: a2 81 1f
loc_26c0:
    load8 sub, ah, ah                                                           ; 26c0: 2a e4
loc_26c2:
    mov cl, 4                                                                   ; 26c2: b1 04
loc_26c4:
    shl ax, cl                                                                  ; 26c4: d3 e0
loc_26c6:
    add ax, strict word decimal_digit_glyphs                                    ; 26c6: 05 20 27
loc_26c9:
    load16 mov, si, ax                                                          ; 26c9: 8b f0
loc_26cb:
    mov ax, 0xb800                                                              ; 26cb: b8 00 b8
loc_26ce:
    mov es, ax                                                                  ; 26ce: 8e c0
loc_26d0:
    mov di, 0x1260                                                              ; 26d0: bf 60 12
loc_26d3:
    mov cx, 0x801                                                               ; 26d3: b9 01 08
loc_26d6:
    call near copy_rectangle_to_cga                                             ; 26d6: e8 c4 06
loc_26d9:
    ret                                                                         ; 26d9: c3

; CS:26da — clear_current_score
; Sets DI=1F82 and clears seven bytes. That buffer is modified by add_score_tens.
clear_current_score:
    mov di, current_score_digits                                                ; 26da: bf 82 1f
loc_26dd:
    call near clear_seven_bytes                                                 ; 26dd: e8 08 00
loc_26e0:
    ret                                                                         ; 26e0: c3

; CS:26e1 — clear_high_score
; Sets DI=1F89 and clears seven bytes. update_high_score_if_greater writes this buffer.
clear_high_score:
    mov di, high_score_digits                                                   ; 26e1: bf 89 1f
loc_26e4:
    call near clear_seven_bytes                                                 ; 26e4: e8 01 00
loc_26e7:
    ret                                                                         ; 26e7: c3

; CS:26e8 — clear_seven_bytes
; Sets ES=DS, CX=7 and AL=0, then REP STOSB at DI. Requires DF clear.
clear_seven_bytes:
    push ds                                                                     ; 26e8: 1e
loc_26e9:
    pop es                                                                      ; 26e9: 07
loc_26ea:
    mov cx, 7                                                                   ; 26ea: b9 07 00
loc_26ed:
    load8 sub, al, al                                                           ; 26ed: 2a c0
loc_26ef:
    rep stosb                                                                   ; 26ef: f3 aa
loc_26f1:
    ret                                                                         ; 26f1: c3

; CS:26f2 — draw_high_score
; Sets BX=1F89 and DI=12CA, then calls the seven-digit renderer. Upstream calls this draw_score; its buffer is the high score.
draw_high_score:
    mov bx, high_score_digits                                                   ; 26f2: bb 89 1f
loc_26f5:
    mov di, 0x12ca                                                              ; 26f5: bf ca 12
loc_26f8:
    call near draw_seven_decimal_digits                                         ; 26f8: e8 3e 00
loc_26fb:
    ret                                                                         ; 26fb: c3

; CS:26fc — draw_current_score
; Sets BX=1F82 and DI=143C, then calls the seven-digit renderer. Upstream calls this draw_high_score.
draw_current_score:
    mov bx, current_score_digits                                                ; 26fc: bb 82 1f
loc_26ff:
    mov di, 0x143c                                                              ; 26ff: bf 3c 14
loc_2702:
    call near draw_seven_decimal_digits                                         ; 2702: e8 34 00
loc_2705:
    ret                                                                         ; 2705: c3

; CS:2706 — add_score_tens
; AAA propagates AL through offsets 1F87 down to 1F82, leaving units byte 1F88 unchanged; then renders current score. Tested with AL=0..9.
add_score_tens:
    mov cx, 6                                                                   ; 2706: b9 06 00
loc_2709:
    load16 mov, bx, cx                                                          ; 2709: 8b d9
loc_270b:
    mov ah, 0                                                                   ; 270b: b4 00
loc_270d:
    add al, byte [bx + current_score_digits - 1]                                ; 270d: 02 87 81 1f
loc_2711:
    aaa                                                                         ; 2711: 37
loc_2712:
    mov byte [bx + current_score_digits - 1], al                                ; 2712: 88 87 81 1f
loc_2716:
    load8 mov, al, ah                                                           ; 2716: 8a c4
loc_2718:
    loop loc_2709                                                               ; 2718: e2 ef
loc_271a:
    call near draw_current_score                                                ; 271a: e8 df ff
loc_271d:
    ret                                                                         ; 271d: c3

; CS:271e — add_seven_decimal_digits
; Adds seven unpacked decimal digits from DS:SI into DS:DI right-to-left using ADC/AAA; preserves AX/BX/CX.
add_seven_decimal_digits:
    push cx                                                                     ; 271e: 51
loc_271f:
    push ax                                                                     ; 271f: 50
loc_2720:
    push bx                                                                     ; 2720: 53
loc_2721:
    clc                                                                         ; 2721: f8
loc_2722:
    pushf                                                                       ; 2722: 9c
loc_2723:
    mov cx, 7                                                                   ; 2723: b9 07 00
loc_2726:
    popf                                                                        ; 2726: 9d
loc_2727:
    load16 mov, bx, cx                                                          ; 2727: 8b d9
loc_2729:
    dec bx                                                                      ; 2729: 4b
loc_272a:
    mov al, byte [bx + di]                                                      ; 272a: 8a 01
loc_272c:
    adc al, byte [bx + si]                                                      ; 272c: 12 00
loc_272e:
    aaa                                                                         ; 272e: 37
loc_272f:
    mov byte [bx + di], al                                                      ; 272f: 88 01
loc_2731:
    pushf                                                                       ; 2731: 9c
loc_2732:
    loop loc_2726                                                               ; 2732: e2 f2
loc_2734:
    popf                                                                        ; 2734: 9d
loc_2735:
    pop bx                                                                      ; 2735: 5b
loc_2736:
    pop ax                                                                      ; 2736: 58
loc_2737:
    pop cx                                                                      ; 2737: 59
loc_2738:
    ret                                                                         ; 2738: c3

; CS:2739 — draw_seven_decimal_digits
; Reads seven digits from DS:BX; each selects an 8x8 glyph at 2720 + digit*16. Adds a two-byte gap after digit three.
draw_seven_decimal_digits:
    mov ax, 0xb800                                                              ; 2739: b8 00 b8
loc_273c:
    mov es, ax                                                                  ; 273c: 8e c0
loc_273e:
    mov word [score_draw_offset], di                                            ; 273e: 89 3e 90 1f
loc_2742:
    mov word [score_digit_pointer], bx                                          ; 2742: 89 1e 93 1f
loc_2746:
    mov byte [score_digit_index], 0                                             ; 2746: c6 06 92 1f 00
loc_274b:
    mov bx, word [score_digit_pointer]                                          ; 274b: 8b 1e 93 1f
loc_274f:
    mov al, byte [bx]                                                           ; 274f: 8a 07
loc_2751:
    load8 sub, ah, ah                                                           ; 2751: 2a e4
loc_2753:
    mov cl, 4                                                                   ; 2753: b1 04
loc_2755:
    shl ax, cl                                                                  ; 2755: d3 e0
loc_2757:
    add ax, strict word decimal_digit_glyphs                                    ; 2757: 05 20 27
loc_275a:
    load16 mov, si, ax                                                          ; 275a: 8b f0
loc_275c:
    mov di, word [score_draw_offset]                                            ; 275c: 8b 3e 90 1f
loc_2760:
    mov cx, 0x801                                                               ; 2760: b9 01 08
loc_2763:
    call near copy_rectangle_to_cga                                             ; 2763: e8 37 06
loc_2766:
    add word [score_draw_offset], strict byte 2                                 ; 2766: 83 06 90 1f 02
loc_276b:
    inc word [score_digit_pointer]                                              ; 276b: ff 06 93 1f
loc_276f:
    inc byte [score_digit_index]                                                ; 276f: fe 06 92 1f
loc_2773:
    cmp byte [score_digit_index], strict byte 7                                 ; 2773: 80 3e 92 1f 07
loc_2778:
    je loc_2788                                                                 ; 2778: 74 0e
loc_277a:
    cmp byte [score_digit_index], strict byte 3                                 ; 277a: 80 3e 92 1f 03
loc_277f:
    jne loc_274b                                                                ; 277f: 75 ca
loc_2781:
    add word [score_draw_offset], strict byte 2                                 ; 2781: 83 06 90 1f 02
loc_2786:
    jmp short loc_274b                                                          ; 2786: eb c3
loc_2788:
    ret                                                                         ; 2788: c3
    times 7 db 0 ; original zero fill at CS:2789
