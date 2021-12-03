; ----------------------------------------------------------------------------------------
;     nasm -felf64 impl.asm && musl-gcc -static impl.o -o impl && ./impl < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts

          section   .text
main:
          mov       rdi, message            ; rdi: first arg
          call      puts
          ret
message:
          db        "HALLOJ!", 0            ; NULL-terminated string
