global main
extern puts
extern scanf
extern printf

%macro printnum 1
   mov rdi, lfmt
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

    sub rsp, (10*8)
    lea rbx, [rsp+8]; int rbx[9]

    mov rdi, rbx
    mov rax, 0
    mov rcx, (9*8)
    rep stosb

readitem:
    mov rdi, itemline
    lea rsi, [rsp+0]
    call scanf
    cmp rax, 1
    jne enda

    mov rax, [rsp+0]
    add qword [rbx+8*rax], 1
    jmp readitem

enda:

    xor r13, r13 ; first day is zero
    xor r14, r14 ; first day is zero

newday:
    mov rax, [rbx+8*r13]
    lea rdi, [r13-2]; seven days later = -2 mod 9
    lea rsi, [r13+7]
    cmp rdi, 0
    cmovl rdi, rsi
    add [rbx+8*rdi], rax

    inc r13
    xor rax, rax
    cmp r13, 9
    cmove r13, rax

    inc r14

    ;printnum r14
    ;printnum r13

    cmp r14, 256
    jl newday

    xor r12, r12
    xor r13, r13
ploop:
    ;printnum r12
    mov rax, [rbx+8*r12]
    add r13, rax

    ;printenum eax
    inc r12
    cmp r12, 9
    jl ploop

    printnum r13

    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret
itemline:
    db  "%d,", 0
fmt:
    db  "%d", 0xA, 0
lfmt:
    db  "%ld", 0xA, 0
