.cpu cortex-a72
.fpu neon-fp-armv8

.data

Winner: .asciz "You are the winner. Congratulations!\n"
Computer: .asciz "The Computer won. Good try!\n"
Draw: .asciz "It's a draw. Nice try!\n"


.text
.align 2
.global winnercheck
.type winnercheck, %function


winnercheck:
    push {fp, lr}
    add fp, sp, #4

    mov r10, r0 @ r10 = array
    mov r9, #52 @ r9 = 52
    b arraycheck    


arraycheck: 
    cmp r9, #0 @ checks if r9 has reached the end of the deck
    ble checkwinner @ exits the loop if it's true

    @ checks the array and loads the value of each array location into r1
    mov r0, #4
    sub r1, r9, #1
    mul r0, r0, r1
    ldr r1, [r10, r0]


    cmp r1, #100     @checks if the user still had a card available at the array location
    bne exit @ exits the function 
    sub r9, r9, #1 @ i--
    b arraycheck @ goes back to loop

checkwinner: @ checks both user and computer's score ( a positive number means user wins while negative means computer wins)
    cmp r8, #0   @ checks if r8 is 0
    beq stalemate @ prints stalemate if true
    cmp r8, #0  @ checks if score is negative
    blt compwin @ prints compwin if true
    cmp r8, #0 @ checks if score is positive
    bgt win @ prints win if true
 
stalemate:  @ informs the user that the game is a draw 
   ldr r0, =Draw
   bl printf
   mov r8, #100 @ moves 100 into r8 to inform main.s that the game is over
   b exit

compwin: @ informs the user that the computer has won
   ldr r0, =Computer
   bl printf
   mov r8, #100 @ moves 100 into r8 to inform main.s that the game is over
   b exit
  
win: @ informs the user that they won
   ldr r0, =Winner
   bl printf
   mov r8, #100 @ moves 100 into r8 to inform main.s that the game is over
   b exit


exit:
    sub sp, fp, #4
    pop {fp, pc}


