CC = riscv32-unknown-linux-gnu-gcc

# Flags used to 1. enable optimization
#				2. specify architecture and abi
#				3. discard standard library
#				4. eliminate the weird .eh_frame sections that otherwise would be included in .text section
#				5. specify linker script
CFLAGS = -O3 -march=rv32imzicsr -mabi=ilp32 -nostdlib -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -T linker.ld

# Define the executable name
TARGET = output/my_program

# Define source files
SRCS = user/main.c user/user_ecall.s lib/utils.c lib/keyboard/keyboard.c lib/uart/uart.c lib/led/led.c lib/seg_display/seg_display.c lib/switch/switch.c lib/button/button.c lib/vga/vga.c sys/trap_handler.c sys/entry.s sys/trap.s sys/csr.c

# Define object files - substitute .c or .s with .o for each source file
OBJS = $(addsuffix .o, $(basename $(SRCS)))

ascii: $(TARGET) elf2ascii.bash
	@echo "Generating ascii text..."
	./elf2ascii.bash $(TARGET)
	@echo "Ascii text generated successfully."

# Default Target: The executable
# Depends on all object files.
$(TARGET): $(OBJS) linker.ld
	@echo "Linking..." # @ hides the command itself
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)
	@echo "$(TARGET) created successfully."

# Rule to compile .c files into .o files
# This is a pattern rule: it tells make how to create any .o file from a .c file
%.o: %.c lib/utils.h lib/keyboard/keyboard.h lib/uart/uart.h lib/led/led.h lib/switch/switch.h lib/seg_display/seg_display.h lib/button/button.h lib/vga/vga.h sys/trap_handler.h sys/csr.h
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to assemble .s files into .o files
%.o: %.s
	@echo "Assembling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Target to clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(TARGET) $(OBJS)

.PHONY: clean