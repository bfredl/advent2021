
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
    xor r14, r14
    xor r15, r15

    ; align to 32 bytes (AVX2 width)
    mov rax, 0x1f
    not rax
    and rsp, rax

    ; rsp = alloca(1024*1024)
    sub rsp, (1024*1024)
    mov rbx, rsp
    sub rsp, 8*8

    mov rdi, rbx
    mov rax, 0
    mov rcx, (1024*1024)
    rep stosb

nextline:
    mov rdi, lineline
    lea  rsi, [rsp+8]
    lea  rdx, [rsp+16]
    lea  rcx, [rsp+24]
    lea  r8,  [rsp+32]
    call scanf
    cmp rax, 4
    jne done

trycol:
    mov rax, [rsp+8]
    cmp rax, [rsp+24]
    jne tryrow

drawcol:
    inc r14
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
    jne trydiag

drawrow:
    inc r15
    shl rax, 10 ; rax = y*1024
    lea rdx, [rbx+rax] ; rdx = arr[y*1024]
    mov rdi, [rsp+8]
    mov rcx, [rsp+24]
    mov r9, 1

    jmp drawcode ; shared loop: rdi,rcx endpoints, r9 sride

trydiag:
    ; comment out for only row/col (subtask 1)
    ;jmp nextline
    mov rcx, [rsp+32]
    mov r10, [rsp+8]
    mov r11, [rsp+24]

    jl nodiagswap ; if y1=rax > y2=rcx, swap
    xchg rax, rcx
    xchg r10, r11

nodiagswap:

    lea rdx, [rbx+r10] ; rdx = &arr[x0]
    shl rax, 10
    shl rcx, 10
    mov rdi, rax ; rdi = 1024*y0
    mov r9, (1024-1) ; y+=1, x-=1
    cmp r10, r11 ; check if x goes up or down

    jg nextcell ; skip swap, we already dunnit
    mov r9, (1024+1) ; y+=1, x+=1
    add rcx, 1024 ; we are gonna miss the final cell as rcx only counts y, twiddle

    jmp nextcell ; skip swap, we already dunnit


drawcode:
; make sure rdi <= rcx by swapping
    cmp rdi, rcx
    jng nextcell
    xchg rdi, rcx

nextcell:
    ; todo use byte test instructions?
    mov al, [rdx+rdi]
    btr eax, 1 ; if eax=2 
    adc eax, 1
    mov [rdx+rdi], al

    ;add byte [rdx+rdi], 1 ; arr[y*1024+x] += 1
    add rdi, r9 ; rdi += stride

    cmp rdi, rcx
    jg nextline
    jmp nextcell

done:
    mov rax, 1 ; write
    mov rdi, 1 ; stdout
    mov rsi, rbx ; buf = array
    mov rdx, (1024*1024) ; size
    ;syscall ; thxplz

    vzeroall ; AVX2 says helloo

    mov al, 2
    vpinsrb xmm2, al, 0
    vpbroadcastb ymm2, xmm2

    mov rcx, 0
reducesum:
    vmovdqa ymm1, [rbx+rcx]

    ; equal bytes are set to 0xFF
    vpcmpeqb ymm1, ymm1, ymm2
    ; invert to get 0x01 for equal byte
    vpsubb ymm1, ymm8, ymm1
    ; reduce to four unsigned qwords
    vpsadbw ymm1, ymm1, ymm8
    ; accumulate qwords
    vpaddq ymm3, ymm3, ymm1

    add rcx, 32
    cmp rcx, (1024*1024)
    jl reducesum

final:
    vmovdqa [rsp], ymm3
    vzeroupper ; AVX2 says BABAJ

    mov rax, [rsp]
    add rax, [rsp+8]
    add rax, [rsp+16]
    add rax, [rsp+24]

    printnum rax
    ;printnum r14
    ;printnum r15

    mov rsp, rbp
    pop rbp
    mov rax, 0
    ret
lineline:
    db  "%d,%d -> %d,%d", 0
fmt:
    db  "%d", 0xA, 0
