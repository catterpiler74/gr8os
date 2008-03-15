;
; ==================================================
;   ��������� ������ ������������ � 16������ �����.
;   ���������:
;    CL - ����� ����������
; ==================================================
;

use32
old_ax dw ?
old_cl db ?
REAL_MODE_SWITCH_SERVICE:
    mov  [old_cl], cl
    mov  [old_ax], ax

    mov  cl, [esp+4]

    ; ������ ���� ����������
    pushfd
    cli
    in	 al, 70h
    or	 al, 80h
    out  70h, al  ; ������ NMI

    ; ������������� ������� � �������� �����...
    lidt fword [REAL_IDTR]

    ; ��������� � CS �������� 16-������� �������� � ������� 64�
    jmp  00100000b:__CONT

use16
    __CONT:

    ; �� � 16������ ��������. ������������� � �������� �����.
    mov  eax, cr0
    and  al, 0FEh
    mov  cr0, eax
    jmp  0:REAL_ENTRY

;    ��� ��������� ������
REAL_ENTRY:
    mov  ax, cs
    mov  ds, ax
    mov  ss, ax
    mov  es, ax

    ; ��������� ���������� ���������� � NMI
;    in   al, 70h
;    and  al, 7Fh
;    out  70h, al
;    sti

    mov  [int_no], cl

    mov  ax, [old_ax]
    mov  cl, [old_cl]

    db 0CDh	  ; INT xx
    int_no db 0

    mov  [old_ax], ax

    ; ������ ���� ����������
;    cli
;    in   al, 70h
;    or   al, 80h
;    out  70h, al  ; ������ NMI

    ; ������������ � PM
    mov  eax, cr0
    or	 al, 1
    mov  cr0, eax

    ; ������
    jmp   00001000b:RESTORE_ENTRY

    ; �� �������������� �� ��������� ������
use32
 RESTORE_ENTRY:
    lidt fword [IDTR]
    mov  ax, 00010000b	; DATA_descr
    mov  ds, ax
    mov  ss, ax
    mov  ax, 00011000b	; VIDEO_descr
    mov  es, ax

    ; ��������� ���������� ���������� � NMI
    in	 al, 70h
    and  al, 7Fh
    out  70h, al
    popfd

    mov  ax, [old_ax]

    ret  4
