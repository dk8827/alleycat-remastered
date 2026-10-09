; Shared room object: floor-mark tracking, pursuit, bounce contact and saved background.
; Original CS:3150..34A0 (end exclusive).

; CS:3150 — update_shared_room_object
; Uses the per-scene BIOS-tick interval, visits floor-mark columns, and otherwise chooses wandering or player-directed motion from distance, elapsed room time and a random accumulator; moves eight pixels horizontally and two vertically.
update_shared_room_object:
    load8 sub, ah, ah                                                           ; 3150: 2a e4
loc_3152:
    int 0x1a                                                                    ; 3152: cd 1a
loc_3154:
    mov bx, word [scene_index]                                                  ; 3154: 8b 1e 04 00
loc_3158:
    shl bl, 1                                                                   ; 3158: d0 e3
loc_315a:
    mov cx, word [bx + shared_object_scene_tick_intervals]                                                  ; 315a: 8b 8f f2 32
loc_315e:
    load16 mov, ax, dx                                                          ; 315e: 8b c2
loc_3160:
    sub ax, word [shared_object_last_tick]                                                       ; 3160: 2b 06 8c 32
loc_3164:
    load16 cmp, ax, cx                                                          ; 3164: 3b c1
loc_3166:
    jae loc_3169                                                                ; 3166: 73 01
loc_3168:
    ret                                                                         ; 3168: c3
loc_3169:
    mov word [shared_object_last_tick], dx                                                       ; 3169: 89 16 8c 32
loc_316d:
    call near check_shared_room_object_contact                                                          ; 316d: e8 4a 02
loc_3170:
    jb loc_3168                                                                 ; 3170: 72 f6
loc_3172:
    call near loc_21e0                                                          ; 3172: e8 6b f0
loc_3175:
    jb loc_3168                                                                 ; 3175: 72 f1
loc_3177:
    inc byte [shared_object_decision_counter]                                                           ; 3177: fe 06 ea 32
loc_317b:
    call near update_random_state                                               ; 317b: e8 7f fc
loc_317e:
    mov al, byte [shared_object_decision_counter]                                                       ; 317e: a0 ea 32
loc_3181:
    load8 and, al, dl                                                           ; 3181: 22 c2
loc_3183:
    xor byte [shared_object_decision_accumulator], al                                                       ; 3183: 30 06 eb 32
loc_3187:
    mov ax, word [shared_object_x]                                                       ; 3187: a1 7d 32
loc_318a:
    sub ax, word [player_x]                                                     ; 318a: 2b 06 79 05
loc_318e:
    mov dl, 0xff                                                                ; 318e: b2 ff
loc_3190:
    jae loc_3196                                                                ; 3190: 73 04
loc_3192:
    not ax                                                                      ; 3192: f7 d0
loc_3194:
    mov dl, 1                                                                   ; 3194: b2 01
loc_3196:
    mov byte [shared_object_direction_to_player_x], dl                                                       ; 3196: 88 16 ed 32
loc_319a:
    mov bl, byte [shared_object_y]                                                       ; 319a: 8a 1e 7f 32
loc_319e:
    add bl, strict byte 0x14                                                    ; 319e: 80 c3 14
loc_31a1:
    sub bl, byte [player_y]                                                     ; 31a1: 2a 1e 7b 05
loc_31a5:
    mov dl, 0xff                                                                ; 31a5: b2 ff
loc_31a7:
    jae loc_31ad                                                                ; 31a7: 73 04
loc_31a9:
    not bl                                                                      ; 31a9: f6 d3
loc_31ab:
    mov dl, 1                                                                   ; 31ab: b2 01
loc_31ad:
    mov byte [shared_object_direction_to_player_y], dl                                                       ; 31ad: 88 16 ee 32
loc_31b1:
    shr ax, 1                                                                   ; 31b1: d1 e8
loc_31b3:
    shr ax, 1                                                                   ; 31b3: d1 e8
loc_31b5:
    shr bl, 1                                                                   ; 31b5: d0 eb
loc_31b7:
    load8 add, al, bl                                                           ; 31b7: 02 c3
loc_31b9:
    mov byte [shared_object_player_distance], al                                                       ; 31b9: a2 ec 32
