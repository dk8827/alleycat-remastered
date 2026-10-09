; Bird motion, cage state and goal contact.
; Original CS:4340..47D6 (end exclusive).

; CS:4340 — update_released_bird
; Returns until cage Y reaches 164; then checks contacts and selects motion from player distance, difficulty, random changes and an eleven-point waypoint table.
update_released_bird:
    load8 sub, ah, ah                                                           ; 4340: 2a e4
loc_4342:
    int 0x1a                                                                    ; 4342: cd 1a
loc_4344:
    cmp dx, word [bird_last_batch_tick]                                         ; 4344: 3b 16 b5 40
loc_4348:
    jne loc_434b                                                                ; 4348: 75 01
loc_434a:
    ret                                                                         ; 434a: c3
loc_434b:
    inc byte [0x40ff]                                                           ; 434b: fe 06 ff 40
loc_434f:
    test byte [0x40ff], 3                                                       ; 434f: f6 06 ff 40 03
loc_4354:
    je loc_435a                                                                 ; 4354: 74 04
loc_4356:
    mov word [bird_last_batch_tick], dx                                         ; 4356: 89 16 b5 40
loc_435a:
    cmp byte [bird_cage_y], strict byte 0xa4                                    ; 435a: 80 3e aa 40 a4
loc_435f:
    jb loc_434a                                                                 ; 435f: 72 e9
loc_4361:
    call near check_bird_goal_contact                                           ; 4361: e8 c9 01
loc_4364:
    call near loc_4557                                                          ; 4364: e8 f0 01
loc_4367:
    jb loc_434a                                                                 ; 4367: 72 e1
loc_4369:
    call near update_random_state                                               ; 4369: e8 91 ea
loc_436c:
    cmp dl, strict byte 0x30                                                    ; 436c: 80 fa 30
loc_436f:
    ja loc_439c                                                                 ; 436f: 77 2b
loc_4371:
    call near loc_44fb                                                          ; 4371: e8 87 01
loc_4374:
    mov si, word [difficulty_level]                                             ; 4374: 8b 36 08 00
loc_4378:
    shl si, 1                                                                   ; 4378: d1 e6
loc_437a:
    mov ax, word [si + 0x40ce]                                                  ; 437a: 8b 84 ce 40
loc_437e:
    cmp word [0x40cc], ax                                                       ; 437e: 39 06 cc 40
loc_4382:
    ja loc_439c                                                                 ; 4382: 77 18
loc_4384:
    call near loc_595d                                                          ; 4384: e8 d6 15
loc_4387:
    mov word [0x40c8], 0xff                                                     ; 4387: c7 06 c8 40 ff 00
loc_438d:
    mov al, byte [0x40ca]                                                       ; 438d: a0 ca 40
loc_4390:
    mov byte [0x40b7], al                                                       ; 4390: a2 b7 40
loc_4393:
    mov al, byte [0x40cb]                                                       ; 4393: a0 cb 40
loc_4396:
    mov byte [0x40b8], al                                                       ; 4396: a2 b8 40
loc_4399:
    jmp near loc_442e                                                           ; 4399: e9 92 00
loc_439c:
    cmp word [0x40c8], strict byte 0xa                                          ; 439c: 83 3e c8 40 0a
loc_43a1:
    ja loc_43b1                                                                 ; 43a1: 77 0e
loc_43a3:
    call near update_random_state                                               ; 43a3: e8 57 ea
loc_43a6:
    cmp dl, strict byte 6                                                       ; 43a6: 80 fa 06
loc_43a9:
    ja loc_43b4                                                                 ; 43a9: 77 09
loc_43ab:
    mov word [0x40c8], 0xff                                                     ; 43ab: c7 06 c8 40 ff 00
loc_43b1:
    jmp short loc_4402                                                          ; 43b1: eb 4f
loc_43b3:
    nop                                                                         ; 43b3: 90
loc_43b4:
    mov bx, word [0x40c8]                                                       ; 43b4: 8b 1e c8 40
loc_43b8:
    load16 mov, si, bx                                                          ; 43b8: 8b f3
loc_43ba:
    shl si, 1                                                                   ; 43ba: d1 e6
loc_43bc:
    load8 sub, dl, dl                                                           ; 43bc: 2a d2
loc_43be:
    mov ax, word [bird_x]                                                       ; 43be: a1 b2 40
loc_43c1:
    and ax, strict word 0xffc                                                   ; 43c1: 25 fc 0f
loc_43c4:
    cmp ax, word [si + 0x40de]                                                  ; 43c4: 3b 84 de 40
loc_43c8:
    je loc_43d0                                                                 ; 43c8: 74 06
loc_43ca:
    inc dl                                                                      ; 43ca: fe c2
