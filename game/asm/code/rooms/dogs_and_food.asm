; Dog alert state, eating and food-slot initialization.
; Original CS:47D6..4C10 (end exclusive).

loc_47d6:
    load8 sub, ah, ah                                                           ; 47d6: 2a e4
loc_47d8:
    int 0x1a                                                                    ; 47d8: cd 1a
loc_47da:
    load16 mov, ax, dx                                                          ; 47da: 8b c2
loc_47dc:
    sub ax, word [0x44d7]                                                       ; 47dc: 2b 06 d7 44
loc_47e0:
    mov si, word [difficulty_level]                                             ; 47e0: 8b 36 08 00
loc_47e4:
    shl si, 1                                                                   ; 47e4: d1 e6
loc_47e6:
    cmp ax, word [si + 0x44dc]                                                  ; 47e6: 3b 84 dc 44
loc_47ea:
    ja loc_47ed                                                                 ; 47ea: 77 01
loc_47ec:
    ret                                                                         ; 47ec: c3
loc_47ed:
    mov word [0x44d7], dx                                                       ; 47ed: 89 16 d7 44
loc_47f1:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 47f1: 80 3e b8 1c 00
loc_47f6:
    jne loc_47ec                                                                ; 47f6: 75 f4
loc_47f8:
    mov byte [0x44fc], 0                                                        ; 47f8: c6 06 fc 44 00
loc_47fd:
    mov cx, 0xc                                                                 ; 47fd: b9 0c 00
loc_4800:
    load16 mov, bx, cx                                                          ; 4800: 8b d9
loc_4802:
    dec bx                                                                      ; 4802: 4b
loc_4803:
    shl bl, 1                                                                   ; 4803: d0 e3
loc_4805:
    cmp word [bx + dog_slot_occupied], strict byte 0                            ; 4805: 83 bf 41 44 00
loc_480a:
    je loc_487d                                                                 ; 480a: 74 71
loc_480c:
    mov ax, word [bx + 0x43f9]                                                  ; 480c: 8b 87 f9 43
loc_4810:
    cmp al, byte [player_y]                                                     ; 4810: 3a 06 7b 05
loc_4814:
    jne loc_485d                                                                ; 4814: 75 47
loc_4816:
    mov ax, word [bx + 0x43e1]                                                  ; 4816: 8b 87 e1 43
loc_481a:
    sub ax, word [player_x]                                                     ; 481a: 2b 06 79 05
loc_481e:
    jae loc_4822                                                                ; 481e: 73 02
loc_4820:
    not ax                                                                      ; 4820: f7 d0
loc_4822:
    mov si, word [difficulty_level]                                             ; 4822: 8b 36 08 00
loc_4826:
    shl si, 1                                                                   ; 4826: d1 e6
loc_4828:
    cmp ax, word [si + 0x44ec]                                                  ; 4828: 3b 84 ec 44
loc_482c:
    ja loc_485d                                                                 ; 482c: 77 2f
loc_482e:
    cmp word [bx + dog_alert_phase], strict byte 2                              ; 482e: 83 bf 59 44 02
loc_4833:
    jb loc_484c                                                                 ; 4833: 72 17
loc_4835:
    mov ax, word [bx + dog_video_offsets]                                       ; 4835: 8b 87 11 44
loc_4839:
    mov word [0x44da], ax                                                       ; 4839: a3 da 44
loc_483c:
    call near loc_488d                                                          ; 483c: e8 4e 00
loc_483f:
    call near loc_48a1                                                          ; 483f: e8 5f 00
loc_4842:
    call near draw_shared_room_object                                                          ; 4842: e8 f4 ea
loc_4845:
    call near draw_player_mask                                                  ; 4845: e8 fd c8
loc_4848:
    call near start_chasing_enemy_capture                                       ; 4848: e8 eb d8
loc_484b:
    ret                                                                         ; 484b: c3
loc_484c:
    inc word [bx + dog_alert_phase]                                             ; 484c: ff 87 59 44
loc_4850:
    cmp word [bx + dog_alert_phase], strict byte 2                              ; 4850: 83 bf 59 44 02
loc_4855:
    jb loc_4870                                                                 ; 4855: 72 19
loc_4857:
    inc byte [0x44fc]                                                           ; 4857: fe 06 fc 44
loc_485b:
    jmp short loc_4870                                                          ; 485b: eb 13
