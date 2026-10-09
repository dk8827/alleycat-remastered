; Additional courtship object; visual identity remains unreviewed.
; Original CS:6100..62EB (end exclusive).

; CS:6100 — initialize_courtship_moving_object
; Clears the moving-object active flag; other fields are initialized when a spawn is accepted.
initialize_courtship_moving_object:
    mov byte [courtship_object_active], 0                                                        ; 6100: c6 06 f2 70 00
loc_6105:
    ret                                                                         ; 6105: c3
; CS:6106 — update_courtship_moving_object
; On each new BIOS tick, checks contact, spawns from a top or side table when inactive, then moves five pixels horizontally and two down; out-of-bounds or player contact deactivates it.
update_courtship_moving_object:
    load8 sub, ah, ah                                                           ; 6106: 2a e4
loc_6108:
    int 0x1a                                                                    ; 6108: cd 1a
loc_610a:
    cmp dx, word [courtship_object_last_tick]                                                       ; 610a: 3b 16 ee 70
loc_610e:
    jne loc_6111                                                                ; 610e: 75 01
loc_6110:
    ret                                                                         ; 6110: c3
loc_6111:
    mov word [courtship_object_last_tick], dx                                                       ; 6111: 89 16 ee 70
loc_6115:
    call near check_courtship_moving_object_contact                                                          ; 6115: e8 8e 01
loc_6118:
    jae loc_6129                                                                ; 6118: 73 0f
loc_611a:
    call near restore_player_background                                         ; 611a: e8 c6 b0
loc_611d:
    call near erase_courtship_moving_object                                                          ; 611d: e8 0b 01
loc_6120:
    call near draw_player_mask                                                  ; 6120: e8 22 b0
loc_6123:
    mov byte [courtship_object_active], 0                                                        ; 6123: c6 06 f2 70 00
loc_6128:
    ret                                                                         ; 6128: c3
loc_6129:
    cmp byte [courtship_object_active], strict byte 0                                            ; 6129: 80 3e f2 70 00
loc_612e:
    jne loc_619e                                                                ; 612e: 75 6e
loc_6130:
    call near update_random_state                                               ; 6130: e8 ca cc
loc_6133:
    load16 mov, bx, dx                                                          ; 6133: 8b da
loc_6135:
    and bx, strict word 0x1f                                                    ; 6135: 81 e3 1f 00
loc_6139:
    cmp bl, strict byte 0x10                                                    ; 6139: 80 fb 10
loc_613c:
    jb loc_6166                                                                 ; 613c: 72 28
loc_613e:
    sub bl, strict byte 0x10                                                    ; 613e: 80 eb 10
loc_6141:
    cmp bl, strict byte 9                                                       ; 6141: 80 fb 09
loc_6144:
    ja loc_6130                                                                 ; 6144: 77 ea
loc_6146:
    mov dl, 1                                                                   ; 6146: b2 01
loc_6148:
    cmp bl, strict byte 5                                                       ; 6148: 80 fb 05
loc_614b:
    jb loc_614f                                                                 ; 614b: 72 02
loc_614d:
    mov dl, 0xff                                                                ; 614d: b2 ff
loc_614f:
    mov byte [courtship_object_horizontal_direction], dl                                                       ; 614f: 88 16 f6 70
loc_6153:
    mov byte [courtship_object_y], 6                                                        ; 6153: c6 06 f5 70 06
loc_6158:
    shl bl, 1                                                                   ; 6158: d0 e3
loc_615a:
    mov ax, word [bx + courtship_object_top_spawn_x]                                                  ; 615a: 8b 87 b8 70
loc_615e:
    add ax, strict word 4                                                       ; 615e: 05 04 00
loc_6161:
    mov word [courtship_object_x], ax                                                       ; 6161: a3 f3 70
loc_6164:
    jmp short loc_6188                                                          ; 6164: eb 22
loc_6166:
    mov ax, 0xc                                                                 ; 6166: b8 0c 00
loc_6169:
    mov dl, 1                                                                   ; 6169: b2 01
loc_616b:
    test bl, 8                                                                  ; 616b: f6 c3 08
loc_616e:
    je loc_6175                                                                 ; 616e: 74 05
loc_6170:
    mov ax, 0x120                                                               ; 6170: b8 20 01
loc_6173:
    mov dl, 0xff                                                                ; 6173: b2 ff
