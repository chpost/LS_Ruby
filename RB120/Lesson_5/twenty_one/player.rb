class Participant
  attr_reader :name, :cards
  attr_accessor :score

  def initialize
    @cards = []
    @score = 0
  end

  def new_hand
    cards.clear
  end

  def display_hand
    puts "#{name} | wins => #{score}"
    puts(cards.map(&:layout).transpose.map { |line| line.join ' ' })
    puts "Total => #{total}"
  end

  def to_s
    name
  end

  def <=>(other)
    total <=> other.total
  end

  def busted?
    total > 21
  end

  def total
    total = cards.map(&:value).sum

    aces = cards.count(&:ace?)
    aces.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end

class Player < Participant
  def initialize(name)
    super()
    @name = name
  end
end

class Dealer < Participant
  def initialize
    super()
    @name = ['Ben Campbell', 'Micky Rosa', 'Kate Bosworth'].sample
  end

  def display_flop
    puts "#{name} | wins => #{score}"
    puts([cards.first.layout, cards.last.layout(hide: true)]
           .transpose.map { |line| line.join ' ' })
    puts "Total => #{cards.first.value}"
  end
end