loc_485d:
    cmp word [bx + dog_alert_phase], strict byte 0                              ; 485d: 83 bf 59 44 00
loc_4862:
    je loc_487d                                                                 ; 4862: 74 19
loc_4864:
    call near update_random_state                                               ; 4864: e8 96 e5
loc_4867:
    cmp dl, strict byte 0x38                                                    ; 4867: 80 fa 38
loc_486a:
    ja loc_4870                                                                 ; 486a: 77 04
loc_486c:
    dec word [bx + dog_alert_phase]                                             ; 486c: ff 8f 59 44
loc_4870:
    push cx                                                                     ; 4870: 51
loc_4871:
    push bx                                                                     ; 4871: 53
loc_4872:
    call near loc_48d7                                                          ; 4872: e8 62 00
loc_4875:
    pop bx                                                                      ; 4875: 5b
loc_4876:
    call near loc_4916                                                          ; 4876: e8 9d 00
loc_4879:
    call near loc_48c1                                                          ; 4879: e8 45 00
loc_487c:
    pop cx                                                                      ; 487c: 59
loc_487d:
    loop loc_488a                                                               ; 487d: e2 0b
loc_487f:
    cmp byte [0x44fc], strict byte 0                                            ; 487f: 80 3e fc 44 00
loc_4884:
    je loc_4889                                                                 ; 4884: 74 03
loc_4886:
    call near loc_5691                                                          ; 4886: e8 08 0e
loc_4889:
    ret                                                                         ; 4889: c3
loc_488a:
    jmp near loc_4800                                                           ; 488a: e9 73 ff
loc_488d:
    cmp byte [0x44bd], strict byte 0                                            ; 488d: 80 3e bd 44 00
loc_4892:
    je loc_489d                                                                 ; 4892: 74 09
loc_4894:
    call near loc_4b03                                                          ; 4894: e8 6c 02
loc_4897:
    mov byte [0x44bd], 0                                                        ; 4897: c6 06 bd 44 00
loc_489c:
    ret                                                                         ; 489c: c3
loc_489d:
    call near restore_player_background                                         ; 489d: e8 43 c9
loc_48a0:
    ret                                                                         ; 48a0: c3
loc_48a1:
    push ds                                                                     ; 48a1: 1e
loc_48a2:
    pop es                                                                      ; 48a2: 07
loc_48a3:
    cld                                                                         ; 48a3: fc
loc_48a4:
    mov di, 0xe                                                                 ; 48a4: bf 0e 00
loc_48a7:
    load16 mov, si, di                                                          ; 48a7: 8b f7
loc_48a9:
    mov ax, 0xaaaa                                                              ; 48a9: b8 aa aa
loc_48ac:
    mov cx, 0x41                                                                ; 48ac: b9 41 00
loc_48af:
    rep stosw                                                                   ; 48af: f3 ab
loc_48b1:
    mov ax, 0xb800                                                              ; 48b1: b8 00 b8
loc_48b4:
    mov es, ax                                                                  ; 48b4: 8e c0
loc_48b6:
    mov di, word [0x44da]                                                       ; 48b6: 8b 3e da 44
loc_48ba:
    mov cx, 0xd05                                                               ; 48ba: b9 05 0d
loc_48bd:
    call near copy_rectangle_to_cga                                             ; 48bd: e8 dd e4
loc_48c0:
    ret                                                                         ; 48c0: c3
loc_48c1:
    cmp byte [0x44d9], strict byte 0                                            ; 48c1: 80 3e d9 44 00
loc_48c6:
    je loc_48d2                                                                 ; 48c6: 74 0a
loc_48c8:
    cmp byte [0x44bd], strict byte 0                                            ; 48c8: 80 3e bd 44 00
loc_48cd:
    je loc_48d3                                                                 ; 48cd: 74 04
loc_48cf:
    call near loc_4b1d                                                          ; 48cf: e8 4b 02
loc_48d2:
    ret                                                                         ; 48d2: c3
loc_48d3:
    call near draw_player_mask                                                  ; 48d3: e8 6f c8
loc_48d6:
    ret                                                                         ; 48d6: c3
loc_48d7:
    mov byte [0x44d9], 0                                                        ; 48d7: c6 06 d9 44 00
loc_48dc:
    mov ax, word [bx + 0x43e1]                                                  ; 48dc: 8b 87 e1 43
loc_48e0:
    mov dx, word [bx + 0x43f9]                                                  ; 48e0: 8b 97 f9 43
