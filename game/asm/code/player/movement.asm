; Player initialization and movement state machine.
; Original CS:070D..0F87 (end exclusive).

; CS:070d — initialize_alley_player
; Chooses X=0 or 296 from prior X relative to 160, sets Y=180 and biased Y=230, sets inward horizontal direction, saves background, and resets player flags.
initialize_alley_player:
    mov cx, 0                                                                   ; 070d: b9 00 00
loc_0710:
    mov ah, 1                                                                   ; 0710: b4 01
loc_0712:
    cmp word [player_x], strict word 0xa0                                       ; 0712: 81 3e 79 05 a0 00
loc_0718:
    jb loc_071f                                                                 ; 0718: 72 05
loc_071a:
    mov cx, 0x128                                                               ; 071a: b9 28 01
loc_071d:
    mov ah, 0xff                                                                ; 071d: b4 ff
loc_071f:
    mov byte [player_horizontal_direction], ah                                  ; 071f: 88 26 6e 05
loc_0723:
    mov byte [0x558], 3                                                         ; 0723: c6 06 58 05 03
loc_0728:
    mov byte [0x559], 0xc                                                       ; 0728: c6 06 59 05 0c
loc_072d:
    mov dl, 0xb4                                                                ; 072d: b2 b4
loc_072f:
    mov word [player_x], cx                                                     ; 072f: 89 0e 79 05
loc_0733:
    mov byte [player_y], dl                                                     ; 0733: 88 16 7b 05
loc_0737:
    mov byte [player_y_plus_50], 0xe6                                           ; 0737: c6 06 7c 05 e6
loc_073c:
    call near calculate_cga_address                                             ; 073c: e8 71 25
loc_073f:
    mov word [player_video_offset], ax                                          ; 073f: a3 5f 05
loc_0742:
    mov word [player_saved_dimensions], 0xb03                                   ; 0742: c7 06 61 05 03 0b
loc_0748:
    call near save_player_background                                            ; 0748: e8 d9 09
loc_074b:
    mov byte [player_vertical_direction], 0                                     ; 074b: c6 06 71 05 00
loc_0750:
    mov word [player_horizontal_speed], 2                                       ; 0750: c7 06 72 05 02 00
loc_0756:
    mov byte [player_vertical_speed], 1                                         ; 0756: c6 06 76 05 01
loc_075b:
    mov byte [0x55b], 0                                                         ; 075b: c6 06 5b 05 00
loc_0760:
    mov byte [player_alley_motion_mode], 0                                      ; 0760: c6 06 50 05 00
loc_0765:
    mov byte [player_support_kind], 0                                           ; 0765: c6 06 5c 05 00
loc_076a:
    mov byte [player_transition_blocked], 0                                     ; 076a: c6 06 5a 05 00
loc_076f:
    mov byte [0x583], 0                                                         ; 076f: c6 06 83 05 00
loc_0774:
    mov byte [input_horizontal], 0                                              ; 0774: c6 06 98 06 00
loc_0779:
    mov byte [input_vertical], 0                                                ; 0779: c6 06 99 06 00
loc_077e:
    mov byte [scene_exit_requested], 0                                          ; 077e: c6 06 51 05 00
loc_0783:
    mov byte [0x584], 0                                                         ; 0783: c6 06 84 05 00
loc_0788:
    mov byte [scene_failed], 0                                                  ; 0788: c6 06 52 05 00
loc_078d:
    mov word [enter_aquarium_requested], 0                                      ; 078d: c7 06 54 05 00 00
loc_0793:
    mov byte [scene_complete], 0                                                ; 0793: c6 06 53 05 00
loc_0798:
    mov byte [0x127c], 0                                                        ; 0798: c6 06 7c 12 00
loc_079d:
    call near reset_player_update_clock                                         ; 079d: e8 60 ff
loc_07a0:
    ret                                                                         ; 07a0: c3
; CS:07a1 — initialize_scene_player
; Loads player coordinates from per-scene tables, or saved alley coordinates for scene zero; biased Y is Y+50. Scene two initializes separate swimming state.
initialize_scene_player:
    mov bx, word [scene_index]                                                  ; 07a1: 8b 1e 04 00
loc_07a5:
    cmp bx, strict byte 0                                                       ; 07a5: 83 fb 00
loc_07a8:
    jne loc_07b5                                                                ; 07a8: 75 0b
loc_07aa:
    mov cx, word [saved_alley_player_x]                                         ; 07aa: 8b 0e 01 00
loc_07ae:
    mov dl, byte [saved_alley_player_y]                                         ; 07ae: 8a 16 03 00
loc_07b2:
    jmp short loc_07bf                                                          ; 07b2: eb 0b
loc_07b4:
    nop                                                                         ; 07b4: 90
loc_07b5:
    mov dl, byte [bx + 0x5e9]                                                   ; 07b5: 8a 97 e9 05
loc_07b9:
    shl bl, 1                                                                   ; 07b9: d0 e3
loc_07bb:
    mov cx, word [bx + 0x5d9]                                                   ; 07bb: 8b 8f d9 05
loc_07bf:
    mov word [player_x], cx                                                     ; 07bf: 89 0e 79 05
loc_07c3:
    mov byte [player_y], dl                                                     ; 07c3: 88 16 7b 05
loc_07c7:
    load8 mov, al, dl                                                           ; 07c7: 8a c2
loc_07c9:
    add al, 0x32                                                                ; 07c9: 04 32
loc_07cb:
    mov byte [player_y_plus_50], al                                             ; 07cb: a2 7c 05
loc_07ce:
    call near calculate_cga_address                                             ; 07ce: e8 df 24
loc_07d1:
    mov word [player_video_offset], ax                                          ; 07d1: a3 5f 05
loc_07d4:
    mov ax, word [0xfb2]                                                        ; 07d4: a1 b2 0f
loc_07d7:
    mov word [0x569], ax                                                        ; 07d7: a3 69 05
loc_07da:
    mov ax, word [0xfbe]                                                        ; 07da: a1 be 0f
loc_07dd:
    mov word [0x567], ax                                                        ; 07dd: a3 67 05
loc_07e0:
    mov word [player_saved_dimensions], ax                                      ; 07e0: a3 61 05
loc_07e3:
    call near save_player_background                                            ; 07e3: e8 3e 09
loc_07e6:
    mov byte [player_vertical_direction], 1                                     ; 07e6: c6 06 71 05 01
loc_07eb:
    mov byte [player_horizontal_direction], 0                                   ; 07eb: c6 06 6e 05 00
loc_07f0:
    mov byte [player_vertical_speed], 1                                         ; 07f0: c6 06 76 05 01
loc_07f5:
    mov byte [player_vertical_acceleration_step], 0x40                          ; 07f5: c6 06 78 05 40
loc_07fa:
    mov al, 0xa                                                                 ; 07fa: b0 0a
loc_07fc:
    cmp word [scene_index], strict byte 7                                       ; 07fc: 83 3e 04 00 07
loc_0801:
    jne loc_0805                                                                ; 0801: 75 02
loc_0803:
    load8 sub, al, al                                                           ; 0803: 2a c0
loc_0805:
    mov byte [0x55b], al                                                        ; 0805: a2 5b 05
loc_0808:
    mov byte [player_alley_motion_mode], 0                                      ; 0808: c6 06 50 05 00
loc_080d:
    mov byte [player_support_kind], 0                                           ; 080d: c6 06 5c 05 00
loc_0812:
    mov byte [player_transition_blocked], 0                                     ; 0812: c6 06 5a 05 00
loc_0817:
    mov byte [0x583], 0                                                         ; 0817: c6 06 83 05 00
loc_081c:
    mov byte [input_horizontal], 0                                              ; 081c: c6 06 98 06 00
loc_0821:
    mov byte [input_vertical], 0                                                ; 0821: c6 06 99 06 00
loc_0826:
    mov byte [scene_exit_requested], 0                                          ; 0826: c6 06 51 05 00
loc_082b:
    mov byte [0x584], 0                                                         ; 082b: c6 06 84 05 00
loc_0830:
    mov byte [scene_failed], 0                                                  ; 0830: c6 06 52 05 00
loc_0835:
    mov word [enter_aquarium_requested], 0                                      ; 0835: c7 06 54 05 00 00
loc_083b:
    mov byte [scene_complete], 0                                                ; 083b: c6 06 53 05 00
loc_0840:
    mov byte [0x127c], 0                                                        ; 0840: c6 06 7c 12 00
loc_0845:
    call near reset_player_update_clock                                         ; 0845: e8 b8 fe
