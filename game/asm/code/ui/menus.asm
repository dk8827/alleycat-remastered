; Display validation, title, menu and joystick configuration.
; Original CS:5C60..6100 (end exclusive).

; CS:5c60 — check_color_adapter
; Checks INT 11h equipment bits; on the monochrome-indicated path probes B800:0000. Prints an error and loops forever if the probe fails.
check_color_adapter:
    int 0x11                                                                    ; 5c60: cd 11
loc_5c62:
    and al, 0x30                                                                ; 5c62: 24 30
loc_5c64:
    cmp al, 0x30                                                                ; 5c64: 3c 30
loc_5c66:
    jne loc_5c95                                                                ; 5c66: 75 2d
loc_5c68:
    mov ax, 0xb800                                                              ; 5c68: b8 00 b8
loc_5c6b:
    mov ds, ax                                                                  ; 5c6b: 8e d8
loc_5c6d:
    mov ax, 0x55aa                                                              ; 5c6d: b8 aa 55
loc_5c70:
    mov word [0], ax                                                            ; 5c70: a3 00 00
loc_5c73:
    mov ax, word [0]                                                            ; 5c73: a1 00 00
loc_5c76:
    cmp ax, strict word 0x55aa                                                  ; 5c76: 3d aa 55
loc_5c79:
    jne loc_5c96                                                                ; 5c79: 75 1b
loc_5c7b:
    mov si, 0x60f0                                                              ; 5c7b: be f0 60
loc_5c7e:
    call near print_startup_message                                             ; 5c7e: e8 1d 00
loc_5c81:
    mov ax, 0x40                                                                ; 5c81: b8 40 00
loc_5c84:
    mov ds, ax                                                                  ; 5c84: 8e d8
loc_5c86:
    mov ax, word [0x10]                                                         ; 5c86: a1 10 00
loc_5c89:
    and al, 0xcf                                                                ; 5c89: 24 cf
loc_5c8b:
    or al, 0x10                                                                 ; 5c8b: 0c 10
loc_5c8d:
    mov word [0x10], ax                                                         ; 5c8d: a3 10 00
loc_5c90:
    mov ax, 4                                                                   ; 5c90: b8 04 00
loc_5c93:
    int 0x10                                                                    ; 5c93: cd 10
loc_5c95:
    ret                                                                         ; 5c95: c3
loc_5c96:
    mov si, 0x6112                                                              ; 5c96: be 12 61
loc_5c99:
    call near print_startup_message                                             ; 5c99: e8 02 00
loc_5c9c:
    jmp short loc_5c9c                                                          ; 5c9c: eb fe

; CS:5c9e — print_startup_message
; Loads DS with relocated game-data paragraph and calls the zero-terminated BIOS text printer.
print_startup_message:
    mov ax, DATA_PARAGRAPH                                                      ; 5c9e: b8 10 00
loc_5ca1:
    mov ds, ax                                                                  ; 5ca1: 8e d8
loc_5ca3:
    call near print_zero_terminated_string                                      ; 5ca3: e8 85 01
loc_5ca6:
    ret                                                                         ; 5ca6: c3
    times 9 db 0 ; original zero fill at CS:5ca7

; CS:5cb0 — run_title_screen
; Draws six title-text rectangles from DS:6152..68A8, alternates publisher credits, and updates the title-screen scene while waiting for input.
run_title_screen:
    cld                                                                         ; 5cb0: fc
loc_5cb1:
    mov word [scene_index], 0                                                   ; 5cb1: c7 06 04 00 00 00
loc_5cb7:
    call near reset_alley_window_event                                          ; 5cb7: e8 76 bb
loc_5cba:
    call near initialize_alley_moving_objects                                   ; 5cba: e8 73 c6
loc_5cbd:
    call near loc_2a30                                                          ; 5cbd: e8 70 cd
loc_5cc0:
    mov ax, 0xb800                                                              ; 5cc0: b8 00 b8
loc_5cc3:
    mov es, ax                                                                  ; 5cc3: 8e c0
loc_5cc5:
    mov si, title_ibm_presents                                                  ; 5cc5: be 52 61
loc_5cc8:
    mov cx, 0x1d0b                                                              ; 5cc8: b9 0b 1d
loc_5ccb:
    mov di, 0xbd                                                                ; 5ccb: bf bd 00
loc_5cce:
    call near copy_rectangle_to_cga                                             ; 5cce: e8 cc d0
loc_5cd1:
    mov si, title_alley_cat_logo                                                ; 5cd1: be d0 63
loc_5cd4:
    mov cx, 0x160e                                                              ; 5cd4: b9 0e 16
loc_5cd7:
    mov di, joystick_pending_axes                                               ; 5cd7: bf 9e 06
loc_5cda:
    call near copy_rectangle_to_cga                                             ; 5cda: e8 c0 d0
loc_5cdd:
    mov si, title_by                                                            ; 5cdd: be 38 66
loc_5ce0:
    mov cx, 0xc03                                                               ; 5ce0: b9 03 0c
loc_5ce3:
    mov di, 0xa78                                                               ; 5ce3: bf 78 0a
loc_5ce6:
    call near copy_rectangle_to_cga                                             ; 5ce6: e8 b4 d0
