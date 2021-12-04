; ----------------------------------------------------------------------------------------
;     nasm -felf64 impl.asm && musl-gcc -static impl.o -o impl && ./impl < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts
          extern    scanf
          extern    printf

          section   .text
main:
          mov  rdi, scanfmt            ; rdi: first arg
          xor  rax, rax
          sub  rsp,  24
          lea  rsi, [rsp+8]            ; rsi: second arg

          call scanf

          mov  rdi, message            ; rdi: first arg
          call puts

          mov  rdi, fmt            ; rdi: first arg
          mov  rsi, [rsp+8]
          call printf
          add  rsp, 24
          ret
message:
          db        "HALLOJ!", 0
scanfmt:
          db        "%d", 0
fmt:
          db        "%d", 0xA, 0