loc_31bc:
    mov bx, word [shared_object_mark_column]                                                       ; 31bc: 8b 1e 8a 32
loc_31c0:
    cmp bx, strict byte 0x27                                                    ; 31c0: 83 fb 27
loc_31c3:
    jb loc_31cc                                                                 ; 31c3: 72 07
loc_31c5:
    mov bx, 0x26                                                                ; 31c5: bb 26 00
loc_31c8:
    mov word [shared_object_mark_column], bx                                                       ; 31c8: 89 1e 8a 32
loc_31cc:
    cmp byte [bx + floor_mark_counts], strict byte 0                                       ; 31cc: 80 bf 8e 32 00
loc_31d1:
    jne loc_324b                                                                ; 31d1: 75 78
loc_31d3:
    dec word [shared_object_mark_column]                                                           ; 31d3: ff 0e 8a 32
loc_31d7:
    load8 sub, ah, ah                                                           ; 31d7: 2a e4
loc_31d9:
    int 0x1a                                                                    ; 31d9: cd 1a
loc_31db:
    sub dx, word [scene_entry_tick]                                             ; 31db: 2b 16 10 04
loc_31df:
    mov cl, 3                                                                   ; 31df: b1 03
loc_31e1:
    shr dx, cl                                                                  ; 31e1: d3 ea
loc_31e3:
    mov al, byte [shared_object_player_distance]                                                       ; 31e3: a0 ec 32
loc_31e6:
    load8 sub, al, dl                                                           ; 31e6: 2a c2
loc_31e8:
    jae loc_31ec                                                                ; 31e8: 73 02
loc_31ea:
    load8 sub, al, al                                                           ; 31ea: 2a c0
loc_31ec:
    cmp al, byte [shared_object_decision_accumulator]                                                       ; 31ec: 3a 06 eb 32
loc_31f0:
    jb loc_3212                                                                 ; 31f0: 72 20
loc_31f2:
    mov byte [shared_object_vertical_direction], 1                                                        ; 31f2: c6 06 81 32 01
loc_31f7:
    call near update_random_state                                               ; 31f7: e8 03 fc
loc_31fa:
    cmp dl, strict byte 0                                                       ; 31fa: 80 fa 00
loc_31fd:
    je loc_320b                                                                 ; 31fd: 74 0c
loc_31ff:
    cmp dl, strict byte 7                                                       ; 31ff: 80 fa 07
loc_3202:
    ja loc_320f                                                                 ; 3202: 77 0b
loc_3204:
    and dl, strict byte 1                                                       ; 3204: 80 e2 01
loc_3207:
    jne loc_320b                                                                ; 3207: 75 02
loc_3209:
    mov dl, 0xff                                                                ; 3209: b2 ff
loc_320b:
    mov byte [shared_object_horizontal_direction], dl                                                       ; 320b: 88 16 80 32
loc_320f:
    jmp near loc_32ac                                                           ; 320f: e9 9a 00
loc_3212:
    mov al, byte [shared_object_decision_accumulator]                                                       ; 3212: a0 eb 32
loc_3215:
    and al, 0x2f                                                                ; 3215: 24 2f
loc_3217:
    jne loc_3238                                                                ; 3217: 75 1f
loc_3219:
    call near update_random_state                                               ; 3219: e8 e1 fb
loc_321c:
    and dl, strict byte 1                                                       ; 321c: 80 e2 01
loc_321f:
    jne loc_3223                                                                ; 321f: 75 02
loc_3221:
    mov dl, 0xff                                                                ; 3221: b2 ff
loc_3223:
    mov byte [shared_object_horizontal_direction], dl                                                       ; 3223: 88 16 80 32
loc_3227:
    call near update_random_state                                               ; 3227: e8 d3 fb
loc_322a:
    and dl, strict byte 1                                                       ; 322a: 80 e2 01
loc_322d:
    jne loc_3231                                                                ; 322d: 75 02
loc_322f:
    mov dl, 0xff                                                                ; 322f: b2 ff
loc_3231:
    mov byte [shared_object_vertical_direction], dl                                                       ; 3231: 88 16 81 32