loc_0848:
    cmp word [scene_index], strict byte 2                                       ; 0848: 83 3e 04 00 02
loc_084d:
    jne loc_0871                                                                ; 084d: 75 22
loc_084f:
    mov byte [player_vertical_speed], 0x10                                      ; 084f: c6 06 76 05 10
loc_0854:
    mov word [0x574], 0x10                                                      ; 0854: c7 06 74 05 10 00
loc_085a:
    load8 sub, ah, ah                                                           ; 085a: 2a e4
loc_085c:
    int 0x1a                                                                    ; 085c: cd 1a
loc_085e:
    mov word [aquarium_last_surface_tick], dx                                                        ; 085e: 89 16 f1 05
loc_0862:
    mov byte [aquarium_drowning], 0                                                         ; 0862: c6 06 f3 05 00
loc_0867:
    mov byte [aquarium_bubble_distance], 5                                                         ; 0867: c6 06 f4 05 05
loc_086c:
    mov byte [aquarium_bubble_countdown], 1                                                         ; 086c: c6 06 f5 05 01
loc_0871:
    ret                                                                         ; 0871: c3
; CS:0872 — apply_room_object_bounce
; Starts the room-contact sound and, unless already bouncing, forces player motion away from the room reference point with speed eight and a sixteen-update support lockout; does not set scene_failed.
apply_room_object_bounce:
    mov word [0x592a], 0x400                                                    ; 0872: c7 06 2a 59 00 04
loc_0878:
    cmp byte [0x584], strict byte 0                                             ; 0878: 80 3e 84 05 00
loc_087d:
    je loc_0880                                                                 ; 087d: 74 01
loc_087f:
    ret                                                                         ; 087f: c3
loc_0880:
    mov byte [player_vertical_speed], 8                                         ; 0880: c6 06 76 05 08
loc_0885:
    mov dl, 0xff                                                                ; 0885: b2 ff
loc_0887:
    mov al, byte [player_y]                                                     ; 0887: a0 7b 05
loc_088a:
    cmp al, byte [0x2652]                                                       ; 088a: 3a 06 52 26
loc_088e:
    jae loc_0892                                                                ; 088e: 73 02
loc_0890:
    mov dl, 1                                                                   ; 0890: b2 01
loc_0892:
    mov byte [player_vertical_direction], dl                                    ; 0892: 88 16 71 05
loc_0896:
    mov ax, word [player_x]                                                     ; 0896: a1 79 05
loc_0899:
    sub ax, word [0x2650]                                                       ; 0899: 2b 06 50 26
loc_089d:
    mov dl, 0xff                                                                ; 089d: b2 ff
loc_089f:
    ja loc_08a5                                                                 ; 089f: 77 04
loc_08a1:
    mov dl, 1                                                                   ; 08a1: b2 01
loc_08a3:
    not ax                                                                      ; 08a3: f7 d0
loc_08a5:
    mov byte [player_horizontal_direction], dl                                  ; 08a5: 88 16 6e 05
loc_08a9:
    cmp ah, strict byte 0                                                       ; 08a9: 80 fc 00
loc_08ac:
    je loc_08b1                                                                 ; 08ac: 74 03
loc_08ae:
    mov ax, 0xff                                                                ; 08ae: b8 ff 00
loc_08b1:
    not al                                                                      ; 08b1: f6 d0
loc_08b3:
    cmp al, 0x30                                                                ; 08b3: 3c 30
loc_08b5:
    jae loc_08b9                                                                ; 08b5: 73 02
loc_08b7:
    mov al, 0x30                                                                ; 08b7: b0 30
loc_08b9:
    load8 mov, bl, al                                                           ; 08b9: 8a d8
loc_08bb:
    shr bl, 1                                                                   ; 08bb: d0 eb
loc_08bd:
    shr bl, 1                                                                   ; 08bd: d0 eb
loc_08bf:
    load8 sub, al, bl                                                           ; 08bf: 2a c3
loc_08c1:
    mov byte [player_vertical_acceleration_step], al                            ; 08c1: a2 78 05
loc_08c4:
    mov cl, 5                                                                   ; 08c4: b1 05
loc_08c6:
    shr al, cl                                                                  ; 08c6: d2 e8
loc_08c8:
    mov word [player_horizontal_speed], ax                                      ; 08c8: a3 72 05
loc_08cb:
    mov byte [player_support_kind], 0                                           ; 08cb: c6 06 5c 05 00
loc_08d0:
    mov byte [0x39e0], 0                                                        ; 08d0: c6 06 e0 39 00
loc_08d5:
    mov byte [player_motion_accumulator], 1                                     ; 08d5: c6 06 77 05 01
loc_08da:
    mov byte [0x55b], 0x10                                                      ; 08da: c6 06 5b 05 10
loc_08df:
    mov byte [0x584], 1                                                         ; 08df: c6 06 84 05 01
loc_08e4:
    ret                                                                         ; 08e4: c3
; CS:08e5 — update_player
; Updates player position, motion, collision, animation and drawing; scene two uses a separate swimming branch. BIOS ticks, a call countdown, and retrace reads gate execution.
update_player:
    load8 sub, ah, ah                                                           ; 08e5: 2a e4
loc_08e7:
    int 0x1a                                                                    ; 08e7: cd 1a
loc_08e9:
    cmp dx, word [player_last_update_tick]                                      ; 08e9: 3b 16 7d 05
loc_08ed:
    jne loc_08fd                                                                ; 08ed: 75 0e
loc_08ef:
    cmp word [player_same_tick_countdown], strict byte 0                        ; 08ef: 83 3e 84 06 00
loc_08f4:
    je loc_08fc                                                                 ; 08f4: 74 06
loc_08f6:
    dec word [player_same_tick_countdown]                                       ; 08f6: ff 0e 84 06
loc_08fa:
    je loc_090c                                                                 ; 08fa: 74 10
loc_08fc:
    ret                                                                         ; 08fc: c3
loc_08fd:
    mov ax, 0x20                                                                ; 08fd: b8 20 00
loc_0900:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 0900: 80 3e 97 06 fd
loc_0905:
    jne loc_0909                                                                ; 0905: 75 02
loc_0907:
    shr ax, 1                                                                   ; 0907: d1 e8
loc_0909:
    mov word [player_same_tick_countdown], ax                                   ; 0909: a3 84 06
loc_090c:
    cmp word [scene_index], strict byte 2                                       ; 090c: 83 3e 04 00 02
loc_0911:
    je loc_091d                                                                 ; 0911: 74 0a
loc_0913:
    mov cl, byte [player_vertical_direction]                                    ; 0913: 8a 0e 71 05
loc_0917:
    or cl, byte [player_horizontal_direction]                                   ; 0917: 0a 0e 6e 05
loc_091b:
    jne loc_0926                                                                ; 091b: 75 09
loc_091d:
    push dx                                                                     ; 091d: 52
loc_091e:
    push ax                                                                     ; 091e: 50
loc_091f:
    call near read_cga_vertical_retrace_bit                                     ; 091f: e8 b6 0a
loc_0922:
    pop ax                                                                      ; 0922: 58
loc_0923:
    pop dx                                                                      ; 0923: 5a
loc_0924:
    je loc_08fc                                                                 ; 0924: 74 d6
loc_0926:
    mov word [player_last_update_tick], dx                                      ; 0926: 89 16 7d 05
loc_092a:
    mov word [0x57f], ax                                                        ; 092a: a3 7f 05
loc_092d:
    cmp word [scene_index], strict byte 4                                       ; 092d: 83 3e 04 00 04
loc_0932:
    jne loc_093b                                                                ; 0932: 75 07
loc_0934:
    cmp byte [0x39e1], strict byte 0                                            ; 0934: 80 3e e1 39 00
loc_0939:
    jne loc_08fc                                                                ; 0939: 75 c1
loc_093b:
    cmp word [scene_index], strict byte 6                                       ; 093b: 83 3e 04 00 06
loc_0940:
    jne loc_0949                                                                ; 0940: 75 07
loc_0942:
    cmp byte [0x44bd], strict byte 0                                            ; 0942: 80 3e bd 44 00
loc_0947:
    jne loc_08fc                                                                ; 0947: 75 b3
loc_0949:
    cmp word [scene_index], strict byte 2                                       ; 0949: 83 3e 04 00 02
loc_094e:
    je loc_0953                                                                 ; 094e: 74 03
loc_0950:
    jmp near loc_0bac                                                           ; 0950: e9 59 02
loc_0953:
    mov si, word [difficulty_level]                                             ; 0953: 8b 36 08 00
loc_0957:
    shl si, 1                                                                   ; 0957: d1 e6
