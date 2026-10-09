; Aquarium fish, hazards and object arrays.
; Original CS:34A0..3850 (end exclusive).

; CS:34a0 — check_aquarium_contacts
; Checks 24 object slots: first twelve are collectibles, remaining twelve hazards. Final collectible sets scene_complete unless protected; unprotected hazard sets scene_failed.
check_aquarium_contacts:
    mov word [0x3511], 0                                                        ; 34a0: c7 06 11 35 00 00
loc_34a6:
    mov byte [0x351b], 0                                                        ; 34a6: c6 06 1b 35 00
loc_34ab:
    mov bx, word [0x3511]                                                       ; 34ab: 8b 1e 11 35
loc_34af:
    cmp byte [bx + aquarium_object_inactive], strict byte 0                     ; 34af: 80 bf a7 34 00
loc_34b4:
    je loc_34b9                                                                 ; 34b4: 74 03
loc_34b6:
    jmp near loc_35ad                                                           ; 34b6: e9 f4 00
loc_34b9:
    load16 mov, si, bx                                                          ; 34b9: 8b f3
loc_34bb:
    shl si, 1                                                                   ; 34bb: d1 e6
loc_34bd:
    mov ax, word [si + aquarium_object_x]                                       ; 34bd: 8b 84 47 34
loc_34c1:
    mov dl, byte [bx + aquarium_object_y]                                       ; 34c1: 8a 97 77 34
loc_34c5:
    mov di, 0                                                                   ; 34c5: bf 00 00
loc_34c8:
    cmp bx, strict byte 0xc                                                     ; 34c8: 83 fb 0c
loc_34cb:
    jb loc_34d0                                                                 ; 34cb: 72 03
loc_34cd:
    mov di, 2                                                                   ; 34cd: bf 02 00
loc_34d0:
    mov si, word [di + 0x3513]                                                  ; 34d0: 8b b5 13 35
loc_34d4:
    mov cx, word [di + 0x3517]                                                  ; 34d4: 8b 8d 17 35
loc_34d8:
    mov bx, word [player_x]                                                     ; 34d8: 8b 1e 79 05
loc_34dc:
    mov dh, byte [player_y]                                                     ; 34dc: 8a 36 7b 05
loc_34e0:
    mov di, 0x18                                                                ; 34e0: bf 18 00
loc_34e3:
    mov ch, 0xe                                                                 ; 34e3: b5 0e
loc_34e5:
    call near rectangles_overlap                                                ; 34e5: e8 41 f9
loc_34e8:
    jae loc_34b6                                                                ; 34e8: 73 cc
loc_34ea:
    mov bx, word [0x3511]                                                       ; 34ea: 8b 1e 11 35
loc_34ee:
    cmp bx, strict byte 0xc                                                     ; 34ee: 83 fb 0c
loc_34f1:
    jb loc_356f                                                                 ; 34f1: 72 7c
loc_34f3:
    cmp byte [scene_complete], strict byte 0                                    ; 34f3: 80 3e 53 05 00
loc_34f8:
    jne loc_356f                                                                ; 34f8: 75 75
loc_34fa:
    cmp byte [aquarium_drowning], strict byte 0                                             ; 34fa: 80 3e f3 05 00
loc_34ff:
    jne loc_356f                                                                ; 34ff: 75 6e
loc_3501:
    mov byte [scene_failed], 1                                                  ; 3501: c6 06 52 05 01
loc_3506:
    mov cx, word [player_x]                                                     ; 3506: 8b 0e 79 05
loc_350a:
    sub cx, strict byte 8                                                       ; 350a: 83 e9 08
loc_350d:
    jae loc_3511                                                                ; 350d: 73 02
loc_350f:
    load16 sub, cx, cx                                                          ; 350f: 2b c9
loc_3511:
    cmp cx, strict word 0x117                                                   ; 3511: 81 f9 17 01
loc_3515:
    jb loc_351a                                                                 ; 3515: 72 03
loc_3517:
    mov cx, 0x116                                                               ; 3517: b9 16 01
loc_351a:
    mov dl, byte [player_y]                                                     ; 351a: 8a 16 7b 05
loc_351e:
    cmp dl, strict byte 0xb5                                                    ; 351e: 80 fa b5
loc_3521:
    jb loc_3525                                                                 ; 3521: 72 02
loc_3523:
    mov dl, 0xb4                                                                ; 3523: b2 b4
