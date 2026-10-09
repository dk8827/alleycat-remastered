; Reviewed score DS offsets. No storage is allocated here.

lives_remaining                             equ 0x1f80 ; 1 bytes
displayed_lives                             equ 0x1f81 ; 1 bytes
current_score_digits                        equ 0x1f82 ; 7 bytes
high_score_digits                           equ 0x1f89 ; 7 bytes
score_draw_offset                           equ 0x1f90 ; 2 bytes
score_digit_index                           equ 0x1f92 ; 1 bytes
score_digit_pointer                         equ 0x1f93 ; 2 bytes
decimal_digit_glyphs                        equ 0x2720 ; 160 bytes
