section .data
    array dq 0       ; Pointer to the array
    array_size dq 0  ; Current size of the array

section .text
    global _start

_start:
    ; Display prompt for array size
    mov rdi, prompt_size
    call print_string

    ; Read the array size
    call read_integer
    movzx eax, byte [input]

    ; Create the array
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

    ; Count the frequencies of elements
    mov rdi, array
    mov rcx, qword [array_size]
    call count_frequencies

    ; Display the frequencies
    mov rdi, frequencies_msg
    call print_string
    mov rdi, array
    mov rcx, qword [array_size]
    call print_frequencies

    ; Exit the program
    jmp exit

; Function to create an array
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

; Function to read the array from the user
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

; Function to count the frequencies of elements in the array
count_frequencies:
    xor rax, rax                      ; Initialize the current element to 0
    mov r8, qword [rdi]               ; Initialize the current frequency count to 1

    .loop:
    cmp rcx, 0
    je .end

    dec rcx
    mov r9, qword [rdi + 8 * rcx]     ; Load the current element

    cmp r9, rax                       ; Compare with the current element
    je .increment                     ; If equal, increment the frequency count

    mov rax, r9                       ; Update the current element
    mov r8, 1                         ; Reset the frequency count to 1

    .increment:
    add r8, 1                         ; Increment the frequency count

    .store_frequency:
    mov qword [rdi + 8 * rcx], r8     ; Store the frequency count in the array

    jmp .loop

    .end:
    ret

; Function to print a string
print_string:
    mov rax, 1
    mov rsi, rdi
    mov rdx, strlen rsi
    syscall
    ret

; Function to print an integer
print_integer:
    xor rsi, rsi
    xor rdx, rdx
    mov rdi, 10
    div rdi
    push rdx
    cmp rax, 0
    jz .print_end
    call print_integer
    pop rax
    add al, '0'
    mov rdi, 1
    mov rsi, rax
    mov rdx, 1
    syscall
    .print_end:
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

; Function to print the frequencies
print_frequencies:
    mov rax, 0
    call print_integer
    movzx eax, byte [input]
    mov qword [array_size], rax

    .print_loop:
    cmp rcx, 0
    je .print_end

    dec rcx
    mov rax, qword [rdi + 8 * rcx]     ; Load the current frequency count
    call print_integer
    mov rax, frequency_delimiter
    call print_string

    jmp .print_loop

    .print_end:
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
frequencies_msg db "Frequencies: ", 0
frequency_delimiter db ", ", 0
input times 2 db 0
strlen equ $ - input

section .bss
array resq 10
array_size resq 1

section .text
global _start