loc_5ce9:
    mov si, title_bill_williams                                                 ; 5ce9: be 80 66
loc_5cec:
    mov cx, 0x80e                                                               ; 5cec: b9 0e 08
loc_5cef:
    mov di, 0xca8                                                               ; 5cef: bf a8 0c
loc_5cf2:
    call near copy_rectangle_to_cga                                             ; 5cf2: e8 a8 d0
loc_5cf5:
    mov si, title_copyright                                                     ; 5cf5: be 60 67
loc_5cf8:
    mov cx, 0xb0c                                                               ; 5cf8: b9 0c 0b
loc_5cfb:
    mov di, 0x1d6e                                                              ; 5cfb: bf 6e 1d
loc_5cfe:
    call near copy_rectangle_to_cga                                             ; 5cfe: e8 9c d0
loc_5d01:
    mov si, title_year_1984                                                     ; 5d01: be 68 68
loc_5d04:
    mov cx, 0x804                                                               ; 5d04: b9 04 08
loc_5d07:
    mov di, 0x1dec                                                              ; 5d07: bf ec 1d
loc_5d0a:
    call near copy_rectangle_to_cga                                             ; 5d0a: e8 90 d0
loc_5d0d:
    mov word [publisher_credit_index], 0                                        ; 5d0d: c7 06 8d 6a 00 00
loc_5d13:
    call near draw_next_publisher_credit                                        ; 5d13: e8 25 01
loc_5d16:
    mov word [player_x], 0                                                      ; 5d16: c7 06 79 05 00 00
loc_5d1c:
    call near initialize_alley_player                                           ; 5d1c: e8 ee a9
loc_5d1f:
    mov byte [player_y], 0x60                                                   ; 5d1f: c6 06 7b 05 60
loc_5d24:
    mov byte [player_y_plus_50], 0x92                                           ; 5d24: c6 06 7c 05 92
loc_5d29:
    call near draw_high_score                                                   ; 5d29: e8 c6 c9
loc_5d2c:
    call near draw_current_score                                                ; 5d2c: e8 cd c9
loc_5d2f:
    mov byte [lives_remaining], 9                                               ; 5d2f: c6 06 80 1f 09
loc_5d34:
    mov byte [displayed_lives], 0xff                                            ; 5d34: c6 06 81 1f ff
loc_5d39:
    call near draw_lives_if_changed                                             ; 5d39: e8 77 c9
loc_5d3c:
    call near initialize_chasing_enemy                                          ; 5d3c: e8 01 c1
loc_5d3f:
    mov byte [input_horizontal], 0                                              ; 5d3f: c6 06 98 06 00
loc_5d44:
    mov byte [input_vertical], 0                                                ; 5d44: c6 06 99 06 00
loc_5d49:
    mov byte [0x6a8a], 0                                                        ; 5d49: c6 06 8a 6a 00
loc_5d4e:
    mov ax, word [keyboard_event_counter]                                       ; 5d4e: a1 93 06
loc_5d51:
    mov word [0x6150], ax                                                       ; 5d51: a3 50 61
loc_5d54:
    load8 sub, ah, ah                                                           ; 5d54: 2a e4
loc_5d56:
    int 0x1a                                                                    ; 5d56: cd 1a
loc_5d58:
    mov word [0x6a8b], dx                                                       ; 5d58: 89 16 8b 6a
loc_5d5c:
    mov word [title_melody_last_tick], dx                                       ; 5d5c: 89 16 22 53
loc_5d60:
    mov word [0x6a93], dx                                                       ; 5d60: 89 16 93 6a
loc_5d64:
    sub dx, strict byte 0x30                                                    ; 5d64: 83 ea 30
loc_5d67:
    mov word [0x6a88], dx                                                       ; 5d67: 89 16 88 6a
loc_5d6b:
    mov word [title_melody_byte_offset], 0                                      ; 5d6b: c7 06 20 53 00 00
loc_5d71:
    load8 sub, ah, ah                                                           ; 5d71: 2a e4
loc_5d73:
    int 0x1a                                                                    ; 5d73: cd 1a
loc_5d75:
    load16 mov, ax, dx                                                          ; 5d75: 8b c2
loc_5d77:
    sub ax, word [0x6a93]                                                       ; 5d77: 2b 06 93 6a
loc_5d7b:
    cmp ax, strict word 0x24                                                    ; 5d7b: 3d 24 00
loc_5d7e:
    jb loc_5d89                                                                 ; 5d7e: 72 09
loc_5d80:
    mov word [0x6a93], dx                                                       ; 5d80: 89 16 93 6a
loc_5d84:
    push dx                                                                     ; 5d84: 52
loc_5d85:
    call near draw_next_publisher_credit                                        ; 5d85: e8 b3 00
loc_5d88:
    pop dx                                                                      ; 5d88: 5a
loc_5d89:
    sub dx, word [0x6a8b]                                                       ; 5d89: 2b 16 8b 6a
loc_5d8d:
    mov ax, word [0x56da]                                                       ; 5d8d: a1 da 56
loc_5d90:
    cmp byte [0x41a], strict byte 0                                             ; 5d90: 80 3e 1a 04 00