loc_48e4:
    sub ax, strict word 0x14                                                    ; 48e4: 2d 14 00
loc_48e7:
    mov si, 0x28                                                                ; 48e7: be 28 00
loc_48ea:
    mov bx, word [player_x]                                                     ; 48ea: 8b 1e 79 05
loc_48ee:
    mov dh, byte [player_y]                                                     ; 48ee: 8a 36 7b 05
loc_48f2:
    mov cx, 0xe06                                                               ; 48f2: b9 06 0e
loc_48f5:
    mov di, 0x18                                                                ; 48f5: bf 18 00
loc_48f8:
    call near rectangles_overlap                                                ; 48f8: e8 2e e5
loc_48fb:
    jae loc_4915                                                                ; 48fb: 73 18
loc_48fd:
    mov byte [0x44d9], 1                                                        ; 48fd: c6 06 d9 44 01
loc_4902:
    call near read_cga_vertical_retrace_bit                                     ; 4902: e8 d3 ca
loc_4905:
    je loc_4902                                                                 ; 4905: 74 fb
loc_4907:
    cmp byte [0x44bd], strict byte 0                                            ; 4907: 80 3e bd 44 00
loc_490c:
    je loc_4912                                                                 ; 490c: 74 04
loc_490e:
    call near loc_4b03                                                          ; 490e: e8 f2 01
loc_4911:
    ret                                                                         ; 4911: c3
loc_4912:
    call near restore_player_background                                         ; 4912: e8 ce c8
loc_4915:
    ret                                                                         ; 4915: c3
loc_4916:
    mov ax, word [bx + dog_video_offsets]                                       ; 4916: 8b 87 11 44
loc_491a:
    mov si, word [bx + dog_alert_phase]                                         ; 491a: 8b b7 59 44
loc_491e:
    shl si, 1                                                                   ; 491e: d1 e6
loc_4920:
    add si, strict word 0x4100                                                  ; 4920: 81 c6 00 41
loc_4924:
    add ax, strict word 0xa7                                                    ; 4924: 05 a7 00
loc_4927:
    cmp word [bx + dog_sprite_pointers], strict word 0x429c                     ; 4927: 81 bf 29 44 9c 42
loc_492d:
    je loc_4935                                                                 ; 492d: 74 06
loc_492f:
    sub ax, strict word 6                                                       ; 492f: 2d 06 00
loc_4932:
    add si, strict byte 6                                                       ; 4932: 83 c6 06
loc_4935:
    load16 mov, di, ax                                                          ; 4935: 8b f8
loc_4937:
    mov ax, 0xb800                                                              ; 4937: b8 00 b8
loc_493a:
    mov es, ax                                                                  ; 493a: 8e c0
loc_493c:
    mov cx, 0x101                                                               ; 493c: b9 01 01
loc_493f:
    call near copy_rectangle_to_cga                                             ; 493f: e8 5b e4
loc_4942:
    ret                                                                         ; 4942: c3
; CS:4943 — update_food_action
; Action selects the nearest nonempty food slot on the player row, aligns player, and consumes a portion on animation accumulator wrap; last empty slot sets scene_complete.
update_food_action:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 4943: 80 3e b8 1c 00
loc_4948:
    jne loc_4966                                                                ; 4948: 75 1c
loc_494a:
    cmp byte [0x44be], strict byte 0                                            ; 494a: 80 3e be 44 00
loc_494f:
    je loc_495c                                                                 ; 494f: 74 0b
loc_4951:
    mov al, byte [0x44be]                                                       ; 4951: a0 be 44
loc_4954:
    mov byte [input_horizontal], al                                             ; 4954: a2 98 06
loc_4957:
    mov byte [input_vertical], 0                                                ; 4957: c6 06 99 06 00
loc_495c:
    load8 sub, ah, ah                                                           ; 495c: 2a e4
loc_495e:
    int 0x1a                                                                    ; 495e: cd 1a
loc_4960:
    cmp dx, word [0x44d3]                                                       ; 4960: 3b 16 d3 44
loc_4964:
    jne loc_4967                                                                ; 4964: 75 01
loc_4966:
    ret                                                                         ; 4966: c3
loc_4967:
    mov word [0x44d3], dx                                                       ; 4967: 89 16 d3 44
loc_496b:
    cmp byte [0x584], strict byte 0                                             ; 496b: 80 3e 84 05 00
