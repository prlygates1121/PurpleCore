
.text
main:
    li t0, 0
#     li t1, 100
LOOP1: 
    addi t0, t0, 10
#     beq t0, t1, END
    j LOOP2
LOOP2:
    j LOOP4
    li t0, 0
LOOP3:
    j LOOP1
LOOP4:
    j LOOP3
    
END:
    