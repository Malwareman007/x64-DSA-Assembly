section .data
    nums dq 2, 4, -1, 7, 5, -3, 2, 1    ; Array of numbers
    nums_size equ $ - nums

section .text
    global _start

_start:
    ; Calculate the prefix sums of the array
    mov rdi, nums
    mov rcx, nums_size
    call calculate_prefix_sums

    ; Display the prefix sums
    mov rdi, prefix_sums_msg
    call print_string
    mov rdi, nums
    mov rsi, rcx
    call print_array

    ; Calculate the sum of a subarray using the prefix sums
    mov rdi, prefix_sums
    mov rsi, 2                           ; Starting index of the subarray
    mov rdx, 5                           ; Ending index of the subarray
    call calculate_subarray_sum

    ; Display the sum of the subarray
    mov rdi, subarray_sum_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the prefix sums of an array
calculate_prefix_sums:
    xor rax, rax                         ; Initialize the current sum to 0

    .loop:
    cmp rcx, 0
    je .set_prefix_sum

    dec rcx
    add rax, qword [rdi + 8 * rcx]       ; Add the current number to the current sum

    mov qword [rdi + 8 * rcx], rax       ; Store the prefix sum

    jmp .loop

    .set_prefix_sum:
    mov rcx, nums_size

    ret

; Function to calculate the sum of a subarray using the prefix sums
calculate_subarray_sum:
    mov rax, qword [rdi + 8 * rdx]       ; Load the prefix sum of the ending index
    mov rbx, qword [rdi + 8 * rsi]       ; Load the prefix sum of the starting index

    sub rax, rbx                         ; Calculate the sum of the subarray

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

; Function to print an array
print_array:
    xor rax, rax                         ; Initialize the loop index to 0

    .loop:
    cmp rcx, 0
    je .print_end

    dec rcx
    mov rdx, qword [rdi + 8 * rcx]       ; Load the current element

    mov rdi, rdx
    call print_integer

    mov rdi, array_delimiter
    call print_string

    jmp .loop

    .print_end:
    ret

; Exit the program
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
prefix_sums_msg db "Prefix Sums: ", 0
subarray_sum_msg db "Sum of Subarray: ", 0
array_delimiter db ", ", 0

section .bss
prefix_sums resq nums_size

section .text
global _start
