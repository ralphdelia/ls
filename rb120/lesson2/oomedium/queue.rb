# frozen_string_literal: true

class CircularQueue
  attr_accessor :queue, :buffer_end, :buffer_start
  attr_reader :last_index

  def initialize(size)
    @queue = [nil] * size
    @last_index = queue.size - 1
    @buffer_start = 0
    @buffer_end = 0
  end

  # write to buffer end
  def enqueue(object)
    dequeue if !queue[buffer_end].nil?

    queue[buffer_end] = object

    if buffer_end + 1 > last_index
      self.buffer_end = 0
    else
      self.buffer_end += 1
    end
  end

  # remove from buffer start
  def dequeue
    return nil if queue_empty?

    obj = queue[buffer_start]
    queue[buffer_start] = nil

    if buffer_start + 1 > last_index
      self.buffer_start = 0
    else
      self.buffer_start += 1
    end
    obj
  end

  def queue_empty?
    queue.all?(nil)
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue.nil?

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
puts queue.dequeue.nil?

queue = CircularQueue.new(4)
puts queue.dequeue.nil?

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
puts queue.dequeue.nil?
