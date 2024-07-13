SUITS = %w(C D H S)
CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
def new_deck
  deck = SUITS.map do |suit|
    CARD_VALUES.map { |val| "#{val} #{suit}" }
  end
  deck.flatten
end

deck = new_deck.shuffle
p deck
p deck.size
