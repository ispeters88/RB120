require "pry-byebug"
require "yaml"
MSG = YAML.load_file("21.yml")

module Viewable
  PROMPT_DELAY = 0.5

  def display_hand
    prompt "#{name}'s hand contains the following cards:"
    hand.each do |card, _|
      prompt "#{card.value} of #{card.suit}"
    end
    sleep(1)
  end

  def display_hand_score
    prompt "#{name}'s current score is #{hand_score}"
    sleep(1)
  end

  def display_results
    if [@dealer, @punter].all?(&:bust?)
      prompt "No one really wins this time"
    elsif tie?
      prompt "Its a push, how boring...."
    else
      winner, _loser = determine_results
      prompt "The winner is #{winner}!"
    end
  end

  def determine_results
    if [@dealer, @punter].one?(&:bust?)
      loser, winner = [@dealer, @punter].partition(&:bust)
    else
      winner = [@dealer, @punter].max_by(&:hand_score)
      loser = [@dealer, @punter].min_by(&:hand_score)
    end
    [winner, loser]
  end

  def display_hand_smart
    size = hand.size
    card_width = 80 / size - (size * 3)

    horiz_border = "+#{'-' * card_width}+ #{' ' * 4}" * size
    spacer_line = "|#{' ' * card_width}| #{' ' * 4}" * size

    top_val, bottom_val = card_value_lines

    puts horiz_border
    puts spacer_line
    puts top_val
    6 * spacer_line
    puts bottom_val
    puts spacer_line
    puts horiz_border
  end

  def card_value_lines; end

  def prompt(str='', delay=PROMPT_DELAY)
    puts ">> " + str
    sleep(delay)
  end

  def delayed_screen_wipe(delay=0.5)
    sleep(delay)
    system "clear"
  end
end

module Formattable
  def format_move(move)
    move.downcase.strip.gsub(/[^a-zA-Z]/, "")
  end
end

module Interactable
  def hit_or_stay
    choice = nil
    loop do
      prompt MSG["hit_or_stay"]
      choice = format_move(gets.chomp)
      break if ['h', 's'].include?(choice[0])
      prompt MSG["hit_or_stay_error"]
    end
    choice
  end
end

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def draw(size=6)
    card_output = Array.new
    horiz_border = "+#{'-' * size}+"
    spacer_line = "|#{' ' * size}|"

    top_value_line = "|#{value}#{' ' * (size - value.length)}|"
    bottom_value_line = "|#{' ' * (size - value.length)}#{value}|"

    [horiz_border, top_value_line,
     spacer_line * size,
     bottom_value_line, horiz_border].each { |piece| card_output << piece }

    card_output
  end
end

class Deck
  attr_accessor :card_list

  CARD_VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10',
                 'J', 'Q', 'K', 'A']
  SUITS = ['Hearts', 'Clubs', 'Spades', 'Diamonds']

  def initialize
    @card_list = Array.new
    add_cards_to_deck
  end

  def add_cards_to_deck
    SUITS.product(CARD_VALUES).each do |suit, value|
      @card_list << Card.new(suit, value)
    end
  end

  def shuffle!
    Dealer::SHUFFLE_REPEATS.times do
      card_list.shuffle!
    end
  end

  def reset; end
end

class Player
  include Viewable
  include Formattable
  include Interactable

  def initialize
    @hand = Hash.new
  end

  def hand_score
    hand.keys.inject(0) do |score, card|
      if card.value == 'A'
        score + (score > 10 ? 1 : 11)
      else
        score + (card.value.to_i.between?(2, 9) ? card.value.to_i : 10)
      end
    end
  end

  def bust?
    hand_score > 21
  end

  def won?
    hand_score == 21
  end

  def to_s
    name
  end
end

class Dealer < Player
  SHUFFLE_REPEATS = 50
  attr_accessor :deck, :punter, :hand
  attr_reader :name

  def initialize(deck, punter)
    super()
    @deck = deck
    @punter = punter
    @name = 'Computer'
  end

  def prep_game
    delayed_screen_wipe(0)
    @deck.shuffle!
    deal_hands
  end

  def turn
    loop do
      game_update(self)
      break if hand_score >= 17 || bust?
      hand[deal_card!] = 'Y'
    end
  end

  def deal_hands
    deal_turn = @punter
    1.upto(2) do |num|
      visible = (num == 1 ? 'N' : 'Y')
      2.times do
        deal_turn.hand[deal_card!] = visible
        deal_turn = alternate_deal_turn(deal_turn)
      end
    end
  end

  def deal_card!
    @deck.card_list.shift
  end

  def alternate_deal_turn(turn)
    [@punter, self].select { |player| player != turn }.first
  end

  def punter_turn
    loop do
      game_update(@punter)
      break if @punter.won? || hit_or_stay == 's'
      delayed_screen_wipe(1)
      prompt MSG["hit"]
      @punter.hand[deal_card!] = 'Y'
      break if @punter.bust?
    end
  end

  def game_update(player)
    player.display_hand
    player.display_hand_score
  end
end

class Punter < Player
  attr_accessor :hand
  attr_reader :name

  def initialize
    super
    @name = enter_name
  end

  def enter_name
    "Isaac"
  end
end

class Game
  include Viewable

  def initialize
    @deck = Deck.new
    @punter = Punter.new
    @dealer = Dealer.new(@deck, @punter)
  end

  def play
    @dealer.prep_game

    @dealer.punter_turn
    if @punter.bust?
      prompt "#{@punter.name} busted."
      return
    end

    @dealer.turn
    if @dealer.bust?
      prompt "#{@dealer.name} busted!"
    end

    display_results
  end

  def determine_winner; end

  def tie?
    [@dealer, @punter].map(&:hand_score).uniq.size == 1
  end
end

game = Game.new
game.play