loc_4970:
    je loc_4995                                                                 ; 4970: 74 23
loc_4972:
    cmp byte [0x44bd], strict byte 0                                            ; 4972: 80 3e bd 44 00
loc_4977:
    je loc_4994                                                                 ; 4977: 74 1b
loc_4979:
    call near loc_4b03                                                          ; 4979: e8 87 01
loc_497c:
    call near erase_shared_room_object                                                          ; 497c: e8 21 ea
loc_497f:
    call near save_player_background                                            ; 497f: e8 a2 c7
loc_4982:
    call near draw_shared_room_object                                                          ; 4982: e8 b4 e9
loc_4985:
    mov byte [0x44bd], 0                                                        ; 4985: c6 06 bd 44 00
loc_498a:
    mov byte [0x43e0], 1                                                        ; 498a: c6 06 e0 43 01
loc_498f:
    mov byte [0x44be], 0                                                        ; 498f: c6 06 be 44 00
loc_4994:
    ret                                                                         ; 4994: c3
loc_4995:
    cmp byte [action_button_state], strict byte 0                               ; 4995: 80 3e 9a 06 00
loc_499a:
    je loc_499f                                                                 ; 499a: 74 03
loc_499c:
    jmp short loc_49f9                                                          ; 499c: eb 5b
loc_499e:
    nop                                                                         ; 499e: 90
loc_499f:
    mov ax, 0xffff                                                              ; 499f: b8 ff ff
loc_49a2:
    mov word [0x44c1], ax                                                       ; 49a2: a3 c1 44
loc_49a5:
    mov word [0x44bf], ax                                                       ; 49a5: a3 bf 44
loc_49a8:
    mov cx, 0xc                                                                 ; 49a8: b9 0c 00
loc_49ab:
    mov si, word [player_x]                                                     ; 49ab: 8b 36 79 05
loc_49af:
    mov dl, byte [player_y]                                                     ; 49af: 8a 16 7b 05
loc_49b3:
    add dl, strict byte 8                                                       ; 49b3: 80 c2 08
loc_49b6:
    load16 mov, bx, cx                                                          ; 49b6: 8b d9
loc_49b8:
    dec bx                                                                      ; 49b8: 4b
loc_49b9:
    cmp byte [bx + food_portions], strict byte 1                                ; 49b9: 80 bf c4 44 01
loc_49be:
    jb loc_49f0                                                                 ; 49be: 72 30
loc_49c0:
    cmp dl, byte [bx + food_slot_y]                                             ; 49c0: 3a 97 99 44
loc_49c4:
    jne loc_49f0                                                                ; 49c4: 75 2a
loc_49c6:
    load16 mov, ax, si                                                          ; 49c6: 8b c6
loc_49c8:
    shl bl, 1                                                                   ; 49c8: d0 e3
loc_49ca:
    mov dh, 0xff                                                                ; 49ca: b6 ff
loc_49cc:
    sub ax, word [bx + food_slot_x]                                             ; 49cc: 2b 87 81 44
loc_49d0:
    jae loc_49d6                                                                ; 49d0: 73 04
loc_49d2:
    not ax                                                                      ; 49d2: f7 d0
loc_49d4:
    mov dh, 1                                                                   ; 49d4: b6 01
loc_49d6:
    cmp ax, word [0x44bf]                                                       ; 49d6: 3b 06 bf 44
loc_49da:
    ja loc_49f0                                                                 ; 49da: 77 14
loc_49dc:
    mov word [0x44bf], ax                                                       ; 49dc: a3 bf 44
loc_49df:
    mov ax, word [bx + 0x44a5]                                                  ; 49df: 8b 87 a5 44
loc_49e3:
    mov word [0x44d1], ax                                                       ; 49e3: a3 d1 44
loc_49e6:
    shr bl, 1                                                                   ; 49e6: d0 eb
loc_49e8:
    mov word [0x44c1], bx                                                       ; 49e8: 89 1e c1 44
loc_49ec:
    mov byte [0x44c3], dh                                                       ; 49ec: 88 36 c3 44
loc_49f0:
    loop loc_49b6                                                               ; 49f0: e2 c4
loc_49f2:
    cmp word [0x44c1], strict byte 0xc                                          ; 49f2: 83 3e c1 44 0c
loc_49f7:
    jb loc_4a20                                                                 ; 49f7: 72 27
