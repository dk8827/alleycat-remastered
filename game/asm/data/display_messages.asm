; Display adapter messages.
; Original DS:60F0..6152 (end exclusive).

; DS:60f0 text_enable_color_display: NUL-terminated text: 'Please turn on the color display.'
data_60f0: db "Please turn on the color display.", 0x00

; DS:6112 text_color_adapter_required: NUL-terminated text: 'This program requires a color/graphics adapter.'
data_6112: db "This program requires a color/graphics adapter.", 0x00
data_6142: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; ..............
data_6150: db 0x00, 0x00 ; ..
