; Reviewed player DS offsets. No storage is allocated here.

saved_alley_player_x                        equ 0x0001 ; 2 bytes
saved_alley_player_y                        equ 0x0003 ; 1 bytes
player_alley_motion_mode                    equ 0x0550 ; 1 bytes
player_transition_blocked                   equ 0x055a ; 1 bytes
player_support_kind                         equ 0x055c ; 1 bytes
player_sprite_pointer                       equ 0x055d ; 2 bytes
player_video_offset                         equ 0x055f ; 2 bytes
player_saved_dimensions                     equ 0x0561 ; 2 bytes
player_draw_dimensions                      equ 0x0565 ; 2 bytes
player_walk_frame                           equ 0x056b ; 1 bytes
player_horizontal_direction                 equ 0x056e ; 1 bytes
player_previous_horizontal_direction        equ 0x056f ; 1 bytes
player_vertical_direction                   equ 0x0571 ; 1 bytes
player_horizontal_speed                     equ 0x0572 ; 2 bytes
player_vertical_speed                       equ 0x0576 ; 1 bytes
player_motion_accumulator                   equ 0x0577 ; 1 bytes
player_vertical_acceleration_step           equ 0x0578 ; 1 bytes
player_x                                    equ 0x0579 ; 2 bytes
player_y                                    equ 0x057b ; 1 bytes
player_y_plus_50                            equ 0x057c ; 1 bytes
player_last_update_tick                     equ 0x057d ; 2 bytes
player_same_tick_countdown                  equ 0x0684 ; 2 bytes
