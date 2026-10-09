; DS symbols, grouped by system. Includes allocate no bytes.

; Numeric CGA address correction, not a pointer to DS:1FD8.
CGA_ODD_ROW_CORRECTION equ 0x2000 - 40

%include "symbols/flow.inc"
%include "symbols/player.inc"
%include "symbols/input_hardware.inc"
%include "symbols/alley.inc"
%include "symbols/enemy.inc"
%include "symbols/score.inc"
%include "symbols/graphics_random.inc"
%include "symbols/rooms.inc"
%include "symbols/sound.inc"
%include "symbols/menus.inc"
