global main
extern puts
extern scanf
extern printf

%macro printnum 1
   mov rdi, fmt
   mov rsi, %1
   call printf
%endmacro
%macro printenum 1
   mov rdi, fmt
   mov esi, %1
   call printf
%endmacro


    section   .text

main:
    push rbp
    mov rbp, rsp

    sub rsp, 6*8
    lea rbx, [rsp+8]; int rbx[9]

readitem:
    mov rdi, itemline
    lea rsi, [rsp+0]
    call scanf
    cmp rax, 1
    jne enda

    mov rax, [rsp+0]
    add dword [rbx+4*rax], 1
    jmp readitem

enda:
    xor r12, r12
ploop:
    printnum r12
    printenum [rbx+4*r12]
    inc r12
    cmp r12, 9
    jl ploop

    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret
itemline:
    db  "%d,", 0
fmt:
    db  "%d", 0xA, 0
