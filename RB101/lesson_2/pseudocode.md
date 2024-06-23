## Sum of Two Integers

### Casual

```
Given two integers

Add the first and second value

Return the resulting integer
```

### Formal

```
START

# Given two integers

SET sum = number1 + number2

RETURN sum

END
```

## Concatenate Array of Strings

### Casual

```
Given a collection of strings.

Initialize return value as an empty string.

Iterate through the collection.
  - add each value to the current string

Aftter iterating through the collection, return the resulting string.
```

### Formal

```
START

# Given a collection of strings called "strings"

SET index = 1
SET result = ''

WHILE index <= length of strings
  SET current_string = value within strings collection at space "index"
  result = result + current_string

  index = index + 1

RETURN result

END
```

## Every Other Integer in Array

### Casual

```
Given a collection of integers.

Iterate through the collection.
  - for each iteration, check if the position in the collection is even or odd.
  - if the position is odd
    - add the value to the resulting collection
  - otherwise
    - move on to the next iteration

After iterating through the collection, return the resulting collection.
```

### Formal

```
START

# Given a collection of integers called "numbers"

SET index = 1
SET result = empty collection

WHILE index <= length of numbers
  SET current_number = value within numbers at "index"
  IF index is odd
    result = result + current_number

  index = index + 1

RETURN result

END
```

## 3rd Occurence in String

### Casual

```
Given a character and string.

Separate string into a collection of characters.

Use an integer to track how many times the character appears.

Iterate through the collection.
  - for each iteration, compare the current character to the given character.
  - if current character equals given character
    - add 1 to the character count collection
    - return the current position if the 3rd occurence is found
  - otherwise
    - move on to the next iteration

Return nothing (nil) if the third occurence was not found.
```

### Formal

```
START

# Given a character "char" and a string "string"

SET index = 1
SET occurences = 0
SET characters = collection of characters in string

WHILE index <= length of characters
  SET current_char = value within characters at "index"
  IF current_char == char
    occurences = occurences + 1
    IF occurences == 3
      RETURN index
  
  index = index + 1

RETURN nil

END
```

## Merge Two Arrays of Numbers

### Casual

```
Given a two collections of integers.

Make copies of both original arrays.

Determine total combined length of the two collections.

Iterate from 0 to the total length
  - for each iteration, check if the position is even or odd.
  - if the position is odd
    - remove the first value from the first collection
    - add the value to the merged collection
  - otherwise
    - remove the first value from the second array
    - add the value to the merged collection

After iterating to the total length, return the resulting collection.
```

### Formal

```
START

# Given a two collections of integers called "numbers1" and "numbers2"

SET index = 1
SET length = number of elements in numbers1 + number of elementts in numbers2
SET result = empty collection

WHILE index <= length
  IF index is odd
    current_number = first element in numbers1
    # remove from numbers1
  ELSE
    current_number = first element in numbers2
    # remove from numbers2
  
  result = result + current_number
  index = index + 1

RETURN result

END
```