; Courtship cat scheduling, contacts, records and OR drawing.
; Original CS:4C10..5060 (end exclusive).

loc_4c10:
    load8 sub, ah, ah                                                           ; 4c10: 2a e4
loc_4c12:
    int 0x1a                                                                    ; 4c12: cd 1a
loc_4c14:
    cmp dx, word [0x45b8]                                                       ; 4c14: 3b 16 b8 45
loc_4c18:
    jne loc_4c1b                                                                ; 4c18: 75 01
loc_4c1a:
    ret                                                                         ; 4c1a: c3
loc_4c1b:
    inc word [courtship_cat_slot]                                               ; 4c1b: ff 06 b6 45
loc_4c1f:
    mov bx, word [courtship_cat_slot]                                           ; 4c1f: 8b 1e b6 45
loc_4c23:
    cmp bx, strict byte 1                                                       ; 4c23: 83 fb 01
loc_4c26:
    je loc_4c38                                                                 ; 4c26: 74 10
loc_4c28:
    cmp bx, strict byte 4                                                       ; 4c28: 83 fb 04
loc_4c2b:
    je loc_4c38                                                                 ; 4c2b: 74 0b
loc_4c2d:
    cmp bx, strict byte 7                                                       ; 4c2d: 83 fb 07
loc_4c30:
    jb loc_4c3c                                                                 ; 4c30: 72 0a
loc_4c32:
    load16 sub, bx, bx                                                          ; 4c32: 2b db
loc_4c34:
    mov word [courtship_cat_slot], bx                                           ; 4c34: 89 1e b6 45
loc_4c38:
    mov word [0x45b8], dx                                                       ; 4c38: 89 16 b8 45
loc_4c3c:
    call near load_courtship_cat_record                                         ; 4c3c: e8 8e 03
loc_4c3f:
    call near loc_502d                                                          ; 4c3f: e8 eb 03
loc_4c42:
    jae loc_4c45                                                                ; 4c42: 73 01
loc_4c44:
    ret                                                                         ; 4c44: c3
loc_4c45:
    cmp word [courtship_cat_work_record + CourtshipCat.hidden_since_tick], strict byte 0; 4c45: 83 3e 4f 45 00
loc_4c4a:
    je loc_4c8c                                                                 ; 4c4a: 74 40
loc_4c4c:
    load8 sub, ah, ah                                                           ; 4c4c: 2a e4
loc_4c4e:
    int 0x1a                                                                    ; 4c4e: cd 1a
loc_4c50:
    sub dx, word [courtship_cat_work_record + CourtshipCat.hidden_since_tick]   ; 4c50: 2b 16 4f 45
loc_4c54:
    mov bx, word [difficulty_level]                                             ; 4c54: 8b 1e 08 00
loc_4c58:
    shl bl, 1                                                                   ; 4c58: d0 e3
loc_4c5a:
    mov ax, word [bx + 0x45c7]                                                  ; 4c5a: 8b 87 c7 45
loc_4c5e:
    cmp word [courtship_cat_slot], strict byte 0                                ; 4c5e: 83 3e b6 45 00
loc_4c63:
    jne loc_4c67                                                                ; 4c63: 75 02
loc_4c65:
    shl ax, 1                                                                   ; 4c65: d1 e0
loc_4c67:
    load16 cmp, dx, ax                                                          ; 4c67: 3b d0
loc_4c69:
    jb loc_4c44                                                                 ; 4c69: 72 d9
loc_4c6b:
    mov word [courtship_cat_work_record + CourtshipCat.hidden_since_tick], 0    ; 4c6b: c7 06 4f 45 00 00
loc_4c71:
    mov byte [courtship_cat_work_record + CourtshipCat.background_absent], 1    ; 4c71: c6 06 4e 45 01
loc_4c76:
    mov ax, 0x24                                                                ; 4c76: b8 24 00
loc_4c79:
    cmp word [player_x], strict word 0xa0                                       ; 4c79: 81 3e 79 05 a0 00
loc_4c7f:
    ja loc_4c84                                                                 ; 4c7f: 77 03
loc_4c81:
    mov ax, 0x108                                                               ; 4c81: b8 08 01
loc_4c84:
    mov word [courtship_cat_work_record + CourtshipCat.x], ax                   ; 4c84: a3 48 45
loc_4c87:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], 0 ; 4c87: c6 06 4a 45 00
loc_4c8c:
    call near check_courtship_cat_contact                                       ; 4c8c: e8 41 01
loc_4c8f:
    jae loc_4c99                                                                ; 4c8f: 73 08
loc_4c91:
    mov bx, word [courtship_cat_slot]                                           ; 4c91: 8b 1e b6 45
loc_4c95:
    call near store_courtship_cat_record                                        ; 4c95: e8 23 03
