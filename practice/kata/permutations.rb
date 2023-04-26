# In this kata you have to create all permutations of a non empty input string and remove duplicates, 
# if present. This means, you have to shuffle all letters from the input in all possible orders.
# 
# Examples:
# 
# * With input 'a'
# * Your function should return: ['a']
# * With input 'ab'
# * Your function should return ['ab', 'ba']
# * With input 'aabb'
# * Your function should return ['aabb', 'abab', 'abba', 'baab', 'baba', 'bbaa']
# The order of the permutations doesn't matter.

def permutations(string)
  # 1. convert string to an array of letters
  # 2. initialize array to add permutations to
  # 3. get permutations of all sizes of the letter array
  # 4. remove all duplicates from permutation array
  letters = string.chars
  permutations = Array.new
  
  1.upto(letters.size) do |num|
    letters.permutation(num).uniq.each do |perm|
      permutations << perm
    end
  end
  permutations
end

p permutations('ab')

