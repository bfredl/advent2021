; ----------------------------------------------------------------------------------------
;     nasm -felf64 impl.asm && musl-gcc -static impl.o -o impl && ./impl < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts
          extern    scanf

          section   .text
main:
          mov       rdi, fmt            ; rdi: first arg
          xor       rax, rax
          push      rax
          mov       rsi, rsp            ; rdi: first arg

          call scanf

          mov       rdi, message            ; rdi: first arg
          call      puts
          ret
message:
          db        "HALLOJ!", 0            ; NULL-terminated string
fmt:
          db        "%d\n", 0            ; NULL-terminated string
