section .data
    nums dq 10, 12, 14, 7, 9, 11, 13, 15, 16, 18, 20   ; Array of numbers
    nums_size equ $ - nums

section .text
    global _start

_start:
    ; Calculate the length of the longest even-odd subarray
    mov rdi, nums
    mov rcx, nums_size
    call calculate_longest_even_odd_subarray

    ; Display the length of the longest even-odd subarray
    mov rdi, longest_even_odd_subarray_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the length of the longest even-odd subarray
calculate_longest_even_odd_subarray:
    xor rax, rax                     ; Initialize the length of the longest even-odd subarray to 0
    xor rcx, rcx                     ; Initialize the current subarray length to 0

    .loop:
    cmp rcx, 0
    je .set_subarray_length

    dec rcx
    mov rdx, qword [rdi + 8 * rcx]   ; Load the current number

    xor r8, r8                       ; Check if the current number is even or odd
    test rdx, 1
    jz .check_next_number

    cmp r8, 0                        ; If the current subarray is even and the current number is odd
    jz .set_subarray_length

    jmp .increment_subarray_length

    .check_next_number:
    cmp r8, 1                        ; If the current subarray is odd and the current number is even
    jz .set_subarray_length

    .increment_subarray_length:
    inc rax                          ; Increment the current subarray length

    .set_subarray_length:
    mov r8, rdx                       ; Update the parity of the current subarray

    mov rdx, qword [rdi + rcx]       ; Load the current number

    xor r8, r8                       ; Check if the current number is even or odd
    test rdx, 1
    jz .loop                         ; If equal, continue to the next number

    cmp rax, rcx                     ; Compare with the length of the longest even-odd subarray
    jle .loop                        ; If less than or equal, continue to the next number

    mov rcx, rax                     ; Update the length of the longest even-odd subarray
    jmp .loop

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

; Exit the program
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
longest_even_odd_subarray_msg db "Length of Longest Even-Odd Subarray: ", 0

section .text
global _start
