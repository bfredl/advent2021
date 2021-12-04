; ----------------------------------------------------------------------------------------
;     nasm -felf64 implb.asm && musl-gcc -static implb.o -o implb && ./implb < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts
          extern    scanf
          extern    printf

%macro readnum 2
%endmacro

          section   .text
main:
          sub  rsp,  (19*8)
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

done:
          mov  rdi, message
          call puts

          mov  rdi, fmt
          mov  rsi, rbp
          call printf

          mov  rdi, fmt
          mov  rsi, [rbx+4*rbp-4]
          call printf

          add  rsp, (19*8)
          ret
message:
          db        "HALLOJ!", 0
tocomma:
          db        "%d,%n", 0
fmt:
          db        "%d", 0xA, 0
