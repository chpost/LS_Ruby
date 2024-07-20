require 'pry-byebug'

SUITS = %w(C D H S)
MAX_VALUE = 21
DEALER_SAFE_VALUE = 17
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

def display(p_hand, d_hand, p_total, d_total, p_score, d_score, hide_dealer_card: true)
  system 'clear'
  puts '=' * 28
  puts "TWENTY ONE"
  puts "wins -> player: #{p_score}, dealer: #{d_score}"
  puts '=' * 28
  puts "Dealer: total #{d_total}"
  if hide_dealer_card
    print_dealer_hand(d_hand)
  else
    print_hand(d_hand)
  end

  puts ''

  puts "Player: total #{p_total}"
  print_hand(p_hand)
  puts '=' * 28
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
  aces.size.times { total -= 10 if total > MAX_VALUE }

  total
end

def busted?(total)
  total > MAX_VALUE
end

def detect_winner(player, dealer)
  return :dealer if busted?(player)

  if busted?(dealer) || player > dealer
    :player
  elsif player == dealer
    :tie
  else
    :dealer
  end
end

def deal
  deck = SUITS.map do |suit|
    CARD_VALUES.map { |val| "#{val} #{suit}" }
  end

  deck.flatten!.shuffle!
  player = []
  dealer = []
  2.times do
    player << deck.shift
    dealer << deck.shift
  end

  [deck, player, dealer]
end

def play_again?
  prompt "Would you like to play again? (y/n)"
  answer = gets.chomp[0].downcase
  answer == 'y'
end

prompt "Welcome to Twenty-One!"

loop do
  player_score = 0
  dealer_score = 0
  winner = nil

  loop do
    deck, player, dealer = deal
    player_total = score(player)
    dealer_total = score([dealer.first])

    # player turn
    loop do
      display(player, dealer, player_total, dealer_total, player_score, dealer_score)

      answer = ''
      loop do
        prompt "Are you going to (h)it or (s)tay?"
        answer = gets.chomp[0].downcase
        break if ['s', 'h'].include?(answer)
        prompt "Invalid input, enter 'h' or 's'."
      end

      if answer == 'h'
        player << hit(deck)
        player_total = score(player)
        prompt "The player is going to hit!"
      else
        prompt "The player is going to stay!"
      end

      sleep 1.5
      break if busted?(player_total) || answer == 's'
    end

    dealer_total = score(dealer)
    display(player, dealer, player_total, dealer_total, player_score, dealer_score, hide_dealer_card: false)
    prompt "The player busted!" if busted?(player_total)

    # dealer turn
    loop do
      break if busted?(player_total) || busted?(dealer_total)
      if dealer_total >= DEALER_SAFE_VALUE
        prompt "The dealer is going to stay!"
        sleep 1.5
        break
      else
        prompt "The dealer is going to hit!"
        dealer << hit(deck)
        dealer_total = score(dealer)
      end

      sleep 1.5
      display(player, dealer, player_total, dealer_total, player_score, dealer_score, hide_dealer_card: false)
    end

    prompt "The dealer busted!" if busted?(dealer_total)

    winner = detect_winner(player_total, dealer_total)
    prompt (winner == :tie ? "It's a tie!" : "The #{winner} won!")
    gets

    case winner
    when :player
      player_score += 1
    when :dealer
      dealer_score += 1
    end

    break if player_score == 5 || dealer_score == 5
  end

  prompt "The #{winner} has won 5 rounds and is the grand winner!"
  break if !play_again?
end

prompt "Thanks for playing! Good bye!"
