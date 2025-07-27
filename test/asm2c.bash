# Check if an input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_assembly_file>"
    exit 1
fi

INPUT_FILE=$1

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

OUTPUT_FILE=../program/user/main.c

# Print the C file header
echo "int main(){" > $OUTPUT_FILE
echo "__asm__ (" >> $OUTPUT_FILE

# Use awk to format each line and print it.
# sub() removes trailing whitespace (spaces, tabs, carriage returns).
# gsub() escapes backslashes and double quotes.
# printf() prints the formatted string.
awk '{ sub(/[[:space:]]+$/, ""); gsub(/\\/, "\\\\"); gsub(/"/, "\\\""); printf "\"%s\\n\"\n", $0 }' "$INPUT_FILE" >> $OUTPUT_FILE

# Print the closing of the C file
echo ");" >> $OUTPUT_FILE
echo "}" >> $OUTPUT_FILE