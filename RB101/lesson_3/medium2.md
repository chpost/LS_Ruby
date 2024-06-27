### Question 1
All 3 variables will have the same value, however there are 2 different objects in memory. a and c reference the same object, so the first and third `object_id` will be identical and the second will be different.

### Question 2
Integers are immutable in Ruby and as such there is only one instance of the object. It will continue to exist as long as one object references the object and any other variables assigned the integer value will also point to that object.

### Question 3
`string_arg_one` will be unchanged because the operation that happens is assignment, which is non mutating and does not change the original object. `string_arg_two` will be affected because `<<` is a mutating operation and concatenates to the orginal string in place in memory. The display will be:
```
String_arg_one looks like this now: pumpkins
String_arg_two looks like this now: pumpkinsrutabaga
```

### Question 4
This time, the string parameter is mutated in place because of the `<<` operator. However, once again the other operation is assignment and is not mutated. The original array is unaffected.
```
My string looks like this now: pumpkinsrutabaga
My array looks like this now: ["pumpkins"]
```

### Question 5
In order to change both values without mutating either of the arguments, we can use assignment within the method, package them into an array, and assign the original variables to the corresponding return value:
```ruby
def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param += ["rutabaga"]
  [a_string_param, an_array_param]
end

my_string = "pumpkins"
my_array = ["pumpkins"]
my_string, my_array = tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"
```

### Question 6
One way to simplify this method is to put all valid colors in an array and check the argument against the array to see if it is a member. We can then simply return the result of this check as it will already be `true` or `false`.
```ruby
def color_valid(color)
  valid_colors = %w(blue green)
  valid_colors.include?(color)
end
```