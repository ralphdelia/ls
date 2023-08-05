# frozen_string_literal: true

class MyCar
  attr_accessor :color
  attr_reader :year, :model, :speed

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up=(num)
    @speed += num
    puts "You sped the car up by #{num} mph"
  end

  def brake=(num)
    @speed -= num
    puts "You slowed the car down by #{num} mph"
  end

  def car_off
    @speed = 0
    puts 'lets park it'
  end

  def current_speed
    puts "you are going #{@speed} mph"
  end

  def spray_paint(new_color)
    self.color = new_color
    puts "You changed the color of the car to #{color}"
  end

  def to_s
    "This is a #{color} #{year} #{model} going #{speed} MPH."
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons}  miles per gallon of gas"
  end
end

the_car = MyCar.new('2001', 'silver', 'Honda Accord')
puts the_car


