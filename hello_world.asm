; Задание выполнено на NASM.
; Запуск:
; nasm -f elf64 -o hello_world.o hello_world.asm
; ld -o hello_world.out hello_world.o
; ./hello_world.out


global _start

section .text

_start:
        ; https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md#x86_64_1
        ; Для вывода строки нам необходим системный вызов write.
        ; В таблице системных вызовов можно увидеть, что значение в регистре rax
        ; должно быть равно единице.
        mov     rax, 1 ; код rax для системного вызова write()

        ; https://man7.org/linux/man-pages/man2/write.2.html
        ; Функция write принимает на вход три аргумента.
        ;   int fd - целое число, файловый дескриптор для файла, в который будет произведена запись.
        ;   const void buf* - указатель на начало буфера с данными.
        ;   size_t count - количество байтов, которые будут взяты из буфера и записаны в файл.

        ; Файловый дескриптор считывается из регистра rdi.
        mov     rdi, 1 ; int fd
        ; Указатель на начало буфера считывается из регистра rsi.
        mov     rsi, message ; const void buf*
        ; Количество байтов для записи считывается из регистра rdx.
        mov     rdx, message_length ; size_t count
        syscall

        ; https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md#x86_64_60
        ; Произведем вызов exit с error_code=0 (успешное завершение программы).
        mov     rax, 60 ; код rax системного вызова exit()
        mov     rdi, 0 ; int error_code
        syscall

section .data ; секция с данными
        ; Определим необходимые переменные.
        ; message - строка с текстом сообщения.
        message: DB "Hello, world!", 10 ; DB - define bytes, определяем последовательность байт; 10 - код для \n
        ; message_length - целое число, длина сообщения в байтах.
        message_length: EQU $ - message ; EQU - определение константы, $ - message - вычисление длины строки в байтах
