.cpu cortex-a72
.fpu neon-fp-armv8

.data
cardstoring: .asciz "%d"

.text
.align 2
.global storeCards
.type storeCards, %function

storeCards:
    push {fp, lr}
    add fp, sp, #4

    mov r10, r0 @ r10 = fp
    mov r9, r1 @ r9 = array
    mov r8, r2 @ r8 = 52

    sub sp, sp, #4 @ moves up a memory location

loop:
    cmp r8, #0
    ble exit

    @ gets the value of cards
    mov r0, r10
    ldr r1, =cardstoring
    mov r2, sp
    bl fscanf

    ldr r2, [sp]

    @ calculate memory offset
    mov r0, #4
    sub r1, r8, #1
    mul r0, r0, r1


    @  stores the card into array   
    str r2, [r9, r0]

    sub r8, r8, #1  @ i--
    b loop

exit:
    sub sp, fp, #4
    pop {fp, pc}