loc_0959:
    mov ax, word [player_last_update_tick]                                      ; 0959: a1 7d 05
loc_095c:
    sub ax, word [aquarium_last_surface_tick]                                                        ; 095c: 2b 06 f1 05
loc_0960:
    cmp ax, word [si + aquarium_drowning_thresholds]                                                   ; 0960: 3b 84 89 05
loc_0964:
    jb loc_09d6                                                                 ; 0964: 72 70
loc_0966:
    cmp ax, word [si + aquarium_failure_thresholds]                                                   ; 0966: 3b 84 99 05
loc_096a:
    jb loc_0971                                                                 ; 096a: 72 05
loc_096c:
    mov byte [scene_failed], 1                                                  ; 096c: c6 06 52 05 01
loc_0971:
    dec byte [aquarium_bubble_countdown]                                                            ; 0971: fe 0e f5 05
loc_0975:
    jne loc_09b9                                                                ; 0975: 75 42
loc_0977:
    call near loc_597f                                                          ; 0977: e8 05 50
loc_097a:
    mov byte [aquarium_bubble_countdown], 6                                                         ; 097a: c6 06 f5 05 06
loc_097f:
    mov al, byte [aquarium_bubble_distance]                                                        ; 097f: a0 f4 05
loc_0982:
    cmp byte [player_y], strict byte 0xb3                                       ; 0982: 80 3e 7b 05 b3
loc_0987:
    jb loc_0992                                                                 ; 0987: 72 09
loc_0989:
    cmp al, 0xc8                                                                ; 0989: 3c c8
loc_098b:
    jae loc_0992                                                                ; 098b: 73 05
loc_098d:
    add al, 0x1e                                                                ; 098d: 04 1e
loc_098f:
    mov byte [aquarium_bubble_distance], al                                                        ; 098f: a2 f4 05
loc_0992:
    mov dl, byte [player_y]                                                     ; 0992: 8a 16 7b 05
loc_0996:
    load8 sub, dl, al                                                           ; 0996: 2a d0
loc_0998:
    jae loc_099c                                                                ; 0998: 73 02
loc_099a:
    load8 sub, dl, dl                                                           ; 099a: 2a d2
loc_099c:
    mov cx, word [player_x]                                                     ; 099c: 8b 0e 79 05
loc_09a0:
    and dl, strict byte 0xf8                                                    ; 09a0: 80 e2 f8
loc_09a3:
    call near calculate_cga_address                                             ; 09a3: e8 0a 23
loc_09a6:
    load16 mov, di, ax                                                          ; 09a6: 8b f8
loc_09a8:
    mov si, 0x64e                                                               ; 09a8: be 4e 06
loc_09ab:
    mov ax, 0xb800                                                              ; 09ab: b8 00 b8
loc_09ae:
    mov es, ax                                                                  ; 09ae: 8e c0
loc_09b0:
    mov bp, 0xe                                                                 ; 09b0: bd 0e 00
loc_09b3:
    mov cx, 0x503                                                               ; 09b3: b9 03 05
loc_09b6:
    call near blit_and_mask                                                     ; 09b6: e8 7c 23
loc_09b9:
    mov byte [player_horizontal_direction], 0                                   ; 09b9: c6 06 6e 05 00
loc_09be:
    mov byte [player_vertical_direction], 1                                     ; 09be: c6 06 71 05 01
loc_09c3:
    mov byte [aquarium_drowning], 1                                                         ; 09c3: c6 06 f3 05 01
loc_09c8:
    mov byte [player_vertical_speed], 0x20                                      ; 09c8: c6 06 76 05 20
loc_09cd:
    load16 sub, bx, bx                                                          ; 09cd: 2b db
loc_09cf:
    mov ah, 0xb                                                                 ; 09cf: b4 0b
loc_09d1:
    int 0x10                                                                    ; 09d1: cd 10
loc_09d3:
    jmp near loc_0a86                                                           ; 09d3: e9 b0 00
loc_09d6:
    mov si, word [difficulty_level]                                             ; 09d6: 8b 36 08 00
loc_09da:
    shl si, 1                                                                   ; 09da: d1 e6
loc_09dc:
    load16 sub, bx, bx                                                          ; 09dc: 2b db
loc_09de:
    cmp ax, word [si + aquarium_palette_phase_one_ticks]                                                   ; 09de: 3b 84 a9 05
loc_09e2:
    jb loc_09f6                                                                 ; 09e2: 72 12
loc_09e4:
    inc bl                                                                      ; 09e4: fe c3
loc_09e6:
    cmp ax, word [si + aquarium_palette_phase_two_ticks]                                                   ; 09e6: 3b 84 b9 05
loc_09ea:
    jb loc_09f6                                                                 ; 09ea: 72 0a
loc_09ec:
    mov bl, 5                                                                   ; 09ec: b3 05
loc_09ee:
    cmp ax, word [si + aquarium_palette_phase_three_ticks]                                                   ; 09ee: 3b 84 c9 05
loc_09f2:
    jb loc_09f6                                                                 ; 09f2: 72 02
loc_09f4:
    dec bl                                                                      ; 09f4: fe cb
loc_09f6:
    mov ah, 0xb                                                                 ; 09f6: b4 0b
loc_09f8:
    int 0x10                                                                    ; 09f8: cd 10
loc_09fa:
    mov al, byte [player_horizontal_direction]                                  ; 09fa: a0 6e 05
loc_09fd:
    mov byte [player_previous_horizontal_direction], al                         ; 09fd: a2 6f 05
loc_0a00:
    mov al, byte [player_vertical_direction]                                    ; 0a00: a0 71 05
loc_0a03:
    mov byte [0x570], al                                                        ; 0a03: a2 70 05
loc_0a06:
    mov al, byte [input_horizontal]                                             ; 0a06: a0 98 06
loc_0a09:
    cmp al, 0                                                                   ; 0a09: 3c 00
loc_0a0b:
    jne loc_0a1a                                                                ; 0a0b: 75 0d
loc_0a0d:
    cmp word [0x574], strict byte 0x10                                          ; 0a0d: 83 3e 74 05 10
loc_0a12:
    jb loc_0a2e                                                                 ; 0a12: 72 1a
loc_0a14:
    dec word [0x574]                                                            ; 0a14: ff 0e 74 05
loc_0a18:
    jmp short loc_0a37                                                          ; 0a18: eb 1d
loc_0a1a:
    cmp al, byte [player_horizontal_direction]                                  ; 0a1a: 3a 06 6e 05
loc_0a1e:
    jne loc_0a2e                                                                ; 0a1e: 75 0e
loc_0a20:
    cmp word [0x574], strict byte 0x30                                          ; 0a20: 83 3e 74 05 30
loc_0a25:
    jae loc_0a37                                                                ; 0a25: 73 10
loc_0a27:
    add word [0x574], strict byte 3                                             ; 0a27: 83 06 74 05 03
loc_0a2c:
    jmp short loc_0a37                                                          ; 0a2c: eb 09
loc_0a2e:
    mov byte [player_horizontal_direction], al                                  ; 0a2e: a2 6e 05
loc_0a31:
    mov word [0x574], 0x20                                                      ; 0a31: c7 06 74 05 20 00
loc_0a37:
    mov ax, word [0x574]                                                        ; 0a37: a1 74 05
loc_0a3a:
    mov cl, 3                                                                   ; 0a3a: b1 03
loc_0a3c:
    shr ax, cl                                                                  ; 0a3c: d3 e8
loc_0a3e:
    mov bx, word [difficulty_level]                                             ; 0a3e: 8b 1e 08 00
loc_0a42:
    shl bl, 1                                                                   ; 0a42: d0 e3
loc_0a44:
    cmp ax, word [bx + 0x66c]                                                   ; 0a44: 3b 87 6c 06
loc_0a48:
    jbe loc_0a4e                                                                ; 0a48: 76 04
loc_0a4a:
    mov ax, word [bx + 0x66c]                                                   ; 0a4a: 8b 87 6c 06
loc_0a4e:
    mov word [player_horizontal_speed], ax                                      ; 0a4e: a3 72 05
loc_0a51:
    call near move_player_horizontally                                          ; 0a51: e8 75 05
loc_0a54:
    mov al, byte [input_vertical]                                               ; 0a54: a0 99 06
loc_0a57:
    cmp al, 0                                                                   ; 0a57: 3c 00
loc_0a59:
    jne loc_0a6a                                                                ; 0a59: 75 0f
loc_0a5b:
    not al                                                                      ; 0a5b: f6 d0