loc_5d95:
    je loc_5da0                                                                 ; 5d95: 74 09
loc_5d97:
    add ax, strict word 0x48                                                    ; 5d97: 05 48 00
loc_5d9a:
    load16 cmp, dx, ax                                                          ; 5d9a: 3b d0
loc_5d9c:
    jae loc_5d54                                                                ; 5d9c: 73 b6
loc_5d9e:
    jmp short loc_5da7                                                          ; 5d9e: eb 07
loc_5da0:
    add ax, strict word 6                                                       ; 5da0: 05 06 00
loc_5da3:
    load16 cmp, dx, ax                                                          ; 5da3: 3b d0
loc_5da5:
    ja loc_5dd3                                                                 ; 5da5: 77 2c
loc_5da7:
    call near update_title_melody                                               ; 5da7: e8 06 f6
loc_5daa:
    call near loc_5dd4                                                          ; 5daa: e8 27 00
loc_5dad:
    cmp byte [joystick_enabled], strict byte 0                                  ; 5dad: 80 3e 9b 06 00
loc_5db2:
    je loc_5dca                                                                 ; 5db2: 74 16
loc_5db4:
    mov dx, 0x201                                                               ; 5db4: ba 01 02
loc_5db7:
    in al, dx                                                                   ; 5db7: ec
loc_5db8:
    and al, 0x10                                                                ; 5db8: 24 10
loc_5dba:
    je loc_5dc3                                                                 ; 5dba: 74 07
loc_5dbc:
    mov byte [0x6a8a], 1                                                        ; 5dbc: c6 06 8a 6a 01
loc_5dc1:
    jmp short loc_5dca                                                          ; 5dc1: eb 07
loc_5dc3:
    cmp byte [0x6a8a], strict byte 0                                            ; 5dc3: 80 3e 8a 6a 00
loc_5dc8:
    jne loc_5dd3                                                                ; 5dc8: 75 09
loc_5dca:
    mov ax, word [0x6150]                                                       ; 5dca: a1 50 61
loc_5dcd:
    cmp ax, word [keyboard_event_counter]                                       ; 5dcd: 3b 06 93 06
loc_5dd1:
    je loc_5d71                                                                 ; 5dd1: 74 9e
loc_5dd3:
    ret                                                                         ; 5dd3: c3
loc_5dd4:
    cmp word [player_x], strict byte 0x20                                       ; 5dd4: 83 3e 79 05 20
loc_5dd9:
    ja loc_5de2                                                                 ; 5dd9: 77 07
loc_5ddb:
    mov byte [input_horizontal], 1                                              ; 5ddb: c6 06 98 06 01
loc_5de0:
    jmp short loc_5e1c                                                          ; 5de0: eb 3a
loc_5de2:
    cmp word [player_x], strict word 0x120                                      ; 5de2: 81 3e 79 05 20 01
loc_5de8:
    jb loc_5df1                                                                 ; 5de8: 72 07
loc_5dea:
    mov byte [input_horizontal], 0xff                                           ; 5dea: c6 06 98 06 ff
loc_5def:
    jmp short loc_5e1c                                                          ; 5def: eb 2b
loc_5df1:
    load8 sub, ah, ah                                                           ; 5df1: 2a e4
loc_5df3:
    int 0x1a                                                                    ; 5df3: cd 1a
loc_5df5:
    load16 mov, ax, dx                                                          ; 5df5: 8b c2
loc_5df7:
    sub ax, word [0x6a88]                                                       ; 5df7: 2b 06 88 6a
loc_5dfb:
    cmp ax, strict word 0x12                                                    ; 5dfb: 3d 12 00
loc_5dfe:
    jb loc_5e1c                                                                 ; 5dfe: 72 1c
loc_5e00:
    mov word [0x6a88], dx                                                       ; 5e00: 89 16 88 6a
loc_5e04:
    call near update_random_state                                               ; 5e04: e8 f6 cf
loc_5e07:
    mov byte [input_horizontal], 0                                              ; 5e07: c6 06 98 06 00
loc_5e0c:
    cmp dl, strict byte 0xa0                                                    ; 5e0c: 80 fa a0
loc_5e0f:
    ja loc_5e1c                                                                 ; 5e0f: 77 0b
loc_5e11:
    and dl, strict byte 1                                                       ; 5e11: 80 e2 01
loc_5e14:
    jne loc_5e18                                                                ; 5e14: 75 02
loc_5e16:
    mov dl, 0xff                                                                ; 5e16: b2 ff
loc_5e18:
    mov byte [input_horizontal], dl                                             ; 5e18: 88 16 98 06
loc_5e1c:
    call near read_cga_vertical_retrace_bit                                     ; 5e1c: e8 b9 b5
loc_5e1f:
    je loc_5e2a                                                                 ; 5e1f: 74 09
loc_5e21:
    mov word [player_horizontal_speed], 4                                       ; 5e21: c7 06 72 05 04 00
loc_5e27:
    call near update_player                                                     ; 5e27: e8 bb aa
loc_5e2a:
    ret                                                                         ; 5e2a: c3

