section .data
    array_size equ 10                    ; Size of the array
    array dq array_size dup(0)            ; Array to be sorted

section .text
    global _start

_start:
    ; Read user input to populate the array
    mov rdi, array
    mov rsi, array_size
    call read_array

    ; Sort the array using insertion sort
    mov rdi, array
    mov rsi, array_size
    call insertion_sort

    ; Display the sorted array
    mov rdi, sorted_array_msg
    call print_string
    mov rdi, array
    mov rsi, array_size
    call print_array

    ; Exit the program
    jmp exit

; Function to read an array from user input
read_array:
    xor rax, rax                         ; Initialize the loop index to 0

    .loop:
    cmp rsi, 0
    je .read_end

    dec rsi
    mov rdi, read_integer_msg
    call print_string

    xor rdi, rdi
    mov rdx, read_buffer
    mov rdx, read_buffer_size
    syscall

    mov rdi, rdx
    call parse_integer
    mov qword [rdi + 8 * rax], rax

    inc rax
    jmp .loop

    .read_end:
    ret

; Function to parse an integer from a string
parse_integer:
    xor rbx, rbx                         ; Initialize the result to 0
    xor rcx, rcx                         ; Initialize the sign flag to 0
    xor rdx, rdx                         ; Initialize the loop index to 0

    .loop:
    movzx eax, byte [rdi + rdx]          ; Load the current character

    cmp eax, '-'                        ; Check for negative sign
    je .set_negative

    cmp eax, '0'
    jl .end

    cmp eax, '9'
    jg .end

    sub eax, '0'                        ; Convert the character to a digit

    imul rbx, 10
    add rbx, rax

    inc rdx
    jmp .loop

    .set_negative:
    inc rcx                              ; Set the sign flag

    inc rdx
    jmp .loop

    .end:
    test rcx, 1                          ; Check if the number is negative
    jnz .set_negative_result

    .set_positive_result:
    mov rax, rbx
    ret

    .set_negative_result:
    neg rbx
    mov rax, rbx
    ret

; Function to print a string
print_string:
    mov rax, 1
    mov rsi, rdi
    mov rdx, strlen rsi
    syscall
    ret

; Function to print an array
print_array:
    xor rax, rax                         ; Initialize the loop index to 0

    .loop:
    cmp rsi, 0
    je .print_end

    dec rsi
    mov rdx, qword [rdi + 8 * rsi]       ; Load the current element

    mov rdi, rdx
    call print_integer

    mov rdi, array_delimiter_msg
    call print_string

    jmp .loop

    .print_end:
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

; Function to perform the insertion sort algorithm
insertion_sort:
    push rbp
    mov rbp, rsp

    mov rdx, rsi                        ; Copy the size of the array to rdx

    xor rax, rax                         ; Initialize the loop index to 0

    .outer_loop:
    cmp rax, rdx                         ; Check if the outer loop index reached the end
    jge .end_outer_loop

    mov r9, qword [rdi + 8 * rax]        ; Load the current element

    xor rbx, rbx                         ; Initialize the inner loop index to 0
    mov rcx, rax                         ; Copy the outer loop index to rcx

    .inner_loop:
    cmp rbx, rax                         ; Check if the inner loop index reached the end
    jle .end_inner_loop

    cmp qword [rdi + 8 * rbx], r9        ; Compare the current element with the elements before it

    jle .end_inner_loop

    mov r10, qword [rdi + 8 * rbx]       ; Load the element to be shifted

    mov qword [rdi + 8 * (rbx + 1)], r10 ; Shift the element to the right

    dec rbx                             ; Decrement the inner loop index
    jmp .inner_loop

    .end_inner_loop:
    mov qword [rdi + 8 * (rbx + 1)], r9  ; Place the current element in the correct position

    inc rax                             ; Increment the outer loop index
    jmp .outer_loop

    .end_outer_loop:
    leave
    ret

; Exit the program
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
read_integer_msg db "Enter an integer: ", 0
sorted_array_msg db "Sorted Array: ", 0
array_delimiter_msg db ", ", 0

section .bss
read_buffer resb 20
read_buffer_size equ 20

section .text
global _start
