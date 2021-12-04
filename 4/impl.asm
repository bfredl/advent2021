; ----------------------------------------------------------------------------------------
;     nasm -felf64 implb.asm && musl-gcc -static implb.o -o implb && ./implb < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts
          extern    scanf
          extern    printf

;%macro readnum 2
;%endmacro

%macro printnum 1
   mov rdi, fmt
   mov rsi, %1
   call printf
%endmacro

          section   .text
main:
          push rbp
          mov rbp, rsp
          sub  rsp, (2*8+128+(4*32))

          lea rbx, [rsp+24]
          xor r15, r15

          ;mov rsi,

commaloop:
          mov  rdi, tocomma
          lea  rsi, [rsp+8]
          mov qword [rsp+16], 0
          lea  rdx, [rsp+16]
          call scanf

          cmp qword [rsp+16], 0
          je donecomma

          mov rax, [rsp+8]
          mov [rbx+rax], r15b

          inc r15

          jmp commaloop

donecomma:
          printnum r15

          mov al, [rbx+11]
          printnum rax

          mov al, [rbx+22]
          printnum rax ; FAIL: this should be zero

          ; time number x is called: int rbx[x];

          lea r12, [rbx+128]
          xor r13, r13

boardloop:

          mov  rdi, readnum
          lea  rsi, [r12+4*r13]
          call scanf
          cmp rax, 1
          jne done

          inc r13

          cmp r13, 25
          jl boardloop

          printnum [r12+4*r13-4]

done:
          ; board numbers: int r12[25];

          lea r13, [r12+(4*25)]

          ; board markers: int r13[25];

          mov rsp, rbp
          pop rbp
          ret
tocomma:
          db        "%d,%n", 0
readnum:
          db        "%d", 0
fmt:
          db        "%d", 0xA, 0