loc_3525:
    call near calculate_cga_address                                             ; 3525: e8 88 f7
loc_3528:
    load16 mov, di, ax                                                          ; 3528: 8b f8
loc_352a:
    mov si, 0x3350                                                              ; 352a: be 50 33
loc_352d:
    mov ax, 0xb800                                                              ; 352d: b8 00 b8
loc_3530:
    mov es, ax                                                                  ; 3530: 8e c0
loc_3532:
    mov cx, 0x1205                                                              ; 3532: b9 05 12
loc_3535:
    call near copy_rectangle_to_cga                                             ; 3535: e8 65 f8
loc_3538:
    call near initialize_bitbang_noise                                          ; 3538: e8 5c 22
loc_353b:
    load8 sub, ah, ah                                                           ; 353b: 2a e4
loc_353d:
    int 0x1a                                                                    ; 353d: cd 1a
loc_353f:
    mov word [aquarium_last_batch_tick], dx                                     ; 353f: 89 16 09 35
loc_3543:
    push dx                                                                     ; 3543: 52
loc_3544:
    call near update_bitbang_noise                                              ; 3544: e8 5f 22
loc_3547:
    call near read_cga_vertical_retrace_bit                                     ; 3547: e8 8e de
loc_354a:
    je loc_3544                                                                 ; 354a: 74 f8
loc_354c:
    call near update_bitbang_noise                                              ; 354c: e8 57 22
loc_354f:
    pop dx                                                                      ; 354f: 5a
loc_3550:
    mov bx, 1                                                                   ; 3550: bb 01 00
loc_3553:
    test dl, 1                                                                  ; 3553: f6 c2 01
loc_3556:
    jne loc_355a                                                                ; 3556: 75 02
loc_3558:
    mov bl, 0xf                                                                 ; 3558: b3 0f
loc_355a:
    mov ah, 0xb                                                                 ; 355a: b4 0b
loc_355c:
    int 0x10                                                                    ; 355c: cd 10
loc_355e:
    call near update_bitbang_noise                                              ; 355e: e8 45 22
loc_3561:
    load8 sub, ah, ah                                                           ; 3561: 2a e4
loc_3563:
    int 0x1a                                                                    ; 3563: cd 1a
loc_3565:
    sub dx, word [aquarium_last_batch_tick]                                     ; 3565: 2b 16 09 35
loc_3569:
    cmp dx, strict byte 0xd                                                     ; 3569: 83 fa 0d
loc_356c:
    jb loc_3543                                                                 ; 356c: 72 d5
loc_356e:
    ret                                                                         ; 356e: c3
loc_356f:
    inc byte [0x351b]                                                           ; 356f: fe 06 1b 35
loc_3573:
    mov ax, 0x5dc                                                               ; 3573: b8 dc 05
loc_3576:
    mov bx, 0x425                                                               ; 3576: bb 25 04
loc_3579:
    call near start_two_stage_sound                                             ; 3579: e8 bf 23
loc_357c:
    cmp byte [0x351b], strict byte 1                                            ; 357c: 80 3e 1b 35 01
loc_3581:
    jne loc_3586                                                                ; 3581: 75 03
loc_3583:
    call near restore_player_background                                         ; 3583: e8 5d dc
loc_3586:
    mov bx, word [0x3511]                                                       ; 3586: 8b 1e 11 35
loc_358a:
    call near erase_aquarium_object                                             ; 358a: e8 34 02
loc_358d:
    mov bx, word [0x3511]                                                       ; 358d: 8b 1e 11 35
loc_3591:
    mov byte [bx + aquarium_object_inactive], 1                                 ; 3591: c6 87 a7 34 01
loc_3596:
    cmp bx, strict byte 0xc                                                     ; 3596: 83 fb 0c
loc_3599:
    jae loc_35ad                                                                ; 3599: 73 12
loc_359b:
    dec byte [fish_remaining]                                                   ; 359b: fe 0e 10 34
loc_359f:
    jne loc_35ad                                                                ; 359f: 75 0c
loc_35a1:
    cmp byte [aquarium_drowning], strict byte 0                                             ; 35a1: 80 3e f3 05 00
loc_35a6:
    jne loc_35ad                                                                ; 35a6: 75 05
loc_35a8:
    mov byte [scene_complete], 1                                                ; 35a8: c6 06 53 05 01
loc_35ad:
    inc word [0x3511]                                                           ; 35ad: ff 06 11 35
