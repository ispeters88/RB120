#TEST_SIZE = 1000000
#ERROR_MARGIN = 0.01
#
#machine = Computer.new
#machine.opponent_move = 'lizard'
##probs = [0.8, [0.05] * 4].flatten
##probs_hsh = Hash.new(0)
##
##TEST_SIZE.times do
##  probs_hsh[machine.benevolent] += 1
##end
##
##probs_hsh.each_key do |key|
##  probs_hsh[key] = probs_hsh[key] / TEST_SIZE.to_f
##end
##
##p probs_hsh
##p probs_hsh.all? do |key, val|
##    (val - probs[key]).abs < ERROR_MARGIN
##  end
#
#
#machine.personality = :shapeshifter
#5.times do
#  machine.shapeshifter
#end

TEST_SIZE = 10000000
machine = Computer.new
machine.opponent_move = Move.new('rock')

counts = Hash.new(0)

TEST_SIZE.times do
  move = machine.choose_move
  counts[move.value] += 1
end

probs = Hash.new

counts.each do |move, count|
  probs[move] = count / TEST_SIZE.to_f
end

p machine.name
p machine.opponent_move
p probs