loc_49f9:
    cmp byte [0x44bd], strict byte 0                                            ; 49f9: 80 3e bd 44 00
loc_49fe:
    je loc_4a0b                                                                 ; 49fe: 74 0b
loc_4a00:
    call near loc_4b03                                                          ; 4a00: e8 00 01
loc_4a03:
    call near draw_player_mask                                                  ; 4a03: e8 3f c7
loc_4a06:
    mov byte [action_button_state], 0x10                                        ; 4a06: c6 06 9a 06 10
loc_4a0b:
    mov byte [0x44bd], 0                                                        ; 4a0b: c6 06 bd 44 00
loc_4a10:
    mov byte [0x43e0], 1                                                        ; 4a10: c6 06 e0 43 01
loc_4a15:
    mov byte [food_eating_accumulator], 0                                       ; 4a15: c6 06 d0 44 00
loc_4a1a:
    mov byte [0x44be], 0                                                        ; 4a1a: c6 06 be 44 00
loc_4a1f:
    ret                                                                         ; 4a1f: c3
loc_4a20:
    cmp word [0x44bf], strict byte 4                                            ; 4a20: 83 3e bf 44 04
loc_4a25:
    jb loc_4a4b                                                                 ; 4a25: 72 24
loc_4a27:
    cmp word [0x44bf], strict byte 8                                            ; 4a27: 83 3e bf 44 08
loc_4a2c:
    ja loc_4a33                                                                 ; 4a2c: 77 05
loc_4a2e:
    mov byte [player_horizontal_speed], 4                                       ; 4a2e: c6 06 72 05 04
loc_4a33:
    mov al, byte [0x44c3]                                                       ; 4a33: a0 c3 44
loc_4a36:
    mov byte [input_horizontal], al                                             ; 4a36: a2 98 06
loc_4a39:
    mov byte [player_horizontal_direction], al                                  ; 4a39: a2 6e 05
loc_4a3c:
    mov byte [0x44be], al                                                       ; 4a3c: a2 be 44
loc_4a3f:
    mov byte [input_vertical], 0                                                ; 4a3f: c6 06 99 06 00
loc_4a44:
    mov byte [player_vertical_direction], 0                                     ; 4a44: c6 06 71 05 00
loc_4a49:
    jmp short loc_49f9                                                          ; 4a49: eb ae
loc_4a4b:
    mov byte [0x44be], 0                                                        ; 4a4b: c6 06 be 44 00
loc_4a50:
    cmp byte [0x44bd], strict byte 0                                            ; 4a50: 80 3e bd 44 00
loc_4a55:
    jne loc_4a5d                                                                ; 4a55: 75 06
loc_4a57:
    call near restore_player_background                                         ; 4a57: e8 89 c7
loc_4a5a:
    call near save_player_background                                            ; 4a5a: e8 c7 c6
loc_4a5d:
    mov byte [0x44bd], 1                                                        ; 4a5d: c6 06 bd 44 01
loc_4a62:
    load8 sub, al, al                                                           ; 4a62: 2a c0
loc_4a64:
    add byte [food_eating_accumulator], strict byte 0x30                        ; 4a64: 80 06 d0 44 30
loc_4a69:
    jae loc_4a6d                                                                ; 4a69: 73 02
loc_4a6b:
    inc al                                                                      ; 4a6b: fe c0
loc_4a6d:
    mov byte [0x44d5], al                                                       ; 4a6d: a2 d5 44
loc_4a70:
    mov cx, word [player_x]                                                     ; 4a70: 8b 0e 79 05
loc_4a74:
    and cx, strict word 0xffc                                                   ; 4a74: 81 e1 fc 0f
loc_4a78:
    mov dl, byte [player_y]                                                     ; 4a78: 8a 16 7b 05
loc_4a7c:
    add dl, strict byte 3                                                       ; 4a7c: 80 c2 03
loc_4a7f:
    cmp word [0x44d1], strict word 0x410c                                       ; 4a7f: 81 3e d1 44 0c 41
loc_4a85:
    je loc_4a95                                                                 ; 4a85: 74 0e
loc_4a87:
    add cx, strict byte 8                                                       ; 4a87: 83 c1 08
loc_4a8a:
    cmp cx, strict word 0x127                                                   ; 4a8a: 81 f9 27 01
loc_4a8e:
    jb loc_4a9c                                                                 ; 4a8e: 72 0c
