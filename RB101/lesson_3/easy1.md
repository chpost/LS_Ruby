### Question 1
The code will print out the original array values:
```
1
2
2
3
```
This is because `numbers.uniq` does not mutate the caller, so when `puts` is called on line 4, `numbers` still has it's original elements.

### Question 2
It's difficult to describe the difference between `!` and `?` in Ruby without going straight into how they are used.
1. `!=` is a comparison operator for "not equal" and should therefore be used in a boolean expression, i.e. `number != 5`.
2. When `!` comes before a variable, it will translate to a boolean value except in this case it will be the opposite. So if `user_name` is a truthy object (such as a valid string), then `!user_name` will be `false`.
3. Placing `!` after a method means it is part of the method name. A method that ends with `!` generally indicates that it mutates the caller, although this is a convention and not a rule.
4. `?` will come before something in the case of a ternary. This involves 3 operands: a boolean expression, a value for when the boolean is true, and a value for when the boolean is false. i.e. `num == 0 ? 'The number is 0!' : 'The number is not 0!'`
5. Similar to `!`, when `?` comes after a method, it is part of the method name. If a method ends with `?`, it generally means the method will return a boolean (true or false). Once again, this is a convention and not a rule.
6. `!!` is just using `!` twice, which will convert a variable to a boolean value. If a variable `obj` is anything other than `false` or `nil`, `!!obj` will return `true`.

### Question 3
Assuming that the original string should be mutated, the following code can be used to replace "important" with "urgent"
```ruby
advice = "Few things in life are as important as house training your pet dinosaur."
advice.sub!('important', 'urgent')
```
This will only affect the first occurence of the word "important," which is fine in this case. However, if there were more occurences and we wanted to change all of them, we should use `#gub!` instead of `#sub!`.

### Question 4
The difference between `Array#delete_at` and `Array#delete` is that `delete_at` will remove the element at a specified index in the array, whereas `delete` will remove the first occurence of the specified object/value.
```ruby
numbers = [1, 2, 3, 4, 5]

numbers.delete_at(1) # removes the element at numbers[1], which is 2
numbers.delete(1) # removes the first occurrence of 1 in the array which is numbers[0]
```

### Question 5
```ruby
num = 42
if (10..100).include?(num)
  puts "#{num} is between 10 and 100!"
else
  puts "#{num} is not between 10 and 100!"
end
```

### Question 6
```ruby
famous_words = "seven years ago..."

# Option 1
famous_words = "Four score and " + famous_words

# Option 2
famous_words.prepend("Four score and ")
```

### Question 7
We can make the array "un-nested" by using `#flatten`, which mutates the array in place and turns it into a single, one-dimensional array.
```ruby
flintstones.flatten!
```

### Question 8
```ruby
flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }
barney = flintstones.select { |name, number| name == 'Barney' }.to_a.flatten
```