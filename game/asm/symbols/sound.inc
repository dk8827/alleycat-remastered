; Reviewed sound DS offsets. No storage is allocated here.

sound_enabled                               equ 0x0000 ; 1 bytes
title_melody_byte_offset                    equ 0x5320 ; 1 x 2 bytes
title_melody_last_tick                      equ 0x5322 ; 1 x 2 bytes
title_note_divisors                         equ 0x5324 ; 52 x 2 bytes
title_note_codes                            equ 0x538c ; 846 x 1 bytes
two_stage_sound_ticks                       equ 0x5920 ; 1 bytes
two_stage_sound_last_tick                   equ 0x5921 ; 2 bytes
two_stage_sound_second_divisor              equ 0x5923 ; 2 bytes
courtship_melody_divisors                   equ 0x5934 ; 67 x 2 bytes
courtship_previous_divisor                  equ 0x59bc ; 1 x 2 bytes
courtship_melody_byte_offset                equ 0x59be ; 1 x 2 bytes
courtship_melody_last_tick                  equ 0x59c0 ; 1 x 2 bytes
alternating_tone_byte_offset                equ 0x5a62 ; 1 x 2 bytes
alternating_tone_divisors                   equ 0x5a64 ; 14 x 2 bytes
alternating_tone_last_tick                  equ 0x5a80 ; 1 x 2 bytes
alternating_tone_phase                      equ 0x5a82 ; 1 x 1 bytes
result_melody_last_tick                     equ 0x5a83 ; 1 x 2 bytes
result_melody_byte_offset                   equ 0x5a85 ; 1 x 2 bytes
result_success_divisors                     equ 0x5a87 ; 14 x 2 bytes
result_failure_divisors                     equ 0x5aa3 ; 14 x 2 bytes
noise_duty_parameter                        equ 0x5acd ; 1 x 2 bytes
noise_phase                                 equ 0x5acf ; 1 x 1 bytes
