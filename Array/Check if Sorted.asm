section .data
    array dq 0     ; Pointer to the dynamic array
    array_size dq 0 ; Current size of the array

section .text
    global _start

_start:
    ; Display prompt for array size
    mov rdi, prompt_size
    call print_string

    ; Read the array size
    call read_integer
    movzx eax, byte [input]

    ; Create the dynamic array
    mov rdi, rax
    call create_array

    ; Display prompt for array elements
    mov rdi, prompt_elements
    call print_string

    ; Read the array elements
    mov rdi, array
    mov rcx, qword [array_size]
    call read_array

    ; Display the original array
    mov rdi, original_array
    mov rcx, qword [array_size]
    call print_array

    ; Check if the array is sorted
    mov rdi, array
    mov rcx, qword [array_size]
    call is_sorted

    ; Display the result
    mov rdi, result_message
    call print_string

    ; Exit the program
    jmp exit

; Function to create a dynamic array
create_array:
    mov rdi, array_size
    imul rdi, rdi, 8    ; Multiply by 8 (size of each element)
    mov rax, 9          ; sys_brk system call
    syscall
    ret

; Function to read an integer from the user
read_integer:
    xor rax, rax
    mov rdi, 0
    mov rsi, input
    mov rdx, 2
    syscall
    ret

; Function to read an array from the user
read_array:
    mov rax, 0
    call read_integer
    movzx eax, byte [input]
    mov qword [array_size], rax

.read_loop:
    cmp rax, 0
    je .read_end

    dec rax
    call read_integer
    mov qword [rdi], rax
    add rdi, 8
    jmp .read_loop

.read_end:
    ret

; Function to check if the array is sorted
is_sorted:
    mov rax, qword [rdi]
    add rdi, 8
    dec rcx

.check_loop:
    cmp rax, qword [rdi]
    jg .not_sorted

    mov rax, qword [rdi]
    add rdi, 8
    dec rcx
    jnz .check_loop

    movzx eax, byte [sorted]
    ret

.not_sorted:
    movzx eax, byte [unsorted]
    ret

; Function to print a string
print_string:
    mov rax, 1
    mov rsi, rdi
    mov rdx, strlen rsi
    syscall
    ret

; Exit the program
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
prompt_size db "Enter the size of the array: ", 0
prompt_elements db "Enter the elements of the array: ", 0
original_array db "Original array: ", 0
result_message db "The array is sorted.", 10, 0
input times 2 db 0
strlen equ $ - input

section .bss
array resq 10
array_size resq 1

section .text
global _start
