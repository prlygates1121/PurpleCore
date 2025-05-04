# Define the compiler
CC = riscv32-unknown-linux-gnu-gcc

# Define compiler flags: -Wall (warnings), -g (debugging info)
CFLAGS = -O3 -march=rv32im -mabi=ilp32 -nostdlib -nostartfiles -T linker.ld

# Define the executable name
TARGET = my_program

# Define source files
SRCS = user/uart_test.c lib/uart/uart.c lib/led/led.c lib/seg_display/seg_display.c

# Define object files - substitute .c with .o for each source file
OBJS = $(SRCS:.c=.o)

ascii: $(TARGET) elf2ascii.bash
	@echo "Generating ascii text..."
	./elf2ascii.bash $(TARGET)
	@echo "Ascii text generated successfully."

# Default Target: The executable
# Depends on all object files.
$(TARGET): $(OBJS) entry.o linker.ld
	@echo "Linking..." # @ hides the command itself
	$(CC) $(CFLAGS) $(OBJS) entry.o -o $(TARGET)
	@echo "$(TARGET) created successfully."

# Rule to compile .c files into .o files
# This is a pattern rule: it tells make how to create any .o file from a .c file
%.o: %.c lib/uart/uart.h lib/led/led.h lib/seg_display/seg_display.h
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

entry.o: entry.s 
	@echo "Compiling entry.s"
	$(CC) $(CFLAGS) -c entry.s -o entry.o

# Target to clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(TARGET) $(OBJS) entry.o

# Declare 'clean' as a phony target.
# This means 'clean' isn't a file name; make should always run the recipe
# without checking for a file named 'clean'.
.PHONY: clean