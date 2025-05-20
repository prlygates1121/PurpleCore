# Write a python program that reads a hex file,
# processes the remaining bytes in 4-byte words reversing the byte order within each word,
# interprets each byte (in the reversed order) as pairs of 4-bit hex digits,
# and converts those digits to ASCII characters ('0'-'9', 'A'-'F').
# Any remaining bytes (<4) are processed without reversal.
# The program should print the ASCII characters to a file named "output.txt".
import sys

def hex_nibbles_to_ascii_reversed_words(input_filename, output_filename, skip_bytes=0, word_size=4):
    """
    Reads a file byte by byte, skips a specified number of bytes,
    processes subsequent bytes in word_size chunks, reversing the byte order within each chunk.
    Interprets each byte (in the reversed order) as two 4-bit hex digits (nibbles),
    converts each nibble to its ASCII hex character ('0'-'9', 'A'-'F'),
    and writes the resulting characters to an output file.
    Remaining bytes (< word_size) are padded with zeros to form a complete word and then reversed.

    Args:
        input_filename (str): The path to the input file.
        output_filename (str): The path to the output ASCII file. Defaults to "output.txt".
        skip_bytes (int): The number of bytes to skip from the beginning. Defaults to 52.
        word_size (int): The size of the word for byte reversal. Defaults to 4.
    """
    try:
        # Open the input file in binary read mode ('rb')
        # Open the output file in text write mode ('w')
        with open(input_filename, 'rb') as infile, open(output_filename, 'w') as outfile:
            # Skip the specified number of bytes
            infile.seek(skip_bytes)

            # Read the remaining bytes from the file
            byte_data = infile.read()

            num_bytes = len(byte_data)
            num_full_words = num_bytes // word_size
            
            # Process full words with byte reversal
            for i in range(num_full_words):
                start_index = i * word_size
                word_bytes = byte_data[start_index : start_index + word_size]
                # Reverse the byte order within the word
                reversed_word_bytes = word_bytes[::-1]

                # Process each byte in the reversed word
                for byte in reversed_word_bytes:
                    # Extract the high nibble (first 4 bits)
                    high_nibble = (byte >> 4) & 0x0F
                    # Extract the low nibble (last 4 bits)
                    low_nibble = byte & 0x0F

                    # Convert nibbles to their hex character representation
                    high_char = format(high_nibble, 'X')
                    low_char = format(low_nibble, 'X')

                    # Write the two ASCII characters to the output file
                    outfile.write(high_char)
                    outfile.write(low_char)
                
                # Write a newline character after each word for clarity (optional)
                outfile.write('\n')

            # Process any remaining bytes with zero padding to form a complete word
            remaining_bytes_start = num_full_words * word_size
            remaining_bytes_count = num_bytes - remaining_bytes_start
            
            if remaining_bytes_count > 0:
                # Get the remaining bytes
                remaining_bytes = byte_data[remaining_bytes_start:]
                # Pad with zeros to form a complete word
                padded_word = bytearray(remaining_bytes) + bytearray([0] * (word_size - remaining_bytes_count))
                # Reverse the padded word
                reversed_padded_word = padded_word[::-1]
                
                # Process each byte in the reversed padded word
                for byte in reversed_padded_word:
                    # Extract the high nibble (first 4 bits)
                    high_nibble = (byte >> 4) & 0x0F
                    # Extract the low nibble (last 4 bits)
                    low_nibble = byte & 0x0F

                    # Convert nibbles to their hex character representation
                    high_char = format(high_nibble, 'X')
                    low_char = format(low_nibble, 'X')

                    # Write the two ASCII characters to the output file
                    outfile.write(high_char)
                    outfile.write(low_char)
                
                # Write a newline character after the last word (optional)
                outfile.write('\n')

        print(f"Successfully converted nibbles from '{input_filename}' (skipping first {skip_bytes} bytes, reversing {word_size}-byte words) to ASCII hex characters in '{output_filename}'.")
        print(f"Remaining bytes ({remaining_bytes_count}) were padded with zeros to form a complete word and reversed.")

    except FileNotFoundError:
        print(f"Error: Input file '{input_filename}' not found.")
    except IOError as e:
        print(f"Error reading or writing file: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python hex2ascii.py <input_hex_file> <output_ascii_file>")
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
        # Call the updated conversion function
        hex_nibbles_to_ascii_reversed_words(input_file, output_file)