loc_0a5d:
    cmp byte [player_vertical_speed], strict byte 0x10                          ; 0a5d: 80 3e 76 05 10
loc_0a62:
    jb loc_0a7e                                                                 ; 0a62: 72 1a
loc_0a64:
    dec byte [player_vertical_speed]                                            ; 0a64: fe 0e 76 05
loc_0a68:
    jmp short loc_0a86                                                          ; 0a68: eb 1c
loc_0a6a:
    cmp al, byte [player_vertical_direction]                                    ; 0a6a: 3a 06 71 05
loc_0a6e:
    jne loc_0a7e                                                                ; 0a6e: 75 0e
loc_0a70:
    cmp byte [player_vertical_speed], strict byte 0x40                          ; 0a70: 80 3e 76 05 40
loc_0a75:
    jae loc_0a86                                                                ; 0a75: 73 0f
loc_0a77:
    add byte [player_vertical_speed], strict byte 4                             ; 0a77: 80 06 76 05 04
loc_0a7c:
    jmp short loc_0a86                                                          ; 0a7c: eb 08
loc_0a7e:
    mov byte [player_vertical_direction], al                                    ; 0a7e: a2 71 05
loc_0a81:
    mov byte [player_vertical_speed], 0x20                                      ; 0a81: c6 06 76 05 20
loc_0a86:
    mov si, word [difficulty_level]                                             ; 0a86: 8b 36 08 00
loc_0a8a:
    mov dl, byte [player_y]                                                     ; 0a8a: 8a 16 7b 05
loc_0a8e:
    mov cl, 4                                                                   ; 0a8e: b1 04
loc_0a90:
    mov bl, byte [player_vertical_speed]                                        ; 0a90: 8a 1e 76 05
loc_0a94:
    shr bl, cl                                                                  ; 0a94: d2 eb
loc_0a96:
    cmp bl, byte [si + 0x67c]                                                   ; 0a96: 3a 9c 7c 06
loc_0a9a:
    jbe loc_0aa0                                                                ; 0a9a: 76 04
loc_0a9c:
    mov bl, byte [si + 0x67c]                                                   ; 0a9c: 8a 9c 7c 06
loc_0aa0:
    mov al, byte [player_vertical_direction]                                    ; 0aa0: a0 71 05
loc_0aa3:
    cmp al, 1                                                                   ; 0aa3: 3c 01
loc_0aa5:
    jb loc_0ace                                                                 ; 0aa5: 72 27
loc_0aa7:
    jne loc_0ab4                                                                ; 0aa7: 75 0b
loc_0aa9:
    load8 add, dl, bl                                                           ; 0aa9: 02 d3
loc_0aab:
    cmp dl, strict byte 0xb4                                                    ; 0aab: 80 fa b4
loc_0aae:
    jb loc_0ace                                                                 ; 0aae: 72 1e
loc_0ab0:
    mov dl, 0xb3                                                                ; 0ab0: b2 b3
loc_0ab2:
    jmp short loc_0ace                                                          ; 0ab2: eb 1a
loc_0ab4:
    load8 sub, dl, bl                                                           ; 0ab4: 2a d3
loc_0ab6:
    jb loc_0abd                                                                 ; 0ab6: 72 05
loc_0ab8:
    cmp dl, strict byte 3                                                       ; 0ab8: 80 fa 03
loc_0abb:
    ja loc_0ace                                                                 ; 0abb: 77 11
loc_0abd:
    mov ax, word [0x9b8]                                                        ; 0abd: a1 b8 09
loc_0ac0:
    cmp ax, word [player_sprite_pointer]                                        ; 0ac0: 3b 06 5d 05
loc_0ac4:
    jne loc_0acc                                                                ; 0ac4: 75 06
loc_0ac6:
    mov ax, word [player_last_update_tick]                                      ; 0ac6: a1 7d 05
loc_0ac9:
    mov word [aquarium_last_surface_tick], ax                                                        ; 0ac9: a3 f1 05
loc_0acc:
    mov dl, 2                                                                   ; 0acc: b2 02
loc_0ace:
    mov byte [player_y], dl                                                     ; 0ace: 88 16 7b 05
loc_0ad2:
    mov cx, word [player_x]                                                     ; 0ad2: 8b 0e 79 05
loc_0ad6:
    call near calculate_cga_address                                             ; 0ad6: e8 d7 21
loc_0ad9:
    mov word [0x563], ax                                                        ; 0ad9: a3 63 05
loc_0adc:
    cmp byte [aquarium_drowning], strict byte 0                                             ; 0adc: 80 3e f3 05 00
loc_0ae1:
    je loc_0ae9                                                                 ; 0ae1: 74 06
loc_0ae3:
    mov bx, 0x10                                                                ; 0ae3: bb 10 00
loc_0ae6:
    jmp short loc_0b64                                                          ; 0ae6: eb 7c
loc_0ae8:
    nop                                                                         ; 0ae8: 90
loc_0ae9:
    mov al, byte [player_horizontal_direction]                                  ; 0ae9: a0 6e 05
loc_0aec:
    cmp al, byte [player_previous_horizontal_direction]                         ; 0aec: 3a 06 6f 05
loc_0af0:
    jne loc_0afb                                                                ; 0af0: 75 09
loc_0af2:
    mov al, byte [player_vertical_direction]                                    ; 0af2: a0 71 05
loc_0af5:
    cmp al, byte [0x570]                                                        ; 0af5: 3a 06 70 05
loc_0af9:
    je loc_0b00                                                                 ; 0af9: 74 05
loc_0afb:
    mov bx, 0x18                                                                ; 0afb: bb 18 00
loc_0afe:
    jmp short loc_0b64                                                          ; 0afe: eb 64
loc_0b00:
    inc word [0x587]                                                            ; 0b00: ff 06 87 05
loc_0b04:
    mov bx, word [0x587]                                                        ; 0b04: 8b 1e 87 05
loc_0b08:
    mov al, byte [input_horizontal]                                             ; 0b08: a0 98 06
loc_0b0b:
    or al, byte [input_vertical]                                                ; 0b0b: 0a 06 99 06
loc_0b0f:
    jne loc_0b13                                                                ; 0b0f: 75 02
loc_0b11:
    shr bl, 1                                                                   ; 0b11: d0 eb
loc_0b13:
    cmp byte [player_y], strict byte 0xb3                                       ; 0b13: 80 3e 7b 05 b3
loc_0b18:
    jb loc_0b21                                                                 ; 0b18: 72 07
loc_0b1a:
    cmp byte [player_vertical_direction], strict byte 1                         ; 0b1a: 80 3e 71 05 01
loc_0b1f:
    je loc_0b3c                                                                 ; 0b1f: 74 1b
loc_0b21:
    cmp byte [player_y], strict byte 4                                          ; 0b21: 80 3e 7b 05 04
loc_0b26:
    ja loc_0b2f                                                                 ; 0b26: 77 07
loc_0b28:
    cmp byte [input_vertical], strict byte 0                                    ; 0b28: 80 3e 99 06 00
loc_0b2d:
    jne loc_0b53                                                                ; 0b2d: 75 24
loc_0b2f:
    mov al, byte [player_vertical_speed]                                        ; 0b2f: a0 76 05
loc_0b32:
    load8 sub, ah, ah                                                           ; 0b32: 2a e4
loc_0b34:
    shr ax, 1                                                                   ; 0b34: d1 e8
loc_0b36:
    cmp ax, word [0x574]                                                        ; 0b36: 3b 06 74 05
loc_0b3a:
    jae loc_0b53                                                                ; 0b3a: 73 17
loc_0b3c:
    cmp byte [player_horizontal_direction], strict byte 0                       ; 0b3c: 80 3e 6e 05 00
loc_0b41:
    je loc_0b53                                                                 ; 0b41: 74 10
loc_0b43:
    and bx, strict word 6                                                       ; 0b43: 81 e3 06 00
loc_0b47:
    cmp byte [player_horizontal_direction], strict byte 1                       ; 0b47: 80 3e 6e 05 01
loc_0b4c:
    je loc_0b64                                                                 ; 0b4c: 74 16
loc_0b4e:
    or bl, strict byte 8                                                        ; 0b4e: 80 cb 08
loc_0b51:
    jmp short loc_0b64                                                          ; 0b51: eb 11
loc_0b53:
    and bx, strict word 2                                                       ; 0b53: 81 e3 02 00
loc_0b57:
    or bl, strict byte 0x10                                                     ; 0b57: 80 cb 10
loc_0b5a:
    cmp byte [player_vertical_direction], strict byte 1                         ; 0b5a: 80 3e 71 05 01
