SUITS = %w(C D H S)
CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

def prompt(msg)
  puts "=> #{msg}"
end

def score(hand)
  sort(hand).inject(0) { |sum, card| sum + value(card) }
end

def sort(hand)
  hand.sort do |card_a, card_b|
    a = card_a.split[0]
    b = card_b.split[0]

    CARD_VALUES.index(a) <=> CARD_VALUES.index(b)
  end
end

def value(card, total = 0)
  val = card.split[0]
  case val
  when '2'..'9' then val.to_i
  when '10', 'J', 'Q', 'K' then 10
  else total > 10 ? 1 : 11
  end
end

def new_deck
  deck = SUITS.map do |suit|
    CARD_VALUES.map { |val| "#{val} #{suit}" }
  end
  deck.flatten
end

deck = new_deck.shuffle
p deck
p deck.size

player_cards = [deck.shift, deck.shift]
dealer_cards = [deck.shift, deck.shift]

puts player_cards
puts score(player_cards)

puts dealer_cards
puts score(dealer_cards)
# player turn
loop do
  break
end
