class Venue < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true

end
