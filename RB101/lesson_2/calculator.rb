require 'yaml'

LANGUAGE = ARGV[0] ? ARGV[0] : 'en'
ARGV.clear()

MESSAGES = YAML.load_file('calculator_messages.yml')

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(key, values={})
  message = messages(key, LANGUAGE)
  message = sprintf(message, values) if values != {}
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  num =~ /^[-+]?\d+$/
end

def number?(num)
  num =~ /^[-+]?\d*\.?\d+$/
end

def operation_to_message(op, lang='en')
  messages('operation', lang)[op.to_i]
end

prompt('welcome')

name = ''
loop do
  name = Kernel.gets().chomp()

  if name.empty?()
    prompt('valid_name')
  else
    break
  end
end

prompt('greeting', {name: name})

loop do # main loop
  number1 = ''
  loop do
    prompt('first_number')
    number1 = Kernel.gets().chomp()

    if valid_number?(number1)
      break
    else
      prompt('valid_number')
    end
  end

  number2 = ''
  loop do
    prompt('second_number')
    number2 = Kernel.gets().chomp()

    if valid_number?(number2)
      break
    else
      prompt('valid_number')
    end
  end

  prompt('operator')

  operator = ''
  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt('valid_operator')
    end
  end

  prompt('operation_message', {operation: operation_to_message(operator)})

  result = case operator
           when '1'
             number1.to_i() + number2.to_i()
           when '2'
             number1.to_i() - number2.to_i()
           when '3'
             number1.to_i() * number2.to_i()
           else
             number1.to_f() / number2.to_f()
           end

  prompt('result', {result: result})

  prompt('again')
  answer = Kernel.gets().chomp()

  break unless answer.downcase().start_with?('y')
end

prompt('goodbye')
