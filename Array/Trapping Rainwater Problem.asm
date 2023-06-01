section .data
    heights dq 0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1   ; Array of heights
    heights_size equ $ - heights

section .text
    global _start

_start:
    ; Calculate the trapped rainwater
    mov rdi, heights
    mov rcx, heights_size
    call calculate_trapped_rainwater

    ; Display the trapped rainwater
    mov rdi, trapped_rainwater_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the trapped rainwater
calculate_trapped_rainwater:
    mov rbp, rsp                      ; Save the base pointer
    mov rax, 0                        ; Initialize the trapped rainwater to 0

    ; Find the left and right boundaries for each bar
    mov rsi, rdi                      ; Start with the first bar
    mov rdx, qword [rsi]              ; Current bar height
    xor r8, r8                        ; Initialize the left boundary to 0

    .find_left_boundary:
    cmp rcx, 0
    je .calculate_end

    dec rcx
    mov r9, qword [rdi + 8 * rcx]     ; Load the current bar height

    cmp r9, rdx                       ; Compare with the current bar height
    jle .set_left                     ; If less than or equal, update the left boundary

    mov rdx, r9                       ; Update the current bar height
    mov r8, rcx                       ; Update the left boundary

    jmp .find_left_boundary

    .set_left:
    cmp r9, rdx                       ; Compare with the current bar height
    jge .find_left_boundary           ; If greater than or equal, continue to the next bar

    ; Find the right boundary for each bar
    mov rsi, rdi                      ; Start with the first bar
    mov rdx, qword [rsi]              ; Current bar height
    xor r9, r9                        ; Initialize the right boundary to 0

    .find_right_boundary:
    cmp rcx, r8                       ; Check if the current bar is within the left boundary
    je .calculate_end

    dec rcx
    mov r10, qword [rdi + 8 * rcx]    ; Load the current bar height

    cmp r10, rdx                      ; Compare with the current bar height
    jle .set_right                    ; If less than or equal, update the right boundary

    mov rdx, r10                      ; Update the current bar height
    mov r9, rcx                       ; Update the right boundary

    jmp .find_right_boundary

    .set_right:
    cmp r10, rdx                      ; Compare with the current bar height
    jge .find_right_boundary          ; If greater than or equal, continue to the next bar

    ; Calculate the trapped rainwater for the current bar
    mov rsi, rdi                      ; Start with the first bar
    mov rdx, qword [rsi + 8 * r8]     ; Left boundary bar height
    mov r9, qword [rsi + 8 * r9]       ; Right boundary bar height

    mov r10, rbp                      ; Save the base pointer
    sub rsp, 8                        ; Allocate space for the minimum height
    mov qword [rsp], rdx               ; Store the left boundary bar height
    mov rdi, rsp                      ; Pass the address of the minimum height as an argument
    mov rsi, r9                       ; Pass the right boundary bar height as an argument
    call find_minimum_height

    add rsp, 8                        ; Deallocate the space for the minimum height
    mov rdx, rax                      ; Minimum height

    mov rax, rdx                      ; Current bar height
    sub rax, rdx                      ; Calculate the trapped rainwater for the current bar
    add qword [rbp], rax              ; Accumulate the trapped rainwater

    jmp .calculate_end

    .calculate_end:
    mov rsp, rbp                      ; Restore the stack pointer
    mov rax, qword [rbp]              ; Trapped rainwater

    ret

; Function to find the minimum height between two bars
find_minimum_height:
    mov rax, qword [rdi]              ; Load the left boundary bar height
    cmp rsi, rax                      ; Compare with the right boundary bar height
    jle .minimum_end

    mov rax, rsi                      ; Update the minimum height

    .minimum_end:
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
trapped_rainwater_msg db "Trapped Rainwater: ", 0

section .text
global _start
