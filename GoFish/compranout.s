.cpu cortex-a72
.fpu neon-fp-armv8

.data

ranout: .asciz "The computer ran out of cards so a card was given to the computer\n"

.text
.align 2
.global compranout
.type compranout, %function

compranout:
    push {fp, lr}
    add fp, sp, #4

    mov r10, r0 @ r10 = array
    mov r9, r7 @ r9 = number of computer cards
    mov r6, #52 @ r6 = 52
    sub r9, r6, r9 @ r9 = 52 - number of computer cards 
	
    b checking
   
checking: 
    cmp r9, #52  @checks if r9 reached end of deck and leaves function if true
    bgt nocardsleft 


    @ checks to see if the computer has any cards
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1

    ldr r1, [r10, r0]
    cmp r1, #100
    bne exit @ leaves the function if the computer does happen to still have cards
    add r9, r9, #1
    b checking


nocardsleft:
    @ checks to see if all cards from the deck have been drawn, leaves the function if true
    add r6, r7, r4
    cmp r6, #51
    beq exit

    @ gives a card to computer and informs the user that the program has done so.
    add r7, r7, #1
    ldr r0, =ranout
    bl printf
    b exit

exit:
    sub sp, fp, #4
    pop {fp, pc}