loc_35b1:
    cmp word [0x3511], strict byte 0x18                                         ; 35b1: 83 3e 11 35 18
loc_35b6:
    jae loc_35bb                                                                ; 35b6: 73 03
loc_35b8:
    jmp near loc_34ab                                                           ; 35b8: e9 f0 fe
loc_35bb:
    cmp byte [0x351b], strict byte 0                                            ; 35bb: 80 3e 1b 35 00
loc_35c0:
    je loc_35c7                                                                 ; 35c0: 74 05
loc_35c2:
    call near loc_363d                                                          ; 35c2: e8 78 00
loc_35c5:
    stc                                                                         ; 35c5: f9
loc_35c6:
    ret                                                                         ; 35c6: c3
loc_35c7:
    clc                                                                         ; 35c7: f8
loc_35c8:
    ret                                                                         ; 35c8: c3
; CS:35c9 — initialize_aquarium_objects
; Initializes 24 object positions/directions/statuses, twelve remaining collectibles, and difficulty-selected initially disabled hazard slots.
initialize_aquarium_objects:
    mov word [aquarium_fish_frame_offset], 0                                    ; 35c9: c7 06 11 34 00 00
loc_35cf:
    mov word [aquarium_update_slot], 0                                          ; 35cf: c7 06 15 34 00 00
loc_35d5:
    mov byte [fish_remaining], 0xc                                              ; 35d5: c6 06 10 34 0c
loc_35da:
    mov cx, 0x18                                                                ; 35da: b9 18 00
loc_35dd:
    load16 mov, bx, cx                                                          ; 35dd: 8b d9
loc_35df:
    dec bx                                                                      ; 35df: 4b
loc_35e0:
    mov byte [bx + aquarium_background_absent], 1                               ; 35e0: c6 87 8f 34 01
loc_35e5:
    mov byte [bx + aquarium_object_inactive], 0                                 ; 35e5: c6 87 a7 34 00
loc_35ea:
    mov al, byte [bx + aquarium_y_minimum]                                      ; 35ea: 8a 87 f1 34
loc_35ee:
    mov byte [bx + aquarium_object_y], al                                       ; 35ee: 88 87 77 34
loc_35f2:
    mov byte [bx + aquarium_vertical_direction], 1                              ; 35f2: c6 87 2f 34 01
loc_35f7:
    call near update_random_state                                               ; 35f7: e8 03 f8
loc_35fa:
    and dl, strict byte 1                                                       ; 35fa: 80 e2 01
loc_35fd:
    jne loc_3601                                                                ; 35fd: 75 02
loc_35ff:
    not dl                                                                      ; 35ff: f6 d2
loc_3601:
    mov byte [bx + aquarium_horizontal_direction], dl                           ; 3601: 88 97 17 34
loc_3605:
    shl bx, 1                                                                   ; 3605: d1 e3
loc_3607:
    call near update_random_state                                               ; 3607: e8 f3 f7
loc_360a:
    load8 sub, dh, dh                                                           ; 360a: 2a f6
loc_360c:
    mov word [bx + aquarium_object_x], dx                                       ; 360c: 89 97 47 34
loc_3610:
    loop loc_35dd                                                               ; 3610: e2 cb
loc_3612:
    mov bx, word [difficulty_level]                                             ; 3612: 8b 1e 08 00
loc_3616:
    mov cl, byte [bx + aquarium_disabled_hazard_counts]                         ; 3616: 8a 8f 1c 35
loc_361a:
    load8 sub, ch, ch                                                           ; 361a: 2a ed
loc_361c:
    call near update_random_state                                               ; 361c: e8 de f7
loc_361f:
    and dl, strict byte 0xf                                                     ; 361f: 80 e2 0f
loc_3622:
    cmp dl, strict byte 0xc                                                     ; 3622: 80 fa 0c
loc_3625:
    jae loc_361c                                                                ; 3625: 73 f5
loc_3627:
    load8 mov, bl, dl                                                           ; 3627: 8a da
loc_3629:
    add bl, strict byte 0xc                                                     ; 3629: 80 c3 0c
loc_362c:
    load8 sub, bh, bh                                                           ; 362c: 2a ff
loc_362e:
    cmp byte [bx + aquarium_object_inactive], strict byte 0                     ; 362e: 80 bf a7 34 00
loc_3633:
    jne loc_361c                                                                ; 3633: 75 e7
