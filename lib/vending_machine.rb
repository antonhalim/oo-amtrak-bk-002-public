class VendingMachine
	attr_reader :stationed_at, :json, :tickets
	attr_accessor :route

	def initialize(json, station)
		@stationed_at = station
		@route = load_json_file(json)
		@tickets = []
	end

	def load_json_file(json)
		JSON.parse(File.read(json))
	end

	def purchase_tickets(destination, tickets, name)
		stations = fetch_involved_stations(route, stationed_at, destination)
		if check_seat_availability(stations, tickets, destination)
			occupy_seats(stations, tickets)
			tickets.times do
				@tickets << Ticket.new(self.stationed_at, destination, name)
			end
			return "Transaction completed, thank you for choosing Amtrak."
		else
			"Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience."
		end
	end
private
	def check_seat_availability(stations, seats, destination)
		stations.keys.each do |route_index|
			# binding.pry
			if route.detect{|each_stop| each_stop["station name"][route_index]}["remaining seats"] < seats && route_index != destination
				return false
			end
		end
	end

	def occupy_seats(stations, seat)
		stations.keys.each do |station|
			mod = route.detect{|stop| stop["station name"] == station}
			mod["remaining seats"] -= seat
		end
	end


end
