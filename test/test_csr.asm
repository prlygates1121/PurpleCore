#
# RISC-V CSR Instruction Verification Test with Check Bits
#
# This test verifies the functionality of the CSR (Control and Status Register)
# read/write, read/set, and read/clear instructions, including their immediate variants.
#
# --- Check Bit Logic ---
# A single register, t5, is used as a failure accumulator.
# - It is initialized to 0 at the start.
# - If a test fails, a unique bit is set in t5.
# - If t5 is 0 at the end of the test, all checks have passed.
# - If t5 is non-zero, the set bits indicate which test(s) failed.
#   A map of bits to tests is provided at the 'end_tests' label.
#
_start:
    # Test registers:
    # t1: value to write/set/clear bits with
    # t2: to store original CSR value
    # t3: to store value read by CSR instruction (old value)
    # t4: to store current CSR value after an operation for verification
    # t5: check bit register. Accumulates failure flags. 0 means PASS, non-zero means FAIL.
    # t6: temporary register for verification logic

    li t5, 0  # Initialize check bit register to 0 (PASS)

    # --- Test mstatus (0x300) ---
test_mstatus:
    csrr t2, mstatus              # Save original mstatus

    # CSRRW: rd = csr; csr = rs1
    li t1, 0x00000008             # Test value (MIE = 1)
    csrrw t3, mstatus, t1         # t3 = original mstatus, mstatus = 0x8
    csrr t4, mstatus              # Read back the value
    # VERIFY: t4 should be 0x8
    li t1, 0x00000008
    sub t6, t4, t1
    snez t6, t6                   # t6 = 1 if fail, 0 if pass
    slli t6, t6, 0                # Failure bit 0 for mstatus_csrrw
    or t5, t5, t6                 # Accumulate failure flag

    # CSRRS: rd = csr; csr = csr | rs1
    li t1, 0x00000080             # Value to set (MPIE bit)
    csrrs t3, mstatus, t1         # t3 = 0x8, mstatus = 0x8 | 0x80 = 0x88
    csrr t4, mstatus              # Read back the value
    # VERIFY: t4 should be 0x88
    li t1, 0x00000088
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 1                # Failure bit 1 for mstatus_csrrs
    or t5, t5, t6

    # CSRRC: rd = csr; csr = csr & ~rs1
    li t1, 0x00000008             # Value to clear (MIE bit)
    csrrc t3, mstatus, t1         # t3 = 0x88, mstatus = 0x88 & ~0x8 = 0x80
    csrr t4, mstatus              # Read back the value
    # VERIFY: t4 should be 0x80
    li t1, 0x00000080
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 2                # Failure bit 2 for mstatus_csrrc
    or t5, t5, t6

    # CSRRWI: rd = csr; csr = uimm
    csrrwi t3, mstatus, 5         # t3 = 0x80, mstatus = 5
    csrr t4, mstatus              # Read back the value
    # VERIFY: t4 should be 5
    li t1, 5
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 3                # Failure bit 3 for mstatus_csrrwi
    or t5, t5, t6

    # CSRRSI: rd = csr; csr = csr | uimm
    csrrsi t3, mstatus, 16        # t3 = 5, mstatus = 5 | 16 = 21
    csrr t4, mstatus              # Read back the value
    # VERIFY: t4 should be 21
    li t1, 21
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 4                # Failure bit 4 for mstatus_csrrsi
    or t5, t5, t6

    # CSRRCI: rd = csr; csr = csr & ~uimm
    csrrci t3, mstatus, 1         # t3 = 21, mstatus = 21 & ~1 = 20
    csrr t4, mstatus              # Read back the value
    # VERIFY: t4 should be 20
    li t1, 20
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 5                # Failure bit 5 for mstatus_csrrci
    or t5, t5, t6

    csrw mstatus, t2              # Restore original mstatus

    # --- Test mie (0x304) ---
test_mie:
    csrr t2, mie                  # Save original mie

    # CSRRW
    li t1, 0x00000888             # Test value (MSIE, MTIE, MEIE)
    csrrw t3, mie, t1             # mie = 0x888
    csrr t4, mie                  # Read back
    # VERIFY: t4 should be 0x888
    li t1, 0x00000888
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 6                # Failure bit 6 for mie_csrrw
    or t5, t5, t6

    # CSRRS
    li t1, 0x00000100             # Set bit 8
    csrrs t3, mie, t1             # mie = 0x888 | 0x100 = 0x988
    csrr t4, mie                  # Read back
    # VERIFY: t4 should be 0x988
    li t1, 0x00000988
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 7                # Failure bit 7 for mie_csrrs
    or t5, t5, t6

    # CSRRC
    li t1, 0x00000800             # Clear MEIE (bit 11)
    csrrc t3, mie, t1             # mie = 0x988 & ~0x800 = 0x188
    csrr t4, mie                  # Read back
    # VERIFY: t4 should be 0x188
    li t1, 0x00000188
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 8                # Failure bit 8 for mie_csrrc
    or t5, t5, t6

    # CSRRWI
    csrrwi t3, mie, 7             # mie = 7
    csrr t4, mie                  # Read back
    # VERIFY: t4 should be 7
    li t1, 7
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 9                # Failure bit 9 for mie_csrrwi
    or t5, t5, t6

    # CSRRSI
    csrrsi t3, mie, 8             # mie = 7 | 8 = 15
    csrr t4, mie                  # Read back
    # VERIFY: t4 should be 15
    li t1, 15
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 10               # Failure bit 10 for mie_csrrsi
    or t5, t5, t6

    # CSRRCI
    csrrci t3, mie, 2             # mie = 15 & ~2 = 13
    csrr t4, mie                  # Read back
    # VERIFY: t4 should be 13
    li t1, 13
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 11               # Failure bit 11 for mie_csrrci
    or t5, t5, t6

    csrw mie, t2                  # Restore original mie

    # --- Test mtval (0x343) ---
