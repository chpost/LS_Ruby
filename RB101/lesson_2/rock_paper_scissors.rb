VALID_CHOICES = {
  'r' => 'rock', 'p' => 'paper',
  'sc' => 'scissors', 'l' => 'lizard',
  'sp' => 'spock'
}

def prompt(message)
  puts("=> #{message}")
end

def win?(first, second)
  win_conditions = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['rock', 'scissors']
  }
  win_conditions[first].include?(second)
end

def update_score(scores, player, computer)
  if win?(player, computer)
    scores[:player] += 1
  elsif win?(computer, player)
    scores[:computer] += 1
  end
end

def display_score(scores)
  prompt(
    "Current score: You - #{scores[:player]}; Computer - #{scores[:computer]}"
  )
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

loop do
  score = {
    player: 0,
    computer: 0
  }

  loop do
    choice = ''
    loop do
      prompt("Choose one: #{
        VALID_CHOICES
          .map { |key, value| "#{value} (#{key})" }
          .join(', ')
      }")
      choice = gets.chomp

      if VALID_CHOICES.keys.include?(choice)
        choice = VALID_CHOICES[choice]
        break
      elsif VALID_CHOICES.values.include?(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.values.sample

    prompt("You chose: #{choice}; Computer chose: #{computer_choice}")
    display_results(choice, computer_choice)

    update_score(score, choice, computer_choice)
    display_score(score)

    if score[:player] == 3
      prompt("You won 3 rounds and are the grand winner!")
      break
    elsif score[:computer] == 3
      prompt("Computer won 3 rounds and is the grand winner!")
      break
    end
  end

  prompt("Do you want to play again?")
  answer = gets.chomp.downcase
  break unless answer == 'y'
end

prompt("Thank you for playing. Good bye!")
