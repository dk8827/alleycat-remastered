; Reviewed flow DS offsets. No storage is allocated here.

scene_index                                 equ 0x0004 ; 2 bytes
previous_scene_index                        equ 0x0006 ; 2 bytes
difficulty_level                            equ 0x0008 ; 2 bytes
scene_entry_tick                            equ 0x0410 ; 2 bytes
courtship_cycle_start_tick                  equ 0x0412 ; 2 bytes
completed_room_count                        equ 0x0414 ; 2 bytes
courtship_pending                           equ 0x0418 ; 1 bytes
restart_requested                           equ 0x041b ; 1 bytes
menu_requested                              equ 0x041c ; 1 bytes
scene_exit_requested                        equ 0x0551 ; 1 bytes
scene_failed                                equ 0x0552 ; 1 bytes
scene_complete                              equ 0x0553 ; 1 bytes
enter_aquarium_requested                    equ 0x0554 ; 1 bytes
