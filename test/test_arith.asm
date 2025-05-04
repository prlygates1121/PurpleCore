# RV32I Arithmetic Instruction Test
.text

_start:
    # Initialize some registers with test values
    li a0, 10
    li a1, 5
    li a2, -3  # Represented as 0xFFFFFFFD
    li a3, 0xFFFFFFF0 # A negative number for unsigned tests
    li a4, 0x80000000 # Minimum signed integer
    li a5, 0x7FFFFFFF # Maximum signed integer
    li a6, 0x0000000F
    li a7, 0x00000003

    # Integer Register-Register Operations

    # add: Addition
    add t0, a0, a1  # t0 = 10 + 5 = 15

    # sub: Subtraction
    sub t1, a0, a1  # t1 = 10 - 5 = 5

    # sll: Shift Left Logical
    sll t2, a0, a7  # t2 = 10 << 3 = 80

    # srl: Shift Right Logical
    srl t3, a0, a7  # t3 = 10 >> 3 = 1 (unsigned shift)
    srl t4, a3, a7  # t4 = 0xFFFFFFF0 >> 3 = 0x1FFFFFFF (unsigned shift)

    # sra: Shift Right Arithmetic
    sra t5, a2, a7  # t5 = -3 >> 3 = -1 (signed shift, preserves sign bit)
    sra t6, a4, a7  # t6 = 0x80000000 >> 3 = 0xFF000000 (signed shift)

    # xor: Bitwise XOR
#     xor t6, a0, a6  # t7 = 10 ^ 15 = 0b1010 ^ 0b1111 = 0b0101 = 5

    # or: Bitwise OR
    or s0, a0, a6   # s0 = 10 | 15 = 0b1010 | 0b1111 = 0b1111 = 15

    # and: Bitwise AND
    and s1, a0, a6  # s1 = 10 & 15 = 0b1010 & 0b1111 = 0b1010 = 10

    # slt: Set Less Than (signed)
    slt s2, a1, a0  # s2 = (5 < 10) ? 1 : 0  (s2 = 1)
    slt s3, a0, a1  # s3 = (10 < 5) ? 1 : 0  (s3 = 0)
    slt s4, a2, a1  # s4 = (-3 < 5) ? 1 : 0  (s4 = 1)
    slt s5, a1, a2  # s5 = (5 < -3) ? 1 : 0  (s5 = 0)

    # sltu: Set Less Than Unsigned
    sltu s6, a1, a0 # s6 = (5 < 10) ? 1 : 0  (s6 = 1)
    sltu s7, a0, a1 # s7 = (10 < 5) ? 1 : 0  (s7 = 0)
    sltu gp, a2, a1 # gp = (0xFFFFFFFD < 5) ? 1 : 0 (gp = 0, -3 is large unsigned)
    sltu tp, a1, a2 # tp = (5 < 0xFFFFFFFD) ? 1 : 0 (tp = 1)

# Integer Immediate Operations

    # addi: Add Immediate
    addi t0, a0, 7   # t0 = 10 + 7 = 17
    addi t1, a2, 10  # t1 = -3 + 10 = 7
    addi t2, a0, -5  # t2 = 10 + (-5) = 5

    # slli: Shift Left Logical Immediate
    slli t3, a0, 4   # t3 = 10 << 4 = 160

    # srli: Shift Right Logical Immediate
    srli t4, a0, 2   # t4 = 10 >> 2 = 2 (unsigned)
    srli t5, a3, 4   # t5 = 0xFFFFFFF0 >> 4 = 0x0FFFFFFF (unsigned)

    # srai: Shift Right Arithmetic Immediate
    srai t6, a2, 2   # t6 = -3 >> 2 = -1 (signed)
    # srai t7, a4, 4   # Incorrect register name
    srai t6, a4, 4   # Corrected: Using t6 again (can reuse if needed, or pick another)

    # xori: Bitwise XOR Immediate
    xori s0, a0, 0xF # s0 = 10 ^ 15 = 5

    # ori: Bitwise OR Immediate
    ori s1, a0, 0xF  # s1 = 10 | 15 = 15

    # andi: Bitwise AND Immediate
    andi s2, a0, 0xF # s2 = 10 & 15 = 10

    # slti: Set Less Than Immediate (signed)
    slti s3, a0, 12  # s3 = (10 < 12) ? 1 : 0  (s3 = 1)
    slti s4, a0, 8   # s4 = (10 < 8)  ? 1 : 0  (s4 = 0)
    slti s5, a2, 0   # s5 = (-3 < 0)  ? 1 : 0  (s5 = 1)
    slti s6, a0, -1  # s6 = (10 < -1) ? 1 : 0  (s6 = 0)

    # sltiu: Set Less Than Immediate Unsigned
    sltiu s7, a0, 12 # s7 = (10 < 12) ? 1 : 0  (s7 = 1)
