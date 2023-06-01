section .data
    array db 10, 20, 30, 40, 50, 60, 70, 80, 90, 100   ; Initial array values
    array_size equ $ - array                           ; Size of the array

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

    ; Add the value to the array
    mov rsi, array_size
    mov byte [array + rsi], al
    inc byte [array_size]

    ; Display the updated array
    mov rdi, array
    mov rcx, array_size
    call print_array

    jmp _start

; Deletion operation
delete:
    ; Display prompt for the value to delete
    mov rdi, prompt_delete
    call print_string

    ; Read the value to delete
    call read_integer
    movzx eax, byte [input]

    ; Find and remove the value from the array
    mov rcx, array_size
    mov rdi, array
    call delete_from_array

    ; Display the updated array
    mov rdi, array
    mov rcx, array_size
    call print_array

    jmp _start

; Sorting operation
sort:
    ; Sort the array in ascending order
    mov rdi, array
    mov rcx, array_size
    call bubble_sort

    ; Display the sorted array
    mov rdi, sorted_array
    mov rcx, array_size
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
    mov rcx, array_size
    mov rdi, array
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

; Function to print the array
print_array:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    imul rdx, rdx, 3
    add rdx, array
    syscall
    ret

; Function to delete a value from the array
delete_from_array:
    mov rbx, rax
    dec rcx

.delete_loop:
    cmp byte [rdi], bl
    je .delete_found

    add rdi, 3
    dec rcx
    jnz .delete_loop

    ret

.delete_found:
    mov al, byte [array + rcx]
    mov byte [rdi], al
    inc rdi
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

    add rbx, 3
    dec rax
    jnz .inner_loop

    dec rcx
    jnz .outer_loop

    ret

.inner_swap:
    mov dl, byte [rbx]
    mov cl, byte [rbx - 3]
    mov byte [rbx], cl
    mov byte [rbx - 3], dl
    jmp .inner_loop

; Function to search for a value in the array
search_in_array:
    xor rdx, rdx

.search_loop:
    cmp byte [rdi], dl
    je .search_found

    add rdi, 3
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
prompt_delete db "Enter a value to delete: ", 0
prompt_search db "Enter a value to search: ", 0
found_message db "Value found in the array!", 10, 0

sorted_array db "Sorted array: ", 0
input times 2 db 0
strlen equ $ - input
array_size db 10

section .bss
array resb 30

section .text
global _start