loc_3235:
    jmp short loc_32ac                                                          ; 3235: eb 75
loc_3237:
    nop                                                                         ; 3237: 90
loc_3238:
    and al, 7                                                                   ; 3238: 24 07
loc_323a:
    jne loc_32ac                                                                ; 323a: 75 70
loc_323c:
    mov al, byte [shared_object_direction_to_player_x]                                                       ; 323c: a0 ed 32
loc_323f:
    mov byte [shared_object_horizontal_direction], al                                                       ; 323f: a2 80 32
loc_3242:
    mov al, byte [shared_object_direction_to_player_y]                                                       ; 3242: a0 ee 32
loc_3245:
    mov byte [shared_object_vertical_direction], al                                                       ; 3245: a2 81 32
loc_3248:
    jmp short loc_32ac                                                          ; 3248: eb 62
loc_324a:
    nop                                                                         ; 324a: 90
loc_324b:
    mov byte [shared_object_vertical_direction], 1                                                        ; 324b: c6 06 81 32 01
loc_3250:
    load16 mov, ax, bx                                                          ; 3250: 8b c3
loc_3252:
    mov cl, 3                                                                   ; 3252: b1 03
loc_3254:
    shl ax, cl                                                                  ; 3254: d3 e0
loc_3256:
    cmp word [shared_object_x], ax                                                       ; 3256: 39 06 7d 32
loc_325a:
    je loc_3269                                                                 ; 325a: 74 0d
loc_325c:
    mov dl, 1                                                                   ; 325c: b2 01
loc_325e:
    jb loc_3262                                                                 ; 325e: 72 02
loc_3260:
    mov dl, 0xff                                                                ; 3260: b2 ff
loc_3262:
    mov byte [shared_object_horizontal_direction], dl                                                       ; 3262: 88 16 80 32
loc_3266:
    jmp short loc_32ac                                                          ; 3266: eb 44
loc_3268:
    nop                                                                         ; 3268: 90
loc_3269:
    mov byte [shared_object_horizontal_direction], 0                                                        ; 3269: c6 06 80 32 00
loc_326e:
    cmp byte [shared_object_y], strict byte 0xa5                                         ; 326e: 80 3e 7f 32 a5
loc_3273:
    jne loc_32ac                                                                ; 3273: 75 37
loc_3275:
    mov byte [shared_object_vertical_direction], 0                                                        ; 3275: c6 06 81 32 00
loc_327a:
    cmp word [shared_object_animation_offset], strict byte 6                                            ; 327a: 83 3e 7a 32 06
loc_327f:
    je loc_3288                                                                 ; 327f: 74 07
loc_3281:
    cmp word [shared_object_animation_offset], strict byte 0x12                                         ; 3281: 83 3e 7a 32 12
loc_3286:
    jne loc_32ac                                                                ; 3286: 75 24
loc_3288:
    push bx                                                                     ; 3288: 53
loc_3289:
    mov si, 0x31e8                                                              ; 3289: be e8 31
loc_328c:
    mov di, word [shared_object_saved_video_offset]                                                       ; 328c: 8b 3e 82 32
loc_3290:
    mov cx, 0x1e02                                                              ; 3290: b9 02 1e
loc_3293:
    mov ax, 0xb800                                                              ; 3293: b8 00 b8
loc_3296:
    mov es, ax                                                                  ; 3296: 8e c0
loc_3298:
    call near copy_rectangle_to_cga                                             ; 3298: e8 02 fb
loc_329b:
    pop bx                                                                      ; 329b: 5b
loc_329c:
    dec byte [bx + floor_mark_counts]                                                      ; 329c: fe 8f 8e 32
loc_32a0:
    mov al, byte [bx + floor_mark_counts]                                                  ; 32a0: 8a 87 8e 32
loc_32a4:
    call near draw_floor_mark                                                          ; 32a4: e8 d8 01
loc_32a7:
    mov byte [shared_object_background_absent], 1                                                        ; 32a7: c6 06 86 32 01
loc_32ac:
    mov cx, word [shared_object_x]                                                       ; 32ac: 8b 0e 7d 32
loc_32b0:
    mov dl, byte [shared_object_y]                                                       ; 32b0: 8a 16 7f 32
