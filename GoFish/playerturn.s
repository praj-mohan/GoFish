.cpu cortex-a72
.fpu neon-fp-armv8

.data
prompt: .asciz "Enter a card (enter 1 for A, 11 for J, 12 for Q, 13 for K): "
yourturn: .asciz "%d"
yourquestionace: .asciz "You ask: Do you have a A\n"
yourquestionjack: .asciz "You ask: Do you have a J\n"
yourquestionqueen: .asciz "You ask: Do you have a Q\n"
yourquestionking: .asciz "You ask: Do you have a K\n"
yourquestionnumber: .asciz "You ask: Do you have a %d\n"
ComputerGofish: .asciz "Computer says: Go Fish\n"
Computerace: .asciz "Computer says: Yes I have a A\n"
Computerjack: .asciz "Computer says: Yes I have a J\n"
Computerqueen: .asciz "Computer says: Yes I have a Q\n"
Computerking: .asciz "Computer says: Yes I have a K\n"
Computernumber: .asciz "Computer says: Yes I have a %d\n" 
carddrawace: .asciz "You draw a A\n"
carddrawjack: .asciz "You draw a J\n"
carddrawqueen: .asciz "You draw a Q\n"
carddrawking: .asciz "You draw a K\n"
carddrawnumber: .asciz "You draw a %d\n"
matchace: .asciz "You book the A and lay down one pair of A\n"
matchjack: .asciz "You book the J and lay down one pair of J\n"
matchqueen: .asciz "You book the Q and lay down one pair of Q\n"
matchking: .asciz "You book the K and lay down one pair of K\n"
matchnumber:  .asciz "You book the %d and lay down one pair of %d\n"
Error: .asciz "Program Message: You don't have this card cheater!\n"
Reminder: .asciz "A reminder your cards are: \n"
cardvalue: .asciz "%d\n" 
nocards: .asciz "No cards are left so the computer didn't draw another card.\n"
cardace: .asciz "A\n"
cardjack: .asciz "J\n"
cardqueen: .asciz "Q\n"
cardking: .asciz "K\n"

.text
.align 2
.global playerturn
.type playerturn, %function

playerturn:
    push {fp, lr}
    add fp, sp, #4
    
    mov r10, r0 @ r10 = array
    mov r9, r4 @ r9 = number of player cards
    
    @ reminds the player of what cards they have
    ldr r0, =Reminder
    bl printf

    @ prints the cards the player has
    b printcards

printcards: 
    cmp r9, #0 @ checks if r9 has reached the end of players cards
    ble input  @goes to check player's input if true
   
    @ goes and finds the value of each array location and stores it into r1
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]

    @ checks if the card is a facecard, prints out the letter if true
    cmp r1, #1
    beq reminderace
    cmp r1, #11
    beq reminderjack
    cmp r1, #12
    beq reminderqueen
    cmp r1, #13
    beq reminderking

    
    cmp r1, #100 @checks to make sure if the card is actually in the players deck, prints the card if it's in the players deck
    bne printvalue
    sub r9, r9, #1
    b printcards



@prints out the facecard letter if the cards are facecards

reminderace:
    ldr r0, =cardace
    bl printf
    sub r9, r9, #1
    b printcards


reminderjack:
    ldr r0, =cardjack
    bl printf
    sub r9, r9, #1
    b printcards

reminderqueen:
    ldr r0, =cardqueen
    bl printf
    sub r9, r9, #1
    b printcards

reminderking:
    ldr r0, =cardking
    bl printf
    sub r9, r9, #1
    b printcards


printvalue: @ prints numbercards that the player has
    mov r6, r1
    ldr r0, =cardvalue
    mov r1, r6
    bl printf
    sub r9, r9, #1
    b printcards

input:
     @ prompts the player for input
    ldr r0, =prompt
    bl printf
    
    @ gets the players input and stores it into r6
    ldr r0, =yourturn
    sub sp, sp, #4 @sp = sp - 4 @ goes up one mem location
    mov r1, sp @ user input will be stored at sp loc
    bl scanf 
    ldr r6, [sp] 

    @ moves the number of players cards into r9
    mov r9, r4

    cmp r6, #100 @ makes sures that the player isn't exploiting the game by using 100 which is used to confirm the cards matched 
    beq cheater @ gives the player an error message if they are attempting to cheat

    b charactercheck


