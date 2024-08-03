%w(yaml io/console).each { |f| require f }
%w(deck player display).each { |f| require_relative f }

class Game
  include Display

  def initialize
    @dealer = Dealer.new
    start
  end

  def start
    clear_and_display_message :welcome
    set_name
    choose_game_mode
    loop do
      reset
      play
      display_final_result unless mode == :single
      break unless play_again?
    end
    clear_and_display_message :goodbye
  end

  private

  MESSAGES = YAML.load_file('messages.yml')
  GAME_MODES = { 1 => :single, 2 => :best_of, 3 => :first_to }.freeze

  attr_reader :player, :dealer, :mode, :target
  attr_accessor :deck, :remaining_rounds

  def display_message(key, data = nil)
    message = MESSAGES[key.to_s]
    message = format(message, data) if data
    puts message
  end

  def detect_grand_winner
    return if player.score == dealer.score
    player.score > dealer.score ? player : dealer
  end

  def display_final_result
    winner = detect_grand_winner
    if !winner
      clear_and_display_message(
        :grand_tie, { player: player, dealer: dealer, score: player.score }
      )
      return
    end
    clear_and_display_message(winner == player ? :grand_win : :grand_lose,
                              { winner: winner, score: winner.score })
  end

  def set_name
    name = nil
    loop do
      display_message :set_name
      puts
      name = gets.chomp.strip
      break unless name.empty?
      display_message :valid_name
    end
    @player = Player.new(name)
  end

  def choose_game_mode
    choice = nil
    loop do
      clear_and_display_message :choose_mode
      choice = gets.chomp
      break if number?(choice) && GAME_MODES.key?(choice.to_i)
      if choice == '?'
        clear_and_display_message :mode_info
        pause
      else
        display_message :valid_mode
      end
    end

    @mode = GAME_MODES[choice.to_i]
    set_target if [:best_of, :first_to].include? mode
  end

  def set_target
    target = nil
    loop do
      display_message :set_target
      target = gets.chomp
      break if valid_target? target
      display_message :valid_target
    end
    @target = target.to_i
    @remaining_rounds = @target if mode == :best_of
  end

  def number?(input)
    input =~ /\A[0-9]+\z/
  end

  def valid_target?(input)
    number?(input) && (3..15).include?(input.to_i)
  end

  def play
    loop do
      new_round
      deal
      player_turn
      dealer_turn unless player.busted?
      display_result
      pause
      @remaining_rounds -= 1 if mode == :best_of
      break if condition_met?
    end
  end

  def condition_met?
    case mode
    when :single then true
    when :best_of then remaining_rounds < (player.score - dealer.score).abs
    when :first_to then player.score == target || dealer.score == target
    end
  end

  def deal
    2.times do
      deck >> player
      deck >> dealer
    end
    display_cards
  end

  def new_round
    self.deck = Deck.new
    player.new_hand
    dealer.new_hand
  end

  def reset
    new_round
    return if mode == :single
    player.score = 0
    dealer.score = 0
  end

  def play_again?
    answer = nil
    loop do
      display_message :play_again
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      display_message :invalid
    end
    answer == 'y'
  end

  def hit_or_stay
    choice = nil
    loop do
      display_message :hit_or_stay
      choice = gets.chomp.downcase
      break if ['h', 'hit', 's', 'stay'].include? choice
    end
    choice.start_with?('h') ? :hit : :stay
  end

  def player_turn
    loop do
      choice = hit_or_stay
      deck >> player if choice == :hit
      display_cards
      display_message choice, { participant: player }
      delay
      break if player.busted? || choice == :stay
    end
  end

  def dealer_turn
    display_cards(dealer_turn: true)

    loop do
      choice = dealer.total <= 17 ? :hit : :stay
      deck >> dealer if choice == :hit
      display_cards dealer_turn: true
      display_message choice, { participant: dealer }
      delay
      break if dealer.busted? || choice == :stay
    end
  end

  def display_cards(dealer_turn: false)
    clear_screen

    player.display_hand
    display_message :hr
    dealer_turn ? dealer.display_hand : dealer.display_flop
    puts
  end

  def detect_winner_loser
    return if player.total == dealer.total
    participants = [player, dealer]
    busted = participants.find(&:busted?)
    winner = busted ? participants.min : participants.max

    winner.score += 1 if winner

    [winner, busted]
  end

  def display_result
    winner, busted = detect_winner_loser

    display_cards(dealer_turn: true)

    display_message(:busted, { busted: busted }) if busted
    winner ? display_message(:win, { winner: winner }) : display_message(:tie)
  end
end

Game.new
