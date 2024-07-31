class Card
  attr_reader :suit, :face
  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def value
    if ace?
      11
    elsif ten?
      10
    else
      face.to_i
    end
  end

  def ten?
    %w(J Q K).include? face
  end

  def ace?
    face == 'A'
  end

  def display(hide_face: false)
    if hide_face
      top = '??'
      bottom = top
    else
      top = face + suit
      bottom = suit + face
    end

    [
      "+-------+",
      "| #{top.ljust(6, ' ')}|",
      "|       |",
      "|       |",
      "|#{bottom.rjust(6, ' ')} |",
      "+-------+"
    ]
  end

  def to_s
    "#{@value}#{suit}"
  end
end

class Deck
  SUITS = [9827, 9830, 9829, 9824].map { |n| n.chr('UTF-8') }
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  attr_accessor :cards

  def initialize
    @cards = SUITS.product(VALUES).map { |ele| Card.new(*ele) }
    shuffle!
  end

  def shuffle!
    cards.shuffle!
  end


  def >>(participant)
    participant << @cards.pop
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    puts cards.map(&:display).transpose.map { |line| line.join ' ' }
    puts "=> Total: #{total}"
    puts ""
  end

  def total
    total = cards.map(&:value).sum

    # correct for Aces
    cards.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def <<(card)
    cards << card
  end

  def busted?
    total > 21
  end
end

class Participant
  include Hand

  attr_accessor :name, :cards

  def initialize
    @cards = []
    set_name
  end
end

class Player < Participant
  def set_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, must enter a value."
    end
    self.name = name
  end

  def show_flop
    show_hand
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    self.name = ROBOTS.sample
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts [cards.first.display, cards.last.display(hide_face: true)]
            .transpose.map { |line| line.join ' ' }
  end
end

class TwentyOne
  attr_accessor :deck, :player, :dealer

  def initialize
    puts "Welcome to Twenty-One!"
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def deal_cards
    2.times do
      deck >> player
      deck >> dealer
    end
  end

  def show_flop
    system 'clear'
    player.show_flop
    dealer.show_flop
  end

  def player_turn
    loop do
      show_flop
      puts "#{player.name}'s turn..."

      puts "Would you like to (h)it or (s)tay?"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if ['h', 's'].include? answer
        puts "Sorry, must enter 'h' or 's'."
      end

      if answer == 's'
        puts "#{player.name} stays!"
        sleep 2
        break
      elsif player.busted?
        break
      else
        deck >> player
        puts "#{player.name} hits!"
        break if player.busted?
      end
    end
  end

  def dealer_turn
    loop do
      show_cards
      puts "#{dealer.name}'s turn..."

      if dealer.total >= 17 &&!dealer.busted?
        puts "#{dealer.name} stays!"
        sleep 2
        break
      elsif dealer.busted?
        break
      else
        puts "#{dealer.name} hits!"
        sleep 2
        deck >> dealer
      end
    end
  end

  def show_busted
    show_cards
    if player.busted?
      puts "It looks like #{player.name} busted! #{dealer.name} wins!"
    elsif dealer.busted?
      puts "It looks like #{dealer.name} busted! #{player.name} wins!"
    end
    gets
  end

  def show_cards
    system 'clear'
    player.show_hand
    dealer.show_hand
  end

  def show_result
    if player.total > dealer.total
      puts "It looks like #{player.name} wins!"
    elsif player.total < dealer.total
      puts "It looks like #{dealer.name} wins!"
    else
      puts "It's a tie!"
    end
    gets
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def start
    loop do
      deal_cards

      player_turn
      if player.busted?
        show_busted
        if play_again?
          reset
          next
        else
          break
        end
      end

      dealer_turn
      if dealer.busted?
        show_busted
        if play_again?
          reset
          next
        else
          break
        end
      end

      show_cards
      show_result
      play_again? ? reset : break
    end

    puts "Thank you for playing Twenty-One. Goodbye!"
  end
end

TwentyOne.new.start