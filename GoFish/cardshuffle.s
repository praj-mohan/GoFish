@ shuffle(fp, ncards, sp)

.cpu cortex-a72
.fpu neon-fp-armv8

.data
cardstore: .asciz "%d\n" @ prints the value of shuffled cards into the file

.text
.align 2
.global cardshuffle
.type cardshuffle, %function

cardshuffle:
    push {fp, lr}
    add fp, sp, #4

    mov r10, r0  @ r10 = fp
    mov r9, r1   @ r9 = 52
    mov r8, r2   @ r8 = array

    @ reseeds random number generator
    mov r0, #0
    bl time
    bl srand  


    mov r7, #0  @ i = 0

loop:
    cmp r7, r9   @ checks if all cards have been written
    bge exit @ leaves if condition is true

    
    bl rand @ gets a random number between 1 - 13
    mov r1, #13
    bl modulo  @ modulo function is called to make sure no roundoff error occurs
    @ returns a number between 0 and 12

    mov r1, #4 @ r1 = 4
    mul r1, r1, r0 @ r1 = 4 * random number
    ldr r2, [r8, r1] @loads value into r2

    cmp r2, #4  @ checks if 4 numbers have already been generated for the card value
    bge loop @ goes back to the beginning if condition is true

    add r7, r7, #1  @i++;
    add r2, r2, #1  @ increments r2
    str r2, [r8, r1]

    add r2, r0, #1   @ increments random number since modulo function returns 0-12 instead of 1-13
    
    @ stores card into the shuffledcards.dat file
    ldr r1, =cardstore 
    mov r0, r10  
    bl fprintf

    b loop @ goes back to loop

exit:
    sub sp, fp, #4
    pop {fp, pc}
