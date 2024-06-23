require 'yaml'

LANGUAGE = ARGV[0] || 'en'
ARGV.clear

MESSAGES = YAML.load_file('loan_messages.yml')

def messages(message)
  MESSAGES[LANGUAGE][message]
end

def prompt(key, data={})
  message = messages(key)
  message = format(message, data) if !data.empty?
  Kernel.puts("=> #{message}")
end

def get_input(key, validator=:valid_number?)
  input = ''
  loop do
    prompt(key)
    input = gets.chomp

    if method(validator).call(input)
      break
    else
      prompt("valid_#{key}")
    end
  end

  input
end

def valid_number?(num)
  num =~ /^\d+$/
end

prompt('welcome')
name = gets.chomp

prompt('greeting', { name: name })

loop do
  loan_amount = get_input('loan_amount').to_i
  rate = get_input('rate').to_f / 100 / 12
  duration = get_input('duration').to_i * 12

  monthly_payment = loan_amount * (rate / (1 - ((1 + rate)**(-duration))))

  prompt('calculating')
  prompt('payment', { payment: monthly_payment })

  prompt('again')
  input = gets.chomp.downcase

  break if input != 'y'
end

prompt('goodbye')
