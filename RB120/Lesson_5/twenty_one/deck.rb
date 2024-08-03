require 'yaml'

class Deck < Array
  def initialize
    cards = Card::RANKS.product Card::SUITS
    cards.map! { |info| Card.new(*info) }
    super(cards)
    shuffle!
  end

  def >>(target)
    target.cards << pop
  end
end

class Card
  RANKS = ((2..10).to_a + %w(J Q K A)).freeze
  SUITS = %w(♣ ♦ ♥ ♠).freeze
  CARD_LAYOUT = YAML.load_file('card.yml')

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    if ace?
      11
    elsif face?
      10
    else
      rank
    end
  end

  def ace?
    rank == 'A'
  end

  def face?
    rank.instance_of? String
  end

  def layout(hide: false)
    CARD_LAYOUT.map do |line|
      format line, hide ? { rank: '?', suit: '?' } : { rank: rank, suit: suit }
    end
  end
end
