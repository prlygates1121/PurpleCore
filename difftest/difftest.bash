if [ ! -f "vivado_dut.log" ]; then
    echo "Error: File not found: vivado_dut.log"
    exit 1
fi

LINE_COUNT=$(($(wc -l < "vivado_dut.log") + 6))

spike --isa=rv32i_zicsr --pc=0x80000200 -m0x80000000:0xC000 --instructions=$LINE_COUNT --log-commits ../program/output/my_program 2> spike.log 
