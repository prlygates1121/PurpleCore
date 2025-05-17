.text

main:
    li a0, 12
    call fib
exit:
    j exit
    
fib:
    # --- Function Prologue ---
    # Allocate stack frame: 3 words (12 bytes)
    # Stack grows downwards (from high addresses to low addresses)
    addi sp, sp, -12      # Decrement stack pointer to make space
    sw ra, 8(sp)          # Save return address (ra) on the stack
    sw s0, 4(sp)          # Save s0 (callee-saved register) on the stack
    sw s1, 0(sp)          # Save s1 (callee-saved register) on the stack

    mv s0, a0             # Move argument n (from a0) into s0 to preserve it.
                          # s0 = n

    # --- Base Cases ---
    # Case 1: fib(0) = 0
    # If n == 0, return 0.
    beq s0, zero, fib_n_is_0  # Branch to fib_n_is_0 if n (s0) is zero

    # Case 2: fib(1) = 1
    # If n == 1, return 1.
    li t0, 1              # Load immediate 1 into temporary register t0
    beq s0, t0, fib_n_is_1  # Branch to fib_n_is_1 if n (s0) is 1

    # --- Recursive Step (n > 1) ---
    # Calculate fib(n-1)
    addi a0, s0, -1       # Set argument for recursive call: a0 = n - 1
    call fib              # Recursive call: fib(n-1). Result is returned in a0.
    mv s1, a0             # Save the result of fib(n-1) into s1.
                          # s1 = fib(n-1)

    # Calculate fib(n-2)
    addi a0, s0, -2       # Set argument for recursive call: a0 = n - 2
    call fib              # Recursive call: fib(n-2). Result is returned in a0.
                          # Now, a0 = fib(n-2) and s1 = fib(n-1)

    # Result = fib(n-1) + fib(n-2)
    add a0, s1, a0        # a0 = s1 (fib(n-1)) + a0 (fib(n-2))
    j fib_return          # Jump to function return sequence

fib_n_is_0:
    li a0, 0              # Set return value to 0 for fib(0)
    j fib_return          # Jump to function return sequence

fib_n_is_1:
    li a0, 1              # Set return value to 1 for fib(1)
    # No jump needed, will fall through to fib_return

fib_return:
    # --- Function Epilogue ---
    # Restore saved registers from the stack
    lw s1, 0(sp)          # Restore s1
    lw s0, 4(sp)          # Restore s0
    lw ra, 8(sp)          # Restore return address (ra)
    addi sp, sp, 12       # Deallocate stack frame (increment stack pointer)

    ret                   # Return to the caller (jr ra)