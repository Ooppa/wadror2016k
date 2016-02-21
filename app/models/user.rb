class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 15 }

  validates :password, length: { minimum: 4 },
                       format: {
                          with: /\d.*[A-Z]|[A-Z].*\d/,
                          message: "has to contain one number and one upper case letter"
                       }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  has_secure_password

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    h = Beer.joins(:ratings).select("beers.style_id, ratings.score").group(:style_id).average(:score)
    Style.find_by(id: h.key(h.values.max)).name
  end

  def favorite_brewery
    return nil if ratings.empty?
    h = Brewery.joins(:ratings, :beers).select("breweries.name, ratings.score").group("breweries.name").average(:score)
    h.key(h.values.max)
  end
end