loc_43cc:
    jb loc_43d0                                                                 ; 43cc: 72 02
loc_43ce:
    mov dl, 0xff                                                                ; 43ce: b2 ff
loc_43d0:
    mov byte [0x40b7], dl                                                       ; 43d0: 88 16 b7 40
loc_43d4:
    load8 sub, dl, dl                                                           ; 43d4: 2a d2
loc_43d6:
    mov al, byte [bird_y]                                                       ; 43d6: a0 b4 40
loc_43d9:
    and al, 0xfe                                                                ; 43d9: 24 fe
loc_43db:
    cmp al, byte [bx + 0x40f4]                                                  ; 43db: 3a 87 f4 40
loc_43df:
    je loc_43e7                                                                 ; 43df: 74 06
loc_43e1:
    inc dl                                                                      ; 43e1: fe c2
loc_43e3:
    jb loc_43e7                                                                 ; 43e3: 72 02
loc_43e5:
    mov dl, 0xff                                                                ; 43e5: b2 ff
loc_43e7:
    mov byte [0x40b8], dl                                                       ; 43e7: 88 16 b8 40
loc_43eb:
    or dl, byte [0x40b7]                                                        ; 43eb: 0a 16 b7 40
loc_43ef:
    jne loc_442e                                                                ; 43ef: 75 3d
loc_43f1:
    call near update_random_state                                               ; 43f1: e8 09 ea
loc_43f4:
    cmp dl, strict byte 0x10                                                    ; 43f4: 80 fa 10
loc_43f7:
    ja loc_442e                                                                 ; 43f7: 77 35
loc_43f9:
    mov word [0x40c8], 0xff                                                     ; 43f9: c7 06 c8 40 ff 00
loc_43ff:
    call near loc_595d                                                          ; 43ff: e8 5b 15
loc_4402:
    call near update_random_state                                               ; 4402: e8 f8 e9
loc_4405:
    cmp dl, strict byte 0x30                                                    ; 4405: 80 fa 30
loc_4408:
    ja loc_4423                                                                 ; 4408: 77 19
loc_440a:
    and dl, strict byte 1                                                       ; 440a: 80 e2 01
loc_440d:
    jne loc_4411                                                                ; 440d: 75 02
loc_440f:
    mov dl, 0xff                                                                ; 440f: b2 ff
loc_4411:
    mov byte [0x40b7], dl                                                       ; 4411: 88 16 b7 40
loc_4415:
    call near update_random_state                                               ; 4415: e8 e5 e9
loc_4418:
    and dl, strict byte 1                                                       ; 4418: 80 e2 01
loc_441b:
    jne loc_441f                                                                ; 441b: 75 02
loc_441d:
    mov dl, 0xff                                                                ; 441d: b2 ff
loc_441f:
    mov byte [0x40b8], dl                                                       ; 441f: 88 16 b8 40
loc_4423:
    call near update_random_state                                               ; 4423: e8 d7 e9
loc_4426:
    and dx, strict word 0xff                                                    ; 4426: 81 e2 ff 00
loc_442a:
    mov word [0x40c8], dx                                                       ; 442a: 89 16 c8 40
loc_442e:
    mov al, byte [bird_y]                                                       ; 442e: a0 b4 40
loc_4431:
    cmp byte [0x40b8], strict byte 1                                            ; 4431: 80 3e b8 40 01
loc_4436:
    jb loc_4459                                                                 ; 4436: 72 21
loc_4438:
    jne loc_4449                                                                ; 4438: 75 0f
loc_443a:
    add al, 2                                                                   ; 443a: 04 02
loc_443c:
    cmp al, 0xa8                                                                ; 443c: 3c a8
loc_443e:
    jb loc_4456                                                                 ; 443e: 72 16
loc_4440:
    mov al, 0xa7                                                                ; 4440: b0 a7
loc_4442:
    mov byte [0x40b8], 0xff                                                     ; 4442: c6 06 b8 40 ff
loc_4447:
    jmp short loc_4456                                                          ; 4447: eb 0d
loc_4449:
    sub al, 2                                                                   ; 4449: 2c 02
loc_444b:
    cmp al, 0x30                                                                ; 444b: 3c 30
loc_444d:
    jae loc_4456                                                                ; 444d: 73 07
loc_444f:
    mov al, 0x30                                                                ; 444f: b0 30
loc_4451:
    mov byte [0x40b8], 1                                                        ; 4451: c6 06 b8 40 01
loc_4456:
    mov byte [bird_y], al                                                       ; 4456: a2 b4 40
loc_4459:
    mov ax, word [bird_x]                                                       ; 4459: a1 b2 40
loc_445c:
    cmp byte [0x40b7], strict byte 1                                            ; 445c: 80 3e b7 40 01
loc_4461:
    jb loc_4486                                                                 ; 4461: 72 23
