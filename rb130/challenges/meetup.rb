

require 'date'

class Meetup
  def initialize(year, month)
    @year = year
    @month = month
  end

  def day(day, schedule)
    schedule = schedule.downcase
    return return_teeth_day(day) if schedule == 'teenth'

    days = return_matching_days(day)
    case schedule
    when 'first' then days[0]
    when 'last' then days[-1]
    when 'second' then days[1]
    when 'third' then days[2]
    when 'fourth' then days[3]
    when 'fifth' then days[4]
    end
  end

  private 

  def return_teeth_day(day)
    13.upto(19) do |number|
      date = Date.civil(year, month, number)
      return date if date.strftime('%A') == day
    end
  end

  def return_matching_days(day)
    day = day.capitalize
    date = Date.civil(year, month, 1)
    results = []

    until date == Date.civil(year, month, 1).next_month
      results << date if date.strftime('%A') == day
      date = date.next_day
    end
    results
  end

  attr_reader :year, :month
end
