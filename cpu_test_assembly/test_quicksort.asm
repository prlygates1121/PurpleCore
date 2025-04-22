# .data
#     array: .space 50

.text

_start:
    jal main
    j exit

main:   
    # s0 = # of elements
    li s0, 15

    # s2 = address of array
    li s2, 0xA000
    
    mv s1, s2
    li t0, 0
    sw t0, 0(s1)
    
    addi s1, s1, 4
    li t0, 3
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 5
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, -1
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 7
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 4
    sw t0, 0(s1)
    
    addi s1, s1, 4
    li t0, 2
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 11
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, -4
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 42
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 2
    sw t0, 0(s1)
    
    addi s1, s1, 4
    li t0, 1
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, -99
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 75
    sw t0, 0(s1)
    addi s1, s1, 4
    li t0, 44
    sw t0, 0(s1)

    # sort
    mv a0, s2
    mv a1, zero
    addi a2, s0, -1
    jal quicksort

    # print sorted array
    mv a0, s2
    mv a1, s0
    jal print_arr

    ret

# void swap() swaps two elements in the array
# a0:   address of the array
# a1:   index 1
# a2:   index 2
swap:
    # t0 = &array[a1]
    slli t0, a1, 2
    add t0, t0, a0
    lw t2, 0(t0)

    # t1 = &array[a2]
    slli t1, a2, 2
    add t1, t1, a0
    lw t3, 0(t1)

    sw t3, 0(t0)
    sw t2, 0(t1)

    jr ra

# int partition() returns the index of the watershed
# a0:   address of the array
# a1:   low index
# a2:   high index
partition:
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    # s5 = high
    mv s5, a2
    # s0 = array[high] (pivot)
    slli s0, s5, 2
    add s0, s0, a0
    lw s0, 0(s0)

    # s1 = low - 1
    addi s1, a1, -1

    # s2 = loop var
    # s3 = high + 1
    mv s2, a1
    addi s3, s5, 1
loop_begin:
    beq s2, s3, loop_end

    # s4 = array[s2]
    slli s4, s2, 2
    add s4, s4, a0
    lw s4, 0(s4)

    blt s4, s0, less_than_pivot

    addi s2, s2, 1
    j loop_begin

less_than_pivot:
    addi s1, s1, 1

    # swap array[s1] and array[s2]
    mv a1, s1
    mv a2, s2
    jal swap

    addi s2, s2, 1
    j loop_begin

loop_end:

    # swap array[s1 + 1] and array[high]
    addi a1, s1, 1
    mv a2, s5
    jal swap

    # return value = s1 + 1
    mv a0, a1

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    jr ra

# void quicksort() sorts an array
# a0:   address of the array
# a1:   low index
# a2:   high index
quicksort:
    blt a1, a2, low_lt_high
    jr ra

low_lt_high:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # s3 = mid = partition(low, high)
    jal partition
    mv s3, a0

    # quicksort(low, mid - 1)
    mv a0, s0
    mv a1, s1
    addi a2, s3, -1
    jal quicksort

    # quicksort(mid + 1, high)
    mv a0, s0
    addi a1, s3, 1
    mv a2, s2
    jal quicksort

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    jr ra

# void print_arr() prints an integer array
# a0:   address of the array
# a1:   array length
print_arr:
    mv t0, zero
    mv t2, a0

print_loop:
    beq t0, a1 print_end

    # a0 = an element
    slli t1, t0, 2
    add t1, t1, t2
    lw a0, 0(t1)

    addi t0, t0, 1
    j print_loop

print_end:
    jr ra
exit: