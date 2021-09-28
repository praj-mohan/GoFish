.cpu cortex-a72
.fpu neon-fp-armv8

@ main.s calls functions to take actions for the computer in each game as well as take user input

.data
.equ  ncards, 52  @ ncards = 52
.equ  ntypes, 13  @ ntypes = 13
filename: .asciz "shuffledcards.dat" @ this is where the shuffled card deck will be stored if the values of the cards need to be checked at the end of the game.
rwIOw:    .asciz "w" @ writes the file
rwIOr:    .asciz "r" @reads the file

.text
.align 2
.global main
.type main, %function

main:
    push {fp, lr}
    add fp, sp, #4


    mov r0, #4  @ 4 bytes
    mov r1, #ntypes @ r1 gets the value of 13 integers
    mul r0, r0, r1  @ r0 = 52 (13 * 4)
    sub sp, sp, r0  @ an array of 13 integers is created

    @ stores the array and value of 13 in volatile registers to be sent to the initializing array function
    mov r0, sp @ r0 = array
    mov r1, #ntypes @ r1 = 13
    bl initializingarray  @ calls the function

   
    ldr r0, =filename @loads shuffledcards.dat into r0
    ldr r1, =rwIOw @loads file write into r1
    bl fopen  @ opens the shuffledcards.dat file
    mov r4, r0 @ r4 = r0 (stores the file into r4)

    mov r1, #ncards @ r1 = 52
    mov r2, sp  @ r2 = array

    bl cardshuffle @ calls cardshuffle function to store the value of shuffled cards into the shuffledcards.dat file
    mov r0, r4 @ moves file back into r0
    bl fclose @ closes the file

 
    mov r0, #208  @ r0 = 4 * 52 bytes
    bl malloc @ dynamically allocates memory for the 52 cards
    mov r5, r0  @ holds the allocated memory for the cards
   

    @ opens the file again to read the card data
    ldr r0, =filename
    ldr r1, =rwIOr
    bl fopen
    mov r4, r0

    @ cards are read into an array
    mov r0, r4
    mov r1, r5
    mov r2, #ncards
    bl storeCards @ calls the storecards function to get the cards read
    
    mov r0, r4
    bl close @ closes the file

    @ draws the cards for user from array
    mov r0, r5
    mov r1, #5
    bl drawCards @ calls drawcards function to draw the card for user

    @ two players, deal 5 cards each
    @ alternate turn asking for cards. 


    mov r4, #5 @ gives 5 cards to the player
    mov r7, #4 @ gives 5 cards to the computer
    mov r8, #0 @ establishes the gamescore 

gameLoop: @ starts the game

    mov r0, r5 @ moves array into r0    
    bl playermatchingcards @ checks if there is any matchingcards in the player's deck

    mov r0, r5 
    bl winnercheck @calls winner function checks to see if there is a winner
    cmp r8, #100 @checks if winner has been called
    beq exit @ exits the program if winner is called

    mov r0, r5
    bl playerranout @ calls playerranout function to check if they ran out of cards

    mov r0, r5
    bl playerturn @ calls playerturn function to let the player make its turn

    mov r0, r5    
    bl winnercheck
    cmp r8, #100
    beq exit

    mov r0, r5    
    bl playermatchingcards

    mov r0, r5    
    bl winnercheck
    cmp r8, #100
    beq exit

    mov r0, r5
    bl computermatchingcards @calls computermatchingcard to see if the computer has any matching cards
 
    mov r0, r5    
    bl winnercheck
    cmp r8, #100
    beq exit

    mov r0, r5
    bl compranout @checks if computer has ran out of cards

    mov r0, r5
    bl compturn @calls the compturn to let the computer make it's turn

    mov r0, r5    
    bl winnercheck
    cmp r8, #100
    beq exit

    mov r0, r5
    bl computermatchingcards  
    
    mov r0, r5    
    bl winnercheck
    cmp r8, #100
    beq exit
  
    b gameLoop

 
exit:


    mov r0, r5
    bl free @ frees the memory allocation

    sub sp, fp, #4
    pop {fp, pc}

