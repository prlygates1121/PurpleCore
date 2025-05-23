.global ecall_test
ecall_test:
    li a7, 0
    ecall
    ret

.global ecall_stop
ecall_stop:
    li a7, 1
    ecall
    ret

.global ecall_break
ecall_break:
    li a7, 2
    ecall
    ret