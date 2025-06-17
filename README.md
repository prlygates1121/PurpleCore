# PurpleCore

PurpleCore is the course project of **CS202** **Computer Organization** (Spring 2025) in **SUSTech**: A RISC-V CPU.

> This is an on-going project as I will continue to add features and fix bugs.

## Features & TODO:
- [x] 5-stage pipelined
    - [ ] multi-cycle EX
- [x] speculative execution

    - [x] branch predictor (two-level adaptive, global)
    - [x] return address stack
- [x] runs bare-metal C programs
- [x] trap handling
    - [x] environment calls
    - [x] exceptions
    - [ ] interrupts
- [x] I/O (hardware controller and C library support)

    - [x] UART
    - [x] VGA
    - [x] PS/2 keyboard
- [ ] better support for privilege modes

## Documentation

Check [this](docs\doc.pdf) out for documentation.

## Directory Tree

- `mycpu\mycpu.srcs\`

    - `sources_1\new\`: 

        Verilog source files

    - `sim_1\new\`: 

        Verilog testbenches

    - `constrs_1\new\`: 

        the constraint file

- `program\`

    C programs and scripts to build them

- `test\`

    Assembly tests

- `coe_gen\`: a python script that generates `.coe` file out of ASCII instructions

## How To Use
First, prepare the following:

- EGO1 FPGA development board (equipped with `XC7A35T-1CSG324C`)

    > required for on-board testing

- Vivado 2025.1

- GNU RISC-V Toolchain

- Make

- Any tool / script that can send & receive data by UART

### To run on FPGA:
1. Initialize a Vivado project by opening the `xpr` file.

2. Make sure `SIMULATION` in `params.v` is not defined.

3. Run synthesis, implementation, generate bitstream and program device.

    >  If successful, the 7-segment display will show `00010000`

4. In `program` folder, add your own program or use existing ones, and modify `main.c` accordingly.

5. In `program` folder, run `make`.

6. Look for `my_program_ascii.txt` generated in `program/output/`, which contains the program in ASCII text.

7. Use your UART tool to send the text file to FPGA at the default frequency `460800`.

    > If successful, the 7-segment display will show `0002` followed by the number of words of data you transmitted to the FPGA, and the 8 LEDs on the right will light up, provided that the program you run does not immediately overwrite the 7-segment display and LED content.

### To run in simulation:

1. Initialize a Vivado project by opening the `xpr` file.

2. Make sure `SIMULATION` in `params.v` is defined.

3. Compile / assemble your C or assembly source code, dump the text section in ASCII format, paste it in the `mycpu/mycpu.srcs/sources_1/new/program.hex`.

    Note that in simulation, we do not have bootloader / starter code to load and relocate different sections of the program, so only the text section is usable.

4. Based on how your program is compiled, choose whether or not to define the `LOAD_AT_0x200` macro. If defined, it enables your program to be loaded to address starting at `0x200`.

5. Run simulation, which invokes the default top testbench module, `cpu_quicksort_test.v`.

## Compilation Flags

You can choose to set the following compilation flags in

1. `SIMULATION`.

    If it is defined, `my_blk_mem.v` will be used as the main memory for the CPU. This allows you to see the memory content directly during simulation.

    Otherwise, `blk_mem.v` is used.

2. `BRANCH_PREDICT_ENA`.

    If it is defined, `branch_prediction_unit.v` will be instantiated in `core` to take over the control flow upon branch / jump instructions. You can get detailed information about the prediction by uncommenting the code in `cpu_quicksort_test.v`.

    Otherwise, no branch predictor is added, and the CPU defaults to always predicting branch not taken.

3. `LOAD_AT_0x200`.

    - **Effective only if `SIMULATION` is defined**

    If it is defined, your instructions in `program.hex` will be loaded to address starting at `0x200`, consistent with what is specified in the linker script.

    Otherwise, your instructions will be loaded to address starting at `0x0`.

4. `DEBUG`.

    - **Effective only if `SIMULATION` is not defined**

    - **Not compatible with `VGA`**

    If it is defined, an ILA core will be added to help you monitor certain signal values inside the CPU while it is running on board.

5. `VGA`.

    - **Not compatible with `DEBUG`**

    If it is defined, the VGA module will be available.
