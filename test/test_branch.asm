
_start:
  # --- Setup ---
  li  x10, 5          # Value for comparisons
  li  x11, 5          # Value for comparisons (equal)
  li  x12, 10         # Value for comparisons (not equal)
  li  x30, 0          # Indicator register (for correctly executed paths)
  li  x31, 0          # Indicator register (for incorrectly executed paths)

  # --- Test 1: BEQ - Branch Taken ---
  # Expect pipeline to fetch addi x31 instructions if hazard not handled.
  beq x10, x11, target_beq_taken
  addi x31, x31, 1    # Should NOT execute if branch taken
  addi x31, x31, 1    # Should NOT execute if branch taken
  j after_beq_taken   # Should NOT execute if branch taken (Safety jump)

target_beq_taken:
  addi x30, x30, 2    # Indicator: BEQ taken path executed (Value: 2)
after_beq_taken:
  nop                   # Provide a buffer instruction

  # --- Test 2: BEQ - Branch Not Taken ---
  # Expect pipeline to correctly execute the instructions following beq.
  beq x10, x12, target_beq_not_taken
  addi x30, x30, 4    # Indicator: BEQ not taken fall-through (Value: 2 + 4 = 6)
  addi x30, x30, 8    # Indicator: BEQ not taken fall-through (Value: 6 + 8 = 14)
  j after_beq_not_taken # Continue sequence

target_beq_not_taken:
  addi x31, x31, 2    # Should NOT execute if branch not taken
after_beq_not_taken:
  nop

  # --- Test 3: BNE - Branch Taken ---
  # Expect pipeline to fetch addi x31 instructions if hazard not handled.
  bne x10, x12, target_bne_taken
  addi x31, x31, 4    # Should NOT execute if branch taken
  addi x31, x31, 4    # Should NOT execute if branch taken
  j after_bne_taken   # Should NOT execute if branch taken (Safety jump)

target_bne_taken:
  addi x30, x30, 16   # Indicator: BNE taken path executed (Value: 14 + 16 = 30)
after_bne_taken:
  nop

  # --- Test 4: BNE - Branch Not Taken ---
  # Expect pipeline to correctly execute the instructions following bne.
  bne x10, x11, target_bne_not_taken
  addi x30, x30, 32   # Indicator: BNE not taken fall-through (Value: 30 + 32 = 62)
  addi x30, x30, 64   # Indicator: BNE not taken fall-through (Value: 62 + 64 = 126)
  j after_bne_not_taken # Continue sequence

target_bne_not_taken:
  addi x31, x31, 8    # Should NOT execute if branch not taken
after_bne_not_taken:
  nop

  # --- Test 5: JAL (Jump And Link) ---
  # Expect pipeline to fetch addi x31 instructions if hazard not handled.
  # x1 (ra) will be updated with the address of the instruction following jal.
  jal x1, target_jal
  addi x31, x31, 16   # Should NOT execute
  addi x31, x31, 16   # Should NOT execute

target_jal:
  addi x30, x30, 128  # Indicator: JAL target reached (Value: 126 + 128 = 254)
  nop

  # --- Test 6: JALR (Jump And Link Register) ---
  # Jump to the address stored in x1 (which should be address after JAL).
  # Effectively, this is a "return" from the JAL above.
  # x5 will be updated with the address of the instruction following jalr.
  # Expect pipeline to fetch addi x31 if hazard not handled.
  # Note: The instruction *at* the return address (the first addi x31)
  # should NOT be executed by this JALR instruction itself.

  # Let's place the target for JALR carefully
  # We expect JALR to land at 'jalr_return_target' label
  # Add some space to ensure target isn't immediately next instruction
  nop
  nop

jalr_setup:
  # We need the address *after* the JALR instruction
  # Use AUIPC/ADDI to get the PC, or rely on x1 from previous JAL
  # Let's reload x1 just to be sure, pointing to jalr_return_target
  la x1, jalr_return_target # Load address pseudo-instruction

  jalr x5, x1, 0      # Jump to address in x1, link in x5
  addi x31, x31, 32   # Should NOT execute

# This is where the JALR should land
jalr_return_target:
  addi x30, x30, 256  # Indicator: JALR return successful (Value: 254 + 256 = 510)
  nop

  # --- End of Test ---
end_test:
  # Final check:
  # If control hazards handled correctly:
  # x30 should be 510 (0x1FE)
  # (2 + 4 + 8 + 16 + 32 + 64 + 128 + 256 = 510)
  # x31 should be 0

  # Halt simulation or loop forever
  ebreak
  # or: loop_forever: j loop_forever