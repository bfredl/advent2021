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
          sub  rsp,  ((3+32)*8)
          lea rbx, [rsp+24]
          xor rbp, rbp

commaloop:
          mov  rdi, tocomma
          lea  rsi, [rbx+4*rbp]
          mov qword [rsp+16], 0
          lea  rdx, [rsp+16]
          call scanf
          inc rbp
          cmp qword [rsp+16], 0
          jne commaloop

donecomma:
          printnum rbp
          printnum [rbx+4*rbp-4]

          lea r12, [rbx+4*rbp]
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

          add  rsp, ((3+32)*8)
          ret
tocomma:
          db        "%d,%n", 0
readnum:
          db        "%d", 0
fmt:
          db        "%d", 0xA, 0
