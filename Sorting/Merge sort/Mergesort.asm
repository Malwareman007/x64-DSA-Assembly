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

    ; Sort the array using merge sort
    mov rdi, array
    mov rsi, array_size
    call merge_sort

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

; Function to perform the merge sort algorithm
merge_sort:
    push rbp
    mov rbp, rsp

    sub rsp, 8                          ; Allocate space for the temporary array
    mov rdi, rsp                        ; Set the temporary array pointer

    mov r8, rdi                         ; Set the pointer to the temporary array in r8

    mov rdx, rsi                        ; Copy the size of the array to rdx
    shr rdx, 1                          ; Divide the size by 2 to get the midpoint

    mov rsi, rdi                        ; Set the destination array pointer in rsi

    add rsi, 8                          ; Move the destination pointer to the second half of the temporary array

    mov rcx, rdx                        ; Copy the midpoint to rcx

    mov rdi, rsi                        ; Set the source array pointer in rdi

    mov rax, rsi                        ; Set the source pointer for the second half of the temporary array

    .copy_first_half:
    cmp rcx, 0                          ; Check if the first half is copied completely
    je .copy_second_half

    dec rcx
    mov rdx, qword [rdi + 8 * rcx]       ; Load the current element

    mov qword [r8 + 8 * rcx], rdx       ; Copy the element to the temporary array

    jmp .copy_first_half

    .copy_second_half:
    mov rcx, rdx                        ; Copy the midpoint to rcx

    .copy_array:
    cmp rdx, 0                          ; Check if the array is copied completely
    je .merge

    dec rdx
    mov rax, qword [rdi + 8 * rdx]       ; Load the current element

    mov qword [rsi + 8 * rdx], rax       ; Copy the element to the destination array

    jmp .copy_array

    .merge:
    xor rdx, rdx                         ; Initialize the loop index to 0
    xor rcx, rcx                         ; Initialize the left array index to 0
    mov r8, rsp                         ; Set the pointer to the temporary array
    mov rdi, rsi                        ; Set the destination array pointer in rdi

    .compare:
    cmp rdx, rsi                         ; Check if the right array index reached the end
    je .copy_left

    cmp rcx, rdx                         ; Check if the left array index reached the midpoint
    je .copy_right

    mov r9, qword [rsp + 8 * rcx]         ; Load the current element from the left array
    mov r10, qword [rsi + 8 * rdx]        ; Load the current element from the right array

    cmp r9, r10                          ; Compare the elements

    jle .copy_left_element

    .copy_right_element:
    mov qword [rdi + 8 * rcx], r10       ; Copy the element from the right array to the destination array
    inc rdx                             ; Increment the right array index
    jmp .increment_rcx

    .copy_left_element:
    mov qword [rdi + 8 * rcx], r9        ; Copy the element from the left array to the destination array

    .increment_rcx:
    inc rcx                             ; Increment the left array index
    jmp .compare

    .copy_left:
    mov rax, rdx                         ; Copy the right array index to rax

    .copy_remaining_elements:
    cmp rax, rsi                         ; Check if the right array index reached the end
    je .end_merge

    mov r9, qword [rsi + 8 * rax]         ; Load the current element from the right array

    mov qword [rdi + 8 * rax], r9        ; Copy the remaining elements from the right array to the destination array

    inc rax                             ; Increment the right array index
    jmp .copy_remaining_elements

    .end_merge:
    add rsp, 8                          ; Deallocate the space for the temporary array

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