loc_32b4:
    mov word [shared_object_previous_x], cx                                                       ; 32b4: 89 0e ef 32
loc_32b8:
    mov byte [shared_object_previous_y], dl                                                       ; 32b8: 88 16 f1 32
loc_32bc:
    cmp byte [shared_object_horizontal_direction], strict byte 1                                            ; 32bc: 80 3e 80 32 01
loc_32c1:
    jb loc_32da                                                                 ; 32c1: 72 17
loc_32c3:
    jne loc_32d3                                                                ; 32c3: 75 0e
loc_32c5:
    add cx, strict byte 8                                                       ; 32c5: 83 c1 08
loc_32c8:
    cmp cx, strict word 0x131                                                   ; 32c8: 81 f9 31 01
loc_32cc:
    jb loc_32da                                                                 ; 32cc: 72 0c
loc_32ce:
    mov cx, 0x130                                                               ; 32ce: b9 30 01
loc_32d1:
    jmp short loc_32da                                                          ; 32d1: eb 07
loc_32d3:
    sub cx, strict byte 8                                                       ; 32d3: 83 e9 08
loc_32d6:
    jae loc_32da                                                                ; 32d6: 73 02
loc_32d8:
    load16 sub, cx, cx                                                          ; 32d8: 2b c9
loc_32da:
    and cx, strict word 0xfff8                                                  ; 32da: 81 e1 f8 ff
loc_32de:
    mov word [shared_object_x], cx                                                       ; 32de: 89 0e 7d 32
loc_32e2:
    cmp byte [shared_object_vertical_direction], strict byte 1                                            ; 32e2: 80 3e 81 32 01
loc_32e7:
    jb loc_32fe                                                                 ; 32e7: 72 15
loc_32e9:
    jne loc_32f7                                                                ; 32e9: 75 0c
loc_32eb:
    add dl, strict byte 2                                                       ; 32eb: 80 c2 02
loc_32ee:
    cmp dl, strict byte 0xa6                                                    ; 32ee: 80 fa a6
loc_32f1:
    jb loc_32fe                                                                 ; 32f1: 72 0b
loc_32f3:
    mov dl, 0xa5                                                                ; 32f3: b2 a5
loc_32f5:
    jmp short loc_32fe                                                          ; 32f5: eb 07
loc_32f7:
    sub dl, strict byte 2                                                       ; 32f7: 80 ea 02
loc_32fa:
    jae loc_32fe                                                                ; 32fa: 73 02
loc_32fc:
    load8 sub, dl, dl                                                           ; 32fc: 2a d2
loc_32fe:
    mov byte [shared_object_y], dl                                                       ; 32fe: 88 16 7f 32
loc_3302:
    call near calculate_cga_address                                             ; 3302: e8 ab f9
loc_3305:
    mov word [shared_object_next_video_offset], ax                                                       ; 3305: a3 84 32
loc_3308:
    call near check_shared_room_object_contact                                                          ; 3308: e8 af 00
loc_330b:
    jae loc_3328                                                                ; 330b: 73 1b
loc_330d:
    mov byte [shared_object_horizontal_direction], 0                                                        ; 330d: c6 06 80 32 00
loc_3312:
    mov byte [shared_object_vertical_direction], 0                                                        ; 3312: c6 06 81 32 00
loc_3317:
    mov cx, word [shared_object_previous_x]                                                       ; 3317: 8b 0e ef 32
loc_331b:
    mov word [shared_object_x], cx                                                       ; 331b: 89 0e 7d 32
loc_331f:
    mov dl, byte [shared_object_previous_y]                                                       ; 331f: 8a 16 f1 32
loc_3323:
    mov byte [shared_object_y], dl                                                       ; 3323: 88 16 7f 32
loc_3327:
    ret                                                                         ; 3327: c3
loc_3328:
    call near loc_21e0                                                          ; 3328: e8 b5 ee
loc_332b:
    jb loc_330d                                                                 ; 332b: 72 e0
loc_332d:
    call near erase_shared_room_object                                                          ; 332d: e8 70 00
loc_3330:
    add word [shared_object_animation_offset], strict byte 2                                            ; 3330: 83 06 7a 32 02