loc_6175:
    mov word [courtship_object_x], ax                                                       ; 6175: a3 f3 70
loc_6178:
    mov byte [courtship_object_horizontal_direction], dl                                                       ; 6178: 88 16 f6 70
loc_617c:
    and bl, strict byte 7                                                       ; 617c: 80 e3 07
loc_617f:
    mov al, byte [bx + courtship_object_side_spawn_y]                                                  ; 617f: 8a 87 b0 70
loc_6183:
    add al, 8                                                                   ; 6183: 04 08
loc_6185:
    mov byte [courtship_object_y], al                                                       ; 6185: a2 f5 70
loc_6188:
    mov byte [courtship_object_active], 1                                                        ; 6188: c6 06 f2 70 01
loc_618d:
    mov byte [courtship_object_background_absent], 1                                                        ; 618d: c6 06 f7 70 01
loc_6192:
    mov word [courtship_object_animation_phase], 0                                                        ; 6192: c7 06 f0 70 00 00
loc_6198:
    mov word [courtship_object_last_cell], 0xffff                                                   ; 6198: c7 06 ec 70 ff ff
loc_619e:
    cmp word [courtship_object_animation_phase], strict word 0xa0                                         ; 619e: 81 3e f0 70 a0 00
loc_61a4:
    jae loc_61ab                                                                ; 61a4: 73 05
loc_61a6:
    add word [courtship_object_animation_phase], strict byte 4                                            ; 61a6: 83 06 f0 70 04
loc_61ab:
    add byte [courtship_object_y], strict byte 2                                            ; 61ab: 80 06 f5 70 02
loc_61b0:
    cmp byte [courtship_object_y], strict byte 0xbf                                         ; 61b0: 80 3e f5 70 bf
loc_61b5:
    ja loc_61d4                                                                 ; 61b5: 77 1d
loc_61b7:
    cmp byte [courtship_object_horizontal_direction], strict byte 1                                            ; 61b7: 80 3e f6 70 01
loc_61bc:
    je loc_61c7                                                                 ; 61bc: 74 09
loc_61be:
    sub word [courtship_object_x], strict byte 5                                            ; 61be: 83 2e f3 70 05
loc_61c3:
    jb loc_61d4                                                                 ; 61c3: 72 0f
loc_61c5:
    jmp short loc_61dd                                                          ; 61c5: eb 16
loc_61c7:
    add word [courtship_object_x], strict byte 5                                            ; 61c7: 83 06 f3 70 05
loc_61cc:
    cmp word [courtship_object_x], strict word 0x12c                                        ; 61cc: 81 3e f3 70 2c 01
loc_61d2:
    jb loc_61dd                                                                 ; 61d2: 72 09
loc_61d4:
    mov byte [courtship_object_active], 0                                                        ; 61d4: c6 06 f2 70 00
loc_61d9:
    call near erase_courtship_moving_object                                                          ; 61d9: e8 4f 00
loc_61dc:
    ret                                                                         ; 61dc: c3
loc_61dd:
    mov cx, word [courtship_object_x]                                                       ; 61dd: 8b 0e f3 70
loc_61e1:
    mov dl, byte [courtship_object_y]                                                       ; 61e1: 8a 16 f5 70
loc_61e5:
    call near calculate_cga_address                                             ; 61e5: e8 c8 ca
loc_61e8:
    mov word [courtship_object_next_video_offset], ax                                                       ; 61e8: a3 fa 70
loc_61eb:
    call near check_courtship_moving_object_contact                                                          ; 61eb: e8 b8 00
loc_61ee:
    jb loc_61d4                                                                 ; 61ee: 72 e4
loc_61f0:
    call near toggle_courtship_platform_cell                                                          ; 61f0: e8 52 00
loc_61f3:
    call near erase_courtship_moving_object                                                          ; 61f3: e8 35 00
loc_61f6:
    call near draw_courtship_moving_object                                                          ; 61f6: e8 01 00
loc_61f9:
    ret                                                                         ; 61f9: c3
; CS:61fa — draw_courtship_moving_object
; Selects one of six 16x8 frames per direction using the capped animation phase and saves thirty-two background bytes at DS:70CC.
draw_courtship_moving_object:
    mov ax, 0xb800                                                              ; 61fa: b8 00 b8
