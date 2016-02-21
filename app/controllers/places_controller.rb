class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.get_one(params[:id])
		@address = ERB::Util.url_encode("#{@place.street}, #{@place.zip} #{@place.city}")
    @apikey = ENV['GOOGLE_APIKEY']
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
