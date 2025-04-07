# RISC-V RV32I Load/Store Instruction Test
#
# Tests: sb, sh, sw, lb, lbu, lh, lhu, lw
#
# Strategy:
# 1. Store known values using sb, sh, sw into a test memory region.
# 2. Load values back using lb, lbu, lh, lhu, lw.
# 3. Compare loaded values with expected results.
# 4. Loop indefinitely on pass or fail.

.text
.globl _start

_start:
    # Load the base address of our test memory area into t1
    li t1, 0x00009000

    # --- Test SW and LW ---
    # Test 1: Store a word (positive) and load it back
    li t0, 0x12345678          # Value to store
    sw t0, 0(t1)               # Store word at address t1 + 0
    lw t2, 0(t1)               # Load word from address t1 + 0
    bne t0, t2, fail           # Branch to fail if loaded value != stored value

    # Test 2: Store a word (negative) and load it back
    li t0, 0xABCDEF01          # Value to store (negative)
    sw t0, 4(t1)               # Store word at address t1 + 4
    lw t2, 4(t1)               # Load word from address t1 + 4
    bne t0, t2, fail           # Branch to fail if loaded value != stored value

    # --- Test SH, LH, LHU ---
    # Prepare memory with known halfwords within a word using SW
    # Store 0x1122EEFF at t1 + 8
    li t0, 0x1122EEFF          # Value with distinct halfwords
    sw t0, 8(t1)               # Store word at t1 + 8

    # Test 3: Store halfword (positive) using SH and load back with LH/LHU
    li t0, 0x5A5A              # Positive halfword value
    sh t0, 8(t1)               # Store halfword at t1 + 8 (overwrites 0xEEFF)
    # Expected memory at t1+8: 0x11225A5A

    # Test 3a: Load back with LH (sign-extended)
    lh t2, 8(t1)               # Load halfword from t1 + 8 (sign-extended)
    li t3, 0x00005A5A          # Expected value (positive, so sign extension is zero)
    bne t2, t3, fail           # Compare

    # Test 3b: Load back with LHU (zero-extended)
    lhu t2, 8(t1)              # Load halfword from t1 + 8 (zero-extended)
    li t3, 0x00005A5A          # Expected value
    bne t2, t3, fail           # Compare

    # Test 4: Store halfword (negative) using SH and load back with LH/LHU
    li t0, 0xA5A5              # Negative halfword value (MSB is 1)
    sh t0, 10(t1)              # Store halfword at t1 + 10 (overwrites 0x1122)
    # Expected memory at t1+8: 0xA5A55A5A

    # Test 4a: Load back with LH (sign-extended)
    lh t2, 10(t1)              # Load halfword from t1 + 10 (sign-extended)
    li t3, 0xFFFFA5A5          # Expected sign-extended value
    bne t2, t3, fail           # Compare

    # Test 4b: Load back with LHU (zero-extended)
    lhu t2, 10(t1)             # Load halfword from t1 + 10 (zero-extended)
    li t3, 0x0000A5A5          # Expected zero-extended value
    bne t2, t3, fail           # Compare


    # --- Test SB, LB, LBU ---
    # Prepare memory with known bytes within a word using SW
    # Store 0x11223344 at t1 + 12
    li t0, 0x11223344          # Value with distinct bytes
    sw t0, 12(t1)              # Store word at t1 + 12

    # Test 5: Store byte (positive) using SB and load back with LB/LBU
    li t0, 0x7F                # Positive byte value (max positive for signed byte)
    sb t0, 12(t1)              # Store byte at t1 + 12 (overwrites 0x44)
    # Expected memory at t1+12: 0x1122337F

    # Test 5a: Load back with LB (sign-extended)
    lb t2, 12(t1)              # Load byte from t1 + 12 (sign-extended)
    li t3, 0x0000007F          # Expected value (positive, sign extension is zero)
    bne t2, t3, fail           # Compare

    # Test 5b: Load back with LBU (zero-extended)
    lbu t2, 12(t1)             # Load byte from t1 + 12 (zero-extended)
    li t3, 0x0000007F          # Expected value
    bne t2, t3, fail           # Compare

    # Test 6: Store byte (negative) using SB and load back with LB/LBU
    li t0, 0x80                # Negative byte value (min negative for signed byte)
    sb t0, 13(t1)              # Store byte at t1 + 13 (overwrites 0x33)
    # Expected memory at t1+12: 0x1122807F

    # Test 6a: Load back with LB (sign-extended)
    lb t2, 13(t1)              # Load byte from t1 + 13 (sign-extended)
    li t3, 0xFFFFFF80          # Expected sign-extended value
    bne t2, t3, fail           # Compare

    # Test 6b: Load back with LBU (zero-extended)
    lbu t2, 13(t1)             # Load byte from t1 + 13 (zero-extended)
    li t3, 0x00000080          # Expected zero-extended value
    bne t2, t3, fail           # Compare

    # Test 7: Store another negative byte (0xFF)
    li t0, 0xFF                # Negative byte value (-1)
    sb t0, 14(t1)              # Store byte at t1 + 14 (overwrites 0x22)
    # Expected memory at t1+12: 0x11FF807F

    # Test 7a: Load back with LB (sign-extended)
    lb t2, 14(t1)              # Load byte from t1 + 14 (sign-extended)
    li t3, 0xFFFFFFFF          # Expected sign-extended value (-1)
    bne t2, t3, fail           # Compare

    # Test 7b: Load back with LBU (zero-extended)
    lbu t2, 14(t1)             # Load byte from t1 + 14 (zero-extended)
    li t3, 0x000000FF          # Expected zero-extended value (255)
    bne t2, t3, fail           # Compare

    # If we reach here, all tests passed
pass:
    # Indicate success (e.g., infinite loop)
    # In a real system or simulator, you might write to a specific
    # memory-mapped register or use an environment call to exit.
    j pass                     # Loop forever on success

fail:
    # Indicate failure (e.g., infinite loop)
    # Store a non-zero value in a register (e.g., a0) for debugging
    li a0, 1                   # Indicate failure code 1
    j fail                     # Loop forever on failure

# End of program