loc_4a90:
    mov cx, 0x126                                                               ; 4a90: b9 26 01
loc_4a93:
    jmp short loc_4a9c                                                          ; 4a93: eb 07
loc_4a95:
    sub cx, strict byte 8                                                       ; 4a95: 83 e9 08
loc_4a98:
    jae loc_4a9c                                                                ; 4a98: 73 02
loc_4a9a:
    load16 sub, cx, cx                                                          ; 4a9a: 2b c9
loc_4a9c:
    call near calculate_cga_address                                             ; 4a9c: e8 11 e2
loc_4a9f:
    mov word [0x43dc], ax                                                       ; 4a9f: a3 dc 43
loc_4aa2:
    call near read_cga_vertical_retrace_bit                                     ; 4aa2: e8 33 c9
loc_4aa5:
    je loc_4aa2                                                                 ; 4aa5: 74 fb
loc_4aa7:
    call near loc_4b03                                                          ; 4aa7: e8 59 00
loc_4aaa:
    cmp byte [0x44d5], strict byte 0                                            ; 4aaa: 80 3e d5 44 00
loc_4aaf:
    je loc_4aff                                                                 ; 4aaf: 74 4e
loc_4ab1:
    mov bx, word [0x44c1]                                                       ; 4ab1: 8b 1e c1 44
loc_4ab5:
    cmp byte [bx + food_portions], strict byte 0                                ; 4ab5: 80 bf c4 44 00
loc_4aba:
    je loc_4aff                                                                 ; 4aba: 74 43
loc_4abc:
    dec byte [bx + food_portions]                                               ; 4abc: fe 8f c4 44
loc_4ac0:
    jne loc_4ae7                                                                ; 4ac0: 75 25
loc_4ac2:
    push bx                                                                     ; 4ac2: 53
loc_4ac3:
    mov ax, 0x8fd                                                               ; 4ac3: b8 fd 08
loc_4ac6:
    mov bx, 0x723                                                               ; 4ac6: bb 23 07
loc_4ac9:
    call near start_two_stage_sound                                             ; 4ac9: e8 6f 0e
loc_4acc:
    pop bx                                                                      ; 4acc: 5b
loc_4acd:
    mov byte [input_horizontal], 0                                              ; 4acd: c6 06 98 06 00
loc_4ad2:
    mov byte [0x44be], 0                                                        ; 4ad2: c6 06 be 44 00
loc_4ad7:
    mov byte [action_button_state], 0x10                                        ; 4ad7: c6 06 9a 06 10
loc_4adc:
    dec byte [food_slots_remaining]                                             ; 4adc: fe 0e d6 44
loc_4ae0:
    jne loc_4ae7                                                                ; 4ae0: 75 05
loc_4ae2:
    mov byte [scene_complete], 1                                                ; 4ae2: c6 06 53 05 01
loc_4ae7:
    push bx                                                                     ; 4ae7: 53
loc_4ae8:
    call near loc_47b0                                                          ; 4ae8: e8 c5 fc
loc_4aeb:
    pop bx                                                                      ; 4aeb: 5b
loc_4aec:
    jae loc_4afc                                                                ; 4aec: 73 0e
loc_4aee:
    push bx                                                                     ; 4aee: 53
loc_4aef:
    call near erase_shared_room_object                                                          ; 4aef: e8 ae e8
loc_4af2:
    pop bx                                                                      ; 4af2: 5b
loc_4af3:
    call near loc_4bc8                                                          ; 4af3: e8 d2 00
loc_4af6:
    call near draw_shared_room_object                                                          ; 4af6: e8 40 e8
loc_4af9:
    jmp short loc_4aff                                                          ; 4af9: eb 04
loc_4afb:
    nop                                                                         ; 4afb: 90
loc_4afc:
    call near loc_4bc8                                                          ; 4afc: e8 c9 00
loc_4aff:
    call near loc_4b1d                                                          ; 4aff: e8 1b 00
loc_4b02:
    ret                                                                         ; 4b02: c3
loc_4b03:
    cmp byte [0x43e0], strict byte 0                                            ; 4b03: 80 3e e0 43 00
loc_4b08:
    jne loc_4b1c                                                                ; 4b08: 75 12
loc_4b0a:
    mov di, word [0x43de]                                                       ; 4b0a: 8b 3e de 43
loc_4b0e:
    mov si, 0x43a0                                                              ; 4b0e: be a0 43
