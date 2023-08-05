# frozen_string_literal: true

module Beepable
  def horn
    puts 'awuuuga'
  end
end

class Vehicle
  attr_accessor :color, :make, :year

  @@num = 0

  def initialize(color, make, year)
    @color = color
    @make = make
    @year = year
    @@num += 1
  end

  def self.display_count
    puts @@num
  end

  def display_age
    puts "The car is #{get_age} years old"
  end

  private 
  def get_age()
    t = Time.new
    t.year - year 
  end
end

class MyCar < Vehicle
  include Beepable
  CONDITION = { dented: true }.freeze
end

class MyTruck < Vehicle
  CONDITION = { dented: false }.freeze
end

car = MyCar.new('blue', 'honda', 2001)

car.display_age