loc_0b5f:
    jne loc_0b64                                                                ; 0b5f: 75 03
loc_0b61:
    add bl, strict byte 4                                                       ; 0b61: 80 c3 04
loc_0b64:
    mov ax, word [bx + 0x9a6]                                                   ; 0b64: 8b 87 a6 09
loc_0b68:
    mov word [player_sprite_pointer], ax                                        ; 0b68: a3 5d 05
loc_0b6b:
    mov ax, word [bx + 0x9c0]                                                   ; 0b6b: 8b 87 c0 09
loc_0b6f:
    mov word [player_draw_dimensions], ax                                       ; 0b6f: a3 65 05
loc_0b72:
    mov al, 0x30                                                                ; 0b72: b0 30
loc_0b74:
    mov cx, 0x2bc                                                               ; 0b74: b9 bc 02
loc_0b77:
    cmp byte [machine_model_byte], strict byte 0xfd                             ; 0b77: 80 3e 97 06 fd
loc_0b7c:
    jb loc_0b97                                                                 ; 0b7c: 72 19
loc_0b7e:
    je loc_0b85                                                                 ; 0b7e: 74 05
loc_0b80:
    mov al, 8                                                                   ; 0b80: b0 08
loc_0b82:
    mov cx, 0x3e8                                                               ; 0b82: b9 e8 03
loc_0b85:
    cmp byte [player_y], al                                                     ; 0b85: 38 06 7b 05
loc_0b89:
    ja loc_0b97                                                                 ; 0b89: 77 0c
loc_0b8b:
    call near read_cga_vertical_retrace_bit                                     ; 0b8b: e8 4a 08
loc_0b8e:
    jne loc_0b8b                                                                ; 0b8e: 75 fb
loc_0b90:
    call near read_cga_vertical_retrace_bit                                     ; 0b90: e8 45 08
loc_0b93:
    je loc_0b90                                                                 ; 0b93: 74 fb
loc_0b95:
    loop loc_0b95                                                               ; 0b95: e2 fe
loc_0b97:
    call near restore_player_background                                         ; 0b97: e8 49 06
loc_0b9a:
    mov ax, word [0x563]                                                        ; 0b9a: a1 63 05
loc_0b9d:
    mov word [player_video_offset], ax                                          ; 0b9d: a3 5f 05
loc_0ba0:
    call near draw_player_mask                                                  ; 0ba0: e8 a2 05
loc_0ba3:
    call near check_aquarium_contacts                                           ; 0ba3: e8 fa 28
loc_0ba6:
    jae loc_0bab                                                                ; 0ba6: 73 03
loc_0ba8:
    call near draw_player_mask                                                  ; 0ba8: e8 9a 05
loc_0bab:
    ret                                                                         ; 0bab: c3
loc_0bac:
    call near check_alley_projectile_contact                                    ; 0bac: e8 cb 0f
loc_0baf:
    jae loc_0bb2                                                                ; 0baf: 73 01
loc_0bb1:
    ret                                                                         ; 0bb1: c3
loc_0bb2:
    cmp byte [enemy_capture_direction], strict byte 0                           ; 0bb2: 80 3e b8 1c 00
loc_0bb7:
    jne loc_0bb1                                                                ; 0bb7: 75 f8
loc_0bb9:
    cmp byte [0x558], strict byte 0                                             ; 0bb9: 80 3e 58 05 00
loc_0bbe:
    je loc_0c1c                                                                 ; 0bbe: 74 5c
loc_0bc0:
    cmp byte [0x559], strict byte 0                                             ; 0bc0: 80 3e 59 05 00
loc_0bc5:
    je loc_0bd3                                                                 ; 0bc5: 74 0c
loc_0bc7:
    cmp byte [enemy_active], strict byte 0                                      ; 0bc7: 80 3e bf 1c 00
loc_0bcc:
    jne loc_0bd2                                                                ; 0bcc: 75 04
loc_0bce:
    dec byte [0x559]                                                            ; 0bce: fe 0e 59 05
loc_0bd2:
    ret                                                                         ; 0bd2: c3
loc_0bd3:
    dec byte [0x558]                                                            ; 0bd3: fe 0e 58 05
loc_0bd7:
    jne loc_0be5                                                                ; 0bd7: 75 0c
loc_0bd9:
    mov word [player_horizontal_speed], 8                                       ; 0bd9: c7 06 72 05 08 00
loc_0bdf:
    call near move_player_horizontally                                          ; 0bdf: e8 e7 03
loc_0be2:
    jmp short loc_0c1c                                                          ; 0be2: eb 38
loc_0be4:
    nop                                                                         ; 0be4: 90
loc_0be5:
    call near select_walking_frame                                              ; 0be5: e8 38 04
loc_0be8:
    mov word [player_sprite_pointer], bx                                        ; 0be8: 89 1e 5d 05
loc_0bec:
    mov al, byte [0x558]                                                        ; 0bec: a0 58 05
loc_0bef:
    mov ah, byte [player_horizontal_direction]                                  ; 0bef: 8a 26 6e 05
loc_0bf3:
    call near clip_player_at_alley_edge                                         ; 0bf3: e8 91 03
loc_0bf6:
    cmp byte [0x558], strict byte 2                                             ; 0bf6: 80 3e 58 05 02
loc_0bfb:
    je loc_0c00                                                                 ; 0bfb: 74 03
loc_0bfd:
    call near restore_player_background                                         ; 0bfd: e8 e3 05
loc_0c00:
    call near check_alley_projectile_contact                                    ; 0c00: e8 77 0f
loc_0c03:
    jb loc_0c1b                                                                 ; 0c03: 72 16
loc_0c05:
    call near check_chasing_enemy_contact                                       ; 0c05: e8 ed 14
loc_0c08:
    jb loc_0c1b                                                                 ; 0c08: 72 11
loc_0c0a:
    mov dl, byte [player_y]                                                     ; 0c0a: 8a 16 7b 05
loc_0c0e:
    mov cx, word [player_x]                                                     ; 0c0e: 8b 0e 79 05
loc_0c12:
    call near calculate_cga_address                                             ; 0c12: e8 9b 20
loc_0c15:
    mov word [player_video_offset], ax                                          ; 0c15: a3 5f 05
loc_0c18:
    call near draw_player_mask                                                  ; 0c18: e8 2a 05
loc_0c1b:
    ret                                                                         ; 0c1b: c3
loc_0c1c:
    cmp byte [player_support_kind], strict byte 1                               ; 0c1c: 80 3e 5c 05 01
loc_0c21:
    jb loc_0c6a                                                                 ; 0c21: 72 47
loc_0c23:
    jne loc_0c5f                                                                ; 0c23: 75 3a
loc_0c25:
    inc byte [player_support_kind]                                              ; 0c25: fe 06 5c 05
loc_0c29:
    mov word [player_horizontal_speed], 6                                       ; 0c29: c7 06 72 05 06 00
loc_0c2f:
    mov dl, byte [player_y]                                                     ; 0c2f: 8a 16 7b 05
loc_0c33:
    mov cx, word [player_x]                                                     ; 0c33: 8b 0e 79 05
loc_0c37:
    call near calculate_cga_address                                             ; 0c37: e8 76 20
loc_0c3a:
    mov word [0x563], ax                                                        ; 0c3a: a3 63 05
loc_0c3d:
    call near restore_player_background                                         ; 0c3d: e8 a3 05
loc_0c40:
    call near check_alley_projectile_contact                                    ; 0c40: e8 37 0f
loc_0c43:
    jb loc_0c66                                                                 ; 0c43: 72 21
loc_0c45:
    call near check_chasing_enemy_contact                                       ; 0c45: e8 ad 14
loc_0c48:
    jb loc_0c66                                                                 ; 0c48: 72 1c
loc_0c4a:
    mov ax, word [0x563]                                                        ; 0c4a: a1 63 05
loc_0c4d:
    mov word [player_video_offset], ax                                          ; 0c4d: a3 5f 05
loc_0c50:
    mov word [player_draw_dimensions], 0xe03                                    ; 0c50: c7 06 65 05 03 0e
loc_0c56:
    mov word [player_sprite_pointer], 0x9da                                     ; 0c56: c7 06 5d 05 da 09
loc_0c5c:
    call near draw_player_mask                                                  ; 0c5c: e8 e6 04
loc_0c5f:
    cmp byte [input_vertical], strict byte 0                                    ; 0c5f: 80 3e 99 06 00
loc_0c64:
    jne loc_0c67                                                                ; 0c64: 75 01
loc_0c66:
    ret                                                                         ; 0c66: c3
