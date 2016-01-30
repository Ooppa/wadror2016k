module RatingAverage extend ActiveSupport::Concern
  def average_rating
    self.ratings.average(:score).round(2)
  end
end