loc_4b11:
    mov ax, 0xb800                                                              ; 4b11: b8 00 b8
loc_4b14:
    mov es, ax                                                                  ; 4b14: 8e c0
loc_4b16:
    mov cx, 0xa03                                                               ; 4b16: b9 03 0a
loc_4b19:
    call near copy_rectangle_to_cga                                             ; 4b19: e8 81 e2
loc_4b1c:
    ret                                                                         ; 4b1c: c3
loc_4b1d:
    mov byte [0x43e0], 0                                                        ; 4b1d: c6 06 e0 43 00
loc_4b22:
    mov ax, 0xb800                                                              ; 4b22: b8 00 b8
loc_4b25:
    mov es, ax                                                                  ; 4b25: 8e c0
loc_4b27:
    mov di, word [0x43dc]                                                       ; 4b27: 8b 3e dc 43
loc_4b2b:
    mov word [0x43de], di                                                       ; 4b2b: 89 3e de 43
loc_4b2f:
    mov bp, 0x43a0                                                              ; 4b2f: bd a0 43
loc_4b32:
    mov si, word [0x44d1]                                                       ; 4b32: 8b 36 d1 44
loc_4b36:
    cmp byte [food_eating_accumulator], strict byte 0x80                        ; 4b36: 80 3e d0 44 80
loc_4b3b:
    jb loc_4b40                                                                 ; 4b3b: 72 03
loc_4b3d:
    add si, strict byte 0x3c                                                    ; 4b3d: 83 c6 3c
loc_4b40:
    mov cx, 0xa03                                                               ; 4b40: b9 03 0a
loc_4b43:
    call near blit_and_mask                                                     ; 4b43: e8 ef e1
loc_4b46:
    ret                                                                         ; 4b46: c3
; CS:4b47 — initialize_food_and_dogs
; Selects difficulty-dependent occupied dog slots, initializes twelve food counters from a difficulty table, draws objects, and resets eating state.
initialize_food_and_dogs:
    push ds                                                                     ; 4b47: 1e
loc_4b48:
    pop es                                                                      ; 4b48: 07
loc_4b49:
    load16 sub, ax, ax                                                          ; 4b49: 2b c0
loc_4b4b:
    mov di, 0x4441                                                              ; 4b4b: bf 41 44
loc_4b4e:
    mov cx, 0xc                                                                 ; 4b4e: b9 0c 00
loc_4b51:
    rep stosw                                                                   ; 4b51: f3 ab
loc_4b53:
    mov ax, 0xb800                                                              ; 4b53: b8 00 b8
loc_4b56:
    mov es, ax                                                                  ; 4b56: 8e c0
loc_4b58:
    mov bx, word [difficulty_level]                                             ; 4b58: 8b 1e 08 00
loc_4b5c:
    mov cl, byte [bx + dog_occupied_counts]                                     ; 4b5c: 8a 8f 71 44
loc_4b60:
    load8 sub, ch, ch                                                           ; 4b60: 2a ed
loc_4b62:
    call near update_random_state                                               ; 4b62: e8 98 e2
loc_4b65:
    load8 mov, bl, dl                                                           ; 4b65: 8a da
loc_4b67:
    and bx, strict word 0x1e                                                    ; 4b67: 81 e3 1e 00
loc_4b6b:
    cmp bl, strict byte 0x18                                                    ; 4b6b: 80 fb 18
loc_4b6e:
    jae loc_4b62                                                                ; 4b6e: 73 f2
loc_4b70:
    cmp word [bx + dog_slot_occupied], strict byte 0                            ; 4b70: 83 bf 41 44 00
loc_4b75:
    jne loc_4b62                                                                ; 4b75: 75 eb
loc_4b77:
    mov word [bx + dog_alert_phase], 0                                          ; 4b77: c7 87 59 44 00 00
loc_4b7d:
    mov word [bx + dog_slot_occupied], 1                                        ; 4b7d: c7 87 41 44 01 00
loc_4b83:
    push cx                                                                     ; 4b83: 51
loc_4b84:
    mov si, word [bx + dog_sprite_pointers]                                     ; 4b84: 8b b7 29 44
loc_4b88:
    mov di, word [bx + dog_video_offsets]                                       ; 4b88: 8b bf 11 44
loc_4b8c:
    mov cx, 0xd05                                                               ; 4b8c: b9 05 0d
loc_4b8f:
    call near copy_rectangle_to_cga                                             ; 4b8f: e8 0b e2
