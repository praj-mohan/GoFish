.cpu cortex-a72
.fpu neon-fp-armv8

.data

.text
.align 2
.global initializingarray
.type initializingarray, %function

initializingarray:
    push {fp, lr}
    add fp, sp, #4

    @ move the arguments into registers to use
    mov r10, r0  @ r10 = array
    mov r9, r1   @ r9 = 13
    mov r2, #0   @ i = 0

arrayloop: @for loop to store the value of 0 in every array location
    cmp r2, r9 @ checks if r0 >= 13
    bge exit @ leaves if condition is true

    mov r0, #4 @ r0 = 4
    mul r0, r0, r2 @ r0 = 4 * i
    mov r1, #0 @ r1 = 0
    str r1, [r10, r0]  @ stores 0 into the array location

    add r2, r2, #1 @ i++
    b arrayloop @ goes back to the beginning of loop

exit:
    sub sp, fp, #4
    pop {fp, pc}
