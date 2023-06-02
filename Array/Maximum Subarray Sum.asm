section .data
    nums dq -2, 1, -3, 4, -1, 2, 1, -5, 4   ; Array of numbers
    nums_size equ $ - nums

section .text
    global _start

_start:
    ; Calculate the maximum subarray sum
    mov rdi, nums
    mov rcx, nums_size
    call calculate_max_subarray_sum

    ; Display the maximum subarray sum
    mov rdi, max_subarray_sum_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the maximum subarray sum
calculate_max_subarray_sum:
    xor rax, rax                     ; Initialize the maximum subarray sum to 0
    xor rcx, rcx                     ; Initialize the current subarray sum to 0

    .loop:
    cmp rcx, 0
    je .set_subarray_sum

    dec rcx
    mov rdx, qword [rdi + 8 * rcx]   ; Load the current number

    add rax, rdx                     ; Add the current number to the current subarray sum
    cmp rax, rdx                     ; Compare with the current number
    jge .set_subarray_sum

    mov rax, rdx                     ; Update the current subarray sum

    .set_subarray_sum:
    mov rdx, qword [rdi + rcx]       ; Load the current number

    cmp rax, rdx                     ; Compare with the current number
    jge .loop                        ; If greater than or equal, continue to the next number

    cmp rax, rcx                     ; Compare with the maximum subarray sum
    jle .loop                        ; If less than or equal, continue to the next number

    mov rcx, rax                     ; Update the maximum subarray sum
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
max_subarray_sum_msg db "Maximum Subarray Sum: ", 0

section .text
global _start
