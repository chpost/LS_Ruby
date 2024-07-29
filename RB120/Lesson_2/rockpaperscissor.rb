class Player
  attr_accessor :move, :name, :score

  def initialize(player_type = :human)
    @player_type = player_type
    @score = 0
    set_name
  end

  def reset_score
    self.score = 0
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Object.const_get(choice.capitalize).new
  end

  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end
end

class Computer < Player
  def choose
    self.move = Object.const_get(Move::VALUES.sample.capitalize).new
  end

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def ==(other)
    self.class == other.class
  end

  # def <(other)
  #   if rock?
  #     other.spock? || other.paper?
  #   elsif paper?
  #     other.lizard? || other.scissors?
  #   elsif scissors?
  #     other.spock? || other.rock?
  #   elsif lizard?
  #     other.rock? || other.scissors?
  #   else
  #     other.lizard? || other.paper?
  #   end
  # end

  # def >(other)
  #   if rock?
  #     other.scissors? || other.lizard?
  #   elsif paper?
  #     other.rock? || other.spock?
  #   elsif scissors?
  #     other.paper? || other.lizard?
  #   elsif lizard?
  #     other.paper? || other.spock?
  #   else
  #     other.rock? || other.scissors?
  #   end
  # end

  def rock?
    false
  end

  def paper?
    false
  end

  def scissors?
    false
  end

  def lizard?
    false
  end

  def spock?
    false
  end

  def to_s
    self.class.to_s.downcase
  end
end

class Rock < Move
  def >(other)
    [Scissors, Lizard].include? other.class
  end

  def <(other)
    [Paper, Spock].include? other.class
  end
end

class Paper < Move
  def >(other)
    [Rock, Spock].include? other.class
  end

  def <(other)
    [Scissors, Lizard].include? other.class
  end
end

class Scissors < Move
  def >(other)
    [Paper, Lizard].include? other.class
  end

  def <(other)
    [Rock, Spock].include? other.class
  end
end

class Lizard < Move
  def >(other)
    [Paper, Spock].include? other.class
  end

  def <(other)
    [Rock, Scissors].include? other.class
  end
end

class Spock < Move
  def >(other)
    [Scissors, Rock].include? other.class
  end

  def <(other)
    [Lizard, Paper].include? other.class
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playinng Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move == computer.move
      puts "It's a tie!"
    else
      puts "#{human.move > computer.move ? human.name : computer.name} won!"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def award_point
    if human.move > computer.move
      human.score += 1
    elsif computer.move > human.move
      computer.score += 1
    end
  end

  def someone_won?
    human.score == 10 || computer.score == 10
  end

  def display_score
    puts "Score: #{human.name} #{human.score} | #{computer.name} #{computer.score}"
  end

  def display_grand_winner
    puts "#{human.score == 10 ? human.name : computer.name } is the first to 10 and is the grand winner!"
  end

  def play
    display_welcome_message

    loop do
      human.reset_score
      computer.reset_score

      loop do
        human.choose
        computer.choose
        # system 'clear'

        display_score
        display_moves
        display_winner
        award_point
        break if someone_won?
      end

      display_grand_winner
      break unless play_again?
    end

    display_goodbye_message
  end
end

loop do
  RPSGame.new.play
  break unless play_again?
end
