class Clock
  attr_accessor :hours, :min

  def initialize(hours, min = 0)
    @hours = hours
    @min = min
  end

  def to_s
    hours = self.hours < 10 ? "0#{self.hours}" : self.hours.to_s
    min = self.min < 10 ? "0#{self.min}" : self.min.to_s
    "#{hours}:#{min}"
  end

  def ==(other)
    hours == other.hours &&
      min == other.min
  end

  def +(other)
    while other.positive?
      self.min += 1
      other -= 1
      if self.min > 59
        self.hours += 1
        self.min = 0
      end
      self.hours = 0 if self.hours > 23
    end
    self.class.at(hours, min)
  end

  def -(other)
    while other.positive?
      self.min -= 1
      other -= 1
      if self.min.negative?
        self.hours -= 1
        self.min = 59
      end
      self.hours = 23 if self.hours.negative?
    end
    self.class.at(hours, min)
  end

  def self.at(hours, min = 0)
    new(hours, min)
  end
end