loc_4463:
    jne loc_4477                                                                ; 4463: 75 12
loc_4465:
    add ax, strict word 4                                                       ; 4465: 05 04 00
loc_4468:
    cmp ax, strict word 0x136                                                   ; 4468: 3d 36 01
loc_446b:
    jb loc_4483                                                                 ; 446b: 72 16
loc_446d:
    mov ax, 0x135                                                               ; 446d: b8 35 01
loc_4470:
    mov byte [0x40b7], 0xff                                                     ; 4470: c6 06 b7 40 ff
loc_4475:
    jmp short loc_4483                                                          ; 4475: eb 0c
loc_4477:
    sub ax, strict word 4                                                       ; 4477: 2d 04 00
loc_447a:
    jae loc_4483                                                                ; 447a: 73 07
loc_447c:
    load16 sub, ax, ax                                                          ; 447c: 2b c0
loc_447e:
    mov byte [0x40b7], 1                                                        ; 447e: c6 06 b7 40 01
loc_4483:
    mov word [bird_x], ax                                                       ; 4483: a3 b2 40
loc_4486:
    call near check_bird_goal_contact                                           ; 4486: e8 a4 00
loc_4489:
    mov cx, word [bird_x]                                                       ; 4489: 8b 0e b2 40
loc_448d:
    mov dl, byte [bird_y]                                                       ; 448d: 8a 16 b4 40
loc_4491:
    call near calculate_cga_address                                             ; 4491: e8 1c e8
loc_4494:
    mov word [0x40bc], ax                                                       ; 4494: a3 bc 40
loc_4497:
    mov ax, 0xb800                                                              ; 4497: b8 00 b8
loc_449a:
    mov es, ax                                                                  ; 449a: 8e c0
loc_449c:
    cmp byte [0x40b9], strict byte 0                                            ; 449c: 80 3e b9 40 00
loc_44a1:
    jne loc_44b0                                                                ; 44a1: 75 0d
loc_44a3:
    mov si, 0x3f2c                                                              ; 44a3: be 2c 3f
loc_44a6:
    mov di, word [0x40ba]                                                       ; 44a6: 8b 3e ba 40
loc_44aa:
    mov cx, 0x501                                                               ; 44aa: b9 01 05
loc_44ad:
    call near copy_rectangle_to_cga                                             ; 44ad: e8 ed e8
loc_44b0:
    call near loc_4557                                                          ; 44b0: e8 a4 00
loc_44b3:
    jb loc_44e6                                                                 ; 44b3: 72 31
loc_44b5:
    mov byte [0x40b9], 0                                                        ; 44b5: c6 06 b9 40 00
loc_44ba:
    add word [0x40be], strict byte 2                                            ; 44ba: 83 06 be 40 02
loc_44bf:
    mov bx, word [0x40be]                                                       ; 44bf: 8b 1e be 40
loc_44c3:
    and bx, strict word 6                                                       ; 44c3: 81 e3 06 00
loc_44c7:
    mov si, word [bx + 0x40c0]                                                  ; 44c7: 8b b7 c0 40
loc_44cb:
    cmp byte [0x40b7], strict byte 0xff                                         ; 44cb: 80 3e b7 40 ff
loc_44d0:
    jne loc_44d5                                                                ; 44d0: 75 03
loc_44d2:
    add si, strict byte 0x1e                                                    ; 44d2: 83 c6 1e
loc_44d5:
    mov di, word [0x40bc]                                                       ; 44d5: 8b 3e bc 40
loc_44d9:
    mov word [0x40ba], di                                                       ; 44d9: 89 3e ba 40
loc_44dd:
    mov bp, 0x3f2c                                                              ; 44dd: bd 2c 3f
loc_44e0:
    mov cx, 0x501                                                               ; 44e0: b9 01 05
loc_44e3:
    call near blit_zero_transparent                                             ; 44e3: e8 e6 e7
loc_44e6:
    ret                                                                         ; 44e6: c3
loc_44e7:
    cmp byte [player_vertical_direction], strict byte 0                         ; 44e7: 80 3e 71 05 00
loc_44ec:
    jne loc_44f9                                                                ; 44ec: 75 0b
loc_44ee:
    mov al, byte [player_y]                                                     ; 44ee: a0 7b 05
loc_44f1:
    and al, 0xf8                                                                ; 44f1: 24 f8
loc_44f3:
    cmp al, 0x88                                                                ; 44f3: 3c 88
loc_44f5:
    jne loc_44f9                                                                ; 44f5: 75 02
loc_44f7:
    stc                                                                         ; 44f7: f9
loc_44f8:
    ret                                                                         ; 44f8: c3
loc_44f9:
    clc                                                                         ; 44f9: f8