; CS:5e2b — print_zero_terminated_string
; Reads DS:SI until NUL; emits each nonzero byte through INT 10h AH=0Eh with BL=2. The menu test stubs that BIOS service.
print_zero_terminated_string:
    lodsb                                                                       ; 5e2b: ac
loc_5e2c:
    cmp al, 0                                                                   ; 5e2c: 3c 00
loc_5e2e:
    je loc_5e3a                                                                 ; 5e2e: 74 0a
loc_5e30:
    push si                                                                     ; 5e30: 56
loc_5e31:
    mov bl, 2                                                                   ; 5e31: b3 02
loc_5e33:
    mov ah, 0xe                                                                 ; 5e33: b4 0e
loc_5e35:
    int 0x10                                                                    ; 5e35: cd 10
loc_5e37:
    pop si                                                                      ; 5e37: 5e
loc_5e38:
    jmp short print_zero_terminated_string                                      ; 5e38: eb f1
loc_5e3a:
    ret                                                                         ; 5e3a: c3

; CS:5e3b — draw_next_publisher_credit
; Toggles index 6A8D, selects one of two pointers at 6A8F, and blits an 80x12 image. Decoded pixels read IBM Corp. and SynSoft; these are publisher credits, not a cat animation.
draw_next_publisher_credit:
    mov ax, 0xb800                                                              ; 5e3b: b8 00 b8
loc_5e3e:
    mov es, ax                                                                  ; 5e3e: 8e c0
loc_5e40:
    add word [publisher_credit_index], strict byte 2                            ; 5e40: 83 06 8d 6a 02
loc_5e45:
    mov bx, word [publisher_credit_index]                                       ; 5e45: 8b 1e 8d 6a
loc_5e49:
    and bx, strict word 2                                                       ; 5e49: 81 e3 02 00
loc_5e4d:
    mov si, word [bx + publisher_credit_pointers]                               ; 5e4d: 8b b7 8f 6a
loc_5e51:
    mov cx, 0xc0a                                                               ; 5e51: b9 0a 0c
loc_5e54:
    mov di, 0x1d38                                                              ; 5e54: bf 38 1d
loc_5e57:
    call near copy_rectangle_to_cga                                             ; 5e57: e8 43 cf
loc_5e5a:
    ret                                                                         ; 5e5a: c3

; CS:5e5b — set_cursor_row_zero_column
; Forces DL=0 and BH=0, calls INT 10h AH=02h. Only caller-supplied DH (row) survives.
set_cursor_row_zero_column:
    mov dl, 0                                                                   ; 5e5b: b2 00
loc_5e5d:
    load8 mov, bh, dl                                                           ; 5e5d: 8a fa
loc_5e5f:
    mov ah, 2                                                                   ; 5e5f: b4 02
loc_5e61:
    int 0x10                                                                    ; 5e61: cd 10
loc_5e63:
    ret                                                                         ; 5e63: c3
    times 12 db 0 ; original zero fill at CS:5e64
loc_5e70:
    call near disable_speaker                                                   ; 5e70: e8 ae fc
loc_5e73:
    load8 sub, ah, ah                                                           ; 5e73: 2a e4
loc_5e75:
    int 0x1a                                                                    ; 5e75: cd 1a
loc_5e77:
    mov word [0x6dfc], dx                                                       ; 5e77: 89 16 fc 6d
loc_5e7b:
    mov word [0x6dfe], cx                                                       ; 5e7b: 89 0e fe 6d
loc_5e7f:
    push ds                                                                     ; 5e7f: 1e
loc_5e80:
    push ds                                                                     ; 5e80: 1e
loc_5e81:
    pop es                                                                      ; 5e81: 07
loc_5e82:
    mov ax, 0xb800                                                              ; 5e82: b8 00 b8
loc_5e85:
    mov ds, ax                                                                  ; 5e85: 8e d8
loc_5e87:
    mov si, 0xdca                                                               ; 5e87: be ca 0d
loc_5e8a:
    mov di, 0xe                                                                 ; 5e8a: bf 0e 00
loc_5e8d:
    mov cx, 0x1020                                                              ; 5e8d: b9 20 10
loc_5e90:
    call near copy_rectangle_from_cga                                           ; 5e90: e8 37 cf
loc_5e93:
    pop ds                                                                      ; 5e93: 1f
loc_5e94:
    mov dx, 0xb05                                                               ; 5e94: ba 05 0b
loc_5e97:
    mov bh, 0                                                                   ; 5e97: b7 00
loc_5e99:
    mov ah, 2                                                                   ; 5e99: b4 02
loc_5e9b:
    int 0x10                                                                    ; 5e9b: cd 10
loc_5e9d:
    mov si, 0x6d91                                                              ; 5e9d: be 91 6d
loc_5ea0:
    cld                                                                         ; 5ea0: fc
loc_5ea1:
    call near print_zero_terminated_string                                      ; 5ea1: e8 87 ff
loc_5ea4:
    mov dx, 0xc05                                                               ; 5ea4: ba 05 0c
loc_5ea7:
    mov bh, 0                                                                   ; 5ea7: b7 00
loc_5ea9:
    mov ah, 2                                                                   ; 5ea9: b4 02
