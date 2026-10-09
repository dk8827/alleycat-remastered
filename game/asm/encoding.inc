; NASM normally selects the store-direction opcode for register/register pairs.
; The original assembler often selected the equally valid load-direction opcode.
; These macros encode that choice from the mnemonic and named registers.
; They are instructions, not copies of bytes from the reference executable.

%assign reg_al 0
%assign reg_cl 1
%assign reg_dl 2
%assign reg_bl 3
%assign reg_ah 4
%assign reg_ch 5
%assign reg_dh 6
%assign reg_bh 7
%assign reg_ax 0
%assign reg_cx 1
%assign reg_dx 2
%assign reg_bx 3
%assign reg_sp 4
%assign reg_bp 5
%assign reg_si 6
%assign reg_di 7

%assign load_opcode_add 0x02
%assign load_opcode_or  0x0a
%assign load_opcode_adc 0x12
%assign load_opcode_sbb 0x1a
%assign load_opcode_and 0x22
%assign load_opcode_sub 0x2a
%assign load_opcode_xor 0x32
%assign load_opcode_cmp 0x3a
%assign load_opcode_mov 0x8a

%macro load8 3
    db load_opcode_%1
    db 0xc0 | (reg_%2 << 3) | reg_%3
%endmacro

%macro load16 3
    db load_opcode_%1 + 1
    db 0xc0 | (reg_%2 << 3) | reg_%3
%endmacro