loc_44fa:
    ret                                                                         ; 44fa: c3
loc_44fb:
    mov ax, word [bird_x]                                                       ; 44fb: a1 b2 40
loc_44fe:
    mov dl, 1                                                                   ; 44fe: b2 01
loc_4500:
    sub ax, word [player_x]                                                     ; 4500: 2b 06 79 05
loc_4504:
    jae loc_450a                                                                ; 4504: 73 04
loc_4506:
    not ax                                                                      ; 4506: f7 d0
loc_4508:
    mov dl, 0xff                                                                ; 4508: b2 ff
loc_450a:
    mov byte [0x40ca], dl                                                       ; 450a: 88 16 ca 40
loc_450e:
    mov word [0x40cc], ax                                                       ; 450e: a3 cc 40
loc_4511:
    mov al, byte [bird_y]                                                       ; 4511: a0 b4 40
loc_4514:
    mov dl, 1                                                                   ; 4514: b2 01
loc_4516:
    sub al, byte [player_y]                                                     ; 4516: 2a 06 7b 05
loc_451a:
    jae loc_4520                                                                ; 451a: 73 04
loc_451c:
    not al                                                                      ; 451c: f6 d0
loc_451e:
    mov dl, 0xff                                                                ; 451e: b2 ff
loc_4520:
    mov byte [0x40cb], dl                                                       ; 4520: 88 16 cb 40
loc_4524:
    load8 sub, ah, ah                                                           ; 4524: 2a e4
loc_4526:
    shl ax, 1                                                                   ; 4526: d1 e0
loc_4528:
    add word [0x40cc], ax                                                       ; 4528: 01 06 cc 40
loc_452c:
    ret                                                                         ; 452c: c3
; CS:452d — check_bird_goal_contact
; Tests player against the bird at DS:40B2/40B4; overlapping contact sets scene_complete unless scene_failed is nonzero.
check_bird_goal_contact:
    mov ax, word [bird_x]                                                       ; 452d: a1 b2 40
loc_4530:
    mov dl, byte [bird_y]                                                       ; 4530: 8a 16 b4 40
loc_4534:
    mov si, 8                                                                   ; 4534: be 08 00
loc_4537:
    mov bx, word [player_x]                                                     ; 4537: 8b 1e 79 05
loc_453b:
    mov dh, byte [player_y]                                                     ; 453b: 8a 36 7b 05
loc_453f:
    mov di, 0x18                                                                ; 453f: bf 18 00
loc_4542:
    mov cx, 0xe05                                                               ; 4542: b9 05 0e
loc_4545:
    call near rectangles_overlap                                                ; 4545: e8 e1 e8
loc_4548:
    jae loc_4556                                                                ; 4548: 73 0c
loc_454a:
    cmp byte [scene_failed], strict byte 0                                      ; 454a: 80 3e 52 05 00
loc_454f:
    jne loc_4556                                                                ; 454f: 75 05
loc_4551:
    mov byte [scene_complete], 1                                                ; 4551: c6 06 53 05 01
loc_4556:
    ret                                                                         ; 4556: c3
loc_4557:
    mov ax, word [bird_x]                                                       ; 4557: a1 b2 40
loc_455a:
    mov dl, byte [bird_y]                                                       ; 455a: 8a 16 b4 40
loc_455e:
    mov si, 8                                                                   ; 455e: be 08 00
loc_4561:
    mov bx, word [shared_object_x]                                                       ; 4561: 8b 1e 7d 32
loc_4565:
    mov dh, byte [shared_object_y]                                                       ; 4565: 8a 36 7f 32
loc_4569:
    mov di, 0x10                                                                ; 4569: bf 10 00
loc_456c:
    mov cx, 0x1e05                                                              ; 456c: b9 05 1e
loc_456f:
    call near rectangles_overlap                                                ; 456f: e8 b7 e8
loc_4572:
    jae loc_4579                                                                ; 4572: 73 05
loc_4574:
    mov byte [0x40b8], 0xff                                                     ; 4574: c6 06 b8 40 ff
loc_4579:
    ret                                                                         ; 4579: c3
; CS:457a — initialize_bird_cage
; Places and draws the cage at X=144,Y=134, then resets cage/bird phase flags and a sentinel index.
initialize_bird_cage:
    mov cx, 0x90                                                                ; 457a: b9 90 00
loc_457d:
    mov dl, 0x86                                                                ; 457d: b2 86
loc_457f:
    mov word [bird_cage_x], cx                                                  ; 457f: 89 0e a8 40
loc_4583:
    mov byte [bird_cage_y], dl                                                  ; 4583: 88 16 aa 40
loc_4587:
    call near calculate_cga_address                                             ; 4587: e8 26 e7
loc_458a:
    mov word [bird_cage_video_offset], ax                                       ; 458a: a3 ab 40