loc_4c98:
    ret                                                                         ; 4c98: c3
loc_4c99:
    cmp byte [courtship_cat_work_record + CourtshipCat.contact_countdown], strict byte 0; 4c99: 80 3e 53 45 00
loc_4c9e:
    je loc_4cb8                                                                 ; 4c9e: 74 18
loc_4ca0:
    dec byte [courtship_cat_work_record + CourtshipCat.contact_countdown]       ; 4ca0: fe 0e 53 45
loc_4ca4:
    jne loc_4cb5                                                                ; 4ca4: 75 0f
loc_4ca6:
    mov dl, 1                                                                   ; 4ca6: b2 01
loc_4ca8:
    cmp byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], strict byte 0xff; 4ca8: 80 3e 4a 45 ff
loc_4cad:
    je loc_4cb1                                                                 ; 4cad: 74 02
loc_4caf:
    mov dl, 0xff                                                                ; 4caf: b2 ff
loc_4cb1:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], dl; 4cb1: 88 16 4a 45
loc_4cb5:
    jmp short loc_4d14                                                          ; 4cb5: eb 5d
loc_4cb7:
    nop                                                                         ; 4cb7: 90
loc_4cb8:
    mov al, byte [courtship_cat_work_record + CourtshipCat.y]                   ; 4cb8: a0 4b 45
loc_4cbb:
    cmp al, byte [player_y]                                                     ; 4cbb: 3a 06 7b 05
loc_4cbf:
    ja loc_4d14                                                                 ; 4cbf: 77 53
loc_4cc1:
    cmp word [courtship_cat_slot], strict byte 6                                ; 4cc1: 83 3e b6 45 06
loc_4cc6:
    jne loc_4ccf                                                                ; 4cc6: 75 07
loc_4cc8:
    cmp byte [player_y], strict byte 0x28                                       ; 4cc8: 80 3e 7b 05 28
loc_4ccd:
    jb loc_4cdc                                                                 ; 4ccd: 72 0d
loc_4ccf:
    call near update_random_state                                               ; 4ccf: e8 2b e1
loc_4cd2:
    mov bx, word [difficulty_level]                                             ; 4cd2: 8b 1e 08 00
loc_4cd6:
    cmp dl, byte [bx + 0x45bf]                                                  ; 4cd6: 3a 97 bf 45
loc_4cda:
    ja loc_4d14                                                                 ; 4cda: 77 38
loc_4cdc:
    load8 sub, dl, dl                                                           ; 4cdc: 2a d2
loc_4cde:
    mov ax, word [courtship_cat_work_record + CourtshipCat.x]                   ; 4cde: a1 48 45
loc_4ce1:
    and ax, strict word 0xff8                                                   ; 4ce1: 25 f8 0f
loc_4ce4:
    mov cx, word [player_x]                                                     ; 4ce4: 8b 0e 79 05
loc_4ce8:
    and cx, strict word 0xff8                                                   ; 4ce8: 81 e1 f8 0f
loc_4cec:
    load16 cmp, ax, cx                                                          ; 4cec: 3b c1
loc_4cee:
    je loc_4cf6                                                                 ; 4cee: 74 06
loc_4cf0:
    mov dl, 1                                                                   ; 4cf0: b2 01
loc_4cf2:
    jb loc_4cf6                                                                 ; 4cf2: 72 02
loc_4cf4:
    mov dl, 0xff                                                                ; 4cf4: b2 ff
loc_4cf6:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], dl; 4cf6: 88 16 4a 45
loc_4cfa:
    cmp byte [player_y], strict byte 0x28                                       ; 4cfa: 80 3e 7b 05 28
loc_4cff:
    jb loc_4d14                                                                 ; 4cff: 72 13
loc_4d01:
    cmp word [courtship_cat_slot], strict byte 6                                ; 4d01: 83 3e b6 45 06
loc_4d06:
    jne loc_4d14                                                                ; 4d06: 75 0c
loc_4d08:
    mov al, 1                                                                   ; 4d08: b0 01
loc_4d0a:
    cmp dl, strict byte 0xff                                                    ; 4d0a: 80 fa ff
loc_4d0d:
    je loc_4d11                                                                 ; 4d0d: 74 02
loc_4d0f:
    mov al, 0xff                                                                ; 4d0f: b0 ff
loc_4d11:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], al; 4d11: a2 4a 45
loc_4d14:
    mov word [0x45bc], 8                                                        ; 4d14: c7 06 bc 45 08 00
loc_4d1a:
    cmp byte [courtship_cat_work_record + CourtshipCat.contact_countdown], strict byte 0; 4d1a: 80 3e 53 45 00
loc_4d1f:
    je loc_4d27                                                                 ; 4d1f: 74 06
loc_4d21:
    mov word [0x45bc], 4                                                        ; 4d21: c7 06 bc 45 04 00
