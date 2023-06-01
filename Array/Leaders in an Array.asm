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

    ; Find the leaders in the array
    mov rdi, array
    mov rcx, qword [array_size]
    call find_leaders

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

; Function to find the leaders in the array
find_leaders:
    mov rax, qword [rdi + 8 * rcx - 8] ; Initialize the max element as the rightmost element
    mov qword [rdi + 8 * rcx], rax    ; Set the sentinel element at the end of the array
    mov r9, rcx

.find_loop:
    cmp rcx, 0
    je .find_end

    dec rcx
    mov r8, qword [rdi + 8 * rcx]     ; Load the current element

    cmp r8, rax                      ; Compare with the current max element
    jle .not_leader                  ; If less than or equal, not a leader

    mov rax, r8                      ; Update the max element
    mov qword [rdi + 8 * r9], r8     ; Store the leader element at the end of the array
    mov r9, r9 + 1                   ; Increment the index for the next leader

.not_leader:
    jmp .find_loop

.find_end:
    mov qword [rdi + 8 * r9], 0       ; Clear the sentinel element
    mov qword [array_size], r9        ; Update the array size to the number of leaders
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
original_array db "Original array: ", 0
input times 2 db 0
strlen equ $ - input

section .bss
array resq 10
array_size resq 1

section .text
global _start
