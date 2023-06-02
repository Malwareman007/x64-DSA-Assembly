section .data
    nums dq 4, 2, 1, 7, 8, 1, 2, 8, 1, 0    ; Array of numbers
    nums_size equ $ - nums
    k equ 3                                 ; Size of the sliding window

section .text
    global _start

_start:
    ; Calculate the maximum sum of a subarray using the sliding window technique
    mov rdi, nums
    mov rcx, nums_size
    mov rsi, k
    call calculate_max_subarray_sum

    ; Display the maximum sum of the subarray
    mov rdi, max_subarray_sum_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the maximum sum of a subarray using the sliding window technique
calculate_max_subarray_sum:
    xor rax, rax                         ; Initialize the maximum sum to 0
    xor rbx, rbx                         ; Initialize the current sum to 0

    ; Calculate the initial sum of the first window
    mov rdx, rsi                         ; Initialize the window size
    .loop:
    cmp rdx, 0
    je .set_initial_sum

    dec rdx
    mov rcx, qword [rdi + 8 * rdx]       ; Load the current number

    add rbx, rcx                         ; Add the current number to the current sum

    jmp .loop

    .set_initial_sum:
    mov rax, rbx                         ; Set the initial sum as the maximum sum

    ; Slide the window across the array and calculate the maximum sum
    mov rdx, nums_size - rsi             ; Calculate the number of iterations
    mov rcx, 0                           ; Initialize the start index of the window

    .slide_window:
    mov rbx, qword [rdi + 8 * rcx]       ; Load the current number
    add rbx, rax                         ; Add the current number to the previous sum

    cmp rbx, rax                         ; Compare with the maximum sum
    jg .update_max_sum

    ; Remove the element that goes out of the window from the current sum
    sub rax, qword [rdi + 8 * rcx]

    inc rcx                              ; Slide the window to the right
    dec rdx                              ; Decrement the number of iterations

    jmp .slide_window

    .update_max_sum:
    mov rax, rbx                         ; Update the maximum sum

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
max_subarray_sum_msg db "Maximum Subarray Sum: ", 0

section .text
global _start