loc_4d27:
    mov ax, word [courtship_cat_work_record + CourtshipCat.x]                   ; 4d27: a1 48 45
loc_4d2a:
    cmp byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], strict byte 1; 4d2a: 80 3e 4a 45 01
loc_4d2f:
    jae loc_4d46                                                                ; 4d2f: 73 15
loc_4d31:
    call near update_random_state                                               ; 4d31: e8 c9 e0
loc_4d34:
    cmp dl, strict byte 0x10                                                    ; 4d34: 80 fa 10
loc_4d37:
    ja loc_4da1                                                                 ; 4d37: 77 68
loc_4d39:
    and dl, strict byte 1                                                       ; 4d39: 80 e2 01
loc_4d3c:
    jne loc_4d40                                                                ; 4d3c: 75 02
loc_4d3e:
    mov dl, 0xff                                                                ; 4d3e: b2 ff
loc_4d40:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], dl; 4d40: 88 16 4a 45
loc_4d44:
    jmp short loc_4da1                                                          ; 4d44: eb 5b
loc_4d46:
    jne loc_4d60                                                                ; 4d46: 75 18
loc_4d48:
    add ax, word [0x45bc]                                                       ; 4d48: 03 06 bc 45
loc_4d4c:
    cmp ax, strict word 0x10b                                                   ; 4d4c: 3d 0b 01
loc_4d4f:
    jb loc_4d78                                                                 ; 4d4f: 72 27
loc_4d51:
    mov ax, 0x10a                                                               ; 4d51: b8 0a 01
loc_4d54:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], 0xff; 4d54: c6 06 4a 45 ff
loc_4d59:
    mov byte [courtship_cat_work_record + CourtshipCat.contact_countdown], 0    ; 4d59: c6 06 53 45 00
loc_4d5e:
    jmp short loc_4d78                                                          ; 4d5e: eb 18
loc_4d60:
    sub ax, word [0x45bc]                                                       ; 4d60: 2b 06 bc 45
loc_4d64:
    jb loc_4d6b                                                                 ; 4d64: 72 05
loc_4d66:
    cmp ax, strict word 0x24                                                    ; 4d66: 3d 24 00
loc_4d69:
    ja loc_4d78                                                                 ; 4d69: 77 0d
loc_4d6b:
    mov ax, 0x25                                                                ; 4d6b: b8 25 00
loc_4d6e:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], 1 ; 4d6e: c6 06 4a 45 01
loc_4d73:
    mov byte [courtship_cat_work_record + CourtshipCat.contact_countdown], 0    ; 4d73: c6 06 53 45 00
loc_4d78:
    mov word [courtship_cat_work_record + CourtshipCat.x], ax                   ; 4d78: a3 48 45
loc_4d7b:
    add word [courtship_cat_work_record + CourtshipCat.animation_byte_offset], strict byte 2; 4d7b: 83 06 51 45 02
loc_4d80:
    cmp word [courtship_cat_work_record + CourtshipCat.animation_byte_offset], strict byte 0xc; 4d80: 83 3e 51 45 0c
loc_4d85:
    jb loc_4d8d                                                                 ; 4d85: 72 06
loc_4d87:
    mov word [courtship_cat_work_record + CourtshipCat.animation_byte_offset], 0; 4d87: c7 06 51 45 00 00
loc_4d8d:
    cmp byte [courtship_cat_work_record + CourtshipCat.contact_countdown], strict byte 0; 4d8d: 80 3e 53 45 00
loc_4d92:
    jne loc_4da1                                                                ; 4d92: 75 0d
loc_4d94:
    call near update_random_state                                               ; 4d94: e8 66 e0
loc_4d97:
    cmp dl, strict byte 8                                                       ; 4d97: 80 fa 08
loc_4d9a:
    ja loc_4da1                                                                 ; 4d9a: 77 05
loc_4d9c:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], 0 ; 4d9c: c6 06 4a 45 00
loc_4da1:
    mov cx, word [courtship_cat_work_record + CourtshipCat.x]                   ; 4da1: 8b 0e 48 45
loc_4da5:
    mov dl, byte [courtship_cat_work_record + CourtshipCat.y]                   ; 4da5: 8a 16 4b 45
loc_4da9:
    call near calculate_cga_address                                             ; 4da9: e8 04 df
loc_4dac:
    mov word [0x45ba], ax                                                       ; 4dac: a3 ba 45
loc_4daf:
    call near loc_502d                                                          ; 4daf: e8 7b 02
loc_4db2:
    jae loc_4db5                                                                ; 4db2: 73 01
loc_4db4:
    ret                                                                         ; 4db4: c3
loc_4db5:
    call near check_courtship_cat_contact                                       ; 4db5: e8 18 00
