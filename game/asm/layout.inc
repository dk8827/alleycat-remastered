; Exact segment boundaries: fail assembly on either growth or shrinkage.
; Unlike alignment/padding directives, this never repairs a displaced module.
%macro assert_offset 1
    times -(($ - $$ - %1) * ($ - $$ - %1)) db 0
%endmacro

%macro include_at 3
    assert_offset %1
    %include %2
    assert_offset %3
%endmacro