loc_5eab:
    int 0x10                                                                    ; 5eab: cd 10
loc_5ead:
    mov si, 0x6db2                                                              ; 5ead: be b2 6d
loc_5eb0:
    cmp byte [joystick_enabled], strict byte 0                                  ; 5eb0: 80 3e 9b 06 00
loc_5eb5:
    je loc_5eba                                                                 ; 5eb5: 74 03
loc_5eb7:
    mov si, 0x6dd3                                                              ; 5eb7: be d3 6d
loc_5eba:
    cld                                                                         ; 5eba: fc
loc_5ebb:
    call near print_zero_terminated_string                                      ; 5ebb: e8 6d ff
loc_5ebe:
    call near wait_for_key_or_button                                            ; 5ebe: e8 d6 00
loc_5ec1:
    mov ax, 0xb800                                                              ; 5ec1: b8 00 b8
loc_5ec4:
    mov es, ax                                                                  ; 5ec4: 8e c0
loc_5ec6:
    mov si, 0xe                                                                 ; 5ec6: be 0e 00
loc_5ec9:
    mov di, 0xdca                                                               ; 5ec9: bf ca 0d
loc_5ecc:
    mov cx, 0x1020                                                              ; 5ecc: b9 20 10
loc_5ecf:
    call near copy_rectangle_to_cga                                             ; 5ecf: e8 cb ce
loc_5ed2:
    mov ah, 1                                                                   ; 5ed2: b4 01
loc_5ed4:
    mov cx, word [0x6dfe]                                                       ; 5ed4: 8b 0e fe 6d
loc_5ed8:
    mov dx, word [0x6dfc]                                                       ; 5ed8: 8b 16 fc 6d
loc_5edc:
    int 0x1a                                                                    ; 5edc: cd 1a
loc_5ede:
    mov ax, word [keyboard_event_counter]                                       ; 5ede: a1 93 06
loc_5ee1:
    mov word [pause_keyboard_counter], ax                                       ; 5ee1: a3 00 6e
loc_5ee4:
    ret                                                                         ; 5ee4: c3

; CS:5ee5 — run_control_difficulty_menu
; Prints joystick and skill-level prompts, sets 069B and 6DF8 based on keys, and prints controls. This is the configuration menu, not the title animation.
run_control_difficulty_menu:
    call near disable_speaker                                                   ; 5ee5: e8 39 fc
loc_5ee8:
    call near clear_cga_visible_banks                                           ; 5ee8: e8 e2 00
loc_5eeb:
    mov word [menu_line_index], 0                                               ; 5eeb: c7 06 8f 6d 00 00
loc_5ef1:
    call near print_next_menu_line                                              ; 5ef1: e8 bd 00
loc_5ef4:
    mov ax, word [keyboard_event_counter]                                       ; 5ef4: a1 93 06
loc_5ef7:
    cmp ax, word [keyboard_event_counter]                                       ; 5ef7: 3b 06 93 06
loc_5efb:
    je loc_5ef7                                                                 ; 5efb: 74 fa
loc_5efd:
    test byte [0x6c1], 0x80                                                     ; 5efd: f6 06 c1 06 80
loc_5f02:
    je loc_5f12                                                                 ; 5f02: 74 0e
loc_5f04:
    test byte [0x6c2], 0x80                                                     ; 5f04: f6 06 c2 06 80
loc_5f09:
    jne loc_5ef4                                                                ; 5f09: 75 e9
loc_5f0b:
    mov byte [joystick_enabled], 0                                              ; 5f0b: c6 06 9b 06 00
loc_5f10:
    jmp short loc_5f1c                                                          ; 5f10: eb 0a
loc_5f12:
    call near validate_joystick_or_show_error                                   ; 5f12: e8 d0 00
loc_5f15:
    jb loc_5ee8                                                                 ; 5f15: 72 d1
loc_5f17:
    mov byte [joystick_enabled], 1                                              ; 5f17: c6 06 9b 06 01
loc_5f1c:
    mov cx, 5                                                                   ; 5f1c: b9 05 00
loc_5f1f:
    push cx                                                                     ; 5f1f: 51
loc_5f20:
    call near print_next_menu_line                                              ; 5f20: e8 8e 00
loc_5f23:
    pop cx                                                                      ; 5f23: 59
loc_5f24:
    loop loc_5f1f                                                               ; 5f24: e2 f9
loc_5f26:
    mov ax, word [keyboard_event_counter]                                       ; 5f26: a1 93 06
loc_5f29:
    cmp ax, word [keyboard_event_counter]                                       ; 5f29: 3b 06 93 06
loc_5f2d:
    je loc_5f29                                                                 ; 5f2d: 74 fa
loc_5f2f:
    load16 sub, ax, ax                                                          ; 5f2f: 2b c0
loc_5f31:
    test byte [0x6c3], 0x80                                                     ; 5f31: f6 06 c3 06 80
loc_5f36:
    je loc_5f50                                                                 ; 5f36: 74 18
loc_5f38:
    inc ax                                                                      ; 5f38: 40
loc_5f39:
    test byte [0x6c4], 0x80                                                     ; 5f39: f6 06 c4 06 80
loc_5f3e:
    je loc_5f50                                                                 ; 5f3e: 74 10