loc_4db8:
    jb loc_4dc8                                                                 ; 4db8: 72 0e
loc_4dba:
    call near loc_4f4a                                                          ; 4dba: e8 8d 01
loc_4dbd:
    call near loc_4f10                                                          ; 4dbd: e8 50 01
loc_4dc0:
    mov byte [0x45be], 0                                                        ; 4dc0: c6 06 be 45 00
loc_4dc5:
    call near loc_4e75                                                          ; 4dc5: e8 ad 00
loc_4dc8:
    mov bx, word [courtship_cat_slot]                                           ; 4dc8: 8b 1e b6 45
loc_4dcc:
    call near store_courtship_cat_record                                        ; 4dcc: e8 ec 01
loc_4dcf:
    ret                                                                         ; 4dcf: c3
; CS:4dd0 — check_courtship_cat_contact
; Contact with slot six sets scene_complete; contact with earlier slots forces a downward player motion and a short rejection animation.
check_courtship_cat_contact:
    mov ax, word [player_x]                                                     ; 4dd0: a1 79 05
loc_4dd3:
    mov dl, byte [player_y]                                                     ; 4dd3: 8a 16 7b 05
loc_4dd7:
    mov si, 0x18                                                                ; 4dd7: be 18 00
loc_4dda:
    load16 mov, di, si                                                          ; 4dda: 8b fe
loc_4ddc:
    mov bx, word [courtship_cat_work_record + CourtshipCat.x]                   ; 4ddc: 8b 1e 48 45
loc_4de0:
    mov dh, byte [courtship_cat_work_record + CourtshipCat.y]                   ; 4de0: 8a 36 4b 45
loc_4de4:
    mov cx, 0xc0e                                                               ; 4de4: b9 0e 0c
loc_4de7:
    call near rectangles_overlap                                                ; 4de7: e8 3f e0
loc_4dea:
    jae loc_4e3d                                                                ; 4dea: 73 51
loc_4dec:
    cmp word [courtship_cat_slot], strict byte 6                                ; 4dec: 83 3e b6 45 06
loc_4df1:
    jne loc_4e00                                                                ; 4df1: 75 0d
loc_4df3:
    mov byte [scene_complete], 1                                                ; 4df3: c6 06 53 05 01
loc_4df8:
    call near restore_player_background                                         ; 4df8: e8 e8 c3
loc_4dfb:
    call near loc_4f4a                                                          ; 4dfb: e8 4c 01
loc_4dfe:
    stc                                                                         ; 4dfe: f9
loc_4dff:
    ret                                                                         ; 4dff: c3
loc_4e00:
    call near restore_player_background                                         ; 4e00: e8 e0 c3
loc_4e03:
    call near loc_4f4a                                                          ; 4e03: e8 44 01
loc_4e06:
    call near draw_player_mask                                                  ; 4e06: e8 3c c3
loc_4e09:
    mov byte [0x55b], 4                                                         ; 4e09: c6 06 5b 05 04
loc_4e0e:
    mov byte [player_vertical_direction], 1                                     ; 4e0e: c6 06 71 05 01
loc_4e13:
    mov byte [player_vertical_speed], 4                                         ; 4e13: c6 06 76 05 04
loc_4e18:
    mov byte [player_vertical_acceleration_step], 8                             ; 4e18: c6 06 78 05 08
loc_4e1d:
    mov byte [courtship_cat_work_record + CourtshipCat.contact_countdown], 4    ; 4e1d: c6 06 53 45 04
loc_4e22:
    mov dl, 1                                                                   ; 4e22: b2 01
loc_4e24:
    mov ax, word [courtship_cat_work_record + CourtshipCat.x]                   ; 4e24: a1 48 45
loc_4e27:
    cmp ax, word [player_x]                                                     ; 4e27: 3b 06 79 05
loc_4e2b:
    ja loc_4e2f                                                                 ; 4e2b: 77 02
loc_4e2d:
    mov dl, 0xff                                                                ; 4e2d: b2 ff
loc_4e2f:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], dl; 4e2f: 88 16 4a 45
loc_4e33:
    mov ax, 0xce4                                                               ; 4e33: b8 e4 0c
loc_4e36:
    mov bx, 0x123b                                                              ; 4e36: bb 3b 12
loc_4e39:
    call near start_two_stage_sound                                             ; 4e39: e8 ff 0a
loc_4e3c:
    stc                                                                         ; 4e3c: f9
loc_4e3d:
    ret                                                                         ; 4e3d: c3
loc_4e3e:
    mov byte [0x45be], 1                                                        ; 4e3e: c6 06 be 45 01
loc_4e43:
    mov ax, word [courtship_cat_slot]                                           ; 4e43: a1 b6 45
loc_4e46:
    push ax                                                                     ; 4e46: 50
