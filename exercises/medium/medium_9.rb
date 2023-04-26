# Deck of Cards
# Using the Card class from the previous exercise, 
#  create a Deck class that contains all of the standard 52 playing cards. 
# Use the following code to start your work:

require "pry-byebug"

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    @cards = Array.new
    deal
    #binding.pry
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

# The Deck class should provide a #draw method to deal one card. 
# The Deck should be shuffled when it is initialized and, if it runs out of cards, 
# it should reset itself by generating a new set of 52 shuffled cards.

class Card
  include Comparable
  attr_reader :rank, :suit

  CARD_VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    VALUES.fetch(rank, rank)
  end

  def <=>(other)
    CARD_VALUES[self.rank] <=> CARD_VALUES[other.rank]
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

# Examples:

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.

# Note that the last line should almost always be true; if you shuffle the deck 1000 times a second, 
# you will be very, very, very old before you see two consecutive shuffles produce the same results. 
# If you get a false result, you almost certainly have something wrong.

