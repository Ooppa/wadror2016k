class Rating < ActiveRecord::Base
  belongs_to :beer

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end

  def to_s
    "#{self.beer.name} - #{score}"
  end
end