loc_458d:
    call near loc_4759                                                          ; 458d: e8 c9 01
loc_4590:
    mov byte [bird_cage_push_pending], 0                                                        ; 4590: c6 06 af 40 00
loc_4595:
    mov byte [bird_cage_falling], 0                                                        ; 4595: c6 06 b1 40 00
loc_459a:
    mov byte [0x40b9], 1                                                        ; 459a: c6 06 b9 40 01
loc_459f:
    mov byte [0x40b8], 0                                                        ; 459f: c6 06 b8 40 00
loc_45a4:
    mov word [0x40c8], 0xff                                                     ; 45a4: c7 06 c8 40 ff 00
loc_45aa:
    ret                                                                         ; 45aa: c3
; CS:45ab — update_bird_cage
; Contact chooses a push direction and separates the player; a later update shifts the cage by eight. Leaving X=120..168 starts a BIOS-tick-gated fall in five-pixel steps, draws the broken cage, and initializes the released bird.
update_bird_cage:
    load8 sub, ah, ah                                                           ; 45ab: 2a e4
loc_45ad:
    int 0x1a                                                                    ; 45ad: cd 1a
loc_45af:
    cmp dx, word [bird_cage_last_tick]                                                       ; 45af: 3b 16 ad 40
loc_45b3:
    jne loc_45b6                                                                ; 45b3: 75 01
loc_45b5:
    ret                                                                         ; 45b5: c3
loc_45b6:
    mov word [bird_cage_last_tick], dx                                                       ; 45b6: 89 16 ad 40
loc_45ba:
    cmp byte [bird_cage_y], strict byte 0xa4                                    ; 45ba: 80 3e aa 40 a4
loc_45bf:
    jae loc_45b5                                                                ; 45bf: 73 f4
loc_45c1:
    call near loc_4786                                                          ; 45c1: e8 c2 01
loc_45c4:
    jae loc_45d6                                                                ; 45c4: 73 10
loc_45c6:
    call near loc_44e7                                                          ; 45c6: e8 1e ff
loc_45c9:
    jae loc_45b5                                                                ; 45c9: 73 ea
loc_45cb:
    mov byte [player_vertical_direction], 1                                     ; 45cb: c6 06 71 05 01
loc_45d0:
    mov byte [0x55b], 0x10                                                      ; 45d0: c6 06 5b 05 10
loc_45d5:
    ret                                                                         ; 45d5: c3
loc_45d6:
    call near check_bird_cage_player_contact                                                          ; 45d6: e8 65 01
loc_45d9:
    jae loc_4649                                                                ; 45d9: 73 6e
loc_45db:
    cmp byte [bird_cage_push_pending], strict byte 0                                            ; 45db: 80 3e af 40 00
loc_45e0:
    jne loc_45fa                                                                ; 45e0: 75 18
loc_45e2:
    mov al, byte [player_horizontal_direction]                                  ; 45e2: a0 6e 05
loc_45e5:
    cmp al, 0                                                                   ; 45e5: 3c 00
loc_45e7:
    jne loc_45f7                                                                ; 45e7: 75 0e
loc_45e9:
    inc al                                                                      ; 45e9: fe c0
loc_45eb:
    mov bx, word [bird_cage_x]                                                  ; 45eb: 8b 1e a8 40
loc_45ef:
    cmp bx, word [player_x]                                                     ; 45ef: 3b 1e 79 05
loc_45f3:
    ja loc_45f7                                                                 ; 45f3: 77 02
loc_45f5:
    mov al, 0xff                                                                ; 45f5: b0 ff
loc_45f7:
    mov byte [bird_cage_push_direction], al                                                       ; 45f7: a2 b0 40
loc_45fa:
    mov byte [bird_cage_push_pending], 1                                                        ; 45fa: c6 06 af 40 01
loc_45ff:
    mov cx, 0x20                                                                ; 45ff: b9 20 00
loc_4602:
    mov ax, word [player_x]                                                     ; 4602: a1 79 05
loc_4605:
    mov dl, 1                                                                   ; 4605: b2 01
loc_4607:
    cmp byte [bird_cage_push_direction], strict byte 1                                            ; 4607: 80 3e b0 40 01
loc_460c:
    jne loc_4615                                                                ; 460c: 75 07
loc_460e:
    sub ax, strict word 8                                                       ; 460e: 2d 08 00
loc_4611:
    mov dl, 0xff                                                                ; 4611: b2 ff
loc_4613:
    jmp short loc_4618                                                          ; 4613: eb 03
loc_4615:
    add ax, strict word 8                                                       ; 4615: 05 08 00
loc_4618:
    mov word [player_x], ax                                                     ; 4618: a3 79 05
