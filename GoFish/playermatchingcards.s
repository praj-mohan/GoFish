.cpu cortex-a72
.fpu neon-fp-armv8

.data
matchingpairnumber: .asciz "You have a matching pair for %d, so a point is given to you\n"
matchingpairace: .asciz "You have a matching pair for A, so a point is given to you\n"
matchingpairjack: .asciz "You have a matching pair for J, so a point is given to you\n"
matchingpairqueen: .asciz "You have a matching pair for Q, so a point is given to you\n"
matchingpairking: .asciz "You have a matching pair for K, so a point is given to you\n"
test: .asciz "%d\n"

.text
.align 2
.global playermatchingcards
.type playermatchingcards, %function


playermatchingcards:
    push {fp, lr}
    add fp, sp, #4

    mov r10, r0 @ r10 = array
    mov r9, r4 @ r9 = number of player cards
    mov r6, r9 @ r6 = r9
    b precursormatchcheck

precursormatchcheck:
    @ loads value of player's first card into r3
    mov r0, #4
    sub r1, r6, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
    mov r3, r1
    
    sub r6, r6, #1 @ subtracts the value of r6 by 1 to go to the next card
    b checkformatch

checkformatch: 
    cmp r6, #0 @checks if r6 reached the bottom of players deck
    ble checknextnumber @ goes to the next card to check for matching cards

    @ loads the value of player's cards
    mov r0, #4 
    sub r1, r6, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]

    @ checks if the card is matching to the card being checked
    cmp r3, r1
    beq matchconfirmedlettercheck @ exits the loop if true
    sub r6, r6, #1 @goes to the next card to compare
    b checkformatch @ goes back to the loop


matchconfirmedlettercheck:
   cmp r3, #100 @checks to make sure that the card is actually part of the players deck
   beq checknextnumber @ checks the next card if it isn't

   add r8, r8, #1 @ gives a point to the player's score

   @ stores the value of 100 to remove the card from the player's deck
   mov r0, #4   
   mov r2, #100
   sub r1, r6, #1
   mul r0, r0, r1
   str r2, [r10, r0]

  @stores the value of 100 into the other matching card
   mov r2, #100
   mov r0, #4
   sub r1, r9, #1
   mul r0, r0, r1
   str r2, [r10, r0]

   @ checks to see if the card was a facecard
   cmp r3, #1
   beq ace
   cmp r3, #11
   beq jack
   cmp r3, #12
   beq queen
   cmp r3, #13
   beq king

   @ informs the player that they had a matching card
   mov r6, r3
   ldr r0, =matchingpairnumber 
   mov r1, r6
   bl printf

   b checknextnumber @checks the other cards in the players deck

@informs the player that they had matching facecards (ace, jack, queen, and king)

ace:
   ldr r0, =matchingpairace
   bl printf
   b checknextnumber

jack:
   ldr r0, =matchingpairjack
   bl printf
   b checknextnumber

queen:
   ldr r0, =matchingpairqueen
   bl printf
   b checknextnumber

king:
   ldr r0, =matchingpairking
   bl printf
   b checknextnumber


checknextnumber: 
   sub r9, r9, #1 @ goes to the next card in players deck
   cmp r9, #0 @ checks if the function has reached the end of the deck 
   beq exit @ exits function if true
   mov r6, r9  @ r6 = r9
   b precursormatchcheck @ goes to the beginning of function

exit:
    sub sp, fp, #4
    pop {fp, pc}