loc_61fd:
    mov es, ax                                                                  ; 61fd: 8e c0
loc_61ff:
    mov byte [courtship_object_background_absent], 0                                                        ; 61ff: c6 06 f7 70 00
loc_6204:
    mov ax, word [courtship_object_animation_phase]                                                       ; 6204: a1 f0 70
loc_6207:
    and ax, strict word 0x1e0                                                   ; 6207: 25 e0 01
loc_620a:
    add ax, strict word 0x6f30                                                  ; 620a: 05 30 6f
loc_620d:
    cmp byte [courtship_object_horizontal_direction], strict byte 0xff                                         ; 620d: 80 3e f6 70 ff
loc_6212:
    je loc_6217                                                                 ; 6212: 74 03
loc_6214:
    add ax, strict word 0xc0                                                    ; 6214: 05 c0 00
loc_6217:
    load16 mov, si, ax                                                          ; 6217: 8b f0
loc_6219:
    mov di, word [courtship_object_next_video_offset]                                                       ; 6219: 8b 3e fa 70
loc_621d:
    mov word [courtship_object_saved_video_offset], di                                                       ; 621d: 89 3e f8 70
loc_6221:
    mov bp, 0x70cc                                                              ; 6221: bd cc 70
loc_6224:
    mov cx, 0x802                                                               ; 6224: b9 02 08
loc_6227:
    call near blit_zero_transparent                                             ; 6227: e8 a2 ca
loc_622a:
    ret                                                                         ; 622a: c3
; CS:622b — erase_courtship_moving_object
; Copies the saved 16x8 rectangle from DS:70CC to the previous CGA position when its background-absent flag is zero.
erase_courtship_moving_object:
    cmp byte [courtship_object_background_absent], strict byte 0                                            ; 622b: 80 3e f7 70 00
loc_6230:
    jne loc_6244                                                                ; 6230: 75 12
loc_6232:
    mov ax, 0xb800                                                              ; 6232: b8 00 b8
loc_6235:
    mov es, ax                                                                  ; 6235: 8e c0
loc_6237:
    mov si, 0x70cc                                                              ; 6237: be cc 70
loc_623a:
    mov di, word [courtship_object_saved_video_offset]                                                       ; 623a: 8b 3e f8 70
loc_623e:
    mov cx, 0x802                                                               ; 623e: b9 02 08
loc_6241:
    call near copy_rectangle_to_cga                                             ; 6241: e8 59 cb
loc_6244:
    ret                                                                         ; 6244: c3
; CS:6245 — toggle_courtship_platform_cell
; Quantizes object position to a platform row and interior column; XORs bit one of a newly visited cell, then erases the object, redraws the cell and redraws the object.
toggle_courtship_platform_cell:
    mov al, byte [courtship_object_y]                                                       ; 6245: a0 f5 70
loc_6248:
    sub al, 8                                                                   ; 6248: 2c 08
loc_624a:
    and al, 0xf8                                                                ; 624a: 24 f8
loc_624c:
    mov cx, 7                                                                   ; 624c: b9 07 00
loc_624f:
    load16 mov, bx, cx                                                          ; 624f: 8b d9
loc_6251:
    dec bx                                                                      ; 6251: 4b
loc_6252:
    cmp al, byte [bx + courtship_platform_y]                                                  ; 6252: 3a 87 d4 2b
loc_6256:
    je loc_625b                                                                 ; 6256: 74 03
loc_6258:
    loop loc_624f                                                               ; 6258: e2 f5
loc_625a:
    ret                                                                         ; 625a: c3
loc_625b:
    mov ax, word [courtship_object_x]                                                       ; 625b: a1 f3 70
loc_625e:
    mov cl, 4                                                                   ; 625e: b1 04
loc_6260:
    shr ax, cl                                                                  ; 6260: d3 e8
loc_6262:
    sub ax, strict word 2                                                       ; 6262: 2d 02 00
loc_6265:
    jb loc_625a                                                                 ; 6265: 72 f3
loc_6267:
    cmp ax, strict word 0x10                                                    ; 6267: 3d 10 00
loc_626a:
    jae loc_625a                                                                ; 626a: 73 ee
loc_626c:
    load16 mov, di, ax                                                          ; 626c: 8b f8
loc_626e:
    mov dl, byte [bx + courtship_platform_row_offsets]                                                  ; 626e: 8a 97 db 2b