test_mtval:
    csrr t2, mtval                # Save original mtval

    # CSRRW
    li t1, 0xCAFEBABE
    csrrw t3, mtval, t1           # mtval = 0xCAFEBABE
    csrr t4, mtval                # Read back
    # VERIFY: t4 should be 0xCAFEBABE
    li t1, 0xCAFEBABE
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 12               # Failure bit 12 for mtval_csrrw
    or t5, t5, t6

    # CSRRS
    li t1, 0x00000001
    csrrs t3, mtval, t1           # mtval = 0xCAFEBABE | 1 = 0xCAFEBABF
    csrr t4, mtval                # Read back
    # VERIFY: t4 should be 0xCAFEBABF
    li t1, 0xCAFEBABF
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 13               # Failure bit 13 for mtval_csrrs
    or t5, t5, t6

    # CSRRC
    li t1, 0x0000000F
    csrrc t3, mtval, t1           # mtval = 0xCAFEBABF & ~0xF = 0xCAFEBAB0
    csrr t4, mtval                # Read back
    # VERIFY: t4 should be 0xCAFEBAB0
    li t1, 0xCAFEBAB0
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 14               # Failure bit 14 for mtval_csrrc
    or t5, t5, t6

    # CSRRWI
    csrrwi t3, mtval, 17          # mtval = 17
    csrr t4, mtval                # Read back
    # VERIFY: t4 should be 17
    li t1, 17
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 15               # Failure bit 15 for mtval_csrrwi
    or t5, t5, t6

    # CSRRSI
    csrrsi t3, mtval, 4           # mtval = 17 | 4 = 21
    csrr t4, mtval                # Read back
    # VERIFY: t4 should be 21
    li t1, 21
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 16               # Failure bit 16 for mtval_csrrsi
    or t5, t5, t6

    # CSRRCI
    csrrci t3, mtval, 1           # mtval = 21 & ~1 = 20
    csrr t4, mtval                # Read back
    # VERIFY: t4 should be 20
    li t1, 20
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 17               # Failure bit 17 for mtval_csrrci
    or t5, t5, t6

    csrw mtval, t2                # Restore original mtval

    # --- Test mcause (0x342) ---
test_mcause:
    csrr t2, mcause               # Save original mcause

    # CSRRW
    li t1, 0x0000000B             # Environment call from M-mode
    csrrw t3, mcause, t1          # mcause = 0xB
    csrr t4, mcause               # Read back
    # VERIFY: t4 should be 0xB
    li t1, 0x0000000B
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 18               # Failure bit 18 for mcause_csrrw
    or t5, t5, t6

    # CSRRS
    li t1, 0x80000000             # Set MSB (Interrupt bit)
    csrrs t3, mcause, t1          # mcause = 0xB | 0x80000000 = 0x8000000B
    csrr t4, mcause               # Read back
    # VERIFY: t4 should be 0x8000000B
    li t1, 0x8000000B
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 19               # Failure bit 19 for mcause_csrrs
    or t5, t5, t6

    # CSRRC
    li t1, 0x0000000B             # Clear lower 4 bits
    csrrc t3, mcause, t1          # mcause = 0x8000000B & ~0xB = 0x80000000
    csrr t4, mcause               # Read back
    # VERIFY: t4 should be 0x80000000
    li t1, 0x80000000
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 20               # Failure bit 20 for mcause_csrrc
    or t5, t5, t6

    # CSRRWI
    csrrwi t3, mcause, 3          # mcause = 3
    csrr t4, mcause               # Read back
    # VERIFY: t4 should be 3
    li t1, 3
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 21               # Failure bit 21 for mcause_csrrwi
    or t5, t5, t6

    # CSRRSI
    csrrsi t3, mcause, 8          # mcause = 3 | 8 = 11
    csrr t4, mcause               # Read back
    # VERIFY: t4 should be 11
    li t1, 11
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 22               # Failure bit 22 for mcause_csrrsi
    or t5, t5, t6

    # CSRRCI
    csrrci t3, mcause, 1          # mcause = 11 & ~1 = 10
    csrr t4, mcause               # Read back
    # VERIFY: t4 should be 10
    li t1, 10
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 23               # Failure bit 23 for mcause_csrrci
    or t5, t5, t6

    csrw mcause, t2               # Restore original mcause

    # --- Test mepc (0x341) ---
