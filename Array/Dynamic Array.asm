section .data
    array dq 0     ; Pointer to the dynamic array
    array_size dq 0 ; Current size of the array

section .text
    global _start

_start:
    ; Display menu options
    mov rdi, menu
    call print_string

    ; Read user choice
    call read_integer
    movzx eax, byte [input]

    ; Process user choice
    cmp al, 1
    je insert
    cmp al, 2
    je delete
    cmp al, 3
    je sort
    cmp al, 4
    je search

    ; Exit if the user choice is not valid
    jmp exit

; Insertion operation
insert:
    ; Display prompt for the value to insert
    mov rdi, prompt_insert
    call print_string

    ; Read the value to insert
    call read_integer
    movzx eax, byte [input]

    ; Increase the size of the array
    mov rdi, array_size
    inc qword [array_size]
    call resize_array

    ; Store the value in the array
    mov rsi, array_size
    imul rsi, rsi, 8    ; Multiply by 8 (size of each element)
    add rsi, array
    mov qword [rsi], rax

    ; Display the updated array
    mov rdi, array
    mov rcx, qword [array_size]
    call print_array

    jmp _start

; Deletion operation
delete:
    ; Display prompt for the index to delete
    mov rdi, prompt_delete
    call print_string

    ; Read the index to delete
    call read_integer
    movzx eax, byte [input]

    ; Check if the index is valid
    cmp rax, qword [array_size]
    jae .invalid_index

    ; Move the elements after the deleted index
    mov rdi, array
    mov rcx, qword [array_size]
    sub rcx, rax
    inc rcx
    mov rsi, rax
    imul rsi, rsi, 8    ; Multiply by 8 (size of each element)
    add rdi, rsi
    call move_elements

    ; Decrease the size of the array
    dec qword [array_size]

    ; Display the updated array
    mov rdi, array
    mov rcx, qword [array_size]
    call print_array

    jmp _start

.invalid_index:
    ; Display error message for invalid index
    mov rdi, invalid_index_message
    call print_string
    jmp _start

; Sorting operation
sort:
    ; Sort the array in ascending order
    mov rdi, array
    mov rcx, qword [array_size]
    call bubble_sort

    ; Display the sorted array
    mov rdi, sorted_array
    mov rcx, qword [array_size]
    call print_array

    jmp _start

; Searching operation
search:
    ; Display prompt for the value to search
    mov rdi, prompt_search
    call print_string

    ; Read the value to search
    call read_integer
    movzx eax, byte [input]

    ; Find the value in the array
    mov rdi, array
    mov rcx, qword [array_size]
    call search_in_array

    jmp _start

; Exit the program
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; Function to print a string
print_string:
    mov rax, 1
    mov rsi, rdi
    mov rdx, strlen rsi
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

; Function to resize the array
resize_array:
    mov rdi, array_size
    imul rdi, rdi, 8    ; Multiply by 8 (size of each element)
    add rdi, 8          ; Add space for one more element
    mov rax, 9          ; sys_brk system call
    syscall
    ret

; Function to move elements in the array
move_elements:
    sub rcx, rax
    imul rcx, rcx, 8    ; Multiply by 8 (size of each element)
    rep movsq
    ret

; Function to perform bubble sort on the array
bubble_sort:
    xor rdx, rdx

.outer_loop:
    xor rax, rax
    mov rbx, rdi
    inc rax

.inner_loop:
    cmp qword [rbx], rdx
    jg .inner_swap

    add rbx, 8
    dec rax
    jnz .inner_loop

    dec rcx
    jnz .outer_loop

    ret

.inner_swap:
    mov r8, qword [rbx]
    mov r9, qword [rbx - 8]
    mov qword [rbx], r9
    mov qword [rbx - 8], r8
    jmp .inner_loop

; Function to search for a value in the array
search_in_array:
    xor rdx, rdx

.search_loop:
    cmp qword [rdi], rdx
    je .search_found

    add rdi, 8
    dec rcx
    jnz .search_loop

    ret

.search_found:
    mov rax, 1
    mov rdi, found_message
    mov rdx, found_len
    syscall
    ret

section .data
menu db "Menu Options:", 0
prompt_insert db "Enter a value to insert: ", 0
prompt_delete db "Enter an index to delete: ", 0
prompt_search db "Enter a value to search: ", 0
invalid_index_message db "Invalid index!", 10, 0
found_message db "Value found in the array!", 10, 0

sorted_array db "Sorted array: ", 0
input times 2 db 0
strlen equ $ - input

section .bss
array resq 10
array_size resq 1

section .text
global _start