loc_6272:
    load8 sub, dh, dh                                                           ; 6272: 2a f6
loc_6274:
    load16 add, ax, dx                                                          ; 6274: 03 c2
loc_6276:
    cmp ax, word [courtship_object_last_cell]                                                       ; 6276: 3b 06 ec 70
loc_627a:
    je loc_625a                                                                 ; 627a: 74 de
loc_627c:
    mov word [courtship_object_last_cell], ax                                                       ; 627c: a3 ec 70
loc_627f:
    load16 mov, si, ax                                                          ; 627f: 8b f0
loc_6281:
    xor byte [si + courtship_platform_cells], strict byte 2                                       ; 6281: 80 b4 e2 2b 02
loc_6286:
    mov al, byte [si + courtship_platform_cells]                                                  ; 6286: 8a 84 e2 2b
loc_628a:
    load8 sub, ah, ah                                                           ; 628a: 2a e4
loc_628c:
    shl di, 1                                                                   ; 628c: d1 e7
loc_628e:
    mov cx, word [di + courtship_object_cell_draw_x]                                                  ; 628e: 8b 8d fc 70
loc_6292:
    mov dl, byte [bx + courtship_object_cell_draw_y]                                                  ; 6292: 8a 97 20 71
loc_6296:
    push ax                                                                     ; 6296: 50
loc_6297:
    push cx                                                                     ; 6297: 51
loc_6298:
    push dx                                                                     ; 6298: 52
loc_6299:
    call near erase_courtship_moving_object                                                          ; 6299: e8 8f ff
loc_629c:
    pop dx                                                                      ; 629c: 5a
loc_629d:
    pop cx                                                                      ; 629d: 59
loc_629e:
    pop bx                                                                      ; 629e: 5b
loc_629f:
    call near loc_30e3                                                          ; 629f: e8 41 ce
loc_62a2:
    call near draw_courtship_moving_object                                                          ; 62a2: e8 55 ff
loc_62a5:
    ret                                                                         ; 62a5: c3
; CS:62a6 — check_courtship_moving_object_contact
; An active 16x8 object overlapping the player forces downward speed two, acceleration 20h and eight updates of support lockout; returns carry without setting failure.
check_courtship_moving_object_contact:
    cmp byte [courtship_object_active], strict byte 0                                            ; 62a6: 80 3e f2 70 00
loc_62ab:
    jne loc_62af                                                                ; 62ab: 75 02
loc_62ad:
    clc                                                                         ; 62ad: f8
loc_62ae:
    ret                                                                         ; 62ae: c3
loc_62af:
    mov ax, word [courtship_object_x]                                                       ; 62af: a1 f3 70
loc_62b2:
    mov dl, byte [courtship_object_y]                                                       ; 62b2: 8a 16 f5 70
loc_62b6:
    mov si, 0x10                                                                ; 62b6: be 10 00
loc_62b9:
    mov bx, word [player_x]                                                     ; 62b9: 8b 1e 79 05
loc_62bd:
    mov dh, byte [player_y]                                                     ; 62bd: 8a 36 7b 05
loc_62c1:
    mov di, 0x18                                                                ; 62c1: bf 18 00
loc_62c4:
    mov cx, 0xe08                                                               ; 62c4: b9 08 0e
loc_62c7:
    call near rectangles_overlap                                                ; 62c7: e8 5f cb
loc_62ca:
    jae loc_62ea                                                                ; 62ca: 73 1e
loc_62cc:
    mov byte [player_vertical_direction], 1                                     ; 62cc: c6 06 71 05 01
loc_62d1:
    mov byte [player_vertical_speed], 2                                         ; 62d1: c6 06 76 05 02
loc_62d6:
    mov byte [player_vertical_acceleration_step], 0x20                          ; 62d6: c6 06 78 05 20
loc_62db:
    mov byte [0x55b], 8                                                         ; 62db: c6 06 5b 05 08
loc_62e0:
    mov ax, 0x91d                                                               ; 62e0: b8 1d 09
loc_62e3:
    mov bx, 0xce4                                                               ; 62e3: bb e4 0c
loc_62e6:
    call near start_two_stage_sound                                             ; 62e6: e8 52 f6
loc_62e9:
    stc                                                                         ; 62e9: f9
loc_62ea:
    ret                                                                         ; 62ea: c3