loc_461b:
    mov byte [player_horizontal_direction], dl                                  ; 461b: 88 16 6e 05
loc_461f:
    mov al, byte [player_y]                                                     ; 461f: a0 7b 05
loc_4622:
    cmp byte [player_vertical_direction], strict byte 1                         ; 4622: 80 3e 71 05 01
loc_4627:
    jb loc_4639                                                                 ; 4627: 72 10
loc_4629:
    jne loc_462f                                                                ; 4629: 75 04
loc_462b:
    sub al, 3                                                                   ; 462b: 2c 03
loc_462d:
    jmp short loc_4631                                                          ; 462d: eb 02
loc_462f:
    add al, 3                                                                   ; 462f: 04 03
loc_4631:
    mov byte [player_y], al                                                     ; 4631: a2 7b 05
loc_4634:
    add al, 0x32                                                                ; 4634: 04 32
loc_4636:
    mov byte [player_y_plus_50], al                                             ; 4636: a2 7c 05
loc_4639:
    push cx                                                                     ; 4639: 51
loc_463a:
    call near check_bird_cage_player_contact                                                          ; 463a: e8 01 01
loc_463d:
    pop cx                                                                      ; 463d: 59
loc_463e:
    jae loc_4642                                                                ; 463e: 73 02
loc_4640:
    loop loc_4602                                                               ; 4640: e2 c0
loc_4642:
    call near restore_player_background                                         ; 4642: e8 9e cb
loc_4645:
    call near save_player_background_at_position                                ; 4645: e8 ca ca
loc_4648:
    ret                                                                         ; 4648: c3
loc_4649:
    cmp byte [bird_cage_falling], strict byte 0                                            ; 4649: 80 3e b1 40 00
loc_464e:
    jne loc_46a2                                                                ; 464e: 75 52
loc_4650:
    cmp byte [bird_cage_push_pending], strict byte 0                                            ; 4650: 80 3e af 40 00
loc_4655:
    je loc_4648                                                                 ; 4655: 74 f1
loc_4657:
    mov ax, word [bird_cage_x]                                                  ; 4657: a1 a8 40
loc_465a:
    cmp byte [bird_cage_push_direction], strict byte 1                                            ; 465a: 80 3e b0 40 01
loc_465f:
    jne loc_4666                                                                ; 465f: 75 05
loc_4661:
    add ax, strict word 8                                                       ; 4661: 05 08 00
loc_4664:
    jmp short loc_4669                                                          ; 4664: eb 03
loc_4666:
    sub ax, strict word 8                                                       ; 4666: 2d 08 00
loc_4669:
    mov word [bird_cage_x], ax                                                  ; 4669: a3 a8 40
loc_466c:
    call near check_bird_cage_player_contact                                                          ; 466c: e8 cf 00
loc_466f:
    jae loc_4672                                                                ; 466f: 73 01
loc_4671:
    ret                                                                         ; 4671: c3
loc_4672:
    mov ax, 0xc00                                                               ; 4672: b8 00 0c
loc_4675:
    mov bx, 0xb54                                                               ; 4675: bb 54 0b
loc_4678:
    call near start_two_stage_sound                                             ; 4678: e8 c0 12
loc_467b:
    mov byte [bird_cage_push_pending], 0                                                        ; 467b: c6 06 af 40 00
loc_4680:
    mov cx, word [bird_cage_x]                                                  ; 4680: 8b 0e a8 40
loc_4684:
    mov dl, byte [bird_cage_y]                                                  ; 4684: 8a 16 aa 40
loc_4688:
    call near calculate_cga_address                                             ; 4688: e8 25 e6
loc_468b:
    mov word [bird_cage_video_offset], ax                                       ; 468b: a3 ab 40
loc_468e:
    call near loc_4773                                                          ; 468e: e8 e2 00
loc_4691:
    call near loc_4759                                                          ; 4691: e8 c5 00
loc_4694:
    mov ax, word [bird_cage_x]                                                  ; 4694: a1 a8 40
loc_4697:
    cmp ax, strict word 0x78                                                    ; 4697: 3d 78 00
loc_469a:
    jb loc_46a2                                                                 ; 469a: 72 06
loc_469c:
    cmp ax, strict word 0xa8                                                    ; 469c: 3d a8 00
loc_469f:
    ja loc_46a2                                                                 ; 469f: 77 01
loc_46a1:
    ret                                                                         ; 46a1: c3
loc_46a2:
    mov byte [bird_cage_falling], 1                                                        ; 46a2: c6 06 b1 40 01
loc_46a7:
    cmp byte [enemy_active], strict byte 0                                      ; 46a7: 80 3e bf 1c 00
loc_46ac:
    je loc_46be                                                                 ; 46ac: 74 10
loc_46ae:
    call near loc_44e7                                                          ; 46ae: e8 36 fe
