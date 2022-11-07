%define lw 0

%macro colon 2
%%lw: dq lw
db %1, 0
db %2, 0

%define lw %%lw
%endmacro