loc_3635:
    mov byte [bx + aquarium_object_inactive], 1                                 ; 3635: c6 87 a7 34 01
loc_363a:
    loop loc_361c                                                               ; 363a: e2 e0
loc_363c:
    ret                                                                         ; 363c: c3
loc_363d:
    mov cx, 0xc                                                                 ; 363d: b9 0c 00
loc_3640:
    load16 mov, bx, cx                                                          ; 3640: 8b d9
loc_3642:
    add bx, strict byte 0xb                                                     ; 3642: 83 c3 0b
loc_3645:
    cmp byte [bx + aquarium_object_inactive], strict byte 0                     ; 3645: 80 bf a7 34 00
loc_364a:
    je loc_3672                                                                 ; 364a: 74 26
loc_364c:
    load16 sub, ax, ax                                                          ; 364c: 2b c0
loc_364e:
    mov dl, 1                                                                   ; 364e: b2 01
loc_3650:
    mov byte [bx + aquarium_object_inactive], al                                ; 3650: 88 87 a7 34
loc_3654:
    cmp word [player_x], strict word 0xa0                                       ; 3654: 81 3e 79 05 a0 00
loc_365a:
    ja loc_3661                                                                 ; 365a: 77 05
loc_365c:
    mov ax, 0x12e                                                               ; 365c: b8 2e 01
loc_365f:
    mov dl, 0xff                                                                ; 365f: b2 ff
loc_3661:
    mov byte [bx + aquarium_horizontal_direction], dl                           ; 3661: 88 97 17 34
loc_3665:
    shl bl, 1                                                                   ; 3665: d0 e3
loc_3667:
    mov word [bx + aquarium_object_x], ax                                       ; 3667: 89 87 47 34
loc_366b:
    dec byte [0x351b]                                                           ; 366b: fe 0e 1b 35
loc_366f:
    jne loc_363d                                                                ; 366f: 75 cc
loc_3671:
    ret                                                                         ; 3671: c3
loc_3672:
    loop loc_3640                                                               ; 3672: e2 cc
loc_3674:
    ret                                                                         ; 3674: c3
loc_3675:
    load8 sub, ah, ah                                                           ; 3675: 2a e4
loc_3677:
    int 0x1a                                                                    ; 3677: cd 1a
loc_3679:
    cmp dx, word [aquarium_last_batch_tick]                                     ; 3679: 3b 16 09 35
loc_367d:
    jne loc_3680                                                                ; 367d: 75 01
loc_367f:
    ret                                                                         ; 367f: c3
loc_3680:
    mov word [aquarium_current_tick], dx                                        ; 3680: 89 16 0b 35
loc_3684:
    inc word [aquarium_update_slot]                                             ; 3684: ff 06 15 34
loc_3688:
    mov bx, word [aquarium_update_slot]                                         ; 3688: 8b 1e 15 34
loc_368c:
    cmp bx, strict byte 0x18                                                    ; 368c: 83 fb 18
loc_368f:
    jb loc_36a4                                                                 ; 368f: 72 13
loc_3691:
    load16 sub, bx, bx                                                          ; 3691: 2b db
loc_3693:
    mov word [aquarium_update_slot], bx                                         ; 3693: 89 1e 15 34
loc_3697:
    xor word [aquarium_fish_frame_offset], strict word 0xc                      ; 3697: 81 36 11 34 0c 00
loc_369d:
    add word [aquarium_hazard_frame_offset], strict byte 8                      ; 369d: 83 06 13 34 08
loc_36a2:
    jmp short loc_36b7                                                          ; 36a2: eb 13
loc_36a4:
    cmp bx, strict byte 0xc                                                     ; 36a4: 83 fb 0c
loc_36a7:
    jne loc_36bd                                                                ; 36a7: 75 14
loc_36a9:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 36a9: 80 3e 97 06 fd
loc_36ae:
    jne loc_36b7                                                                ; 36ae: 75 07
loc_36b0:
    cmp byte [player_y], strict byte 0x30                                       ; 36b0: 80 3e 7b 05 30
loc_36b5:
    jb loc_36bd                                                                 ; 36b5: 72 06
loc_36b7:
    mov ax, word [aquarium_current_tick]                                        ; 36b7: a1 0b 35
loc_36ba:
    mov word [aquarium_last_batch_tick], ax                                     ; 36ba: a3 09 35
loc_36bd:
    load16 mov, si, bx                                                          ; 36bd: 8b f3