loc_0c67:
    jmp near loc_0e78                                                           ; 0c67: e9 0e 02
loc_0c6a:
    cmp byte [player_vertical_direction], strict byte 0                         ; 0c6a: 80 3e 71 05 00
loc_0c6f:
    jne loc_0c74                                                                ; 0c6f: 75 03
loc_0c71:
    jmp near loc_0e23                                                           ; 0c71: e9 af 01
loc_0c74:
    call near move_player_horizontally                                          ; 0c74: e8 52 03
loc_0c77:
    jae loc_0c90                                                                ; 0c77: 73 17
loc_0c79:
    mov byte [player_horizontal_direction], 0                                   ; 0c79: c6 06 6e 05 00
loc_0c7e:
    mov byte [player_vertical_speed], 2                                         ; 0c7e: c6 06 76 05 02
loc_0c83:
    mov byte [player_vertical_direction], 1                                     ; 0c83: c6 06 71 05 01
loc_0c88:
    mov byte [0x55b], 0                                                         ; 0c88: c6 06 5b 05 00
loc_0c8d:
    jmp short loc_0cc1                                                          ; 0c8d: eb 32
loc_0c8f:
    nop                                                                         ; 0c8f: 90
loc_0c90:
    mov al, byte [player_vertical_acceleration_step]                            ; 0c90: a0 78 05
loc_0c93:
    sub byte [player_motion_accumulator], al                                    ; 0c93: 28 06 77 05
loc_0c97:
    jae loc_0cc1                                                                ; 0c97: 73 28
loc_0c99:
    cmp byte [player_vertical_direction], strict byte 1                         ; 0c99: 80 3e 71 05 01
loc_0c9e:
    je loc_0cb6                                                                 ; 0c9e: 74 16
loc_0ca0:
    cmp byte [player_vertical_speed], strict byte 1                             ; 0ca0: 80 3e 76 05 01
loc_0ca5:
    jbe loc_0cae                                                                ; 0ca5: 76 07
loc_0ca7:
    dec byte [player_vertical_speed]                                            ; 0ca7: fe 0e 76 05
loc_0cab:
    jmp short loc_0cc1                                                          ; 0cab: eb 14
loc_0cad:
    nop                                                                         ; 0cad: 90
loc_0cae:
    mov byte [player_vertical_direction], 1                                     ; 0cae: c6 06 71 05 01
loc_0cb3:
    jmp short loc_0cc1                                                          ; 0cb3: eb 0c
loc_0cb5:
    nop                                                                         ; 0cb5: 90
loc_0cb6:
    cmp byte [player_vertical_speed], strict byte 4                             ; 0cb6: 80 3e 76 05 04
loc_0cbb:
    jae loc_0cc1                                                                ; 0cbb: 73 04
loc_0cbd:
    inc byte [player_vertical_speed]                                            ; 0cbd: fe 06 76 05
loc_0cc1:
    cmp byte [player_transition_blocked], strict byte 0                         ; 0cc1: 80 3e 5a 05 00
loc_0cc6:
    jne loc_0ce7                                                                ; 0cc6: 75 1f
loc_0cc8:
    cmp byte [0x55b], strict byte 0                                             ; 0cc8: 80 3e 5b 05 00
loc_0ccd:
    je loc_0cd5                                                                 ; 0ccd: 74 06
loc_0ccf:
    dec byte [0x55b]                                                            ; 0ccf: fe 0e 5b 05
loc_0cd3:
    jne loc_0ce7                                                                ; 0cd3: 75 12
loc_0cd5:
    cmp byte [player_vertical_direction], strict byte 1                         ; 0cd5: 80 3e 71 05 01
loc_0cda:
    jne loc_0ce7                                                                ; 0cda: 75 0b
loc_0cdc:
    call near check_player_support                                              ; 0cdc: e8 29 09
loc_0cdf:
    jae loc_0ce7                                                                ; 0cdf: 73 06
loc_0ce1:
    mov al, byte [player_y_plus_50]                                             ; 0ce1: a0 7c 05
loc_0ce4:
    jmp short loc_0d29                                                          ; 0ce4: eb 43
loc_0ce6:
    nop                                                                         ; 0ce6: 90
loc_0ce7:
    mov al, byte [player_y_plus_50]                                             ; 0ce7: a0 7c 05
loc_0cea:
    cmp byte [player_vertical_direction], strict byte 1                         ; 0cea: 80 3e 71 05 01
loc_0cef:
    je loc_0d06                                                                 ; 0cef: 74 15
loc_0cf1:
    sub al, byte [player_vertical_speed]                                        ; 0cf1: 2a 06 76 05
loc_0cf5:
    jae loc_0d4f                                                                ; 0cf5: 73 58
loc_0cf7:
    load8 sub, al, al                                                           ; 0cf7: 2a c0
loc_0cf9:
    mov byte [player_vertical_direction], 1                                     ; 0cf9: c6 06 71 05 01
loc_0cfe:
    mov byte [player_vertical_speed], 1                                         ; 0cfe: c6 06 76 05 01
loc_0d03:
    jmp short loc_0d4f                                                          ; 0d03: eb 4a
loc_0d05:
    nop                                                                         ; 0d05: 90
loc_0d06:
    add al, byte [player_vertical_speed]                                        ; 0d06: 02 06 76 05
loc_0d0a:
    cmp al, 0xe6                                                                ; 0d0a: 3c e6
loc_0d0c:
    jbe loc_0d4f                                                                ; 0d0c: 76 41
loc_0d0e:
    cmp word [scene_index], strict byte 7                                       ; 0d0e: 83 3e 04 00 07
loc_0d13:
    jne loc_0d22                                                                ; 0d13: 75 0d
loc_0d15:
    cmp al, 0xf8                                                                ; 0d15: 3c f8
loc_0d17:
    jb loc_0d4f                                                                 ; 0d17: 72 36
loc_0d19:
    mov al, 0xf8                                                                ; 0d19: b0 f8
loc_0d1b:
    mov byte [scene_exit_requested], 1                                          ; 0d1b: c6 06 51 05 01
loc_0d20:
    jmp short loc_0d4f                                                          ; 0d20: eb 2d
loc_0d22:
    mov al, 0xe6                                                                ; 0d22: b0 e6
loc_0d24:
    mov byte [player_alley_motion_mode], 0                                      ; 0d24: c6 06 50 05 00
loc_0d29:
    mov byte [player_vertical_direction], 0                                     ; 0d29: c6 06 71 05 00
loc_0d2e:
    mov byte [0x584], 0                                                         ; 0d2e: c6 06 84 05 00
loc_0d33:
    mov word [player_horizontal_speed], 2                                       ; 0d33: c7 06 72 05 02 00
loc_0d39:
    mov byte [0x55b], 0                                                         ; 0d39: c6 06 5b 05 00
loc_0d3e:
    mov byte [player_transition_blocked], 0                                     ; 0d3e: c6 06 5a 05 00
loc_0d43:
    cmp byte [player_support_kind], strict byte 0                               ; 0d43: 80 3e 5c 05 00
loc_0d48:
    je loc_0d4f                                                                 ; 0d48: 74 05
loc_0d4a:
    push ax                                                                     ; 0d4a: 50
loc_0d4b:
    call near loc_5ac2                                                          ; 0d4b: e8 74 4d
loc_0d4e:
    pop ax                                                                      ; 0d4e: 58
loc_0d4f:
    mov byte [player_y_plus_50], al                                             ; 0d4f: a2 7c 05
loc_0d52:
    sub al, 0x32                                                                ; 0d52: 2c 32
loc_0d54:
    jae loc_0d58                                                                ; 0d54: 73 02
loc_0d56:
    load8 sub, al, al                                                           ; 0d56: 2a c0
loc_0d58:
    mov byte [player_y], al                                                     ; 0d58: a2 7b 05
loc_0d5b:
    mov dl, byte [player_y]                                                     ; 0d5b: 8a 16 7b 05
loc_0d5f:
    mov cx, word [player_x]                                                     ; 0d5f: 8b 0e 79 05
loc_0d63:
    call near calculate_cga_address                                             ; 0d63: e8 4a 1f
loc_0d66:
    mov word [0x563], ax                                                        ; 0d66: a3 63 05
loc_0d69:
    cmp byte [0x583], strict byte 0                                             ; 0d69: 80 3e 83 05 00
loc_0d6e:
    jne loc_0d73                                                                ; 0d6e: 75 03
loc_0d70:
    call near restore_player_background                                         ; 0d70: e8 70 04
loc_0d73:
    call near check_alley_projectile_contact                                    ; 0d73: e8 04 0e
