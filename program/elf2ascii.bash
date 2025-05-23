#!/bin/bash

# Script to compile C to object, extract .text section, and convert to ASCII hex

# --- Configuration ---
OBJCOPY="riscv32-unknown-linux-gnu-objcopy"
OBJDUMP="riscv32-unknown-linux-gnu-objdump"
PYTHON_INTERPRETER="python3" # Or just "python" if python3 is not the default
HEX_CONVERTER_SCRIPT="hex2ascii.py"

# --- Script Logic ---

# Check if input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_elf_file>"
    exit 1
fi

INPUT_ELF_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_ELF_FILE" ]; then
    echo "Error: Input file '$INPUT_ELF_FILE' not found."
    exit 1
fi

# Check if hex converter script exists
if [ ! -f "$HEX_CONVERTER_SCRIPT" ]; then
    echo "Error: Hex converter script '$HEX_CONVERTER_SCRIPT' not found in the current directory."
    exit 1
fi

# Input is assumed to be an ELF file
ELF_FILE_PATH="$INPUT_ELF_FILE"
BASE_NAME=$(basename "$ELF_FILE_PATH")
BASE_NAME=${BASE_NAME%.o} # Remove .o extension if present for naming consistency
HEX_DUMP_FILE_NAME="${BASE_NAME}_hex" # Intermediate hex dump file name (without path)
OUTPUT_ASCII_FILE="${BASE_NAME}_ascii.txt" # Output of hex2ascii.py defaults to output.txt, let's make it specific

# Folder names
OUTPUT_FOLDER="output"

echo "--- Starting C to ASCII Hex Conversion for $INPUT_ELF_FILE ---"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

echo "1. Input is ELF file: $ELF_FILE_PATH"

# Step 2: Extract .text section to hex dump
echo "2. Extracting .text section from $ELF_FILE_PATH to $OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME..."
$OBJCOPY -O binary -j .text -j .text.startup -j .rodata* -j .data -j .sdata "$ELF_FILE_PATH" "$OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME"
if [ $? -ne 0 ]; then
    echo "Error: objcopy failed."
    exit 1
fi
echo "   .text section extracted."

# Step 3: Process hex dump with Python script
echo "3. Converting hex dump $OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME to ASCII $OUTPUT_FOLDER/$OUTPUT_ASCII_FILE..."
# Modify the python script call to specify the output file
# Assuming hex2ascii.py is modified or can take output filename as an argument
# If hex2ascii.py always writes to "output.txt", adjust accordingly:
# $PYTHON_INTERPRETER "$HEX_CONVERTER_SCRIPT" "$HEX_DUMP_FILE"
# mv output.txt "$OUTPUT_ASCII_FILE"
$PYTHON_INTERPRETER "$HEX_CONVERTER_SCRIPT" "$OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME" "$OUTPUT_FOLDER/$OUTPUT_ASCII_FILE" # Pass output filename
if [ $? -ne 0 ]; then
    echo "Error: Python script execution failed."
    # Clean up intermediate files
    rm -f "$OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME"
    exit 1
fi
echo "   Conversion successful."

echo "--- Process Completed ---"
echo "ELF file used: $ELF_FILE_PATH"
echo "Hex dump file: $OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME"
echo "Final ASCII output: $OUTPUT_FOLDER/$OUTPUT_ASCII_FILE"

# Also, display the disassembly of the object file in the terminal using objdump
echo "4. Disassembling $ELF_FILE_PATH for verification..."
$OBJDUMP -D "$ELF_FILE_PATH" > "$OUTPUT_FOLDER/objdump.txt"
if [ $? -ne 0 ]; then
    echo "Error: objdump failed."
    exit 1
fi

# Optional: Clean up intermediate files
# echo "Cleaning up intermediate files..."
# rm -f "$OUTPUT_FOLDER/$HEX_DUMP_FILE_NAME"

exit 0