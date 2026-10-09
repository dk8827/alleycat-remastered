; Reviewed input / hardware DS offsets. No storage is allocated here.

processed_keyboard_counter                  equ 0x0691 ; 2 bytes
keyboard_event_counter                      equ 0x0693 ; 2 bytes
machine_model_byte                          equ 0x0697 ; 1 bytes
input_horizontal                            equ 0x0698 ; 1 bytes
input_vertical                              equ 0x0699 ; 1 bytes
action_button_state                         equ 0x069a ; 1 bytes
joystick_enabled                            equ 0x069b ; 1 bytes
joystick_pit_start                          equ 0x069c ; 2 bytes
joystick_pending_axes                       equ 0x069e ; 1 bytes
last_control_poll_tick                      equ 0x069f ; 2 bytes
keyboard_scan_codes                         equ 0x06a1 ; 22 bytes
keyboard_key_states                         equ 0x06b7 ; 22 bytes