loc_4e47:
    mov word [courtship_cat_slot], 0                                            ; 4e47: c7 06 b6 45 00 00
loc_4e4d:
    mov bx, word [courtship_cat_slot]                                           ; 4e4d: 8b 1e b6 45
loc_4e51:
    call near load_courtship_cat_record                                         ; 4e51: e8 79 01
loc_4e54:
    cmp word [courtship_cat_work_record + CourtshipCat.hidden_since_tick], strict byte 0; 4e54: 83 3e 4f 45 00
loc_4e59:
    jne loc_4e65                                                                ; 4e59: 75 0a
loc_4e5b:
    call near loc_4e75                                                          ; 4e5b: e8 17 00
loc_4e5e:
    mov bx, word [courtship_cat_slot]                                           ; 4e5e: 8b 1e b6 45
loc_4e62:
    call near store_courtship_cat_record                                        ; 4e62: e8 56 01
loc_4e65:
    inc word [courtship_cat_slot]                                               ; 4e65: ff 06 b6 45
loc_4e69:
    cmp word [courtship_cat_slot], strict byte 7                                ; 4e69: 83 3e b6 45 07
loc_4e6e:
    jb loc_4e4d                                                                 ; 4e6e: 72 dd
loc_4e70:
    pop ax                                                                      ; 4e70: 58
loc_4e71:
    mov word [courtship_cat_slot], ax                                           ; 4e71: a3 b6 45
loc_4e74:
    ret                                                                         ; 4e74: c3
loc_4e75:
    mov cx, 8                                                                   ; 4e75: b9 08 00
loc_4e78:
    load16 mov, bx, cx                                                          ; 4e78: 8b d9
loc_4e7a:
    dec bx                                                                      ; 4e7a: 4b
loc_4e7b:
    cmp byte [bx + 0x2b72], strict byte 0                                       ; 4e7b: 80 bf 72 2b 00
loc_4e80:
    je loc_4ea3                                                                 ; 4e80: 74 21
loc_4e82:
    push cx                                                                     ; 4e82: 51
loc_4e83:
    mov dl, byte [bx + 0x2b6a]                                                  ; 4e83: 8a 97 6a 2b
loc_4e87:
    shl bl, 1                                                                   ; 4e87: d0 e3
loc_4e89:
    mov ax, word [bx + 0x2b5a]                                                  ; 4e89: 8b 87 5a 2b
loc_4e8d:
    mov si, 0x18                                                                ; 4e8d: be 18 00
loc_4e90:
    load16 mov, di, si                                                          ; 4e90: 8b fe
loc_4e92:
    mov bx, word [courtship_cat_work_record + CourtshipCat.x]                   ; 4e92: 8b 1e 48 45
loc_4e96:
    mov dh, byte [courtship_cat_work_record + CourtshipCat.y]                   ; 4e96: 8a 36 4b 45
loc_4e9a:
    mov cx, 0xc0f                                                               ; 4e9a: b9 0f 0c
loc_4e9d:
    call near rectangles_overlap                                                ; 4e9d: e8 89 df
loc_4ea0:
    pop cx                                                                      ; 4ea0: 59
loc_4ea1:
    jb loc_4ea6                                                                 ; 4ea1: 72 03
loc_4ea3:
    loop loc_4e78                                                               ; 4ea3: e2 d3
loc_4ea5:
    ret                                                                         ; 4ea5: c3
loc_4ea6:
    push cx                                                                     ; 4ea6: 51
loc_4ea7:
    cmp byte [0x45be], strict byte 0                                            ; 4ea7: 80 3e be 45 00
loc_4eac:
    jne loc_4ebb                                                                ; 4eac: 75 0d
loc_4eae:
    call near restore_player_background                                         ; 4eae: e8 32 c3
loc_4eb1:
    cmp byte [courtship_object_active], strict byte 0                                            ; 4eb1: 80 3e f2 70 00
loc_4eb6:
    je loc_4ebb                                                                 ; 4eb6: 74 03
loc_4eb8:
    call near erase_courtship_moving_object                                                          ; 4eb8: e8 70 13
loc_4ebb:
    call near loc_4f4a                                                          ; 4ebb: e8 8c 00
loc_4ebe:
    pop cx                                                                      ; 4ebe: 59
loc_4ebf:
    load16 mov, bx, cx                                                          ; 4ebf: 8b d9
loc_4ec1:
    dec bx                                                                      ; 4ec1: 4b
loc_4ec2:
    mov byte [bx + 0x2b72], 0                                                   ; 4ec2: c6 87 72 2b 00
loc_4ec7:
    mov dl, byte [bx + 0x2b6a]                                                  ; 4ec7: 8a 97 6a 2b
loc_4ecb:
    shl bl, 1                                                                   ; 4ecb: d0 e3
