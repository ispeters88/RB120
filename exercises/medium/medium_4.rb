# Circular Queue
# A circular queue is a collection of objects stored in a buffer 
# that is treated as though it is connected end-to-end in a circle. 
# When an object is added to this circular queue, it is added to the position 
# that immediately follows the most recently added object, 
# while removing an object always removes the object that has been in the queue the longest.
# 
# This works as long as there are empty spots in the buffer. If the buffer becomes full, 
# adding a new object to the queue requires getting rid of an existing object; 
# with a circular queue, the object that has been in the queue the longest is discarded and replaced by the new object.
# 
# Assuming we have a circular queue with room for 3 objects, the circular queue looks and acts like this:
# 
# P1	P2	P3	Comments
# All positions are initially empty
# 1			Add 1 to the queue
# 1	2		Add 2 to the queue
# 2		Remove oldest item from the queue (1)
# 2	3	Add 3 to the queue
# 4	2	3	Add 4 to the queue, queue is now full
# 4		3	Remove oldest item from the queue (2)
# 4	5	3	Add 5 to the queue, queue is full again
# 4	5	6	Add 6 to the queue, replaces oldest element (3)
# 7	5	6	Add 7 to the queue, replaces oldest element (4)
# 7		6	Remove oldest item from the queue (5)
# 7			Remove oldest item from the queue (6)
# Remove oldest item from the queue (7)
# Remove non-existent item from the queue (nil)
# Your task is to write a CircularQueue class that implements 
# a circular queue for arbitrary objects. 
# The class should obtain the buffer size with an argument provided to CircularQueue::new, 
# and should provide the following methods:
# 
# enqueue to add an object to the queue
# dequeue to remove (and return) the oldest object in the queue. It should return nil if the queue is empty.
# You may assume that none of the values stored in the queue are nil 
# (however, nil may be used to designate empty spots in the buffer).
# 

# collaborator object for storing the queued objects
#   > we could use an array, but we need to keep track of the length of time something has been in the queue
#   > could use a hash where the key is the object and the value is how long its been in the queue; we would
#     then need to update this each move
#   > could create a custom object - then we could store @age as a state variable
#     would then be good to store these custom QueueItem objects in an array

require "pry-byebug"

class QueueItem
  attr_accessor :age
  attr_reader :value

  def initialize(value)
    @value = value
    @age = 0
  end
end

class CircularQueue
  def initialize(buffer_size)
    @buffer_size = buffer_size
    @queue = Array.new(buffer_size)
  end

  def enqueue(item)
    reset_val_for_oldest if @queue.count(&:nil?) == 0
    add_queue_item(item)
    update_item_ages
  end

  def dequeue
    return nil if @queue.all?(&:nil?)
    update_item_ages
    oldest = find_oldest
    reset_val_for_oldest
    oldest.value
  end

  private

  def find_buffer_items
    @queue.reject(&:nil?)
  end

  def find_oldest
    find_buffer_items.max_by(&:age)
  end

  def reset_val_for_oldest
    @queue[@queue.index(find_oldest)] = nil
  end

  def add_queue_item(item)
    @queue[empty_spots.sample] = QueueItem.new(item)
  end

  def empty_spots
    @queue.map.with_index { |item, idx| idx }.select do |idx|
      @queue[idx].nil?
    end
  end

  def update_item_ages
    @queue.each do |item|
      next if item.nil?
      item.age += 1
    end
  end
end

# Examples:

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

# The above code should display true 15 times.

