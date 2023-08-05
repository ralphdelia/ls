class Flight
  
  def initialize(flight_number, database_handle)
    @database_handle = database_handle
    @flight_number = flight_number
  end
end

dbase = Database.init

Flight.new(num, dbase)