loc_5f40:
    inc ax                                                                      ; 5f40: 40
loc_5f41:
    test byte [0x6c5], 0x80                                                     ; 5f41: f6 06 c5 06 80
loc_5f46:
    je loc_5f50                                                                 ; 5f46: 74 08
loc_5f48:
    inc ax                                                                      ; 5f48: 40
loc_5f49:
    test byte [0x6c6], 0x80                                                     ; 5f49: f6 06 c6 06 80
loc_5f4e:
    jne loc_5f26                                                                ; 5f4e: 75 d6
loc_5f50:
    mov word [selected_difficulty], ax                                          ; 5f50: a3 f8 6d
loc_5f53:
    mov cx, 5                                                                   ; 5f53: b9 05 00
loc_5f56:
    push cx                                                                     ; 5f56: 51
loc_5f57:
    call near print_next_menu_line                                              ; 5f57: e8 57 00
loc_5f5a:
    pop cx                                                                      ; 5f5a: 59
loc_5f5b:
    loop loc_5f56                                                               ; 5f5b: e2 f9
loc_5f5d:
    cmp byte [joystick_enabled], strict byte 0                                  ; 5f5d: 80 3e 9b 06 00
loc_5f62:
    je loc_5f7e                                                                 ; 5f62: 74 1a
loc_5f64:
    mov word [menu_line_index], 0x20                                            ; 5f64: c7 06 8f 6d 20 00
loc_5f6a:
    call near print_next_menu_line                                              ; 5f6a: e8 44 00
loc_5f6d:
    call near print_next_menu_line                                              ; 5f6d: e8 41 00
loc_5f70:
    mov word [menu_line_index], 0x18                                            ; 5f70: c7 06 8f 6d 18 00
loc_5f76:
    call near print_next_menu_line                                              ; 5f76: e8 38 00
loc_5f79:
    call near print_next_menu_line                                              ; 5f79: e8 35 00
loc_5f7c:
    jmp short loc_5f93                                                          ; 5f7c: eb 15
loc_5f7e:
    mov word [menu_line_index], 0x1c                                            ; 5f7e: c7 06 8f 6d 1c 00
loc_5f84:
    call near print_next_menu_line                                              ; 5f84: e8 2a 00
loc_5f87:
    call near print_next_menu_line                                              ; 5f87: e8 27 00
loc_5f8a:
    mov word [menu_line_index], 0x16                                            ; 5f8a: c7 06 8f 6d 16 00
loc_5f90:
    call near print_next_menu_line                                              ; 5f90: e8 1e 00
loc_5f93:
    call near wait_for_key_or_button                                            ; 5f93: e8 01 00
loc_5f96:
    ret                                                                         ; 5f96: c3

; CS:5f97 — wait_for_key_or_button
; Joystick mode polls active-low port 201h bit 4; keyboard mode waits for event counter 0693 to change.
wait_for_key_or_button:
    cmp byte [joystick_enabled], strict byte 0                                  ; 5f97: 80 3e 9b 06 00
loc_5f9c:
    je loc_5fa7                                                                 ; 5f9c: 74 09
loc_5f9e:
    mov dx, 0x201                                                               ; 5f9e: ba 01 02
loc_5fa1:
    in al, dx                                                                   ; 5fa1: ec
loc_5fa2:
    and al, 0x10                                                                ; 5fa2: 24 10
loc_5fa4:
    jne loc_5f9e                                                                ; 5fa4: 75 f8
loc_5fa6:
    ret                                                                         ; 5fa6: c3
loc_5fa7:
    mov ax, word [keyboard_event_counter]                                       ; 5fa7: a1 93 06
loc_5faa:
    cmp ax, word [keyboard_event_counter]                                       ; 5faa: 3b 06 93 06
loc_5fae:
    je loc_5faa                                                                 ; 5fae: 74 fa
loc_5fb0:
    ret                                                                         ; 5fb0: c3

; CS:5fb1 — print_next_menu_line
; Uses word index 6D8F into text pointers 6D37 and cursor positions 6D63; advances index by two. Calls cursor and string routines only; no input wait.
print_next_menu_line:
    mov bx, word [menu_line_index]                                              ; 5fb1: 8b 1e 8f 6d
loc_5fb5:
    mov dx, word [bx + menu_cursor_positions]                                   ; 5fb5: 8b 97 63 6d
loc_5fb9:
    call near set_cursor_row_zero_column                                        ; 5fb9: e8 9f fe
loc_5fbc:
    mov bx, word [menu_line_index]                                              ; 5fbc: 8b 1e 8f 6d
loc_5fc0:
    add word [menu_line_index], strict byte 2                                   ; 5fc0: 83 06 8f 6d 02
loc_5fc5:
    mov si, word [bx + menu_text_pointers]                                      ; 5fc5: 8b b7 37 6d
loc_5fc9:
    call near print_zero_terminated_string                                      ; 5fc9: e8 5f fe
loc_5fcc:
    ret                                                                         ; 5fcc: c3

; CS:5fcd — clear_cga_visible_banks
; Writes 4000 zero words at video offsets 0000 and 2000; preserves the 192-byte gaps at each bank end.
clear_cga_visible_banks:
    cld                                                                         ; 5fcd: fc
