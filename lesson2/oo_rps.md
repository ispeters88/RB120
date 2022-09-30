RPS is a game that may consist of multiple rounds of moves by competitors - one human, the other machine - organized into scored matches. Our version will initiate a playing session, which will allow any number of matches, until such point that the human player decides to end the session.

A running history of moves by competitors will be kept during each session, and will be available for display. 

Module `Viewable`
*Job* Provide functions for displaying information to the screen
*Objects* No custom objects
*Attributes* No 
*Behaviors* Format and display messages to the screen, accept user input
*Collaborator objects* None

Class `Player`
*Job* Define player attributes that humans and computers have in common
*Objects* Human players, Computer players (subclassed)
*Attributes* Name, move, move history
*Behaviors* Check game result, record move history, reset move history
*Collaborator objects* Move (subclass)

**Class** `Human` < Player
*Job* Select name and choose moves for human players
*Objects* Human players
*Attributes* Name, move (inherit from `Player`)
*Behaviors* Set name, Choose move
*Collaborator objects* Move (subclass)

Class `Computer` < Player
*Job* Select name and choose moves for computer players
*Objects* Computer players
*Attributes* Name, move (inherit from `Player`)
*Behaviors* Set name, Choose move
*Collaborator objects* Move (subclass)

Class `Move`
*Job* Define the available moves and their abilities to win/lose relative to each other
*Objects* player moves
*Attributes* Name of move
*Behaviors* Compare moves
*Collaborator objects* None

Class `Match` < Session
*Job* Executes game flow logic
*Objects* A set of rounds of play
*Attributes* Score
*Behaviors*
*Collaborator objects*

Class `History`
*Job* Perform functions to keep and allow display of the move history for the session
*Objects* A record of all moves chosen in the course of a session
*Attributes*
*Behaviors* Update history, display history
            Display should allow display of the moves for a specific match, or the entire session
*Collaborator objects* Player (Human/Computer)

* Question * What is a game? Is it
  - One set of moves by each player?
    Round
  - A sequence of pairs of moves, until a target score is reached?
    Match
  - Reaching the target score multiple times until the player chooses not to continue playing?
    Session

Class `Session`
*Job* Initiates and allows continuation of play through multiple matches
*Objects* A session of game play
*Attributes* Move history, players (one human, 1+ computers)
*Behaviors* Welcomes user and introduces game, prompts user for name and opponent(optional)
*Collaborator objects* Match, Player (Human/Computer), Move, History

* 
* One thing I'm finding is that ths subclass Match is not inhering the state values/attributes of the superclass
* This is somewhat annoying because I have to pass these state values around between the Session and Match instance methods
*