loc_3335:
    call near draw_shared_room_object                                                          ; 3335: e8 01 00
loc_3338:
    ret                                                                         ; 3338: c3
; CS:3339 — draw_shared_room_object
; Cycles a zero-terminated word-pointer animation table and ORs a 16x30 sprite into CGA while saving 120 background bytes at DS:31E8.
draw_shared_room_object:
    mov bx, word [shared_object_animation_offset]                                                       ; 3339: 8b 1e 7a 32
loc_333d:
    mov ax, word [bx + shared_object_animation_pointers]                                                  ; 333d: 8b 87 60 32
loc_3341:
    cmp ax, strict word 0                                                       ; 3341: 3d 00 00
loc_3344:
    jne loc_334b                                                                ; 3344: 75 05
loc_3346:
    mov word [shared_object_animation_offset], ax                                                       ; 3346: a3 7a 32
loc_3349:
    jmp short draw_shared_room_object                                                          ; 3349: eb ee
loc_334b:
    load16 mov, si, ax                                                          ; 334b: 8b f0
loc_334d:
    mov di, word [shared_object_next_video_offset]                                                       ; 334d: 8b 3e 84 32
loc_3351:
    mov word [shared_object_saved_video_offset], di                                                       ; 3351: 89 3e 82 32
loc_3355:
    mov bp, 0x31e8                                                              ; 3355: bd e8 31
loc_3358:
    mov ax, 0xb800                                                              ; 3358: b8 00 b8
loc_335b:
    mov es, ax                                                                  ; 335b: 8e c0
loc_335d:
    mov cx, 0x1e02                                                              ; 335d: b9 02 1e
loc_3360:
    mov byte [shared_object_background_absent], 0                                                        ; 3360: c6 06 86 32 00
loc_3365:
    cld                                                                         ; 3365: fc
loc_3366:
    mov byte [0x3289], ch                                                       ; 3366: 88 2e 89 32
loc_336a:
    load8 sub, ch, ch                                                           ; 336a: 2a ed
loc_336c:
    mov word [0x3287], cx                                                       ; 336c: 89 0e 87 32
loc_3370:
    mov cx, word [0x3287]                                                       ; 3370: 8b 0e 87 32
loc_3374:
    mov bx, word [es:di]                                                        ; 3374: 26 8b 1d
loc_3377:
    mov word [ds:bp], bx                                                        ; 3377: 3e 89 5e 00
loc_337b:
    lodsw                                                                       ; 337b: ad
loc_337c:
    load16 or, ax, bx                                                           ; 337c: 0b c3
loc_337e:
    stosw                                                                       ; 337e: ab
loc_337f:
    add bp, strict byte 2                                                       ; 337f: 83 c5 02
loc_3382:
    loop loc_3374                                                               ; 3382: e2 f0
loc_3384:
    sub di, word [0x3287]                                                       ; 3384: 2b 3e 87 32
loc_3388:
    sub di, word [0x3287]                                                       ; 3388: 2b 3e 87 32
loc_338c:
    xor di, strict word 0x2000                                                  ; 338c: 81 f7 00 20
loc_3390:
    test di, 0x2000                                                             ; 3390: f7 c7 00 20
loc_3394:
    jne loc_3399                                                                ; 3394: 75 03
loc_3396:
    add di, strict byte 0x50                                                    ; 3396: 83 c7 50
loc_3399:
    dec byte [0x3289]                                                           ; 3399: fe 0e 89 32
loc_339d:
    jne loc_3370                                                                ; 339d: 75 d1
loc_339f:
    ret                                                                         ; 339f: c3
; CS:33a0 — erase_shared_room_object
; Restores the saved 16x30 CGA rectangle only when the background-absent flag is zero.
erase_shared_room_object:
    cmp byte [shared_object_background_absent], strict byte 0                                            ; 33a0: 80 3e 86 32 00
loc_33a5:
    jne loc_33b9                                                                ; 33a5: 75 12
loc_33a7:
    mov ax, 0xb800                                                              ; 33a7: b8 00 b8
loc_33aa:
    mov es, ax                                                                  ; 33aa: 8e c0
loc_33ac:
    mov si, 0x31e8                                                              ; 33ac: be e8 31
