section .data
    prices dq 100, 180, 260, 310, 40, 535, 695    ; Array of stock prices
    prices_size equ $ - prices

section .text
    global _start

_start:
    ; Calculate the maximum profit
    mov rdi, prices
    mov rcx, prices_size
    call calculate_max_profit

    ; Display the maximum profit
    mov rdi, max_profit_msg
    call print_string
    mov rdi, rax
    call print_integer

    ; Exit the program
    jmp exit

; Function to calculate the maximum profit
calculate_max_profit:
    xor rax, rax                      ; Initialize the maximum profit to 0
    xor r8, r8                        ; Initialize the minimum price to 0
    mov r9, qword [rdi]               ; Initialize the maximum price to the first element

    .loop:
    cmp rcx, 0
    je .end

    dec rcx
    mov r10, qword [rdi + 8 * rcx]     ; Load the current price

    cmp r10, r9                       ; Compare with the current maximum price
    jle .set_max                      ; If less than or equal, update the maximum price

    mov r9, r10                       ; Update the maximum price

    .set_max:
    cmp r10, r8                       ; Compare with the current minimum price
    jge .set_min                      ; If greater than or equal, update the minimum price

    mov r8, r10                       ; Update the minimum price

    ; Calculate the current profit
    sub r10, r8
    cmp r10, rax                      ; Compare with the current maximum profit
    jle .loop                         ; If less than or equal, continue to the next element

    mov rax, r10                      ; Update the maximum profit

    jmp .loop

    .set_min:
    cmp r10, r9                       ; Compare with the current maximum price
    jl .loop                          ; If less than, continue to the next element

    jmp .loop

    .end:
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
max_profit_msg db "Maximum Profit: ", 0

section .text
global _start
