# Roman Numerals Helper
# Create a RomanNumerals class that can convert a roman numeral to and from an integer value. It should follow the API demonstrated in the examples below. Multiple roman numeral values will be tested for each helper method.
# 
# Modern Roman numerals are written by expressing each digit separately 
# starting with the left most digit and skipping any digit with a value of zero. 
# In Roman numerals 1990 is rendered: 1000=M, 900=CM, 90=XC; resulting in MCMXC. 
# 2008 is written as 2000=MM, 8=VIII; or MMVIII. 1666 uses each Roman symbol in descending order: MDCLXVI.
# 
# Input range : 1 <= n < 4000
# 
# In this kata 4 should be represented as IV, NOT as IIII (the "watchmaker's four").

# Observation
#   > All digit values are represented by either 1, or 2-4 letters in roman numeral format. They are represented by 1 letter
#     when the digit value matches the standard key of the roman numeral conversion chart. They are represented by 2-4 letters
#     when they do not.

# General algorithm
# 1) form an array of zero-padded representations of each "digit value" of the input string
#     > digit value here means - the digit with its associated 10s place

class RomanNumerals
  DIGITS = [0, 1, 5, 10, 50, 100, 500, 1000]
  ROMANS = ['', 'I', 'V', 'X', 'L', 'C', 'D', 'M']
  # Make a hash with integer keys and roman numeral equivalent values
  CONV_CHART = [DIGITS, ROMANS].transpose.to_h
  
  def self.to_roman(int)
    # Represent the integer as an array of its place values
    place_values = get_place_values(int)
    # Convert each place value to its (string) roman numeral equivalent, then join them
    place_values.map do |place_value|
      convert_pv(place_value)
    end.join
  end

  def self.from_roman(str)
    int, idx = 0, 0
    len = str.length
    
    loop do
      break if idx == len
      if idx == len - 1
        int += CONV_CHART.key(str[idx])
      elsif ROMANS.find_index(str[idx]) < ROMANS.find_index(str[idx + 1])
        int += CONV_CHART.key(str[idx+1])
        int -= CONV_CHART.key(str[idx])
        idx += 1
      else
        int += CONV_CHART.key(str[idx])
      end
      idx += 1
    end
    int
  end

  def self.get_place_values(int)
    # Takes an integer and returns an array containing each of its place values
    # Size of array returned will be number of digits in argument
    components = Array.new
    size = int.digits.size 

    int.digits.reverse.each_with_index do |digit, idx|
      component = digit * 10 ** (size - idx - 1)
      components << component
    end
    components
  end

  def self.convert_pv(num)
    # 3 options - we either
    #   1. can convert directly to an RN
    #   2. need to prefix the next biggest RN equivalent with the next smaller exponent of ten
    #   3. need to suffix the next smaller RN equivalent with enough instances of the 2nd
    #      next smallest to get to the number
    if CONV_CHART.keys.include?(num)
      CONV_CHART[num]
    elsif num > DIGITS.last
      mult = num / DIGITS.last
      CONV_CHART[DIGITS.last] * mult
    else
      roman_compound(num)
    end
  end

  def self.roman_compound(num)
    # Makes a prefixed RN equivalent
    possible_digits = DIGITS.clone

    loop do
      next_lower_ten = get_next_ten(possible_digits.last)

      if possible_digits.last - num == next_lower_ten
        return CONV_CHART[next_lower_ten] + CONV_CHART[possible_digits.last]
      else
        possible_digits.pop
      end

      next if possible_digits.last > num

      combo = [possible_digits[-2], possible_digits[-1]]
      mult = (num - combo.last) / combo.first
      return CONV_CHART[combo.last] + CONV_CHART[combo.first] * mult
    end
  end

  def self.get_next_ten(last)
    # Finds the next smaller exponent of ten
    DIGITS.reverse.select { |digit| digit < last }.find do |maybe_next|
      maybe_next_log = Math.log10(maybe_next)
      maybe_next_log.floor == maybe_next_log
    end
  end
end

=begin
class RomanNumerals
  DIGITS = [0, 1, 5, 10, 50, 100, 500, 1000]
  ROMANS = ['', 'I', 'V', 'X', 'L', 'C', 'D', 'M']
  CONV_CHART = [DIGITS, ROMANS].transpose.to_h

  def self.to_roman(int)
    roman = ''
    place_vals = get_place_values(int)
    binding.pry
  end

  def self.get_place_values(int)
    components = Array.new
    size = int.digits.size 

    int.digits.reverse.each_with_index do |digit, idx|
      component = digit * 10 ** (size - idx - 1)
      components << component
    end
    components
  end

  def <=>(other_roman)

  end
end

# from_roman - algorithm
    # Initialize a LVar - int
    # Iterate over each letter in str
    #   If cur letter is last letter in str, add its integer equivalent from conversion chart to int
    #   Else, Check both the current letter as well as the next letter
    #     If the next letter comes "before" the current letter in the list of Roman numeral values, if we
    #     reverse sort the list of Romans, subtract roman(current letter) - roman(next letter), 
    #     and add the int equivalent of the result (from conv chart) to int
    #       eg. IX - X comes before I in the reverse sorted list of Romans, so we do X - I = 9
    #       eg2. but XIII - X comes after I in the reverse sorted list of Romans, so we do X + I + I + I = 13
    #       eg3 CM - C comes before M, so we do M - C = 900
    #     Else, add the integer equivalent from conv chart to int
    # Return int
=end

puts RomanNumerals.to_roman(1000)# , "M", "Should be")
puts RomanNumerals.to_roman(1990)# , "MCMXC", "Should be")
puts RomanNumerals.to_roman(1999)# , "MCMXCIX", "Should be")
puts RomanNumerals.to_roman(2008)# , "MMVIII", "Should be")
puts RomanNumerals.to_roman(1666)# , "MDCLXVI", "Should be")

puts RomanNumerals.from_roman('M') #, 1000, "Should be")
puts RomanNumerals.from_roman('MI') #, 1001, "Should be")
puts RomanNumerals.from_roman('MIX') #, 1009, "Should be")
puts RomanNumerals.from_roman('MIV') #, 1004, "Should be")
puts RomanNumerals.from_roman('MXL') #, 1040, "Should be")
puts RomanNumerals.from_roman('MDCLXVI') #, 1666, "Should be")
puts RomanNumerals.from_roman('MCMXC') #, 1990, "Should be")
puts RomanNumerals.from_roman('MCMXCIX') #, 1999, "Should be")
puts RomanNumerals.from_roman('MCMXXVII') #, 1927, "Should be")
puts RomanNumerals.from_roman('MMVIII') #, 2008, "Should be")