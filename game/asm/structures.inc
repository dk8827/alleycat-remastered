; Recovered in-memory record, not an allocation and not an original type name.
; CS:4FBB/4FCD copies 12 bytes through seven pointers at DS:45A8.
; Current work record lives at DS:4548. Saved records start at DS:4554.
struc CourtshipCat
    .x                     resw 1
    .horizontal_direction  resb 1
    .y                     resb 1
    .video_offset          resw 1
    .background_absent     resb 1
    .hidden_since_tick     resw 1
    .animation_byte_offset resw 1
    .contact_countdown     resb 1
endstruc
%if CourtshipCat_size != 12
    %error CourtshipCat record must remain 12 bytes
%endif