loc_46b1:
    jae loc_46bd                                                                ; 46b1: 73 0a
loc_46b3:
    mov byte [player_vertical_direction], 1                                     ; 46b3: c6 06 71 05 01
loc_46b8:
    mov byte [0x55b], 0x10                                                      ; 46b8: c6 06 5b 05 10
loc_46bd:
    ret                                                                         ; 46bd: c3
loc_46be:
    load8 sub, ah, ah                                                           ; 46be: 2a e4
loc_46c0:
    int 0x1a                                                                    ; 46c0: cd 1a
loc_46c2:
    cmp dx, word [bird_cage_last_tick]                                                       ; 46c2: 3b 16 ad 40
loc_46c6:
    je loc_46a2                                                                 ; 46c6: 74 da
loc_46c8:
    mov word [bird_cage_last_tick], dx                                                       ; 46c8: 89 16 ad 40
loc_46cc:
    cmp byte [sound_enabled], strict byte 0                                     ; 46cc: 80 3e 00 00 00
loc_46d1:
    je loc_46ec                                                                 ; 46d1: 74 19
loc_46d3:
    mov al, 0xb6                                                                ; 46d3: b0 b6
loc_46d5:
    out 0x43, al                                                                ; 46d5: e6 43
loc_46d7:
    mov al, byte [bird_cage_y]                                                  ; 46d7: a0 aa 40
loc_46da:
    load8 sub, ah, ah                                                           ; 46da: 2a e4
loc_46dc:
    shl ax, 1                                                                   ; 46dc: d1 e0
loc_46de:
    shl ax, 1                                                                   ; 46de: d1 e0
loc_46e0:
    out 0x42, al                                                                ; 46e0: e6 42
loc_46e2:
    load8 mov, al, ah                                                           ; 46e2: 8a c4
loc_46e4:
    out 0x42, al                                                                ; 46e4: e6 42
loc_46e6:
    in al, 0x61                                                                 ; 46e6: e4 61
loc_46e8:
    or al, 3                                                                    ; 46e8: 0c 03
loc_46ea:
    out 0x61, al                                                                ; 46ea: e6 61
loc_46ec:
    mov dl, byte [bird_cage_y]                                                  ; 46ec: 8a 16 aa 40
loc_46f0:
    cmp dl, strict byte 0xa4                                                    ; 46f0: 80 fa a4
loc_46f3:
    jae loc_470e                                                                ; 46f3: 73 19
loc_46f5:
    add dl, strict byte 5                                                       ; 46f5: 80 c2 05
loc_46f8:
    mov byte [bird_cage_y], dl                                                  ; 46f8: 88 16 aa 40
loc_46fc:
    mov cx, word [bird_cage_x]                                                  ; 46fc: 8b 0e a8 40
loc_4700:
    call near calculate_cga_address                                             ; 4700: e8 ad e5
loc_4703:
    mov word [bird_cage_video_offset], ax                                       ; 4703: a3 ab 40
loc_4706:
    call near loc_4773                                                          ; 4706: e8 6a 00
loc_4709:
    call near loc_4759                                                          ; 4709: e8 4d 00
loc_470c:
    jmp short loc_46be                                                          ; 470c: eb b0
loc_470e:
    call near disable_speaker                                                   ; 470e: e8 10 14
loc_4711:
    call near loc_4773                                                          ; 4711: e8 5f 00
loc_4714:
    mov bp, 0x401e                                                              ; 4714: bd 1e 40
loc_4717:
    dec word [0x40a6]                                                           ; 4717: ff 0e a6 40
loc_471b:
    mov di, word [0x40a6]                                                       ; 471b: 8b 3e a6 40
loc_471f:
    mov si, 0x3f36                                                              ; 471f: be 36 3f
loc_4722:
    mov cx, 0x1104                                                              ; 4722: b9 04 11
loc_4725:
    call near blit_and_mask                                                     ; 4725: e8 0d e6
loc_4728:
    mov ax, word [bird_cage_x]                                                  ; 4728: a1 a8 40
loc_472b:
    mov word [bird_x], ax                                                       ; 472b: a3 b2 40
loc_472e:
    mov al, byte [bird_cage_y]                                                  ; 472e: a0 aa 40
loc_4731:
    mov byte [bird_y], al                                                       ; 4731: a2 b4 40
loc_4734:
    call near loc_44fb                                                          ; 4734: e8 c4 fd
loc_4737:
    mov al, byte [0x40ca]                                                       ; 4737: a0 ca 40
loc_473a:
    mov byte [0x40b7], al                                                       ; 473a: a2 b7 40
loc_473d:
    ret                                                                         ; 473d: c3