loc_0d76:
    jb loc_0dc4                                                                 ; 0d76: 72 4c
loc_0d78:
    call near check_chasing_enemy_contact                                       ; 0d78: e8 7a 13
loc_0d7b:
    jb loc_0dc4                                                                 ; 0d7b: 72 47
loc_0d7d:
    mov ax, word [0x563]                                                        ; 0d7d: a1 63 05
loc_0d80:
    mov word [player_video_offset], ax                                          ; 0d80: a3 5f 05
loc_0d83:
    cmp byte [0x584], strict byte 0                                             ; 0d83: 80 3e 84 05 00
loc_0d88:
    je loc_0da1                                                                 ; 0d88: 74 17
loc_0d8a:
    add word [0x585], strict byte 2                                             ; 0d8a: 83 06 85 05 02
loc_0d8f:
    mov bx, word [0x585]                                                        ; 0d8f: 8b 1e 85 05
loc_0d93:
    and bx, strict word 0xe                                                     ; 0d93: 81 e3 0e 00
loc_0d97:
    mov ax, word [bx + 0xfc2]                                                   ; 0d97: 8b 87 c2 0f
loc_0d9b:
    mov bx, word [bx + 0xfd2]                                                   ; 0d9b: 8b 9f d2 0f
loc_0d9f:
    jmp short loc_0da8                                                          ; 0d9f: eb 07
loc_0da1:
    mov ax, word [0x569]                                                        ; 0da1: a1 69 05
loc_0da4:
    mov bx, word [0x567]                                                        ; 0da4: 8b 1e 67 05
loc_0da8:
    mov word [player_sprite_pointer], ax                                        ; 0da8: a3 5d 05
loc_0dab:
    mov word [player_draw_dimensions], bx                                       ; 0dab: 89 1e 65 05
loc_0daf:
    mov al, 0x32                                                                ; 0daf: b0 32
loc_0db1:
    sub al, byte [player_y_plus_50]                                             ; 0db1: 2a 06 7c 05
loc_0db5:
    je loc_0dde                                                                 ; 0db5: 74 27
loc_0db7:
    jb loc_0dde                                                                 ; 0db7: 72 25
loc_0db9:
    mov cx, 0x168                                                               ; 0db9: b9 68 01
loc_0dbc:
    loop loc_0dbc                                                               ; 0dbc: e2 fe
loc_0dbe:
    load8 sub, bh, al                                                           ; 0dbe: 2a f8
loc_0dc0:
    je loc_0dc4                                                                 ; 0dc0: 74 02
loc_0dc2:
    jae loc_0dca                                                                ; 0dc2: 73 06
loc_0dc4:
    mov byte [0x583], 1                                                         ; 0dc4: c6 06 83 05 01
loc_0dc9:
    ret                                                                         ; 0dc9: c3
loc_0dca:
    mov word [player_draw_dimensions], bx                                       ; 0dca: 89 1e 65 05
loc_0dce:
    load8 mov, ah, bl                                                           ; 0dce: 8a e3
loc_0dd0:
    shl ah, 1                                                                   ; 0dd0: d0 e4
loc_0dd2:
    mul ah                                                                      ; 0dd2: f6 e4
loc_0dd4:
    add ax, word [0x569]                                                        ; 0dd4: 03 06 69 05
loc_0dd8:
    mov word [player_sprite_pointer], ax                                        ; 0dd8: a3 5d 05
loc_0ddb:
    jmp short loc_0e1f                                                          ; 0ddb: eb 42
loc_0ddd:
    nop                                                                         ; 0ddd: 90
loc_0dde:
    cmp word [scene_index], strict byte 7                                       ; 0dde: 83 3e 04 00 07
loc_0de3:
    jne loc_0dee                                                                ; 0de3: 75 09
loc_0de5:
    mov al, byte [player_y]                                                     ; 0de5: a0 7b 05
loc_0de8:
    sub al, 0xbb                                                                ; 0de8: 2c bb
loc_0dea:
    jb loc_0e1f                                                                 ; 0dea: 72 33
loc_0dec:
    jae loc_0dfc                                                                ; 0dec: 73 0e
loc_0dee:
    cmp byte [player_alley_motion_mode], strict byte 2                          ; 0dee: 80 3e 50 05 02
loc_0df3:
    jne loc_0e1f                                                                ; 0df3: 75 2a
loc_0df5:
    mov al, byte [player_y]                                                     ; 0df5: a0 7b 05
loc_0df8:
    sub al, 0x5e                                                                ; 0df8: 2c 5e
loc_0dfa:
    jb loc_0e1f                                                                 ; 0dfa: 72 23
loc_0dfc:
    load8 sub, bh, al                                                           ; 0dfc: 2a f8
loc_0dfe:
    je loc_0e02                                                                 ; 0dfe: 74 02
loc_0e00:
    jae loc_0e16                                                                ; 0e00: 73 14
loc_0e02:
    cmp word [scene_index], strict byte 7                                       ; 0e02: 83 3e 04 00 07
loc_0e07:
    jne loc_0e0f                                                                ; 0e07: 75 06
loc_0e09:
    mov byte [scene_exit_requested], 1                                          ; 0e09: c6 06 51 05 01
loc_0e0e:
    ret                                                                         ; 0e0e: c3
loc_0e0f:
    call near initialize_alley_player                                           ; 0e0f: e8 fb f8
loc_0e12:
    call near loc_59cb                                                          ; 0e12: e8 b6 4b
loc_0e15:
    ret                                                                         ; 0e15: c3
loc_0e16:
    mov word [player_draw_dimensions], bx                                       ; 0e16: 89 1e 65 05
loc_0e1a:
    mov byte [player_vertical_speed], 2                                         ; 0e1a: c6 06 76 05 02
loc_0e1f:
    call near draw_player_mask                                                  ; 0e1f: e8 23 03
loc_0e22:
    ret                                                                         ; 0e22: c3
loc_0e23:
    cmp word [scene_index], strict byte 7                                       ; 0e23: 83 3e 04 00 07
loc_0e28:
    je loc_0e31                                                                 ; 0e28: 74 07
loc_0e2a:
    cmp byte [player_y], strict byte 0xb4                                       ; 0e2a: 80 3e 7b 05 b4
loc_0e2f:
    jae loc_0e78                                                                ; 0e2f: 73 47
loc_0e31:
    call near check_player_support                                              ; 0e31: e8 d4 07
loc_0e34:
    jb loc_0e43                                                                 ; 0e34: 72 0d
loc_0e36:
    mov byte [player_horizontal_direction], 0                                   ; 0e36: c6 06 6e 05 00
loc_0e3b:
    mov byte [player_vertical_direction], 1                                     ; 0e3b: c6 06 71 05 01
loc_0e40:
    jmp short loc_0eb1                                                          ; 0e40: eb 6f
loc_0e42:
    nop                                                                         ; 0e42: 90
loc_0e43:
    cmp word [scene_index], strict byte 0                                       ; 0e43: 83 3e 04 00 00
loc_0e48:
    jne loc_0e78                                                                ; 0e48: 75 2e
loc_0e4a:
    call near loc_22f7                                                          ; 0e4a: e8 aa 14
loc_0e4d:
    jb loc_0e56                                                                 ; 0e4d: 72 07
loc_0e4f:
    mov byte [0x56c], 0                                                         ; 0e4f: c6 06 6c 05 00
loc_0e54:
    jmp short loc_0e78                                                          ; 0e54: eb 22
loc_0e56:
    cmp byte [0x56c], strict byte 0                                             ; 0e56: 80 3e 6c 05 00
loc_0e5b:
    jne loc_0e60                                                                ; 0e5b: 75 03
loc_0e5d:
    call near loc_591f                                                          ; 0e5d: e8 bf 4a
loc_0e60:
    mov byte [input_vertical], 1                                                ; 0e60: c6 06 99 06 01
loc_0e65:
    mov byte [0x56c], 1                                                         ; 0e65: c6 06 6c 05 01
loc_0e6a:
    call near update_random_state                                               ; 0e6a: e8 90 1f
loc_0e6d:
    and dl, strict byte 1                                                       ; 0e6d: 80 e2 01
loc_0e70:
    jne loc_0e74                                                                ; 0e70: 75 02
loc_0e72:
    mov dl, 0xff                                                                ; 0e72: b2 ff
loc_0e74:
    mov byte [input_horizontal], dl                                             ; 0e74: 88 16 98 06
loc_0e78:
    mov al, byte [player_horizontal_direction]                                  ; 0e78: a0 6e 05
