# frozen_string_literal: true

class Foo
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def size(obj)
    obj.size
  end
end

class Bar < Foo
  attr_accessor :how_big

  def initialize(color, how_big)
    super(color)
    @how_big = how_big
  end

  def size
    super(how_big) * 2
  end
end

abug = Bar.new('brown', 'big')

p abug.size
