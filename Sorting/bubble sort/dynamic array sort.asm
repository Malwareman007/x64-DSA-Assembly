section .data
    prompt db "Enter the size of the array: ", 0
    array_prompt db "Enter the elements of the array: ", 0
    sorted_array db "Sorted array: ", 0
    input times 16 db 0
    newline db 10, 0

section .text
    global _start

_start:
    ; Display prompt for array size
    mov rdi, prompt
    call print_string

    ; Read array size from user
    call read_integer
    movzx eax, byte [input]

    ; Allocate memory for the array
    mov rdi, rax
    mov rax, 9
    syscall
    mov rsi, rax  ; save the pointer to the allocated memory

    ; Display prompt for array elements
    mov rdi, array_prompt
    call print_string

    ; Read array elements from user
    mov rcx, rax
    mov rdi, rsi
    call read_array

    ; Sort the array using bubble sort
    mov rcx, rax
    mov rdi, rsi
    call bubble_sort

    ; Display the sorted array
    mov rdi, sorted_array
    call print_string
    mov rcx, rax
    mov rdi, rsi
    call print_array

    ; Free the allocated memory
    mov rdi, rsi
    mov rax, 11
    syscall

    ; Exit the program
    mov rax, 60
    xor rdi, rdi
    syscall

; Function to print a string
print_string:
    mov rax, 1
    mov rdx, strlen rdi
    syscall
    ret

; Function to read an integer from the user
read_integer:
    xor rax, rax
    mov rdi, 0
    mov rsi, input
    mov rdx, 16
    syscall
    ret

; Function to read an array from the user
read_array:
    mov r8, rdi  ; save the starting address of the array

.read_loop:
    call read_integer
    mov byte [rdi], al
    inc rdi
    dec rcx
    jnz .read_loop

    ret

; Function to print the array
print_array:
    mov rax, 1
    mov rdx, rcx
    sub rdx, rdi
    imul rdx, rdx, 2
    add rdx, rdi

.print_loop:
    movzx eax, byte [rdi]
    call print_integer
    inc rdi
    cmp rdi, rdx
    jl .print_loop

    mov rdi, newline
    call print_string

    ret

; Function to print an integer
print_integer:
    mov rcx, 10
    xor rdx, rdx

    .convert_loop:
        xor rax, rax
        div rcx
        push dx
        add dl, '0'
        mov [rsi], dl
        inc rsi
        pop dx
        test rax, rax
        jnz .convert_loop

    mov byte [rsi], 0
    sub rsi, rdi
    mov rax, 1
    mov rdx, rsi
    syscall
    ret

; Function to perform bubble sort on the array
bubble_sort:
    xor rdx, rdx

    .outer_loop:
        xor rax, rax
        mov rbx, rdi
        inc rax

        .inner_loop:
            cmp byte [rbx], bl
            jg .inner_swap

            add rbx, 2
            dec rax
            jnz .inner_loop

        dec rcx
        jnz .outer_loop

    ret

.inner_swap:
    mov dl, byte [rbx]
    mov cl, byte [rbx - 2]
    mov byte [rbx], cl
    mov byte [rbx - 2], dl
    jmp .inner_loop

section .data
strlen equ $ - input

section .bss
input resb 16
