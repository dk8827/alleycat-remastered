; Rectangle overlap primitive.
; Original CS:2E29..2E60 (end exclusive).

; CS:2e29 — rectangles_overlap
; Unsigned rectangle comparison using AX/DL/SI/CL and BX/DH/DI/CH; returns CF=1 on overlap including touching edges. Clamps subtractions at zero; additions retain machine-width wrapping.
rectangles_overlap:
    load16 add, ax, si                                                          ; 2e29: 03 c6
loc_2e2b:
    load16 cmp, ax, bx                                                          ; 2e2b: 3b c3
loc_2e2d:
    jb loc_2e4f                                                                 ; 2e2d: 72 20
loc_2e2f:
    load16 sub, ax, si                                                          ; 2e2f: 2b c6
loc_2e31:
    load16 sub, ax, di                                                          ; 2e31: 2b c7
loc_2e33:
    jae loc_2e37                                                                ; 2e33: 73 02
loc_2e35:
    load16 sub, ax, ax                                                          ; 2e35: 2b c0
loc_2e37:
    load16 cmp, ax, bx                                                          ; 2e37: 3b c3
loc_2e39:
    ja loc_2e4f                                                                 ; 2e39: 77 14
loc_2e3b:
    load8 add, dl, cl                                                           ; 2e3b: 02 d1
loc_2e3d:
    load8 cmp, dl, dh                                                           ; 2e3d: 3a d6
loc_2e3f:
    jb loc_2e4f                                                                 ; 2e3f: 72 0e
loc_2e41:
    load8 sub, dl, cl                                                           ; 2e41: 2a d1
loc_2e43:
    load8 sub, dl, ch                                                           ; 2e43: 2a d5
loc_2e45:
    jae loc_2e49                                                                ; 2e45: 73 02
loc_2e47:
    load8 sub, dl, dl                                                           ; 2e47: 2a d2
loc_2e49:
    load8 cmp, dl, dh                                                           ; 2e49: 3a d6
loc_2e4b:
    ja loc_2e4f                                                                 ; 2e4b: 77 02
loc_2e4d:
    stc                                                                         ; 2e4d: f9
loc_2e4e:
    ret                                                                         ; 2e4e: c3
loc_2e4f:
    clc                                                                         ; 2e4f: f8
loc_2e50:
    ret                                                                         ; 2e50: c3
    times 15 db 0 ; original zero fill at CS:2e51
