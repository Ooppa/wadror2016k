class Rating < ActiveRecord::Base
  belongs_to :beer, touch: true
  belongs_to :user
  validates :score, numericality: { greater_than_or_equal_to: 1,
                                      less_than_or_equal_to: 50,
                                      only_integer: true }
  scope :recent, -> { order(created_at: :desc).limit(5) }

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id, :user_id)

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def recent
    order(created_at: :desc).limit(5)
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end

  def to_s
    "#{self.beer.name} - #{score}"
  end
end
