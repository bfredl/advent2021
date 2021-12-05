
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

    ; align to 32 bytes (AVX2 width)
    mov rax, 0x1f
    not rax
    and rsp, rax

    ; rsp = alloca(1024*1024)
    sub rsp, (1024*1024)
    mov rbx, rsp
    sub rsp, 4*8


nextline:
    mov rdi, lineline
    lea  rsi, [rsp+8]
    lea  rdx, [rsp+16]
    lea  rcx, [rsp+24]
    lea  r8,  [rsp+32]
    call scanf
    cmp rax, 4
    jne done

    printnum [rsp+8]
    printnum [rsp+16]
    printnum [rsp+24]
    printnum [rsp+32]

trycol:
    mov rax, [rsp+8]
    cmp rax, [rsp+24]
    jne tryrow

drawcol:
    ; basepointer: &arr[x]
    lea rdx, [rbx+rax]
    mov rdi, [rsp+16]
    mov rcx, [rsp+32]

    ; rdi=1024*y0, rcx=1024*y1
    shl rdi, 10
    shl rcx, 10
    mov r9, 1024
    jmp drawcode ; shared loop: rdi,rcx endpoints, r9 sride

tryrow:
    mov rax, [rsp+16]
    cmp rax, [rsp+32]
    jne nextline

drawrow:
    shl rax, 10 ; rax = y*1024
    lea rdx, [rbx+rax] ; rdx = arr[y*1024]
    mov rdi, [rsp+8]
    mov rcx, [rsp+16]
    mov r9, 1

drawcode:
; make sure rdi <= rcx by swapping
    cmp rdi, rcx
    jng noswap
    xchg rdi, rcx
noswap:

nextcell:
    add byte [rdx+rdi], 1 ; arr[y*1024+x] += 1
    add rdi, r9 ; rdi += stride

    cmp rdi, rcx
    jge nextline
    jmp nextcell

done:

    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret
lineline:
    db  "%d,%d -> %d,%d", 0
fmt:
    db  "%d", 0xA, 0