loc_33af:
    mov di, word [shared_object_saved_video_offset]                                                       ; 33af: 8b 3e 82 32
loc_33b3:
    mov cx, 0x1e02                                                              ; 33b3: b9 02 1e
loc_33b6:
    call near copy_rectangle_to_cga                                             ; 33b6: e8 e4 f9
loc_33b9:
    ret                                                                         ; 33b9: c3
; CS:33ba — check_shared_room_object_contact
; Skips player contact during enemy capture, delegates active eating in scene six, and otherwise checks a 16x30 rectangle; ordinary contact bounces the player, while cheese transfer suppresses that bounce.
check_shared_room_object_contact:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 33ba: 80 3e b8 1c 00
loc_33bf:
    jne loc_3403                                                                ; 33bf: 75 42
loc_33c1:
    cmp word [scene_index], strict byte 6                                       ; 33c1: 83 3e 04 00 06
loc_33c6:
    jne loc_33d3                                                                ; 33c6: 75 0b
loc_33c8:
    cmp byte [0x44bd], strict byte 0                                            ; 33c8: 80 3e bd 44 00
loc_33cd:
    je loc_33d3                                                                 ; 33cd: 74 04
loc_33cf:
    call near loc_47b0                                                          ; 33cf: e8 de 13
loc_33d2:
    ret                                                                         ; 33d2: c3
loc_33d3:
    mov ax, word [shared_object_x]                                                       ; 33d3: a1 7d 32
loc_33d6:
    mov dl, byte [shared_object_y]                                                       ; 33d6: 8a 16 7f 32
loc_33da:
    mov si, 0x10                                                                ; 33da: be 10 00
loc_33dd:
    mov bx, word [player_x]                                                     ; 33dd: 8b 1e 79 05
loc_33e1:
    mov dh, byte [player_y]                                                     ; 33e1: 8a 36 7b 05
loc_33e5:
    mov di, 0x18                                                                ; 33e5: bf 18 00
loc_33e8:
    mov cx, 0xe1e                                                               ; 33e8: b9 1e 0e
loc_33eb:
    call near rectangles_overlap                                                ; 33eb: e8 3b fa
loc_33ee:
    jae loc_3403                                                                ; 33ee: 73 13
loc_33f0:
    cmp word [scene_index], strict byte 4                                       ; 33f0: 83 3e 04 00 04
loc_33f5:
    jne loc_33fe                                                                ; 33f5: 75 07
loc_33f7:
    cmp byte [0x39e1], strict byte 0                                            ; 33f7: 80 3e e1 39 00
loc_33fc:
    jne loc_3401                                                                ; 33fc: 75 03
loc_33fe:
    call near apply_room_object_bounce                                                          ; 33fe: e8 71 d4
loc_3401:
    stc                                                                         ; 3401: f9
loc_3402:
    ret                                                                         ; 3402: c3
loc_3403:
    clc                                                                         ; 3403: f8
loc_3404:
    ret                                                                         ; 3404: c3
; CS:3405 — initialize_shared_room_object
; Clears forty floor-mark counters, resets the visited-column sentinel, starts the object at (0,160) with no saved background, and seeds its decision accumulator from RNG.
initialize_shared_room_object:
    cld                                                                         ; 3405: fc
loc_3406:
    load16 sub, ax, ax                                                          ; 3406: 2b c0
loc_3408:
    push ds                                                                     ; 3408: 1e
loc_3409:
    pop es                                                                      ; 3409: 07
loc_340a:
    mov di, 0x328e                                                              ; 340a: bf 8e 32
loc_340d:
    mov cx, 0x14                                                                ; 340d: b9 14 00
loc_3410:
    rep stosw                                                                   ; 3410: f3 ab
loc_3412:
    mov word [floor_mark_previous_column], 0xff                                                     ; 3412: c7 06 b6 32 ff 00
loc_3418:
    mov word [shared_object_animation_offset], 0                                                        ; 3418: c7 06 7a 32 00 00
loc_341e:
    mov word [shared_object_x], 0                                                        ; 341e: c7 06 7d 32 00 00
loc_3424:
    mov byte [shared_object_y], 0xa0                                                     ; 3424: c6 06 7f 32 a0