charactercheck:
    @ checks if the card the player requested is a facecard 
    cmp r6, #1
    beq acevalue
    cmp r6, #11
    beq jackvalue
    cmp r6, #13
    beq kingvalue
    cmp r6, #12
    beq queenvalue 
     
    @ prints out the card that the player has asked for
    ldr r0, =yourquestionnumber
    mov r1, r6
    bl printf

    b anticheat

@ prints out the facecard that the player has asked for
acevalue: 
    ldr r0, =yourquestionace
    bl printf
    b anticheat

kingvalue:
    ldr r0, =yourquestionking
    bl printf
    b anticheat

queenvalue:
    ldr r0, =yourquestionqueen
    bl printf
    b anticheat

jackvalue:
    ldr r0, =yourquestionjack
    bl printf
    b anticheat


anticheat: @ checks if the requested card is actually in the player's deck
    cmp r9, #0 @ checks if all cards have been checked
    ble cheater @ goes to cheater if the player doesn't have the card

    @loads each value of array locations into r1 to see if it's equal to the player's requested card, exits the loop if it is true.
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0] 
    cmp r1, r6
    beq notcheater

    sub r9, r9, #1 @ i--
    b anticheat @ checks next card


cheater: @ prints out the error message if the player doesn't have the card
    ldr r0, =Error
    bl printf
    b input

notcheater: @prepares to check the computers cards
    mov r9, r7 @moves the number of computer cards into r9
    mov r3, #52 @ r3 = 52
    sub r9, r3, r9 @ r9 = 52 - r9
    b question


question:
    cmp r9, #52 @checks if it reaches the end of computer's deck
    bgt computergofish  @goes to computer gofish if true

    @checks each card of the computer's deck to see if it's the same as the player's requested card
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
    cmp r1, r6
    beq match @ leaves the loop if it's true
   
    add r9, r9, #1 @checks the next card
    b question


computergofish: 
    ldr r0, =ComputerGofish @ computer says go fish
    bl printf

    @ checks to see if all cards have been drawn from the pile
    add r6, r7, r4 
    cmp r6, #51
    beq nocardsleft @ goes to nocards left if true
    b drawcard     

nocardsleft: @tells the players that no cards are left in the deck so they can't draw any cards
    ldr r0, =nocards
    bl printf
    b exityourturn 

drawcard: @ gives a card to player
    add r4, r4, #1 @adds a card to players deck

    @loads the value of player's card into r1 and prints it
    mov r9, r4
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
   

    @checks if card is a facecard. Prints a letter if it's a facecard
    cmp r1, #1
    beq converttoace
    cmp r1, #11
    beq converttojack
    cmp r1, #12
    beq converttoqueen
    cmp r1, #13
    beq converttoking

    @prints a number if the card is a numbercard
    ldr r1, [r10, r0]
    ldr r0, =carddrawnumber
    bl printf
    b exityourturn

@prints letters if the card is a facecard
converttojack:
    ldr r0, =carddrawjack
    bl printf
    b exityourturn

converttoace: 
    ldr r0, =carddrawace
    bl printf
    b exityourturn

converttoqueen:
    ldr r0, =carddrawqueen
    bl printf
    b exityourturn

converttoking:
    ldr r0, =carddrawking
    bl printf
    b exityourturn


match: @removes the card from the computer's deck if a match has been confirmed
    
    @ loads the value of match card location from the computers deck
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1

    mov r2, #100
    str r2, [r5, r0] @ stores 100 into the location to remove the card from deck
    add r8, r8, #1 @gives a point to the player
    mov r9, r4
    b playermatch

playermatch:@removes the card from the player's deck if a match has been confirmed

    @ loads the value of a cards location from the player's deck
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]
    cmp r1, r6 @ checks if the card is found
    beq replace @leaves loop if it has been found
    sub r9, r9, #1
    b playermatch

replace:
    @ loads the value of a cards location from the player's deck
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    mov r2, #100
    str r2, [r5, r0] @ stores 100 into the location to remove the card from deck
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
