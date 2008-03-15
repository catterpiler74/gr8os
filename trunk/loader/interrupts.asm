;
; ========================================================
;  ����������� ����������� ���������� ����������� ������
; ========================================================
;

use32

;
; ��������� ����� INT 30
;
syscall_handler:
    pushad

    cmp  ax, 0
    jz	 __syscall_print_string
    cmp  ax, 1
    jz	 __syscall_goto_nextline
    jmp  __syscall_invalid_syscall

; AX = 00 - ������ ������
;
; ������� ���������: DS:ESI ��������� �� ASCIIZ-������, ES ��������� � ������� �����������
; �������� ���������: ���
__syscall_print_string:
    lodsb
    .if al,ne,13
      mov  edi, dword [cursor]
      mov  [gs:edi*2], al
      inc  dword [cursor]
    .else
      mov  ax, 1
      int  30h
    .endif

    .if dword [cursor],g,2000
      mov  dword [cursor], 0
    .endif

    test al, al
    jnz  __syscall_print_string
    jmp  __syscall_end

; AX = 01 - ������� ������
;
; ������� ���������: ���
; �������� ���������: ���
__syscall_goto_nextline:
    xor  edx, edx
    mov  eax, dword [cursor]
    mov  ebx, 80
    div  ebx
    mov  ebx, 80
    sub  ebx, edx
    add  dword [cursor], ebx

    .if dword [cursor],g,2000
      mov  dword [cursor], 0
    .endif

    jmp  __syscall_end


__syscall_invalid_syscall:
    halt
    ; stc
__syscall_end:
    popad
    iretd

