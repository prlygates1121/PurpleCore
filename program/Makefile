# Whether to link start.s
ENTRY ?= yes

CC = riscv32-unknown-linux-gnu-gcc

ifeq ($(ENTRY), yes)
	LINKER := linker.processed.ld
else
	LINKER := linker.ld
endif

# Flags used to	1. enable optimization
#				2. specify architecture and abi
#				3. discard standard library
#				4. eliminate the weird .eh_frame sections that otherwise would be included in .text section
#				5. specify linker script
CFLAGS := -O3 -march=rv32imzicsr -mabi=ilp32 -nostdlib -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -T $(LINKER)

# Define the executable name
TARGET := output/my_program

# Define source files
SRCS := user/main.c user/user_ecall.s lib/utils.c lib/keyboard/keyboard.c lib/uart/uart.c lib/led/led.c lib/seg_display/seg_display.c lib/switch/switch.c lib/button/button.c lib/vga/vga.c sys/trap_handler.c sys/trap.s sys/csr.c sys/plic.c

ifeq ($(ENTRY), yes)
	SRCS += sys/entry.s
endif

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
	$(CC) -E -P -x c -DIGNORE_ENTRY linker.ld -o linker.processed.ld
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)
	rm linker.processed.ld
	@echo "$(TARGET) created successfully."

# Rule to compile .c files into .o files
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
	rm -f $(TARGET) $(OBJS) linker.processed.ld

.PHONY: clean