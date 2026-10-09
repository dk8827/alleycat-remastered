; Alley Cat DOS game program.
; Assemble from the repository root: nasm -f bin -I game/asm/ game/asm/alleycat.asm
bits 16
cpu 8086
%include "encoding.inc"
%include "layout.inc"
%include "symbols.inc"
%include "structures.inc"

HEADER_BYTES     equ 0x0200
DATA_FILE_OFFSET equ 0x0300
CODE_FILE_OFFSET equ 0x7430
EXE_BYTES        equ 0xd71b
DATA_PARAGRAPH   equ (DATA_FILE_OFFSET - HEADER_BYTES) / 16
CODE_PARAGRAPH   equ (CODE_FILE_OFFSET - HEADER_BYTES) / 16

section header start=0 vstart=0 align=1
    db 'MZ'
    dw EXE_BYTES % 512        ; bytes in last page
    dw (EXE_BYTES + 511) / 512
    dw 9                     ; DOS segment relocation count
    dw HEADER_BYTES / 16
    dw 0, 0xffff             ; minimum / maximum extra allocation
    dw 0, 0x0100             ; initial SS:SP relative to load image
    dw 0x8555                ; original checksum field, preserved exactly
    dw entry, CODE_PARAGRAPH ; initial IP:CS
    dw relocation_table, 0  ; relocation offset, overlay number
    dw 0x0bdc, 0x0400        ; original extra header words; meaning unconfirmed
relocation_table:
    dw loc_0008 + 1, CODE_PARAGRAPH
    dw loc_0540 + 1, CODE_PARAGRAPH
    dw save_player_background + 1, CODE_PARAGRAPH
    dw loc_13ec + 1, CODE_PARAGRAPH
    dw loc_14b7 + 1, CODE_PARAGRAPH
    dw loc_1500 + 1, CODE_PARAGRAPH
    dw loc_2add + 1, CODE_PARAGRAPH
    dw loc_3a97 + 1, CODE_PARAGRAPH
    dw print_startup_message + 1, CODE_PARAGRAPH
    times HEADER_BYTES - ($ - $$) db 0

section stack start=HEADER_BYTES vstart=0 align=1
    times 0x100 db 0

section data start=DATA_FILE_OFFSET vstart=0 align=1
%include "data/layout.inc"

section code start=CODE_FILE_OFFSET vstart=0 align=1
%include "code/layout.inc"
code_end:
    ; Negative TIMES count fails assembly if the original layout changes.
    times -(($ - $$ - (EXE_BYTES - CODE_FILE_OFFSET)) * ($ - $$ - (EXE_BYTES - CODE_FILE_OFFSET))) db 0
