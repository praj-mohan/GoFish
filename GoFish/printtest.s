.cpu cortex-a72
.fpu neon-fp-armv8

.data
cardout: .asciz "%d\n"
header:  .asciz "Your cards are:\n"
acecard:  .asciz "A\n"
jackcard: .asciz "J\n"
queencard:.asciz "Q\n"
kingcard: .asciz "K\n"

.text
.align 2
.global printtest
.type printtest, %function

printtest:
    push {fp, lr}
    add fp, sp, #4

    mov r10, r0
    mov r9, #52

    ldr r0, =header
    bl printf

printCards_loop:
    cmp r9, #0
    ble done_printCards_loop

    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1

    ldr r1, [r10, r0]

    ldr r0, =cardout
    @ printf("%d\n", card)
    bl printf

    sub r9, r9, #1
    b printCards_loop



done_printCards_loop:

    sub sp, fp, #4
    pop {fp, pc}
