class BeermappingApi
  def self.places_in(city)
      Rails.cache.fetch(city, :expires_in => 1.week) { fetch_places_in(city.downcase) }
  end

  def self.get_one(id)
      Rails.cache.fetch("place_#{id}", expires_in: 1.week) { get_one(id) }
  end

  private

  def self.places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.get_one(id)
		url = "http://beermapping.com/webservice/locquery/#{key}/"

		response = HTTParty.get "#{url}#{ERB::Util.url_encode(id)}"
		place = response.parsed_response["bmp_locations"]["location"]

		return Place.new(place)
	end

  def self.key
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end
end
