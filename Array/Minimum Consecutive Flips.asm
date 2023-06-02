section .data
    nums db 1, 1, 0, 0, 1, 1, 1, 0, 1   ; Array of numbers (0 and 1)
    nums_size equ $ - nums

section .text
    global _start

_start:
    ; Find the minimum consecutive flips
    mov rdi, nums
    mov rcx, nums_size
    call find_min_consecutive_flips

    ; Display the minimum consecutive flips
    mov rdi, min_consecutive_flips_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to find the minimum consecutive flips
find_min_consecutive_flips:
    xor rax, rax                 ; Initialize the current element to 0
    xor rcx, rcx                 ; Initialize the count of flips to 0

    .loop:
    cmp rcx, 0
    je .set_current_element

    dec rcx
    mov dl, byte [rdi + rcx]     ; Load the current number

    cmp al, dl                   ; Compare with the current element
    je .continue_sequence

    inc rax                      ; Increment the count of flips

    .continue_sequence:
    mov al, dl                   ; Update the current element

    jmp .loop

    .set_current_element:
    mov al, byte [rdi + rcx]     ; Set the current element as the current number

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

; Exit the program
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
min_consecutive_flips_msg db "Minimum Consecutive Flips: ", 0

section .text
global _start
