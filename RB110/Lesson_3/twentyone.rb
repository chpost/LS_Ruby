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
  "|#{"#{val} #{to_icon(suit)}".ljust(7, ' ')}|"
end

def card_right(card)
  val, suit = card.split
  "|#{"#{to_icon(suit)} #{val}".rjust(7, ' ')}|"
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

def display(p_hand, d_hand, hide_dealer_card: true)
  system 'clear'
  puts "DEALER: total #{hide_dealer_card ? value(d_hand.first) : score(d_hand)}"
  if hide_dealer_card
    print_dealer_hand(d_hand)
  else
    print_hand(d_hand)
  end

  puts ''

  puts "PLAYER: total #{score(p_hand)}"
  print_hand(p_hand)
end

def score(hand)
  aces, other = hand.partition { |card| card.start_with?('A') }
  total = (other.map do |card|
    val = card.split[0]
    if ('2'..'9').include?(val)
      val.to_i
    else
      10
    end
  end).sum

  total += aces.size * 11
  aces.size.times { total -= 10 if total > 21 }

  total
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

def busted?(hand)
  score(hand) > 21
end

def winner(player, dealer)
  return 'dealer' if busted?(player)

  if busted?(dealer) || score(player) > score(dealer)
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

prompt "Welcome to Twenty-One!"

loop do
  deck = new_deck.shuffle
  player = [hit(deck), hit(deck)]
  dealer = [hit(deck), hit(deck)]

  # player turn
  loop do
    display(player, dealer)

    answer = ''
    loop do
      prompt "Are you going to (h)it or (s)tay?"
      answer = gets.chomp[0].downcase
      break if ['s', 'h'].include?(answer)
      prompt "Invalid input, enter 'h' or 's'."
    end

    if answer == 'h'
      player << hit(deck)
      prompt "The player is going to hit!"
      sleep 1.5
    end

    break if busted?(player) || answer == 's'
  end

  display(player, dealer, hide_dealer_card: false)
  prompt "The player busted!" if busted?(player)

  # dealer turn
  loop do
    break if busted?(player) || score(dealer) >= 17
    prompt "The dealer is going to hit!"
    sleep 1.5
    dealer << hit(deck)
    display(player, dealer, hide_dealer_card: false)
    if busted?(dealer)
      prompt "The dealer busted!"
      break
    end
  end

  prompt "The #{winner(player, dealer)} won!"

  prompt "Would you like to play again? (y/n)"
  play_again = (gets.chomp.downcase[0] == 'y')
  break if !play_again
end

prompt "Thanks for playing! Good bye!"
