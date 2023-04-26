# Problem description

Twenty-one is a card game in which two players attempt to reach a score as close as 21 as possible, without going over 21. The game begins with one player designated the "dealer" and then each player being dealt two cards; they then each have an opportunity to repeatedly draw an additional card until they decide to stop or their score exceeds 21 (a "bust"). The non-dealer proceeds with their turn first; the dealer follows, presuming the non-dealer has not already busted.

The score is calculated as the sum of the values of the cards they have been dealt. Those values are constant with the exception of the Ace card, which varies with the current hand score (1 if the current score is 12 or higher, 11 otherwise)

# Nouns and Verbs

* Nouns: game, player (banker/dealer, punter), hand, card, score, turn
* Verbs: deal, draw (i.e. hit), stop (i.e. stay), bust

# Class structure

* Player
  hit
  stay
  @busted
  score
* Banker < Player
  deal
  stay @ 17+
* Punter < Player

* Hand
  cards
  score
* Deck
  cards
* Card
  points
* Game
  begin