; Publisher selection, menu strings, controls and menu state.
; Original DS:6A88..6E10 (end exclusive).

data_6a88: db 0x00, 0x00, 0x00, 0x00, 0x00 ; .....

; DS:6a8d publisher_credit_index: Incremented by two, masked with two, used to select a publisher-credit image.
data_6a8d: db 0x00, 0x00 ; ..

; DS:6a8f publisher_credit_pointers: Two little-endian pointers: 68A8 and 6998.
data_6a8f: dw publisher_credit_ibm, publisher_credit_synsoft
data_6a93: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; .............


; DS:6aa0 text_joystick_prompt: NUL-terminated text: 'Do you want to use a joystick (Y/N)?'
data_6aa0: db "Do you want to use a joystick (Y/N)?", 0x00

; DS:6ac5 text_skill_prompt: NUL-terminated text: 'Please select your skill level:'
data_6ac5: db "Please select your skill level:", 0x00

; DS:6ae5 text_kitten: NUL-terminated text: '   (K)itten'
data_6ae5: db "   (K)itten", 0x00

; DS:6af1 text_house_cat: NUL-terminated text: '   (H)ouse Cat'
data_6af1: db "   (H)ouse Cat", 0x00

; DS:6b00 text_tomcat: NUL-terminated text: '   (T)omcat'
data_6b00: db "   (T)omcat", 0x00

; DS:6b0c text_alley_cat: NUL-terminated text: '   (A)lley Cat'
data_6b0c: db "   (A)lley Cat", 0x00

; DS:6b1b text_during_play: NUL-terminated text: 'During play:'
data_6b1b: db "During play:", 0x00

; DS:6b28 text_sound_control: NUL-terminated text: '   Ctrl-S  turns the sound on and off.'
data_6b28: db "   Ctrl-S  turns the sound on and off.", 0x00

; DS:6b4f text_restart_control: NUL-terminated text: '   Ctrl-R  restarts the game.'
data_6b4f: db "   Ctrl-R  restarts the game.", 0x00

; DS:6b6d text_menu_control: NUL-terminated text: '   Ctrl-M  returns you to this menu.'
data_6b6d: db "   Ctrl-M  returns you to this menu.", 0x00

; DS:6b92 text_pause_control: NUL-terminated text: '   Esc     puts the game into paws mode.'
data_6b92: db "   Esc     puts the game into paws mode.", 0x00

; DS:6bbb text_cursor_control: NUL-terminated text: 'Use the cursor keys to control the cat.'
data_6bbb: db "Use the cursor keys to control the cat.", 0x00

; DS:6be3 text_alt_control: NUL-terminated text: 'The Alt key performs special actions.'
data_6be3: db "The Alt key performs special actions.", 0x00

; DS:6c09 text_press_key_start: NUL-terminated text: 'Press any key to start.'
data_6c09: db "Press any key to start.", 0x00

; DS:6c21 text_joystick_control: NUL-terminated text: 'Use the joystick to control the cat.'
data_6c21: db "Use the joystick to control the cat.", 0x00

; DS:6c46 text_button_control: NUL-terminated text: 'The button performs special actions.'
data_6c46: db "The button performs special actions.", 0x00

; DS:6c6b text_center_joystick: NUL-terminated text: 'Please center your joystick and'
data_6c6b: db "Please center your joystick and", 0x00

; DS:6c8b text_button_start: NUL-terminated text: 'press the joystick button to start.'
data_6c8b: db "press the joystick button to start.", 0x00

; DS:6caf text_no_joystick: NUL-terminated text: 'Either joystick is not attached or'
data_6caf: db "Either joystick is not attached or", 0x00

; DS:6cd2 text_no_game_adapter: NUL-terminated text: 'Game Control Adapter is not present.'
data_6cd2: db "Game Control Adapter is not present.", 0x00

; DS:6cf7 text_select_keyboard: NUL-terminated text: 'Please correct or select keyboard.'
data_6cf7: db "Please correct or select keyboard.", 0x00

; DS:6d1a text_key_continue: NUL-terminated text: 'Press any key to continue...'
data_6d1a: db "Press any key to continue...", 0x00

; DS:6d37 menu_text_pointers: 22 DS-relative pointers consumed by CS:5FB1; entries resolve to NUL-terminated menu strings.
data_6d37: dw text_joystick_prompt, text_skill_prompt, text_kitten, text_house_cat, text_tomcat, text_alley_cat, text_during_play, text_sound_control, text_restart_control, text_menu_control, text_pause_control, text_press_key_start, text_center_joystick, text_button_start, text_cursor_control, text_alt_control, text_joystick_control, text_button_control, text_no_joystick, text_no_game_adapter, text_select_keyboard, text_key_continue

; DS:6d63 menu_cursor_positions: 22 BIOS DH:DL cursor values consumed by CS:5FB1; the cursor helper forces column zero.
data_6d63: dw 0x0000, 0x0200, 0x0400, 0x0500, 0x0600, 0x0700, 0x0900, 0x0a00, 0x0b00, 0x0c00, 0x0d00, 0x1400, 0x1300, 0x1400, 0x0f00, 0x1000, 0x0f00, 0x1000, 0x0200, 0x0300, 0x0400, 0x0600

; DS:6d8f menu_line_index: Byte offset into both menu tables, advanced by two per printed line.
data_6d8f: db 0x00 ; .
data_6d90: db 0x00 ; .
data_6d91: db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x50, 0x61, 0x77, 0x73 ;            Paws
data_6da0: db 0x20, 0x47, 0x61, 0x6d, 0x65, 0x3a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20 ;  Game:
data_6db0: db 0x20, 0x00, 0x20, 0x20, 0x50, 0x72, 0x65, 0x73, 0x73, 0x20, 0x61, 0x6e, 0x79, 0x20, 0x6b, 0x65 ;  .  Press any ke
data_6dc0: db 0x79, 0x20, 0x74, 0x6f, 0x20, 0x63, 0x6f, 0x6e, 0x74, 0x69, 0x6e, 0x75, 0x65, 0x2e, 0x2e, 0x2e ; y to continue...
data_6dd0: db 0x20, 0x20, 0x00, 0x20, 0x50, 0x72, 0x65, 0x73, 0x73, 0x20, 0x74, 0x68, 0x65, 0x20, 0x62, 0x75 ;   . Press the bu
data_6de0: db 0x74, 0x74, 0x6f, 0x6e, 0x20, 0x74, 0x6f, 0x20, 0x63, 0x6f, 0x6e, 0x74, 0x69, 0x6e, 0x75, 0x65 ; tton to continue
data_6df0: db 0x2e, 0x2e, 0x2e, 0x00, 0x4b, 0x48, 0x54, 0x41 ; ....KHTA


; DS:6df8 selected_difficulty: Menu stores 0..3 after checking K/H/T/A; entry copies it into difficulty_level.
data_6df8: db 0x00, 0x00 ; ..

; DS:6dfa menu_axis_start_tick: BIOS tick used by the axis-discharge timeout.
data_6dfa: db 0x00, 0x00 ; ..
data_6dfc: db 0x00, 0x00, 0x00, 0x00 ; ....

; DS:6e00 pause_keyboard_counter: Checked before entering pause and initialized from the keyboard counter plus 0240h.
data_6e00: db 0x00, 0x00 ; ..
data_6e02: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; ..............
