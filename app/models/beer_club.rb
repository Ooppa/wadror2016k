class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, -> { distinct }, through: :memberships, source: :user
  validates :name, presence: true
  validates :city, presence: true
  validates :founded, numericality: { greater_than_or_equal_to: 1600, only_integer: true}
  validate :founded_in_future

  def founded_in_future
    if founded > Time.now.year
      errors.add(:founded, "can't be in the future")
    end
  end

  def to_s
    "#{name} #{city}"
  end

  def isMember(user)
    membership = self.memberships.find_by(user_id: user.id, beer_club_id: self.id)

    if membership.nil?
      return false
    end

    return membership.confirmed
  end

  def isApplied(user)
    membership = self.memberships.find_by(user_id: user.id, beer_club_id: self.id)

    if membership.nil?
      return false
    end

    return !membership.confirmed
  end
end
