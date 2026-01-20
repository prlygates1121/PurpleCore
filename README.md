# PurpleCore

PurpleCore is the course project of **CS202** **Computer Organization** (Spring 2025) in **SUSTech**: A RISC-V CPU.

> This is an on-going project as I will continue to add features and fix bugs.

## Features & TODO:
- [x] ISA: `rv32izicsr`
- [x] Frequency: 50MHz+
- [x] 5-stage pipelined
- [x] speculative execution
    - [x] branch predictor (two-level adaptive, global)
    - [x] return address stack
- [x] runs bare-metal C programs
- [x] trap handling (basic)
    - [x] environment calls
    - [x] exceptions
    - [x] interrupts
- [x] I/O (hardware controller and C library support)
    - [x] UART
    - [x] VGA
    - [x] PS/2 keyboard
- [ ] better support for privilege modes

## Directory Tree

- **Verilog sources:** 

    [`mycpu/mycpu.srcs/sources_1/new/`](mycpu/mycpu.srcs/sources_1/new/)

- **Verilog testbenches:** 

    [`mycpu/mycpu.srcs/sim_1/new/`](mycpu/mycpu.srcs/sim_1/new/)

- **The constraint:** 

    [`mycpu/mycpu.srcs/constrs_1/new/`](mycpu/mycpu.srcs/constrs_1/new/)

- **C programs and scripts to build them:** 

    [`program/`](program/)

- **Assembly tests:**

    [`test/`](test/)

- **Bootloader & `.coe` file generator**
	
	[`coe_gen/`](coe_gen/)

## How To Use
First, prepare the following:

- EGO1 FPGA development board (equipped with `XC7A35T-1CSG324C`)

    > required for on-board testing

- Vivado 2025.2

- GNU RISC-V Toolchain

- Make

- Any tool / script that can send & receive data by UART

### To run on FPGA:
1. Initialize a Vivado project by opening the `xpr` file.

2. Make sure `SIMULATION` in `params.v` is not defined.

3. Run synthesis, implementation, generate bitstream and program device.

    >  If successful, the 7-segment display will show `00010000`

4. In `program` folder, replace `main.c` with your own program or with existing ones in user folder that you want to use.

5. In `program` folder, run `make`.

6. Look for `my_program_ascii.txt` generated in `program/output/`, which contains the program in ASCII text.

7. Use your UART tool to send the generated text file to FPGA at the default frequency `460800`.

    > If successful, the 7-segment display will show `0002` followed by the number of words of data you transmitted to the FPGA, and the 8 LEDs on the right will light up, provided that the program you run does not immediately overwrite the 7-segment display and LED content.

### To run in simulation:

1. Initialize a Vivado project by opening the `xpr` file.

2. Make sure `SIMULATION` in `params.v` is defined.

3.  - If you want to run your program within the given framework, you should:
        
        - Compile your program following step 4 ~ 6 of *To run on FPGA*. Then, paste `my_program_ascii.txt` into `mycpu/mycpu.srcs/sources_1/new/program.hex`.

        - Make sure `LOAD_OFFSET_200` in `params.v` is defined, which means your program will be loaded at address starting at `0x80000200`.

        > In this case, your program can utilize existing peripheral libraries and system functionalities including exceptions, environment calls and interrupts. Your program must be placed at address starting at `0x80000200`, which aligns with the case when you are compiling for an FPGA (first 0x200 bytes are reserved for the bootloader). Global variables and constant variables are supported because `entry.s` will always be run before your main program, relocating the `.data` section and clearing `.bss`.

    - If you want to run a simple piece of standalone assembly / C code without relying on the given framework, then you should:
        
        - Compile your code by yourself, dump the **text** section in hexadecimal, convert the hex dump to **ASCII** characters and paste it in `mycpu/mycpu.srcs/sources_1/new/program.hex`.

        - Make sure `LOAD_OFFSET_200` in `params.v` is not defined, which means your program will be loaded at address starting at `0x80000000`. 

        > In this case, your program should not contain any global data / variables. Only the text section (the instructions) will be used.

4. Run simulation, which invokes the default top testbench module, `cpu_quicksort_test.v`.

## Verilog Build Flags

You can choose to set the following flags in `params.v` in the Verilog sources.

1. `SIMULATION`.

    If it is defined, `my_blk_mem.v` will be used as the main memory for the CPU. This allows you to see the memory content directly during simulation.

    Otherwise, `blk_mem.v` is used.

2. `BRANCH_PREDICT_ENA`.

    If it is defined, `branch_prediction_unit.v` will be instantiated in `core` to take over the control flow upon branch / jump instructions. You can get detailed information about the prediction by uncommenting the code in `cpu_quicksort_test.v`.

    Otherwise, no branch predictor is added, and the CPU defaults to always predicting branch not taken.

3. `LOAD_OFFSET_200`.

    - **Effective only if `SIMULATION` is defined**

    If it is defined, your instructions in `program.hex` will be loaded to address starting at `0x80000200`, consistent with what is specified in the linker script. It also means that the rogram counter will start at `0x80000200` in simulation.

    Otherwise, your instructions will be loaded to address starting at `0x80000000`.

4. `DEBUG`.

    - **Effective only if `SIMULATION` is not defined**

    - **Not compatible with `VGA`**

    If it is defined, an ILA core will be added to help you monitor certain signal values inside the CPU while it is running on board.

5. `VGA`.

    - **Not compatible with `DEBUG`**

    If it is defined, the VGA module will be available.

## Documentation

Check [this](docs/doc.pdf) out for documentation.

> Unfortunately, the documentation is currently outdated.