; ----------------------------------------------------------------------------------------
;     nasm -felf64 implb.asm && musl-gcc -static implb.o -o implb && ./implb < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts
          extern    scanf
          extern    printf

%macro readnum 1
          mov  rdi, scanfmt
          lea  rsi, [rsp+8]
          call scanf
          mov %1, [rsp+8]
%endmacro

          section   .text
main:
          sub  rsp,  24

          xor rax, rax
          mov rbp, rax

          readnum r14
          readnum r13
          readnum r12

          ; r12 previous number
          ; r13 second last number
          ; r14 third last number

loop:
          mov  rdi, scanfmt
          lea  rsi, [rsp+8]
          call scanf
          cmp rax, 1
          jne done

          cmp [rsp+8], r14
          jng skip
          add rbp, 1 ; add one if greater
skip:
          mov r14, r13
          mov r13, r12
          mov r12, [rsp+8]
          jmp loop

done:
          mov  rdi, message
          call puts

          mov  rdi, fmt
          mov  rsi, rbp
          call printf
          add  rsp, 24
          ret
message:
          db        "HALLOJ!", 0
scanfmt:
          db        "%d\n", 0
fmt:
          db        "%d", 0xA, 0