loc_3429:
    mov byte [shared_object_background_absent], 1                                                        ; 3429: c6 06 86 32 01
loc_342e:
    mov byte [shared_object_horizontal_direction], 0                                                        ; 342e: c6 06 80 32 00
loc_3433:
    mov byte [shared_object_vertical_direction], 0                                                        ; 3433: c6 06 81 32 00
loc_3438:
    call near update_random_state                                               ; 3438: e8 c2 f9
loc_343b:
    mov byte [shared_object_decision_accumulator], dl                                                       ; 343b: 88 16 eb 32
loc_343f:
    mov byte [shared_object_decision_counter], 0x6c                                                     ; 343f: c6 06 ea 32 6c
loc_3444:
    ret                                                                         ; 3444: c3
; CS:3445 — record_floor_mark
; For horizontal player motion at Y>=180, maps (X+12)/8 to a column; entering a different valid column increments its mark count up to four and redraws it.
record_floor_mark:
    cmp byte [player_y], strict byte 0xb4                                       ; 3445: 80 3e 7b 05 b4
loc_344a:
    jb loc_347e                                                                 ; 344a: 72 32
loc_344c:
    cmp byte [player_horizontal_direction], strict byte 0                       ; 344c: 80 3e 6e 05 00
loc_3451:
    je loc_347e                                                                 ; 3451: 74 2b
loc_3453:
    mov ax, word [player_x]                                                     ; 3453: a1 79 05
loc_3456:
    add ax, strict word 0xc                                                     ; 3456: 05 0c 00
loc_3459:
    mov cl, 3                                                                   ; 3459: b1 03
loc_345b:
    shr ax, cl                                                                  ; 345b: d3 e8
loc_345d:
    cmp ax, strict word 0x27                                                    ; 345d: 3d 27 00
loc_3460:
    ja loc_347e                                                                 ; 3460: 77 1c
loc_3462:
    cmp ax, word [floor_mark_previous_column]                                                       ; 3462: 3b 06 b6 32
loc_3466:
    je loc_347e                                                                 ; 3466: 74 16
loc_3468:
    mov word [floor_mark_previous_column], ax                                                       ; 3468: a3 b6 32
loc_346b:
    load16 mov, bx, ax                                                          ; 346b: 8b d8
loc_346d:
    mov al, byte [bx + floor_mark_counts]                                                  ; 346d: 8a 87 8e 32
loc_3471:
    cmp al, 4                                                                   ; 3471: 3c 04
loc_3473:
    jae loc_347e                                                                ; 3473: 73 09
loc_3475:
    inc al                                                                      ; 3475: fe c0
loc_3477:
    mov byte [bx + floor_mark_counts], al                                                  ; 3477: 88 87 8e 32
loc_347b:
    call near draw_floor_mark                                                          ; 347b: e8 01 00
loc_347e:
    ret                                                                         ; 347e: c3
; CS:347f — draw_floor_mark
; Draws the ten-byte image selected by mark count at CGA offset 1E00+2*column, covering eight pixels by five rows.
draw_floor_mark:
    mov ah, 0xa                                                                 ; 347f: b4 0a
loc_3481:
    mul ah                                                                      ; 3481: f6 e4
loc_3483:
    add ax, strict word 0x32b8                                                  ; 3483: 05 b8 32
loc_3486:
    load16 mov, si, ax                                                          ; 3486: 8b f0
loc_3488:
    load16 mov, di, bx                                                          ; 3488: 8b fb
loc_348a:
    shl di, 1                                                                   ; 348a: d1 e7
loc_348c:
    add di, strict word 0x1e00                                                  ; 348c: 81 c7 00 1e
loc_3490:
    mov ax, 0xb800                                                              ; 3490: b8 00 b8
loc_3493:
    mov es, ax                                                                  ; 3493: 8e c0
loc_3495:
    mov cx, 0x501                                                               ; 3495: b9 01 05
loc_3498:
    call near copy_rectangle_to_cga                                             ; 3498: e8 02 f9
loc_349b:
    ret                                                                         ; 349b: c3
    times 4 db 0 ; original zero fill at CS:349c
