### Question 1
Originally I thought the code would throw an error, but it would seem that greeting is recognized as a local variable since the if statement is in scope. However, since the statement does not get evaluated due to the `false` condition, `greeting` has a value of `nil`.

### Question 2
`informal_greeting` points to the same object in memory as the value associated with `:a` in the hash, so when `informal_greeting` is mutated on line 3, the hash is affected as well.
```
{:a=>"hi there"}
```

### Question 3
```
# A
one is: one
two is: two
three is: three

# B
one is: one
two is: two
three is: three

# C
one is: two
two is: three
three is: one
```

### Question 4
```ruby
def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false if dot_separated_words.size != 4
  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    next if is_an_ip_number?(word)
    return false
  end
  return true
end

def is_an_ip_number?(string)
  string =~ /\A\d{1,3}\z/ && (0..255).include?(string.to_i)
end
```