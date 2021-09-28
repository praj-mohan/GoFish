.cpu cortex-a72
.fpu neon-fp-armv8

.data
yourquestionace: .asciz "Computer ask: Do you have a A\n"
yourquestionjack: .asciz "Computer ask: Do you have a J\n"
yourquestionqueen: .asciz "Computer ask: Do you have a Q\n"
yourquestionking: .asciz "Computer ask: Do you have a K\n"
yourquestionnumber: .asciz "Computer ask: Do you have a %d\n"
ComputerGofish: .asciz "You says: Go Fish\n"
Computerace: .asciz "You say: Yes I have a A\n"
Computerjack: .asciz "You say: Yes I have a J\n"
Computerqueen: .asciz "You say: Yes I have a Q\n"
Computerking: .asciz "You say: Yes I have a K\n"
Computernumber: .asciz "You say: Yes I have a %d\n" 
carddrawnumber: .asciz "Computer draws a card\n"
matchace: .asciz "Computer books the A and lays down one pair of A\n"
matchjack: .asciz "Computer books the J and lays down one pair of J\n"
matchqueen: .asciz "Computer books the Q and lays down one pair of Q\n"
matchking: .asciz "Computer books the K and lays down one pair of K\n"
matchnumber:  .asciz "Computer books the %d and lays down one pair of %d\n"
nocards: .asciz "No cards are left so the computer didn't draw another card.\n"
test: .asciz "%d"
.text
.align 2
.global compturn
.type compturn, %function


compturn:
    push {fp, lr}
    add fp, sp, #4
    mov r10, r0 @ r10 = array
    mov r9,  r7 @ r9 = number of computer cards

    @ reseed random number generator
    mov r0, #0
    bl time
    bl srand  @ srand(time(0))

random:
    bl rand
    mov r1, r9 @ generates a random number that's within the range of computer's cards
    bl modulo @calls the modulo function to get rid of any runoff errors
    mov r6, r0 @ stores number into r6
    add r0, r0, #1  @ increments number by 1 since modulo function is off by 1 number
    mov r3, #52  @ r3 = 52
    sub r6, r3, r0 @ r6 = 52 - random number

    @ loads the value of the random memory location into r1
    mov r0, #4
    sub r1, r6, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
    
    @ checks to see if that card is still in the computer's deck
    mov r6, r1
    cmp r6, #100
    beq random @ goes back to get a different number if it isn't

    b charactercheck

charactercheck:
    
    @ checks if the computer's requested card is a facecard, prints out a letter if it is
    cmp r6, #1
    beq acevalue
    cmp r6, #11
    beq jackvalue
    cmp r6, #13
    beq kingvalue
    cmp r6, #12
    beq queenvalue 
  
    ldr r0, =yourquestionnumber @ informs user what card the computer has requested
    mov r1, r6
    bl printf
    b precursor


@prints out the facecard letter if the cards are facecards
acevalue: 
    ldr r0, =yourquestionace
    bl printf
    b precursor

kingvalue:
    ldr r0, =yourquestionking
    bl printf
    b precursor

queenvalue:
    ldr r0, =yourquestionqueen
    bl printf
    b precursor

jackvalue:
    ldr r0, =yourquestionjack
    bl printf
    b precursor



precursor:
    mov r9, r4 @ moves number of player cards into r9
    b question


question:
    cmp r9, #0 @checks if it reaches the end of player's deck
    ble computergofish @ goes to gofish if it is done

    @checks each card of the computer's deck to see if it's the same as the player's requested card
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1

    ldr r1, [r10, r0]
    cmp r1, r6
    beq match @ leaves the loop if it's true

    sub r9, r9, #1 @checks the next card
    b question


computergofish: 
    ldr r0, =ComputerGofish @ player says go fish
    bl printf

    @ checks to see if all cards have been drawn from the pile
    add r6, r7, r4
    cmp r6, #51
    beq nocardsleft @ goes to nocards left if true
    b drawcard

nocardsleft: @tells the players that no cards are left in the deck so computer can't draw any cards
    ldr r0, =nocards
    bl printf
    b exityourturn 


drawcard: @ gives a card to computer	
    add r7, r7, #1 @adds a card to computer's deck
    ldr r0, =carddrawnumber @ lets the player know.
    bl printf
    b exityourturn



match: @removes the card from the player's deck if a match has been confirmed
    @ loads the value of match card location from the players deck
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    mov r2, #100 @ stores 100 into the location to remove the card from deck
    str r2, [r5, r0]
    sub r8, r8, #1 @gives a point to the computer
    mov r9, r7
    b compmatchprecursor
 
compmatchprecursor:
   mov r2, #52
   sub r9, r2, r9
   b playermatch

playermatch: @removes the card from the computer's deck if a match has been confirmed
    mov r0, #4      @ loads the value of match card location from the computers deck
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
    cmp r1, r6 @ checks if the card is found
    beq replace @leaves loop if it has been found
    add r9, r9, #1
    b playermatch

replace:
    @ loads the value of a cards location from the computer's deck
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    mov r2, #100 @ stores 100 into the location to remove the card from deck
    str r2, [r5, r0]
    b print
    

print:
    @ checks if the matched card is a face card, prints a letter if that's the case.
    cmp r6, #1
    beq gotace
    cmp r6, #11
    beq gotjack
    cmp r6, #12
    beq gotqueen
    cmp r6, #13
    beq gotking
    @ prints a number if the card is a number card.
    ldr r0, =Computernumber
    mov r1, r6
    bl printf
    ldr r0, =matchnumber
    mov r1, r6
    mov r2, r6
    bl printf
    b exityourturn



@prints out log that the player has booked a pair of face cards
gotace:
    ldr r0, =Computerace
    bl printf
    ldr r0, =matchace
    bl printf
    b exityourturn

gotjack:
    ldr r0, =Computerjack
    bl printf
    ldr r0, =matchjack
    bl printf
    b exityourturn

gotqueen:
    ldr r0, =Computerqueen
    bl printf
    ldr r0, =matchqueen
    bl printf
    b exityourturn

gotking:
    ldr r0, =Computerking
    bl printf
    ldr r0, =matchking
    bl printf
    b exityourturn

exityourturn:
    sub sp, fp, #4
    pop {fp, pc}