loc_4ecd:
    mov cx, word [bx + 0x2b5a]                                                  ; 4ecd: 8b 8f 5a 2b
loc_4ed1:
    call near calculate_cga_address                                             ; 4ed1: e8 dc dd
loc_4ed4:
    load16 mov, di, ax                                                          ; 4ed4: 8b f8
loc_4ed6:
    mov si, 0x2b7a                                                              ; 4ed6: be 7a 2b
loc_4ed9:
    mov ax, 0xb800                                                              ; 4ed9: b8 00 b8
loc_4edc:
    mov es, ax                                                                  ; 4edc: 8e c0
loc_4ede:
    mov cx, 0xf03                                                               ; 4ede: b9 03 0f
loc_4ee1:
    call near copy_rectangle_to_cga                                             ; 4ee1: e8 b9 de
loc_4ee4:
    cmp byte [0x45be], strict byte 0                                            ; 4ee4: 80 3e be 45 00
loc_4ee9:
    jne loc_4ef8                                                                ; 4ee9: 75 0d
loc_4eeb:
    cmp byte [courtship_object_active], strict byte 0                                            ; 4eeb: 80 3e f2 70 00
loc_4ef0:
    je loc_4ef5                                                                 ; 4ef0: 74 03
loc_4ef2:
    call near draw_courtship_moving_object                                                          ; 4ef2: e8 05 13
loc_4ef5:
    call near draw_player_mask                                                  ; 4ef5: e8 4d c2
loc_4ef8:
    load16 sub, dx, dx                                                          ; 4ef8: 2b d2
loc_4efa:
    cmp word [courtship_cat_slot], strict byte 6                                ; 4efa: 83 3e b6 45 06
loc_4eff:
    je loc_4f0b                                                                 ; 4eff: 74 0a
loc_4f01:
    load8 sub, ah, ah                                                           ; 4f01: 2a e4
loc_4f03:
    int 0x1a                                                                    ; 4f03: cd 1a
loc_4f05:
    cmp dx, strict byte 0                                                       ; 4f05: 83 fa 00
loc_4f08:
    jne loc_4f0b                                                                ; 4f08: 75 01
loc_4f0a:
    dec dx                                                                      ; 4f0a: 4a
loc_4f0b:
    mov word [courtship_cat_work_record + CourtshipCat.hidden_since_tick], dx   ; 4f0b: 89 16 4f 45
loc_4f0f:
    ret                                                                         ; 4f0f: c3
loc_4f10:
    mov byte [courtship_cat_work_record + CourtshipCat.background_absent], 0    ; 4f10: c6 06 4e 45 00
loc_4f15:
    mov si, 0x4500                                                              ; 4f15: be 00 45
loc_4f18:
    cmp byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], strict byte 0; 4f18: 80 3e 4a 45 00
loc_4f1d:
    je loc_4f3e                                                                 ; 4f1d: 74 1f
loc_4f1f:
    mov bx, word [courtship_cat_work_record + CourtshipCat.animation_byte_offset]; 4f1f: 8b 1e 51 45
loc_4f23:
    cmp byte [courtship_cat_work_record + CourtshipCat.contact_countdown], strict byte 0; 4f23: 80 3e 53 45 00
loc_4f28:
    je loc_4f30                                                                 ; 4f28: 74 06
loc_4f2a:
    and bl, strict byte 2                                                       ; 4f2a: 80 e3 02
loc_4f2d:
    add bl, strict byte 0xc                                                     ; 4f2d: 80 c3 0c
loc_4f30:
    cmp byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], strict byte 0xff; 4f30: 80 3e 4a 45 ff
loc_4f35:
    jne loc_4f3a                                                                ; 4f35: 75 03
loc_4f37:
    add bx, strict byte 0x10                                                    ; 4f37: 83 c3 10
loc_4f3a:
    mov si, word [bx + 0x4a60]                                                  ; 4f3a: 8b b7 60 4a
loc_4f3e:
    mov di, word [0x45ba]                                                       ; 4f3e: 8b 3e ba 45
loc_4f42:
    mov word [courtship_cat_work_record + CourtshipCat.video_offset], di        ; 4f42: 89 3e 4c 45
loc_4f46:
    call near blit_courtship_or_mask                                            ; 4f46: e8 96 00
loc_4f49:
    ret                                                                         ; 4f49: c3
loc_4f4a:
    cmp byte [courtship_cat_work_record + CourtshipCat.background_absent], strict byte 0; 4f4a: 80 3e 4e 45 00
loc_4f4f:
    jne loc_4f58                                                                ; 4f4f: 75 07
loc_4f51:
    mov di, word [courtship_cat_work_record + CourtshipCat.video_offset]        ; 4f51: 8b 3e 4c 45
loc_4f55:
    call near loc_5008                                                          ; 4f55: e8 b0 00
loc_4f58:
    ret                                                                         ; 4f58: c3