loc_5fce:
    mov ax, 0xb800                                                              ; 5fce: b8 00 b8
loc_5fd1:
    mov es, ax                                                                  ; 5fd1: 8e c0
loc_5fd3:
    load16 sub, ax, ax                                                          ; 5fd3: 2b c0
loc_5fd5:
    load16 mov, di, ax                                                          ; 5fd5: 8b f8
loc_5fd7:
    mov cx, 0xfa0                                                               ; 5fd7: b9 a0 0f
loc_5fda:
    rep stosw                                                                   ; 5fda: f3 ab
loc_5fdc:
    mov di, 0x2000                                                              ; 5fdc: bf 00 20
loc_5fdf:
    mov cx, 0xfa0                                                               ; 5fdf: b9 a0 0f
loc_5fe2:
    rep stosw                                                                   ; 5fe2: f3 ab
loc_5fe4:
    ret                                                                         ; 5fe4: c3

; CS:5fe5 — validate_joystick_or_show_error
; Checks equipment flag bit 12 and calls the axis-discharge routine twice. On failure prints four messages, waits for a key event, returns CF=1.
validate_joystick_or_show_error:
    int 0x11                                                                    ; 5fe5: cd 11
loc_5fe7:
    test ax, 0x1000                                                             ; 5fe7: a9 00 10
loc_5fea:
    je loc_5ff6                                                                 ; 5fea: 74 0a
loc_5fec:
    call near wait_for_joystick_axes_discharge                                  ; 5fec: e8 20 00
loc_5fef:
    jae loc_600e                                                                ; 5fef: 73 1d
loc_5ff1:
    call near wait_for_joystick_axes_discharge                                  ; 5ff1: e8 1b 00
loc_5ff4:
    jae loc_600e                                                                ; 5ff4: 73 18
loc_5ff6:
    mov word [menu_line_index], 0x24                                            ; 5ff6: c7 06 8f 6d 24 00
loc_5ffc:
    mov cx, 4                                                                   ; 5ffc: b9 04 00
loc_5fff:
    call near print_next_menu_line                                              ; 5fff: e8 af ff
loc_6002:
    loop loc_5fff                                                               ; 6002: e2 fb
loc_6004:
    mov ax, word [keyboard_event_counter]                                       ; 6004: a1 93 06
loc_6007:
    cmp ax, word [keyboard_event_counter]                                       ; 6007: 3b 06 93 06
loc_600b:
    je loc_6007                                                                 ; 600b: 74 fa
loc_600d:
    stc                                                                         ; 600d: f9
loc_600e:
    ret                                                                         ; 600e: c3

; CS:600f — wait_for_joystick_axes_discharge
; Triggers port 201h and waits for both bits 0/1 to clear; returns CF=1 after an 18-BIOS-tick timeout.
wait_for_joystick_axes_discharge:
    mov dx, 0x201                                                               ; 600f: ba 01 02
loc_6012:
    out dx, al                                                                  ; 6012: ee
loc_6013:
    load8 sub, ah, ah                                                           ; 6013: 2a e4
loc_6015:
    int 0x1a                                                                    ; 6015: cd 1a
loc_6017:
    mov word [menu_axis_start_tick], dx                                         ; 6017: 89 16 fa 6d
loc_601b:
    mov dx, 0x201                                                               ; 601b: ba 01 02
loc_601e:
    in al, dx                                                                   ; 601e: ec
loc_601f:
    test al, 3                                                                  ; 601f: a8 03
loc_6021:
    jne loc_6025                                                                ; 6021: 75 02
loc_6023:
    clc                                                                         ; 6023: f8
loc_6024:
    ret                                                                         ; 6024: c3
loc_6025:
    load8 sub, ah, ah                                                           ; 6025: 2a e4
loc_6027:
    int 0x1a                                                                    ; 6027: cd 1a
loc_6029:
    sub dx, word [menu_axis_start_tick]                                         ; 6029: 2b 16 fa 6d
loc_602d:
    cmp dx, strict byte 0x12                                                    ; 602d: 83 fa 12
loc_6030:
    jb loc_601b                                                                 ; 6030: 72 e9
loc_6032:
    stc                                                                         ; 6032: f9
loc_6033:
    ret                                                                         ; 6033: c3
    times 12 db 0 ; original zero fill at CS:6034
loc_6040:
    cld                                                                         ; 6040: fc
loc_6041:
    push ds                                                                     ; 6041: 1e
loc_6042:
    pop es                                                                      ; 6042: 07
loc_6043:
    mov di, 0xe                                                                 ; 6043: bf 0e 00
loc_6046:
    mov cx, 0x24                                                                ; 6046: b9 24 00
loc_6049:
    load16 sub, ax, ax                                                          ; 6049: 2b c0
loc_604b:
    rep stosw                                                                   ; 604b: f3 ab
loc_604d:
    mov word [0x6f24], 0x25                                                     ; 604d: c7 06 24 6f 25 00
loc_6053:
    mov ax, 0xb800                                                              ; 6053: b8 00 b8
loc_6056:
    mov es, ax                                                                  ; 6056: 8e c0
