

class MyCar
  attr_accessor :color
  attr_reader :year

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
  def car_off()
    @speed = 0
    puts 'lets park it'
  end
  def current_speed
    puts "you are going #{@speed} mph"
  end
  def spray_paint(new_color)
    self.color = new_color
    puts "You changed the color of the car to #{self.color}"
  end

end


claudia = MyCar.new("2001", "Honda", "Accord")

claudia.speed_up = 20
claudia.current_speed
