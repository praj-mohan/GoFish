.cpu cortex-a72
.fpu neon-fp-armv8

.data

ranout: .asciz "You ran out of cards so a card was given to you\n"

.text
.align 2
.global playerranout
.type playerranout, %function

playerranout:
    push {fp, lr}
    add fp, sp, #4
    mov r10, r0 @ r10 = array
    mov r9, r4 @ r9 = number of user cards
    b checking
   
checking: 
    cmp r9, #0 @checks if r9 reached end of deck and leaves function if true
    ble nocardsleft 


    @ checks to see if the user has any cards
    mov r0, #4  
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
    cmp r1, #100
    bne exit @ leaves the function if the user does happen to still have cards

    sub r9, r9, #1 @ i--
    b checking @ goes back to loop




nocardsleft:
    @ checks to see if all cards from the deck have been drawn, leaves the function if true
    add r6, r7, r4
    cmp r6, #51
    beq exit

    @ gives a card to user and informs them that the program has done so.
    add r4, r4, #1
    ldr r0, =ranout
    bl printf
    b exit @leaves function

exit:
    sub sp, fp, #4
    pop {fp, pc}




