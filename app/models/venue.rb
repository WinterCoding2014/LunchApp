class Venue < ActiveRecord::Base

  has_many :ratings
  has_many :chosen_venues
  validates_presence_of :name, :message => "*name cannot be blank"
  validates_presence_of :description, :message => "*description cannot be blank"
  validates_presence_of :address, :message => "*address cannot be blank"

  scope :sorted, -> { order("upper(name)") }

  def rating
    @_rating = Random.rand(5) unless @_rating
    @_rating
  end
end
