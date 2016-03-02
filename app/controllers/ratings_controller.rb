class RatingsController < ApplicationController

  def index
    Rails.cache.write('brewery top 3', Beer.top(3), expires_in: 15.minutes) if fragment_exist?('brewery top 3')
    Rails.cache.write('brewery top 3', Brewery.top(3), expires_in: 15.minutes) if fragment_exist?('beer top 3')
    Rails.cache.write('user top 3', User.top(3), expires_in: 15.minutes) if fragment_exist?('user top 3')
    Rails.cache.write('style top 3', Style.top(3), expires_in: 15.minutes) if fragment_exist?('style top 3')

    @top_beers = Rails.cache.read 'beer top 3'
    @top_breweries = Rails.cache.read 'brewery top 3'
    @top_users = Rails.cache.read 'user top 3'
    @top_styles = Rails.cache.read 'style top 3'
    @recent = Rating.recent # Recent ei ole recent jos se on cachettu
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    if @rating.save
      current_user.ratings << @rating
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end

  def background_worker
    while true do
      sleep 25.minutes
      Rails.cache.write('brewery top 3', Beer.top(3), expires_in: 25.minutes)
      Rails.cache.write('brewery top 3', Brewery.top(3), expires_in: 25.minutes)
      Rails.cache.write('user top 3', User.top(3), expires_in: 25.minutes)
      Rails.cache.write('style top 3', Style.top(3), expires_in: 25.minutes)
    end
  end
end
