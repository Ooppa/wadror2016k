class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    "#{self.beer.name} - #{score}"
  end
end
