# frozen_string_literal: true

class Robot
  @@previous_names = []

  attr_reader :name

  def initialize
    set_valid_name
  end

  def reset
    set_valid_name
  end

  def set_valid_name
    name = generate_name
    name = generate_name while @@previous_names.include?(name)

    @@previous_names << name
    self.name = name
  end

  def generate_name
    digits = (0..9).to_a
    chars = ('A'..'Z').to_a

    chars.sample.to_s * 2 + digits.sample.to_s * 3
  end

  private

  attr_writer :name
end
