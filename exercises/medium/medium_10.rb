# Poker!
# In the previous two exercises, you developed a Card class and a Deck class. 
# You are now going to use those classes to create and evaluate poker hands. 
# Create a class, PokerHand, that takes 5 cards from a Deck of Cards and evaluates those cards as a Poker hand. 
# If you've never played poker before, you may find this overview of poker hands useful.
# 
# You should build your class using the following code skeleton:
# 
# # Include Card and Deck classes from the last two exercises.

require "pry-byebug"

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    @cards = Array.new
    deal
  end

  def deal
    add_cards_to_deck
    shuffle
  end

  def draw
    deal if @cards.size == 0
    @cards.pop
  end

  private

  def add_cards_to_deck
    RANKS.product(SUITS).each do |rank, suit|
      @cards << Card.new(rank, suit)
    end
  end
  
  def shuffle
    1000.times { @cards.shuffle! }
  end

end

class Card
  include Comparable
  attr_reader :rank, :suit

  CARD_VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    CARD_VALUES.fetch(rank, rank)
  end

  def <=>(other)
    CARD_VALUES[self.rank] <=> CARD_VALUES[other.rank]
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class PokerHand
  def initialize(deck)
    @hand = Array.new
    5.times { @hand << deck.draw }
  end

  def print
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def hand_suits
    @hand.map(&:suit)
  end

  def hand_ranks
    @hand.map(&:value)
  end

  def hand_deltas
    pairs = hand_ranks.sort.each_cons(2).to_a
    pairs.map { |pair| pair.inject(&:-).abs }
  end

  def card_frequencies
    counts = Hash.new(0)
    @hand.each { |card| counts[card.value] += 1 }
    counts
  end

  def highest_multiple
    card_frequencies.values.max
  end

  def royals?
    royal_ranks = [10, 11, 12, 13, 14]
    hand_ranks.map.sort == royal_ranks
  end

  def royal_flush?
    royals? && flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    highest_multiple == 4
  end

  def full_house?
    card_frequencies.values.sort == [2, 3]
  end

  def flush?
    hand_suits.uniq.size == 1
  end

  def straight?
    hand_deltas.all? { |delta| delta == 1 }
  end

  def three_of_a_kind?
    highest_multiple == 3
  end

  def two_pair?
    card_frequencies.count { |_,freq| freq == 2 } == 2
  end

  def pair?
    highest_multiple == 2
  end
end


# Testing your class:

#hand = PokerHand.new(Deck.new)
#hand.print
#puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'

# The exact cards and the type of hand will vary with each run.
# 
# Most variants of Poker allow both Ace-high (A, K, Q, J, 10) and Ace-low (A, 2, 3, 4, 5) straights. 
# For simplicity, your code only needs to recognize Ace-high straights.
# 
# If you are unfamiliar with Poker, please see this description of the various hand types. 
# Since we won't actually be playing a game of Poker, it isn't necessary to know how to play.


# Further Exploration
# The following questions are meant to be thought exercises; rather than write code, 
# think about what you would need to do. Feel free to write some code after thinking about the problem.
# 
# How would you modify this class if you wanted the individual classification methods 
# (royal_flush?, straight?, three_of_a_kind?, etc) to be public class methods that work with an Array of 5 cards, e.g.,
# 
def self.royal_flush?(cards)
  ...
end

# How would you modify our original solution to choose the best hand between two poker hands?
#   > Create an array or hash to "rank" the possible hands, then compare the two input hands

# How would you modify our original solution to choose the best 5-card hand from a 7-card poker hand?
#   > After implementing the prior enhancement, we can run all 5-card permutations of the 7 card hand and
#   find the highest scoring one