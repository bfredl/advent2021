
global main
extern puts
extern scanf
extern printf

%macro printnum 1
   mov rdi, fmt
   mov rsi, %1
   call printf
%endmacro

    section   .text

main:
    push rbp
    mov rbp, rsp
    sub rsp, (4*8)

    mov rdi, lineline
    lea  rsi, [rsp+8]
    lea  rdx, [rsp+16]
    lea  rcx, [rsp+24]
    lea  r8,  [rsp+32]
    call scanf
    cmp rax, 4
    jne done


    printnum rax
    printnum [rsp+8]
    printnum [rsp+16]
    printnum [rsp+24]
    printnum [rsp+32]

done:

    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret
lineline:
    db  "%d,%d -> %d,%d", 0
fmt:
    db  "%d", 0xA, 0
