section .data
    array dq 0       ; Pointer to the dynamic array
    array_size dq 0  ; Current size of the array
    rotation dq 0    ; Number of places to rotate

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

    ; Display prompt for number of places to rotate
    mov rdi, prompt_rotation
    call print_string

    ; Read the number of places to rotate
    call read_integer
    mov qword [rotation], rax

    ; Perform left rotation
    mov rdi, array
    mov rcx, qword [array_size]
    mov rdx, qword [rotation]
    call left_rotate

    ; Display the rotated array
    mov rdi, rotated_array
    mov rcx, qword [array_size]
    call print_array

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

; Function to perform left rotation by D places
left_rotate:
    mov rax, qword [rdx]
    mov rcx, qword [rsi]
    sub rcx, rax
    shr rcx, 3          ; Divide by 8 (size of each element)
    mov rsi, rdi
    add rsi, 8          ; Skip the first element
    mov rdx, rcx
    imul rdx, rdx, 8    ; Multiply by 8 (size of each element)
    rep movsq
    mov rdi, qword [array]
    mov rax, qword [array_size]
    add rax, rdx
    mov qword [array_size], rax
    ret

; Function to print a string
print_string:
    mov rax, 1
    mov rsi, rdi
    mov rdx, strlen rsi
    syscall
    ret

; Function to print the array
print_array:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    imul rdx, rdx, 8    ; Multiply by 8 (size of each element)
    add rdx, rdi
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
prompt_rotation db "Enter the number of places to rotate: ", 0
original_array db "Original array: ", 0
rotated_array db "Rotated array: ", 0
input times 2 db 0
strlen equ $ - input

section .bss
array resq 10
array_size resq 1
rotation resq 1

section .text
global _start
