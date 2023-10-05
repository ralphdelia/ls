class Element
  attr_reader :datum, :following
  def initialize(datum, following=nil)
    @datum = datum
    @following = following
  end

  def tail?
    following.nil?
  end

  def next
    following
  end

end

class SimpleLinkedList

  def initialize
    @head = nil
  end

  def push(datum)
    @head = Element.new(datum)
  end

  def size
    count = @head.nil? ? 0 : 1 
    current = @head
    
    loop do
      break if current.nil? || current.next.nil?
      current = current.next
    end
     
    count
  end

  def empty?
    @list.nil?
  end


end