; CS:473e — check_bird_cage_player_contact
; Checks the cage rectangle at DS:40A8/40AA against the player rectangle and returns carry on overlap.
check_bird_cage_player_contact:
    mov ax, word [bird_cage_x]                                                  ; 473e: a1 a8 40
loc_4741:
    mov dl, byte [bird_cage_y]                                                  ; 4741: 8a 16 aa 40
loc_4745:
    mov si, 0x18                                                                ; 4745: be 18 00
loc_4748:
    mov bx, word [player_x]                                                     ; 4748: 8b 1e 79 05
loc_474c:
    mov dh, byte [player_y]                                                     ; 474c: 8a 36 7b 05
loc_4750:
    load16 mov, di, si                                                          ; 4750: 8b fe
loc_4752:
    mov cx, 0xe10                                                               ; 4752: b9 10 0e
loc_4755:
    call near rectangles_overlap                                                ; 4755: e8 d1 e6
loc_4758:
    ret                                                                         ; 4758: c3
loc_4759:
    mov ax, 0xb800                                                              ; 4759: b8 00 b8
loc_475c:
    mov es, ax                                                                  ; 475c: 8e c0
loc_475e:
    mov bp, 0x401e                                                              ; 475e: bd 1e 40
loc_4761:
    mov si, 0x3fbe                                                              ; 4761: be be 3f
loc_4764:
    mov di, word [bird_cage_video_offset]                                       ; 4764: 8b 3e ab 40
loc_4768:
    mov word [0x40a6], di                                                       ; 4768: 89 3e a6 40
loc_476c:
    mov cx, 0x1003                                                              ; 476c: b9 03 10
loc_476f:
    call near blit_and_mask                                                     ; 476f: e8 c3 e5
loc_4772:
    ret                                                                         ; 4772: c3
loc_4773:
    mov ax, 0xb800                                                              ; 4773: b8 00 b8
loc_4776:
    mov es, ax                                                                  ; 4776: 8e c0
loc_4778:
    mov si, 0x401e                                                              ; 4778: be 1e 40
loc_477b:
    mov di, word [0x40a6]                                                       ; 477b: 8b 3e a6 40
loc_477f:
    mov cx, 0x1003                                                              ; 477f: b9 03 10
loc_4782:
    call near copy_rectangle_to_cga                                             ; 4782: e8 18 e6
loc_4785:
    ret                                                                         ; 4785: c3
loc_4786:
    cmp byte [shared_object_y], strict byte 0x66                                         ; 4786: 80 3e 7f 32 66
loc_478b:
    jb loc_47a4                                                                 ; 478b: 72 17
loc_478d:
    mov ax, word [bird_cage_x]                                                  ; 478d: a1 a8 40
loc_4790:
    sub ax, strict word 0x14                                                    ; 4790: 2d 14 00
loc_4793:
    cmp ax, word [shared_object_x]                                                       ; 4793: 3b 06 7d 32
loc_4797:
    ja loc_47a4                                                                 ; 4797: 77 0b
loc_4799:
    add ax, strict word 0x30                                                    ; 4799: 05 30 00
loc_479c:
    cmp ax, word [shared_object_x]                                                       ; 479c: 3b 06 7d 32
loc_47a0:
    jb loc_47a4                                                                 ; 47a0: 72 02
loc_47a2:
    stc                                                                         ; 47a2: f9
loc_47a3:
    ret                                                                         ; 47a3: c3
loc_47a4:
    clc                                                                         ; 47a4: f8
loc_47a5:
    ret                                                                         ; 47a5: c3
    times 10 db 0 ; original zero fill at CS:47a6
loc_47b0:
    mov ax, word [shared_object_x]                                                       ; 47b0: a1 7d 32
loc_47b3:
    mov dl, byte [shared_object_y]                                                       ; 47b3: 8a 16 7f 32
loc_47b7:
    mov si, 0x10                                                                ; 47b7: be 10 00
loc_47ba:
    mov bx, word [player_x]                                                     ; 47ba: 8b 1e 79 05
loc_47be:
    sub bx, strict byte 8                                                       ; 47be: 83 eb 08
loc_47c1:
    jae loc_47c5                                                                ; 47c1: 73 02
loc_47c3:
    load16 sub, bx, bx                                                          ; 47c3: 2b db
loc_47c5:
    mov dh, byte [player_y]                                                     ; 47c5: 8a 36 7b 05
loc_47c9:
    add dh, strict byte 3                                                       ; 47c9: 80 c6 03
loc_47cc:
    mov di, 0x28                                                                ; 47cc: bf 28 00
loc_47cf:
    mov cx, 0xe1e                                                               ; 47cf: b9 1e 0e
loc_47d2:
    call near rectangles_overlap                                                ; 47d2: e8 54 e6
loc_47d5:
    ret                                                                         ; 47d5: c3
