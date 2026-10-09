; Reviewed enemy DS offsets. No storage is allocated here.

enemy_capture_direction                     equ 0x1cb8 ; 1 x 1 bytes
enemy_capture_delay                         equ 0x1cb9 ; 1 x 2 bytes
enemy_sprite_pointer                        equ 0x1cbb ; 1 x 2 bytes
enemy_video_offset                          equ 0x1cbd ; 1 x 2 bytes
enemy_active                                equ 0x1cbf ; 1 x 1 bytes
enemy_entry_phase                           equ 0x1cc0 ; 1 x 1 bytes
enemy_exit_phase                            equ 0x1cc1 ; 1 x 1 bytes
enemy_saved_dimensions                      equ 0x1cc2 ; 1 x 2 bytes
enemy_draw_dimensions                       equ 0x1cc4 ; 1 x 2 bytes
enemy_x                                     equ 0x1cc6 ; 1 x 2 bytes
enemy_y                                     equ 0x1cc8 ; 1 x 1 bytes
enemy_last_update_tick                      equ 0x1cc9 ; 1 x 2 bytes
enemy_horizontal_direction                  equ 0x1cd0 ; 1 x 1 bytes
enemy_update_counter                        equ 0x1ce1 ; 1 x 2 bytes
enemy_spawn_thresholds                         equ 0x1cd1 ; 8 x 1 bytes
enemy_pursuit_thresholds                       equ 0x1cd9 ; 8 x 1 bytes
enemy_forced_entry                             equ 0x1d58 ; 1 x 1 bytes