loc_36bf:
    shl si, 1                                                                   ; 36bf: d1 e6
loc_36c1:
    cmp byte [bx + aquarium_object_inactive], strict byte 0                     ; 36c1: 80 bf a7 34 00
loc_36c6:
    jne loc_367f                                                                ; 36c6: 75 b7
loc_36c8:
    call near update_random_state                                               ; 36c8: e8 32 f7
loc_36cb:
    cmp dl, strict byte 0x10                                                    ; 36cb: 80 fa 10
loc_36ce:
    ja loc_36e9                                                                 ; 36ce: 77 19
loc_36d0:
    and dl, strict byte 1                                                       ; 36d0: 80 e2 01
loc_36d3:
    jne loc_36d7                                                                ; 36d3: 75 02
loc_36d5:
    not dl                                                                      ; 36d5: f6 d2
loc_36d7:
    mov byte [bx + aquarium_horizontal_direction], dl                           ; 36d7: 88 97 17 34
loc_36db:
    call near update_random_state                                               ; 36db: e8 1f f7
loc_36de:
    and dl, strict byte 1                                                       ; 36de: 80 e2 01
loc_36e1:
    jne loc_36e5                                                                ; 36e1: 75 02
loc_36e3:
    not dl                                                                      ; 36e3: f6 d2
loc_36e5:
    mov byte [bx + aquarium_vertical_direction], dl                             ; 36e5: 88 97 2f 34
loc_36e9:
    mov cx, 4                                                                   ; 36e9: b9 04 00
loc_36ec:
    cmp bx, strict byte 0xc                                                     ; 36ec: 83 fb 0c
loc_36ef:
    jb loc_36f3                                                                 ; 36ef: 72 02
loc_36f1:
    shr cl, 1                                                                   ; 36f1: d0 e9
loc_36f3:
    mov ax, word [si + aquarium_object_x]                                       ; 36f3: 8b 84 47 34
loc_36f7:
    cmp byte [bx + aquarium_horizontal_direction], strict byte 1                ; 36f7: 80 bf 17 34 01
loc_36fc:
    je loc_370b                                                                 ; 36fc: 74 0d
loc_36fe:
    load16 sub, ax, cx                                                          ; 36fe: 2b c1
loc_3700:
    jae loc_371a                                                                ; 3700: 73 18
loc_3702:
    load16 sub, ax, ax                                                          ; 3702: 2b c0
loc_3704:
    mov byte [bx + aquarium_horizontal_direction], 1                            ; 3704: c6 87 17 34 01
loc_3709:
    jmp short loc_371a                                                          ; 3709: eb 0f
loc_370b:
    load16 add, ax, cx                                                          ; 370b: 03 c1
loc_370d:
    cmp ax, strict word 0x12f                                                   ; 370d: 3d 2f 01
loc_3710:
    jb loc_371a                                                                 ; 3710: 72 08
loc_3712:
    mov ax, 0x12e                                                               ; 3712: b8 2e 01
loc_3715:
    mov byte [bx + aquarium_horizontal_direction], 0xff                         ; 3715: c6 87 17 34 ff
loc_371a:
    mov word [si + aquarium_object_x], ax                                       ; 371a: 89 84 47 34
loc_371e:
    mov al, byte [bx + aquarium_object_y]                                       ; 371e: 8a 87 77 34
loc_3722:
    cmp byte [bx + aquarium_vertical_direction], strict byte 1                  ; 3722: 80 bf 2f 34 01
loc_3727:
    je loc_373c                                                                 ; 3727: 74 13
loc_3729:
    dec al                                                                      ; 3729: fe c8
loc_372b:
    cmp al, byte [bx + aquarium_y_minimum]                                      ; 372b: 3a 87 f1 34
loc_372f:
    jae loc_3750                                                                ; 372f: 73 1f
loc_3731:
    mov al, byte [bx + aquarium_y_minimum]                                      ; 3731: 8a 87 f1 34
loc_3735:
    mov byte [bx + aquarium_vertical_direction], 1                              ; 3735: c6 87 2f 34 01
loc_373a:
    jmp short loc_3750                                                          ; 373a: eb 14
loc_373c:
    inc al                                                                      ; 373c: fe c0
loc_373e:
    mov dl, byte [bx + aquarium_y_minimum]                                      ; 373e: 8a 97 f1 34
loc_3742:
    add dl, strict byte 0x18                                                    ; 3742: 80 c2 18