loc_0e7b:
    mov byte [player_previous_horizontal_direction], al                         ; 0e7b: a2 6f 05
loc_0e7e:
    mov al, byte [input_horizontal]                                             ; 0e7e: a0 98 06
loc_0e81:
    mov byte [player_horizontal_direction], al                                  ; 0e81: a2 6e 05
loc_0e84:
    mov al, byte [input_vertical]                                               ; 0e84: a0 99 06
loc_0e87:
    mov byte [player_vertical_direction], al                                    ; 0e87: a2 71 05
loc_0e8a:
    cmp al, 0                                                                   ; 0e8a: 3c 00
loc_0e8c:
    jne loc_0e91                                                                ; 0e8c: 75 03
loc_0e8e:
    jmp near loc_0f34                                                           ; 0e8e: e9 a3 00
loc_0e91:
    cmp byte [player_vertical_direction], strict byte 1                         ; 0e91: 80 3e 71 05 01
loc_0e96:
    jne loc_0ec9                                                                ; 0e96: 75 31
loc_0e98:
    cmp byte [player_y], strict byte 0xb4                                       ; 0e98: 80 3e 7b 05 b4
loc_0e9d:
    jb loc_0eb1                                                                 ; 0e9d: 72 12
loc_0e9f:
    mov byte [player_vertical_direction], 0                                     ; 0e9f: c6 06 71 05 00
loc_0ea4:
    mov byte [0x584], 0                                                         ; 0ea4: c6 06 84 05 00
loc_0ea9:
    mov byte [input_vertical], 0                                                ; 0ea9: c6 06 99 06 00
loc_0eae:
    jmp near loc_0f34                                                           ; 0eae: e9 83 00
loc_0eb1:
    mov ah, 1                                                                   ; 0eb1: b4 01
loc_0eb3:
    mov al, 0x20                                                                ; 0eb3: b0 20
loc_0eb5:
    mov byte [0x55b], 8                                                         ; 0eb5: c6 06 5b 05 08
loc_0eba:
    cmp byte [player_alley_motion_mode], strict byte 1                          ; 0eba: 80 3e 50 05 01
loc_0ebf:
    jne loc_0ef1                                                                ; 0ebf: 75 30
loc_0ec1:
    mov byte [player_alley_motion_mode], 0                                      ; 0ec1: c6 06 50 05 00
loc_0ec6:
    jmp short loc_0ef1                                                          ; 0ec6: eb 29
loc_0ec8:
    nop                                                                         ; 0ec8: 90
loc_0ec9:
    mov byte [0x55b], 0                                                         ; 0ec9: c6 06 5b 05 00
loc_0ece:
    mov ax, word [player_horizontal_speed]                                      ; 0ece: a1 72 05
loc_0ed1:
    load8 mov, bl, al                                                           ; 0ed1: 8a d8
loc_0ed3:
    cmp al, 2                                                                   ; 0ed3: 3c 02
loc_0ed5:
    jbe loc_0ed9                                                                ; 0ed5: 76 02
loc_0ed7:
    sub al, 2                                                                   ; 0ed7: 2c 02
loc_0ed9:
    mov word [player_horizontal_speed], ax                                      ; 0ed9: a3 72 05
loc_0edc:
    mov ah, 8                                                                   ; 0edc: b4 08
loc_0ede:
    load8 mov, al, bl                                                           ; 0ede: 8a c3
loc_0ee0:
    xor al, 0xf                                                                 ; 0ee0: 34 0f
loc_0ee2:
    mov cl, 4                                                                   ; 0ee2: b1 04
loc_0ee4:
    shl al, cl                                                                  ; 0ee4: d2 e0
loc_0ee6:
    cmp byte [player_alley_motion_mode], strict byte 1                          ; 0ee6: 80 3e 50 05 01
loc_0eeb:
    jne loc_0ef1                                                                ; 0eeb: 75 04
loc_0eed:
    inc byte [player_alley_motion_mode]                                         ; 0eed: fe 06 50 05
loc_0ef1:
    mov byte [player_vertical_acceleration_step], al                            ; 0ef1: a2 78 05
loc_0ef4:
    mov byte [player_vertical_speed], ah                                        ; 0ef4: 88 26 76 05
loc_0ef8:
    mov byte [player_motion_accumulator], 1                                     ; 0ef8: c6 06 77 05 01
loc_0efd:
    mov byte [player_support_kind], 0                                           ; 0efd: c6 06 5c 05 00
loc_0f02:
    mov bl, byte [player_horizontal_direction]                                  ; 0f02: 8a 1e 6e 05
loc_0f06:
    inc bl                                                                      ; 0f06: fe c3
loc_0f08:
    shl bl, 1                                                                   ; 0f08: d0 e3
loc_0f0a:
    cmp byte [player_vertical_direction], strict byte 0xff                      ; 0f0a: 80 3e 71 05 ff
loc_0f0f:
    je loc_0f14                                                                 ; 0f0f: 74 03
loc_0f11:
    add bl, strict byte 6                                                       ; 0f11: 80 c3 06
loc_0f14:
    load8 sub, bh, bh                                                           ; 0f14: 2a ff
loc_0f16:
    mov ax, word [bx + 0xfaa]                                                   ; 0f16: 8b 87 aa 0f
loc_0f1a:
    mov word [0x569], ax                                                        ; 0f1a: a3 69 05
loc_0f1d:
    mov ax, word [bx + 0xfb6]                                                   ; 0f1d: 8b 87 b6 0f
loc_0f21:
    mov word [0x567], ax                                                        ; 0f21: a3 67 05
loc_0f24:
    mov byte [0x39e0], 0                                                        ; 0f24: c6 06 e0 39 00
loc_0f29:
    cmp byte [0x127c], strict byte 0                                            ; 0f29: 80 3e 7c 12 00
loc_0f2e:
    je loc_0f33                                                                 ; 0f2e: 74 03
loc_0f30:
    call near loc_58f8                                                          ; 0f30: e8 c5 49
loc_0f33:
    ret                                                                         ; 0f33: c3
loc_0f34:
    cmp word [scene_index], strict byte 0                                       ; 0f34: 83 3e 04 00 00
loc_0f39:
    je loc_0f45                                                                 ; 0f39: 74 0a
loc_0f3b:
    cmp word [scene_index], strict byte 7                                       ; 0f3b: 83 3e 04 00 07
loc_0f40:
    je loc_0f45                                                                 ; 0f40: 74 03
loc_0f42:
    call near record_floor_mark                                                          ; 0f42: e8 00 25
loc_0f45:
    call near move_player_horizontally                                          ; 0f45: e8 81 00
loc_0f48:
    mov dl, byte [player_y]                                                     ; 0f48: 8a 16 7b 05
loc_0f4c:
    mov cx, word [player_x]                                                     ; 0f4c: 8b 0e 79 05
loc_0f50:
    call near calculate_cga_address                                             ; 0f50: e8 5d 1d
loc_0f53:
    mov word [0x563], ax                                                        ; 0f53: a3 63 05
loc_0f56:
    mov al, byte [player_horizontal_direction]                                  ; 0f56: a0 6e 05
loc_0f59:
    or al, byte [player_vertical_direction]                                     ; 0f59: 0a 06 71 05
loc_0f5d:
    jne loc_0f63                                                                ; 0f5d: 75 04
loc_0f5f:
    call near loc_1069                                                          ; 0f5f: e8 07 01
loc_0f62:
    ret                                                                         ; 0f62: c3
loc_0f63:
    call near select_walking_frame                                              ; 0f63: e8 ba 00
loc_0f66:
    mov word [player_sprite_pointer], bx                                        ; 0f66: 89 1e 5d 05
loc_0f6a:
    call near restore_player_background                                         ; 0f6a: e8 76 02
loc_0f6d:
    call near check_alley_projectile_contact                                    ; 0f6d: e8 0a 0c
loc_0f70:
    jb loc_0f86                                                                 ; 0f70: 72 14
loc_0f72:
    call near check_chasing_enemy_contact                                       ; 0f72: e8 80 11
loc_0f75:
    jb loc_0f86                                                                 ; 0f75: 72 0f
loc_0f77:
    mov ax, word [0x563]                                                        ; 0f77: a1 63 05
loc_0f7a:
    mov word [player_video_offset], ax                                          ; 0f7a: a3 5f 05
loc_0f7d:
    mov word [player_draw_dimensions], 0xb03                                    ; 0f7d: c7 06 65 05 03 0b
loc_0f83:
    call near draw_player_mask                                                  ; 0f83: e8 bf 01
loc_0f86:
    ret                                                                         ; 0f86: c3
