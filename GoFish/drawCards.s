.cpu cortex-a72
.fpu neon-fp-armv8

.data
card: .asciz "%d\n"
yourcards:  .asciz "Your cards are:\n"
acecard:  .asciz "A\n"
jackcard: .asciz "J\n"
queencard:.asciz "Q\n"
kingcard: .asciz "K\n"

.text
.align 2
.global drawCards
.type drawCards, %function

drawCards:
    push {fp, lr}
    add fp, sp, #4



    mov r10, r0 @ r10 = array
    mov r9, r1 @ r9 = 52

    ldr r0, =yourcards
    bl printf

loop:
    cmp r9, #0 @checks if the loop reaches end of array
    ble exit @ leaves if condition is true

    @ goes to the nth element in the array
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1

    ldr r1, [r10, r0] @ loads the value array location into r1

    @ checks if the card is a facecard and prints out a letter if it's the case 
    cmp r1, #1
    beq ace
    cmp r1, #11
    beq jack
    cmp r1, #12
    beq queen
    cmp r1, #13
    beq king

    @ prints out the card if it's a numbercard
    ldr r1, [r10, r0]
    ldr r0, =card
    bl printf
    
     @ i--
    sub r9, r9, #1
    b loop @ goes back to the loop

ace: @prints out ace if value is 1
    ldr r0, =acecard
    bl printf
    sub r9, r9, #1
    b loop

jack: @prints out jack if value is 11
    ldr r0, =jackcard
    bl printf
    sub r9, r9, #1
    b loop

queen: @prints out queen if value is 12
   ldr r0, =queencard
   bl printf
   sub r9, r9, #1
   b loop

king: @prints out king if value is 13
   ldr r0, =kingcard
   bl printf
   sub r9, r9, #1
   b loop


exit:

    sub sp, fp, #4
    pop {fp, pc}