; CS:4f59 — initialize_courtship_cats
; Initializes seven table-backed cat slots with random X in 96..223 and row-specific Y; only slot zero receives an initial nonzero activation tick.
initialize_courtship_cats:
    mov word [courtship_cat_slot], 0                                            ; 4f59: c7 06 b6 45 00 00
loc_4f5f:
    call near update_random_state                                               ; 4f5f: e8 9b de
loc_4f62:
    and dx, strict word 0x7f                                                    ; 4f62: 81 e2 7f 00
loc_4f66:
    add dx, strict byte 0x60                                                    ; 4f66: 83 c2 60
loc_4f69:
    mov word [courtship_cat_work_record + CourtshipCat.x], dx                   ; 4f69: 89 16 48 45
loc_4f6d:
    mov byte [courtship_cat_work_record + CourtshipCat.horizontal_direction], 0 ; 4f6d: c6 06 4a 45 00
loc_4f72:
    mov byte [courtship_cat_work_record + CourtshipCat.background_absent], 1    ; 4f72: c6 06 4e 45 01
loc_4f77:
    mov word [courtship_cat_work_record + CourtshipCat.animation_byte_offset], 0; 4f77: c7 06 51 45 00 00
loc_4f7d:
    mov byte [courtship_cat_work_record + CourtshipCat.contact_countdown], 0    ; 4f7d: c6 06 53 45 00
loc_4f82:
    load16 sub, dx, dx                                                          ; 4f82: 2b d2
loc_4f84:
    cmp word [courtship_cat_slot], strict byte 0                                ; 4f84: 83 3e b6 45 00
loc_4f89:
    jne loc_4f95                                                                ; 4f89: 75 0a
loc_4f8b:
    load8 sub, ah, ah                                                           ; 4f8b: 2a e4
loc_4f8d:
    int 0x1a                                                                    ; 4f8d: cd 1a
loc_4f8f:
    cmp dx, strict byte 0                                                       ; 4f8f: 83 fa 00
loc_4f92:
    jne loc_4f95                                                                ; 4f92: 75 01
loc_4f94:
    dec dx                                                                      ; 4f94: 4a
loc_4f95:
    mov word [courtship_cat_work_record + CourtshipCat.hidden_since_tick], dx   ; 4f95: 89 16 4f 45
loc_4f99:
    mov bx, word [courtship_cat_slot]                                           ; 4f99: 8b 1e b6 45
loc_4f9d:
    mov al, byte [bx + courtship_platform_y]                                                  ; 4f9d: 8a 87 d4 2b
loc_4fa1:
    add al, 3                                                                   ; 4fa1: 04 03
loc_4fa3:
    mov byte [courtship_cat_work_record + CourtshipCat.y], al                   ; 4fa3: a2 4b 45
loc_4fa6:
    call near store_courtship_cat_record                                        ; 4fa6: e8 12 00
loc_4fa9:
    inc word [courtship_cat_slot]                                               ; 4fa9: ff 06 b6 45
loc_4fad:
    cmp word [courtship_cat_slot], strict byte 7                                ; 4fad: 83 3e b6 45 07
loc_4fb2:
    jb loc_4f5f                                                                 ; 4fb2: 72 ab
loc_4fb4:
    mov word [courtship_cat_slot], 0                                            ; 4fb4: c7 06 b6 45 00 00
loc_4fba:
    ret                                                                         ; 4fba: c3
; CS:4fbb — store_courtship_cat_record
; Copies twelve bytes from DS:4548 into the record selected by BX through the seven-pointer table at DS:45A8; doubles BX.
store_courtship_cat_record:
    push ds                                                                     ; 4fbb: 1e
loc_4fbc:
    pop es                                                                      ; 4fbc: 07
loc_4fbd:
    shl bl, 1                                                                   ; 4fbd: d0 e3
loc_4fbf:
    cld                                                                         ; 4fbf: fc
loc_4fc0:
    mov di, word [bx + courtship_cat_record_pointers]                           ; 4fc0: 8b bf a8 45
loc_4fc4:
    mov si, 0x4548                                                              ; 4fc4: be 48 45
loc_4fc7:
    mov cx, 0xc                                                                 ; 4fc7: b9 0c 00
loc_4fca:
    rep movsb                                                                   ; 4fca: f3 a4
loc_4fcc:
    ret                                                                         ; 4fcc: c3
; CS:4fcd — load_courtship_cat_record
; Copies twelve bytes from the record selected by BX through DS:45A8 into DS:4548; doubles BX.
load_courtship_cat_record:
    push ds                                                                     ; 4fcd: 1e
loc_4fce:
    pop es                                                                      ; 4fce: 07
loc_4fcf:
    shl bl, 1                                                                   ; 4fcf: d0 e3
