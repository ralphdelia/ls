# frozen_string_literal: true

class Student
  attr_accessor :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other)
    grade > other.grade
  end

  protected

  attr_reader :grade
end

jim = Student.new('jim', 90)
bob = Student.new('bob', 85)

puts jim.better_grade_than?(bob)
puts jim.grade
