### Question 1
```ruby
ages.has_key?('Spot')
ages.key?('Spot')
ages.member?('Spot')
ages.include?('Spot')
```

### Question 2
```ruby
munsters_description = "The Munsters are creepy in a good way."
munsters_description.swapcase
# => "tHE mUNSTERS ARE CREEPY IN A GOOD WAY."
munsters_description.capitalize
# => "The munsters are creepy in a good way."
munsters_description.downcase
# => "the munsters are creepy in a good way."
munsters_description.upcase
# => "THE MUNSTERS ARE CREEPY IN A GOOD WAY."
```

### Question 3
```ruby
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10 }
additional_ages = { "Marilyn" => 22, "Spot" => 237 }

ages.merge!(additional_ages)

# or

additional_ages.each { |name, age| ages[name] = age }
```

### Question 4
There are a couple of options:
```ruby
advice.include?('dino')

advice.match?('dino')
```
Both of these would match a partial word, which may not be the desired effect. A better solution would be to use a regex with anchors to catch the beginning and end of each word.
```ruby
advice.match?(/\bdino\b/)
```

### Question 5
```ruby
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)
```

### Question 6
```ruby
flintstones << "Dino"

# or 

flintstones.push("Dino")
```

### Question 7
```ruby
flintstones += ["Dino","Hoppy"]

# or

flintstones.push("Dino", "Hoppy")
```

### Question 8
```ruby
advice.slice!(/^.*as /)
```
Bonus: If we instead used `#slice`, the return value would be the same but the value of `advice` would not be mutated and would retain the original full sentence.

### Question 9
```ruby
statement.count('t')
```

### Question 10
```ruby
WIDTH = 40
title = "Flintstone Family Members"
leading_space = (WIDTH - title.size) / 2
puts "#{' ' * leading_space}#{title}"
```