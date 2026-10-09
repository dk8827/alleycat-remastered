; Blitter scratch and random state.
; Original DS:2AE0..2AF0 (end exclusive).

; DS:2ae0 blit_width_words: Low-byte width scratch; word reads also consume zero byte at 2AE1.
data_2ae0: db 0x00 ; .
data_2ae1: db 0x00 ; .

; DS:2ae2 blit_height_rows: Scanline counter used by the graphics routines.
data_2ae2: db 0x00 ; .

; DS:2ae3 blit_source_word: Original source word retained while the transparency mask is formed.
data_2ae3: db 0x00, 0x00 ; ..

; DS:2ae5 random_state: Seeded at CS:2E10 and advanced at CS:2DFD.
data_2ae5: db 0x00, 0x00 ; ..
data_2ae7: db 0x00, 0x00 ; ..

; DS:2ae9 blit_row_source: Source row start in the strided copy routine.
data_2ae9: db 0x00, 0x00 ; ..

; DS:2aeb blit_source_stride_bytes: Byte-sized doubled AL stride in CS:2D70; overflows modulo 256.
data_2aeb: db 0x00 ; .
data_2aec: db 0x00, 0x00, 0x00, 0x00 ; ....