loc_4fd1:
    cld                                                                         ; 4fd1: fc
loc_4fd2:
    mov si, word [bx + courtship_cat_record_pointers]                           ; 4fd2: 8b b7 a8 45
loc_4fd6:
    mov di, 0x4548                                                              ; 4fd6: bf 48 45
loc_4fd9:
    mov cx, 0xc                                                                 ; 4fd9: b9 0c 00
loc_4fdc:
    rep movsb                                                                   ; 4fdc: f3 a4
loc_4fde:
    ret                                                                         ; 4fde: c3
; CS:4fdf — blit_courtship_or_mask
; ORs three source words into CGA for each of twelve rows, alternating banks; unlike player drawing this preserves zero source bits.
blit_courtship_or_mask:
    mov ax, 0xb800                                                              ; 4fdf: b8 00 b8
loc_4fe2:
    mov es, ax                                                                  ; 4fe2: 8e c0
loc_4fe4:
    cld                                                                         ; 4fe4: fc
loc_4fe5:
    mov dh, 0xc                                                                 ; 4fe5: b6 0c
loc_4fe7:
    mov cx, 3                                                                   ; 4fe7: b9 03 00
loc_4fea:
    mov bx, word [es:di]                                                        ; 4fea: 26 8b 1d
loc_4fed:
    lodsw                                                                       ; 4fed: ad
loc_4fee:
    load16 or, ax, bx                                                           ; 4fee: 0b c3
loc_4ff0:
    stosw                                                                       ; 4ff0: ab
loc_4ff1:
    loop loc_4fea                                                               ; 4ff1: e2 f7
loc_4ff3:
    sub di, strict byte 6                                                       ; 4ff3: 83 ef 06
loc_4ff6:
    xor di, strict word 0x2000                                                  ; 4ff6: 81 f7 00 20
loc_4ffa:
    test di, 0x2000                                                             ; 4ffa: f7 c7 00 20
loc_4ffe:
    jne loc_5003                                                                ; 4ffe: 75 03
loc_5000:
    add di, strict byte 0x50                                                    ; 5000: 83 c7 50
loc_5003:
    dec dh                                                                      ; 5003: fe ce
loc_5005:
    jne loc_4fe7                                                                ; 5005: 75 e0
loc_5007:
    ret                                                                         ; 5007: c3
loc_5008:
    mov ax, 0xb800                                                              ; 5008: b8 00 b8
loc_500b:
    mov es, ax                                                                  ; 500b: 8e c0
loc_500d:
    cld                                                                         ; 500d: fc
loc_500e:
    mov dh, 0xc                                                                 ; 500e: b6 0c
loc_5010:
    mov ax, 0x5555                                                              ; 5010: b8 55 55
loc_5013:
    mov cx, 3                                                                   ; 5013: b9 03 00
loc_5016:
    rep stosw                                                                   ; 5016: f3 ab
loc_5018:
    sub di, strict byte 6                                                       ; 5018: 83 ef 06
loc_501b:
    xor di, strict word 0x2000                                                  ; 501b: 81 f7 00 20
loc_501f:
    test di, 0x2000                                                             ; 501f: f7 c7 00 20
loc_5023:
    jne loc_5028                                                                ; 5023: 75 03
loc_5025:
    add di, strict byte 0x50                                                    ; 5025: 83 c7 50
loc_5028:
    dec dh                                                                      ; 5028: fe ce
loc_502a:
    jne loc_5013                                                                ; 502a: 75 e7
loc_502c:
    ret                                                                         ; 502c: c3
loc_502d:
    cmp byte [courtship_object_active], strict byte 0                                            ; 502d: 80 3e f2 70 00
loc_5032:
    jne loc_5036                                                                ; 5032: 75 02
loc_5034:
    clc                                                                         ; 5034: f8
loc_5035:
    ret                                                                         ; 5035: c3
loc_5036:
    mov ax, word [courtship_object_x]                                                       ; 5036: a1 f3 70
loc_5039:
    mov dl, byte [courtship_object_y]                                                       ; 5039: 8a 16 f5 70
loc_503d:
    mov si, 0x10                                                                ; 503d: be 10 00
loc_5040:
    mov bx, word [courtship_cat_work_record + CourtshipCat.x]                   ; 5040: 8b 1e 48 45
loc_5044:
    mov dh, byte [courtship_cat_work_record + CourtshipCat.y]                   ; 5044: 8a 36 4b 45
loc_5048:
    mov di, 0x18                                                                ; 5048: bf 18 00
loc_504b:
    mov cx, 0xc08                                                               ; 504b: b9 08 0c
loc_504e:
    call near rectangles_overlap                                                ; 504e: e8 d8 dd
loc_5051:
    ret                                                                         ; 5051: c3
    times 14 db 0 ; original zero fill at CS:5052
