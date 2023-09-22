require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

#

class NewTest < Minitest::Test

  def setup
    
  end

  # Your tests go here. Remember they must start with "test_"

  def test
    refute_includes(list, 'xyz')
  end

end