test_mepc:
    csrr t2, mepc                 # Save original mepc

    # CSRRW
    li t1, 0x80001000             # An arbitrary PC value
    csrrw t3, mepc, t1            # mepc = 0x80001000
    csrr t4, mepc                 # Read back
    # VERIFY: t4 should be 0x80001000
    li t1, 0x80001000
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 24               # Failure bit 24 for mepc_csrrw
    or t5, t5, t6

    # CSRRS
    li t1, 0x00000004
    csrrs t3, mepc, t1            # mepc = 0x80001000 | 4 = 0x80001004
    csrr t4, mepc                 # Read back
    # VERIFY: t4 should be 0x80001004
    li t1, 0x80001004
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 25               # Failure bit 25 for mepc_csrrs
    or t5, t5, t6

    # CSRRC
    li t1, 0x0000000C
    csrrc t3, mepc, t1            # mepc = 0x80001004 & ~0xC = 0x80001000
    csrr t4, mepc                 # Read back
    # VERIFY: t4 should be 0x80001000
    li t1, 0x80001000
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 26               # Failure bit 26 for mepc_csrrc
    or t5, t5, t6

    # CSRRWI
    csrrwi t3, mepc, 30           # mepc = 30 (0x1E)
    csrr t4, mepc                 # Read back
    # VERIFY: t4 should be 30
    li t1, 30
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 27               # Failure bit 27 for mepc_csrrwi
    or t5, t5, t6

    # CSRRSI
    csrrsi t3, mepc, 1            # mepc = 30 | 1 = 31
    csrr t4, mepc                 # Read back
    # VERIFY: t4 should be 31
    li t1, 31
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 28               # Failure bit 28 for mepc_csrrsi
    or t5, t5, t6

    # CSRRCI
    csrrci t3, mepc, 2            # mepc = 31 & ~2 = 29
    csrr t4, mepc                 # Read back
    # VERIFY: t4 should be 29
    li t1, 29
    sub t6, t4, t1
    snez t6, t6
    slli t6, t6, 29               # Failure bit 29 for mepc_csrrci
    or t5, t5, t6

    csrw mepc, t2                 # Restore original mepc

    # --- Test mip (0x344) ---
    # mip bits are often Read-Only or Write-1-to-Clear (W1C).
    # This means writing a value and reading it back may not yield the written value.
    # For example, writing a 1 to a W1C bit that is currently 1 will clear it to 0.
    # Writing a 0 to a W1C bit has no effect.
    # Therefore, a simple read-after-write check will likely fail and is not included here.
    # The following code demonstrates the operations, but does not verify the outcome
    # against a fixed value, as the result is implementation-dependent.
test_mip:
    csrr t2, mip                  # Save original mip

    # CSRRW: Attempt to write a pattern.
    li t1, 0x00000AAA
    csrrw t3, mip, t1
    csrr t4, mip                  # Observe result in t4

    # CSRRS: Attempt to set bits.
    li t1, 0x00000888
    csrrs t3, mip, t1
    csrr t4, mip                  # Observe result in t4

    # CSRRC: Attempt to clear bits.
    li t1, 0x00000888
    csrrc t3, mip, t1
    csrr t4, mip                  # Observe result in t4

    # CSRRWI
    csrrwi t3, mip, 5
    csrr t4, mip                  # Observe result in t4

    # CSRRSI
    csrrsi t3, mip, 8
    csrr t4, mip                  # Observe result in t4

    # CSRRCI
    csrrci t3, mip, 2
    csrr t4, mip                  # Observe result in t4

    csrw mip, t2                  # Restore original mip state (as best as possible)

    # --- End of tests ---
    # The final result is in register t5.
    # If t5 is 0, all verifiable tests passed.
    # If t5 is non-zero, one or more tests failed. Each bit corresponds to a specific test:
    # Bit 0: mstatus_csrrw   Bit 1: mstatus_csrrs   Bit 2: mstatus_csrrc
    # Bit 3: mstatus_csrrwi  Bit 4: mstatus_csrrsi  Bit 5: mstatus_csrrci
    # Bit 6: mie_csrrw       Bit 7: mie_csrrs       Bit 8: mie_csrrc
    # Bit 9: mie_csrrwi      Bit 10: mie_csrrsi     Bit 11: mie_csrrci
    # Bit 12: mtval_csrrw    Bit 13: mtval_csrrs    Bit 14: mtval_csrrc
    # Bit 15: mtval_csrrwi   Bit 16: mtval_csrrsi   Bit 17: mtval_csrrci
    # Bit 18: mcause_csrrw   Bit 19: mcause_csrrs   Bit 20: mcause_csrrc
    # Bit 21: mcause_csrrwi  Bit 22: mcause_csrrsi  Bit 23: mcause_csrrci
    # Bit 24: mepc_csrrw     Bit 25: mepc_csrrs     Bit 26: mepc_csrrc
    # Bit 27: mepc_csrrwi    Bit 28: mepc_csrrsi    Bit 29: mepc_csrrci
end_tests:
    nop

halt:
    j halt                        # Infinite loop for debugger
