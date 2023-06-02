section .data
    nums dq 2, 4, 3, 4, 4, 2, 4, 4, 5   ; Array of numbers
    nums_size equ $ - nums

section .text
    global _start

_start:
    ; Find the majority element in the array
    mov rdi, nums
    mov rcx, nums_size
    call find_majority_element

    ; Display the majority element
    mov rdi, majority_element_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to find the majority element in an array
find_majority_element:
    xor rax, rax                     ; Initialize the candidate element to 0
    xor rcx, rcx                     ; Initialize the count of the candidate element to 0

    .loop:
    cmp rcx, 0
    je .set_candidate_element

    dec rcx
    mov rdx, qword [rdi + 8 * rcx]   ; Load the current number

    cmp rax, rdx                     ; Compare with the candidate element
    je .increment_count

    cmp rcx, 0                       ; If the count of the candidate element becomes 0
    je .set_candidate_element

    jmp .decrement_count

    .increment_count:
    inc rcx                          ; Increment the count of the candidate element

    .decrement_count:
    dec rcx                          ; Decrement the count of the candidate element

    .set_candidate_element:
    mov rax, qword [rdi + rcx]       ; Set the candidate element as the current number

    mov rcx, nums_size
    mov rdi, nums
    call count_occurrences           ; Count the occurrences of the candidate element

    cmp rax, rcx                     ; Compare with the threshold for majority
    jle .loop                        ; If less than or equal, continue to the next number

    ret

; Function to count the occurrences of an element in an array
count_occurrences:
    xor rax, rax                     ; Initialize the count to 0

    .loop:
    cmp rcx, 0
    je .set_count

    dec rcx
    mov rdx, qword [rdi + 8 * rcx]   ; Load the current number

    cmp rdx, rax                     ; Compare with the element
    je .increment_count
    jmp .loop

    .increment_count:
    inc rax                          ; Increment the count

    jmp .loop

    .set_count:
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
majority_element_msg db "Majority Element: ", 0

section .text
global _start
