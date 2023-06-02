section .data
    nums db 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1   ; Array of binary numbers
    nums_size equ $ - nums

section .text
    global _start

_start:
    ; Calculate the maximum consecutive 1s
    mov rdi, nums
    mov rcx, nums_size
    call calculate_max_consecutive_1s

    ; Display the maximum consecutive 1s
    mov rdi, max_consecutive_1s_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the maximum consecutive 1s
calculate_max_consecutive_1s:
    xor rax, rax                     ; Initialize the maximum consecutive 1s to 0
    xor rcx, rcx                     ; Initialize the current consecutive 1s to 0

    .loop:
    cmp rcx, 0
    je .set_consecutive_1s

    dec rcx
    movzx rdx, byte [rdi + rcx]      ; Load the current number

    cmp rdx, 1                       ; Compare with 1
    je .increment_consecutive_1s
    jmp .set_consecutive_1s

    .increment_consecutive_1s:
    inc rax                          ; Increment the current consecutive 1s

    .set_consecutive_1s:
    movzx rdx, byte [rdi + rcx]      ; Load the current number

    cmp rdx, 1                       ; Compare with 1
    je .loop                         ; If equal, continue to the next number

    cmp rax, rcx                     ; Compare with the maximum consecutive 1s
    jle .loop                        ; If less than or equal, continue to the next number

    mov rcx, rax                     ; Update the maximum consecutive 1s
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
max_consecutive_1s_msg db "Maximum Consecutive 1s: ", 0

section .text
global _start
