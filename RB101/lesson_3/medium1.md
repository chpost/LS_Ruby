### Question 1
```ruby
10.times { |i| puts "#{' ' * i}The Flintstones Rock!" }
```

### Question 2
The error is a TypeError due to trying to concatenate `(40 + 2)` to the preceding string. Two ways to fix this are as follows:
```ruby
# call to_s on resulting value to cast it to a string
puts "the value of 40 + 2 is " + (40 + 2).to_s

# use interpolation to insert the value
puts "the value of 40 + 2 is #{40 + 2}"
```

### Question 3
```ruby
def factors(number)
  divisor = number
  factors = []
  until divisor <= 0
    factors << number / divisor if number % divisor == 0
    divisor -= 1
  end
  factors
end
```

Or we could easily replace this logic with a one-line operation
```ruby
def factors(number)
  (1..number).select { |divisor| number % divisor == 0 }
end
```

Bonus 1: The purpose of `number % divisor == 0` is to check if there is any remainder when dividing `number` by `divisor`. If there is no remainder, then it is a factor.

Bonus 2: The purpose of `factors` on line 8 is to return the array of factors. If there is no explicit return value, a method will return the last evaluated value.

### Question 4
There are a couple of differences between these implementations.

`rolling_buffer1`
1. This implementation is mutating and will modify the passed `buffer` array in place.
2. It returns the `buffer` object, although it does not necessarily need to because it has already mutated the value.

`rolling_buffer2`
1. This implementation is non-mutating and creates a new array object in memory.
2. It returns the new `buffer`, which will need to be assigned to the desired variable in order to complete the update of information, otherwise this method will effectively do nothing

### Question 5
The `limit` variable is not visible in the method scope. Two ways to resolve this are to make the variable a constant (`LIMIT`) or pass it as a third argument to the method:
```ruby
# line 3
def fib(first_num, second_num, limit)

# line 12
result = fib(0, 1, limit)
```

### Question 6
The output is `34` because `mess_with_it` does not perform operation (and `answer` is immutable). Therefore, the value of `answer` has not changed.

### Question 7
Yes, the family's data was ransacked. Although the method did not mutate the array itself, it does mutate each element causing all the ages to be increased and all genders to be changed to "other"

### Question 8
The call will result with "paper". It must first evaluate the innermost calls to `rps` and work outward in order to have the arguments necessary for the outermost call.

### Question 9
The return value is "yes". While `foo` uses the default parameter of `"no"`, it does not do anything with this value and simply returns `"yes"`. Then `bar` uses this value instead of the default, which then makes the ternary statement false because "yes" does not equal "no". The false branch is executed, which returns `"no"`.