loc_3745:
    load8 cmp, al, dl                                                           ; 3745: 3a c2
loc_3747:
    jbe loc_3750                                                                ; 3747: 76 07
loc_3749:
    load8 mov, al, dl                                                           ; 3749: 8a c2
loc_374b:
    mov byte [bx + aquarium_vertical_direction], 0xff                           ; 374b: c6 87 2f 34 ff
loc_3750:
    mov byte [bx + aquarium_object_y], al                                       ; 3750: 88 87 77 34
loc_3754:
    load8 mov, dl, al                                                           ; 3754: 8a d0
loc_3756:
    mov cx, word [si + aquarium_object_x]                                       ; 3756: 8b 8c 47 34
loc_375a:
    call near calculate_cga_address                                             ; 375a: e8 53 f5
loc_375d:
    mov word [0x34ef], ax                                                       ; 375d: a3 ef 34
loc_3760:
    mov bx, word [aquarium_update_slot]                                         ; 3760: 8b 1e 15 34
loc_3764:
    call near erase_aquarium_object                                             ; 3764: e8 5a 00
loc_3767:
    mov bx, word [aquarium_update_slot]                                         ; 3767: 8b 1e 15 34
loc_376b:
    load16 mov, si, bx                                                          ; 376b: 8b f3
loc_376d:
    shl si, 1                                                                   ; 376d: d1 e6
loc_376f:
    mov di, word [0x34ef]                                                       ; 376f: 8b 3e ef 34
loc_3773:
    mov word [si + aquarium_saved_video_offsets], di                            ; 3773: 89 bc bf 34
loc_3777:
    mov byte [bx + aquarium_background_absent], 0                               ; 3777: c6 87 8f 34 00
loc_377c:
    mov ax, 0xb800                                                              ; 377c: b8 00 b8
loc_377f:
    mov es, ax                                                                  ; 377f: 8e c0
loc_3781:
    cmp bx, strict byte 0xc                                                     ; 3781: 83 fb 0c
loc_3784:
    jb loc_379f                                                                 ; 3784: 72 19
loc_3786:
    load16 mov, si, bx                                                          ; 3786: 8b f3
loc_3788:
    mov cl, 3                                                                   ; 3788: b1 03
loc_378a:
    shl si, cl                                                                  ; 378a: d3 e6
loc_378c:
    add si, word [aquarium_hazard_frame_offset]                                 ; 378c: 03 36 13 34
loc_3790:
    and si, strict word 0x18                                                    ; 3790: 81 e6 18 00
loc_3794:
    add si, strict word 0x3330                                                  ; 3794: 81 c6 30 33
loc_3798:
    mov cx, 0x202                                                               ; 3798: b9 02 02
loc_379b:
    call near copy_rectangle_to_cga                                             ; 379b: e8 ff f5
loc_379e:
    ret                                                                         ; 379e: c3
loc_379f:
    mov si, word [aquarium_fish_frame_offset]                                   ; 379f: 8b 36 11 34
loc_37a3:
    test bl, 1                                                                  ; 37a3: f6 c3 01
loc_37a6:
    jne loc_37ac                                                                ; 37a6: 75 04
loc_37a8:
    xor si, strict word 0xc                                                     ; 37a8: 81 f6 0c 00
loc_37ac:
    cmp byte [bx + aquarium_horizontal_direction], strict byte 1                ; 37ac: 80 bf 17 34 01
loc_37b1:
    je loc_37b6                                                                 ; 37b1: 74 03
loc_37b3:
    add si, strict byte 0x18                                                    ; 37b3: 83 c6 18
loc_37b6:
    add si, strict word 0x3300                                                  ; 37b6: 81 c6 00 33
loc_37ba:
    mov cx, 0x601                                                               ; 37ba: b9 01 06
loc_37bd:
    call near copy_rectangle_to_cga                                             ; 37bd: e8 dd f5
loc_37c0:
    ret                                                                         ; 37c0: c3
; CS:37c1 — erase_aquarium_object
; Skips slots whose background-absent flag is set; otherwise copies the blank tile at DS:3404 to the saved CGA address, using 8x6 for fish and 16x2 for hazards.
erase_aquarium_object:
    cmp byte [bx + aquarium_background_absent], strict byte 0                   ; 37c1: 80 bf 8f 34 00
loc_37c6:
    jne loc_37e4                                                                ; 37c6: 75 1c
loc_37c8:
    shl bx, 1                                                                   ; 37c8: d1 e3