loc_4b92:
    pop cx                                                                      ; 4b92: 59
loc_4b93:
    loop loc_4b62                                                               ; 4b93: e2 cd
loc_4b95:
    mov cx, 0xc                                                                 ; 4b95: b9 0c 00
loc_4b98:
    load16 mov, bx, cx                                                          ; 4b98: 8b d9
loc_4b9a:
    dec bx                                                                      ; 4b9a: 4b
loc_4b9b:
    mov si, word [difficulty_level]                                             ; 4b9b: 8b 36 08 00
loc_4b9f:
    mov dl, byte [si + food_initial_portions]                                   ; 4b9f: 8a 94 79 44
loc_4ba3:
    mov byte [bx + food_portions], dl                                           ; 4ba3: 88 97 c4 44
loc_4ba7:
    push cx                                                                     ; 4ba7: 51
loc_4ba8:
    call near loc_4bc8                                                          ; 4ba8: e8 1d 00
loc_4bab:
    pop cx                                                                      ; 4bab: 59
loc_4bac:
    loop loc_4b98                                                               ; 4bac: e2 ea
loc_4bae:
    mov byte [food_eating_accumulator], 0                                       ; 4bae: c6 06 d0 44 00
loc_4bb3:
    mov byte [0x44bd], 0                                                        ; 4bb3: c6 06 bd 44 00
loc_4bb8:
    mov byte [0x43e0], 1                                                        ; 4bb8: c6 06 e0 43 01
loc_4bbd:
    mov byte [food_slots_remaining], 0xc                                        ; 4bbd: c6 06 d6 44 0c
loc_4bc2:
    mov byte [0x44be], 0                                                        ; 4bc2: c6 06 be 44 00
loc_4bc7:
    ret                                                                         ; 4bc7: c3
loc_4bc8:
    call near loc_4be8                                                          ; 4bc8: e8 1d 00
loc_4bcb:
    load16 mov, di, ax                                                          ; 4bcb: 8b f8
loc_4bcd:
    mov al, byte [bx + food_portions]                                           ; 4bcd: 8a 87 c4 44
loc_4bd1:
    load8 sub, ah, ah                                                           ; 4bd1: 2a e4
loc_4bd3:
    mov cl, 5                                                                   ; 4bd3: b1 05
loc_4bd5:
    shl ax, cl                                                                  ; 4bd5: d3 e0
loc_4bd7:
    add ax, strict word 0x41fc                                                  ; 4bd7: 05 fc 41
loc_4bda:
    load16 mov, si, ax                                                          ; 4bda: 8b f0
loc_4bdc:
    mov cx, 0x802                                                               ; 4bdc: b9 02 08
loc_4bdf:
    mov ax, 0xb800                                                              ; 4bdf: b8 00 b8
loc_4be2:
    mov es, ax                                                                  ; 4be2: 8e c0
loc_4be4:
    call near copy_rectangle_to_cga                                             ; 4be4: e8 b6 e1
loc_4be7:
    ret                                                                         ; 4be7: c3
loc_4be8:
    push bx                                                                     ; 4be8: 53
loc_4be9:
    mov dl, byte [bx + food_slot_y]                                             ; 4be9: 8a 97 99 44
loc_4bed:
    shl bl, 1                                                                   ; 4bed: d0 e3
loc_4bef:
    mov cx, word [bx + food_slot_x]                                             ; 4bef: 8b 8f 81 44
loc_4bf3:
    call near calculate_cga_address                                             ; 4bf3: e8 ba e0
loc_4bf6:
    pop bx                                                                      ; 4bf6: 5b
loc_4bf7:
    ret                                                                         ; 4bf7: c3
    times 8 db 0 ; original zero fill at CS:4bf8
loc_4c00:
    ret                                                                         ; 4c00: c3
loc_4c01:
    ret                                                                         ; 4c01: c3
loc_4c02:
    ret                                                                         ; 4c02: c3
loc_4c03:
    ret                                                                         ; 4c03: c3
loc_4c04:
    clc                                                                         ; 4c04: f8
loc_4c05:
    ret                                                                         ; 4c05: c3
loc_4c06:
    clc                                                                         ; 4c06: f8
loc_4c07:
    ret                                                                         ; 4c07: c3
loc_4c08:
    ret                                                                         ; 4c08: c3
    times 7 db 0 ; original zero fill at CS:4c09
