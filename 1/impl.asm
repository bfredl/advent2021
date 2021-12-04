; ----------------------------------------------------------------------------------------
;     nasm -felf64 impl.asm && musl-gcc -static impl.o -o impl && ./impl < input
; ----------------------------------------------------------------------------------------

          global    main
          extern    puts
          extern    scanf
          extern    printf

          section   .text
main:
          sub  rsp,  24

          xor rax, rax
          mov rbp, rax

          mov  rdi, scanfmt            ; rdi: first arg
          lea  rsi, [rsp+8]            ; rsi: second arg
          call scanf

loop:
          mov  rdi, scanfmt            ; rdi: first arg
          lea  rsi, [rsp+16]           ; rsi: second arg
          call scanf
          cmp rax, 1
          jne done

          mov rcx, [rsp+16]
          cmp rcx, [rsp+8]
          jng skip
          add rbp, 1 ; add one if greater
skip:
          mov [rsp+8], rcx
          jmp loop

done:
          mov  rdi, message            ; rdi: first arg
          call puts

          mov  rdi, fmt            ; rdi: first arg
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