loc_6058:
    call near read_cga_vertical_retrace_bit                                     ; 6058: e8 7d b3
loc_605b:
    je loc_6058                                                                 ; 605b: 74 fb
loc_605d:
    mov si, 0xe                                                                 ; 605d: be 0e 00
loc_6060:
    mov di, word [0x6f24]                                                       ; 6060: 8b 3e 24 6f
loc_6064:
    mov cx, 0xc03                                                               ; 6064: b9 03 0c
loc_6067:
    call near copy_rectangle_to_cga                                             ; 6067: e8 33 cd
loc_606a:
    add word [0x6f24], strict word 0x1e0                                        ; 606a: 81 06 24 6f e0 01
loc_6070:
    mov si, 0x6e10                                                              ; 6070: be 10 6e
loc_6073:
    mov di, word [0x6f24]                                                       ; 6073: 8b 3e 24 6f
loc_6077:
    mov cx, 0xc03                                                               ; 6077: b9 03 0c
loc_607a:
    call near copy_rectangle_to_cga                                             ; 607a: e8 20 cd
loc_607d:
    load8 sub, ah, ah                                                           ; 607d: 2a e4
loc_607f:
    int 0x1a                                                                    ; 607f: cd 1a
loc_6081:
    cmp dx, word [0x6f26]                                                       ; 6081: 3b 16 26 6f
loc_6085:
    je loc_607d                                                                 ; 6085: 74 f6
loc_6087:
    mov word [0x6f26], dx                                                       ; 6087: 89 16 26 6f
loc_608b:
    cmp byte [sound_enabled], strict byte 0                                     ; 608b: 80 3e 00 00 00
loc_6090:
    je loc_60a7                                                                 ; 6090: 74 15
loc_6092:
    mov al, 0xb6                                                                ; 6092: b0 b6
loc_6094:
    out 0x43, al                                                                ; 6094: e6 43
loc_6096:
    mov ax, word [0x6f24]                                                       ; 6096: a1 24 6f
loc_6099:
    shr ax, 1                                                                   ; 6099: d1 e8
loc_609b:
    out 0x42, al                                                                ; 609b: e6 42
loc_609d:
    load8 mov, al, ah                                                           ; 609d: 8a c4
loc_609f:
    out 0x42, al                                                                ; 609f: e6 42
loc_60a1:
    in al, 0x61                                                                 ; 60a1: e4 61
loc_60a3:
    or al, 3                                                                    ; 60a3: 0c 03
loc_60a5:
    out 0x61, al                                                                ; 60a5: e6 61
loc_60a7:
    cmp word [0x6f24], strict word 0x1a40                                       ; 60a7: 81 3e 24 6f 40 1a
loc_60ad:
    jb loc_6058                                                                 ; 60ad: 72 a9
loc_60af:
    mov si, 0x6e58                                                              ; 60af: be 58 6e
loc_60b2:
    mov di, word [0x6f24]                                                       ; 60b2: 8b 3e 24 6f
loc_60b6:
    mov cx, 0x1106                                                              ; 60b6: b9 06 11
loc_60b9:
    call near copy_rectangle_to_cga                                             ; 60b9: e8 e1 cc
loc_60bc:
    load8 sub, ah, ah                                                           ; 60bc: 2a e4
loc_60be:
    int 0x1a                                                                    ; 60be: cd 1a
loc_60c0:
    cmp dx, word [0x6f28]                                                       ; 60c0: 3b 16 28 6f
loc_60c4:
    je loc_60bc                                                                 ; 60c4: 74 f6
loc_60c6:
    mov word [0x6f28], dx                                                       ; 60c6: 89 16 28 6f
loc_60ca:
    cmp byte [sound_enabled], strict byte 0                                     ; 60ca: 80 3e 00 00 00
loc_60cf:
    je loc_60e6                                                                 ; 60cf: 74 15
loc_60d1:
    mov al, 0xb6                                                                ; 60d1: b0 b6
loc_60d3:
    out 0x43, al                                                                ; 60d3: e6 43
loc_60d5:
    mov ax, 0xc00                                                               ; 60d5: b8 00 0c
loc_60d8:
    test dl, 1                                                                  ; 60d8: f6 c2 01
loc_60db:
    je loc_60e0                                                                 ; 60db: 74 03
loc_60dd:
    mov ax, 0xb54                                                               ; 60dd: b8 54 0b
loc_60e0:
    out 0x42, al                                                                ; 60e0: e6 42
loc_60e2:
    load8 mov, al, ah                                                           ; 60e2: 8a c4
loc_60e4:
    out 0x42, al                                                                ; 60e4: e6 42
loc_60e6:
    sub dx, word [0x6f26]                                                       ; 60e6: 2b 16 26 6f
loc_60ea:
    cmp dx, strict byte 0x12                                                    ; 60ea: 83 fa 12
loc_60ed:
    jb loc_60bc                                                                 ; 60ed: 72 cd
loc_60ef:
    call near disable_speaker                                                   ; 60ef: e8 2f fa
loc_60f2:
    ret                                                                         ; 60f2: c3
    times 13 db 0 ; original zero fill at CS:60f3