loc_37ca:
    mov si, 0x3404                                                              ; 37ca: be 04 34
loc_37cd:
    mov di, word [bx + aquarium_saved_video_offsets]                            ; 37cd: 8b bf bf 34
loc_37d1:
    mov ax, 0xb800                                                              ; 37d1: b8 00 b8
loc_37d4:
    mov es, ax                                                                  ; 37d4: 8e c0
loc_37d6:
    mov cx, 0x601                                                               ; 37d6: b9 01 06
loc_37d9:
    cmp bx, strict byte 0x18                                                    ; 37d9: 83 fb 18
loc_37dc:
    jb loc_37e1                                                                 ; 37dc: 72 03
loc_37de:
    mov cx, 0x202                                                               ; 37de: b9 02 02
loc_37e1:
    call near copy_rectangle_to_cga                                             ; 37e1: e8 b9 f5
loc_37e4:
    ret                                                                         ; 37e4: c3
loc_37e5:
    load8 sub, ah, ah                                                           ; 37e5: 2a e4
loc_37e7:
    int 0x1a                                                                    ; 37e7: cd 1a
loc_37e9:
    load16 mov, ax, dx                                                          ; 37e9: 8b c2
loc_37eb:
    sub ax, word [0x350f]                                                       ; 37eb: 2b 06 0f 35
loc_37ef:
    cmp ax, strict word 8                                                       ; 37ef: 3d 08 00
loc_37f2:
    jb loc_384a                                                                 ; 37f2: 72 56
loc_37f4:
    inc word [0x350d]                                                           ; 37f4: ff 06 0d 35
loc_37f8:
    mov bx, word [0x350d]                                                       ; 37f8: 8b 1e 0d 35
loc_37fc:
    cmp bx, strict byte 0x28                                                    ; 37fc: 83 fb 28
loc_37ff:
    jb loc_380b                                                                 ; 37ff: 72 0a
loc_3801:
    load16 sub, bx, bx                                                          ; 3801: 2b db
loc_3803:
    mov word [0x350d], bx                                                       ; 3803: 89 1e 0d 35
loc_3807:
    mov word [0x350f], dx                                                       ; 3807: 89 16 0f 35
loc_380b:
    load16 mov, di, bx                                                          ; 380b: 8b fb
loc_380d:
    shl di, 1                                                                   ; 380d: d1 e7
loc_380f:
    cmp byte [player_y], strict byte 7                                          ; 380f: 80 3e 7b 05 07
loc_3814:
    ja loc_3829                                                                 ; 3814: 77 13
loc_3816:
    mov ax, word [player_x]                                                     ; 3816: a1 79 05
loc_3819:
    mov cl, 2                                                                   ; 3819: b1 02
loc_381b:
    shr ax, cl                                                                  ; 381b: d3 e8
loc_381d:
    inc ax                                                                      ; 381d: 40
loc_381e:
    load16 sub, ax, di                                                          ; 381e: 2b c7
loc_3820:
    jae loc_3824                                                                ; 3820: 73 02
loc_3822:
    not ax                                                                      ; 3822: f7 d0
loc_3824:
    cmp ax, strict word 4                                                       ; 3824: 3d 04 00
loc_3827:
    jb loc_384a                                                                 ; 3827: 72 21
loc_3829:
    add di, strict word 0xa0                                                    ; 3829: 81 c7 a0 00
loc_382d:
    mov al, byte [bx + 0x2656]                                                  ; 382d: 8a 87 56 26
loc_3831:
    add al, 8                                                                   ; 3831: 04 08
loc_3833:
    mov byte [bx + 0x2656], al                                                  ; 3833: 88 87 56 26
loc_3837:
    and ax, strict word 0x18                                                    ; 3837: 25 18 00
loc_383a:
    add ax, strict word 0x2020                                                  ; 383a: 05 20 20
loc_383d:
    load16 mov, si, ax                                                          ; 383d: 8b f0
loc_383f:
    mov ax, 0xb800                                                              ; 383f: b8 00 b8
loc_3842:
    mov es, ax                                                                  ; 3842: 8e c0
loc_3844:
    mov cx, 0x401                                                               ; 3844: b9 01 04
loc_3847:
    call near copy_rectangle_to_cga                                             ; 3847: e8 53 f5
loc_384a:
    ret                                                                         ; 384a: c3
    times 5 db 0 ; original zero fill at CS:384b
