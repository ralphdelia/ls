class TextAnalyzer
  def process
    file = File.open('my_file.txt', 'r')
    yield(file.read)
    file.close
  end
end

analyzer = TextAnalyzer.new
analyzer.process { |text| puts text.split(' ').count }
analyzer.process { |text| puts text.lines.count }
analyzer.process { |text| puts text.lines.count("\n") + 1 }