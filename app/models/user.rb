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
    favorite :style
  end

  def favorite(category)
    return nil if ratings.empty?
    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end

  def favorite_brewery
    return nil if ratings.empty?
    h = Brewery.joins(:ratings, :beers).select("breweries.name, ratings.score").group("breweries.name").average(:score)
    Brewery.find_by(name: h.key(h.values.max))
  end

  def most_active_users(n)
    h = User.joins(:ratings).select("users.username, rating.user_id").group(:username).count(:user_id).sort_by {|k,v| v}.reverse[0..n]
    hash = {}
      h.each do |key, value|
        u = User.find_by(:username => key)
        hash[u] = value
      end
    hash
  end
end
