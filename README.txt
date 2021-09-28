This Program is created by Prajit Mohan.


In the Program Folder, it contains the following files:


shuffledcards.dat: Contains the card deck that was generated for the game.

makefile: Generates the program.

goFish: The executable file of the Program.

printtest.s: A function that can be used to verify if cards are being properly removed from the deck. Isn't part of the final version of the program.




Function files that are part of the program:
cardshuffle: Shuffles the cards for the game.
compranout: Checks if the computer has ran out of cards.
compturn: Simulates the Computer's turn.
computermatchingcards: checks if there is any matching cards in the computer's deck and removes them as well as awarding a computer a point for the matching cards.
drawCards: Draws the cards for the players.
initializingarray: creates the array for shuffling the deck.
main: calls functions to carry out the game.
modulo: uses a modulus function to make sure no runoff error occured during the generation of the random number.
playermatchingcards: checks if the player has any matching cards and removes it from their deck as well as giving them a point for the matching cards.
playerranout: checks if the player ran out of cards.
playerturn: allows the player to make their turn.
storeCards: stores cards into an array used for the game.
winnercheck: checks if either the player or the computer has won the game or if the game has ended in a draw.
