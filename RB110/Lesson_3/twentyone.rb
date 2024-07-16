require 'pry-byebug'

SUITS = %w(C D H S)
CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
CARD_BORDER = "+-------+"
CARD_FRONT = "|       |"
CARD_BACK = "|XXXXXXX|"

def prompt(msg)
  puts "=> #{msg}"
end

def hit(deck)
  deck.shift
end

def card_left(card)
  val, suit = card.split
  "|#{(val + ' ' + to_icon(suit)).ljust(7, ' ')}|"
end

def card_right(card)
  val, suit = card.split
  "|#{(to_icon(suit) + ' ' + val).rjust(7, ' ')}|"
end

def print_dealer_hand(hand)
  print_hand = [
    "#{CARD_BORDER} #{CARD_BORDER}",
    "#{card_left(hand.first)} #{CARD_BACK}",
    "#{CARD_FRONT} #{CARD_BACK}",
    "#{CARD_FRONT} #{CARD_BACK}",
    "#{card_right(hand.first)} #{CARD_BACK}",
    "#{CARD_BORDER} #{CARD_BORDER}"
  ]

  puts print_hand.join("\n")
end

def print_hand(hand)
  print_hand = [
    [CARD_BORDER] * hand.size,
    hand.map(&method(:card_left)),
    [CARD_FRONT] * hand.size,
    [CARD_FRONT] * hand.size,
    hand.map(&method(:card_right)),
    [CARD_BORDER] * hand.size
  ]

  print_hand.map! { |line| line.join(' ') }
  puts print_hand.join("\n")
end

def to_icon(suit)
  icons = {
    'C' => 9827, 'D' => 9830,
    'H' => 9829, 'S' => 9824
  }
  icons[suit].chr('UTF-8')
end

def display(p_hand, d_hand, hide_dealer_card = true)
  system 'clear'
  puts "DEALER"
  if hide_dealer_card
    print_dealer_hand(d_hand)
  else
    print_hand(d_hand)
  end

  puts ''

  puts "PLAYER"
  print_hand(p_hand)
end

def score(hand)
  sort(hand).inject(0) { |sum, card| sum + value(card, sum) }
end

def sort(hand)
  hand.sort do |card_a, card_b|
    a = card_a.split[0]
    b = card_b.split[0]

    CARD_VALUES.index(a) <=> CARD_VALUES.index(b)
  end
end

def value(card, total)
  val = card.split[0]
  case val
  when '2'..'9' then val.to_i
  when '10', 'J', 'Q', 'K' then 10
  else total > 10 ? 1 : 11
  end
end

def busted?(hand)
  score(hand) > 21
end

def winner(player, dealer)
  if busted?(player)
    'dealer'
  elsif busted?(dealer)
    'player'
  elsif score(player) > score(dealer)
    'player'
  else
    'dealer'
  end
end

def new_deck
  deck = SUITS.map do |suit|
    CARD_VALUES.map { |val| "#{val} #{suit}" }
  end
  deck.flatten
end

deck = new_deck.shuffle
player = [hit(deck), hit(deck)]
dealer = [hit(deck), hit(deck)]

# player turn
loop do
  display(player, dealer)
  prompt "hit or stay?"
  answer = gets.chomp
  break if busted?(player) || answer.downcase.start_with?('s')
  player << hit(deck)
end

display(player, dealer, false)
prompt "The player busted!" if busted?(player)

# dealer turn
loop do
  break if busted?(player) || score(dealer) >= 17
  prompt "The dealer is going to hit"
  sleep 2
  dealer << hit(deck)
  display(player, dealer, false)
  if busted?(dealer)
    prompt "The dealer busted!"
    break
  end
end

prompt "The #{winner(player, dealer)} won!"
