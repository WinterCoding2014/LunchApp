class Venue < ActiveRecord::Base
  validates_presence_of :name, :message => "*name cannot be blank"
  validates_presence_of :description, :message => "*description cannot be blank"
  validates_presence_of :address, :message => "*address cannot be blank"

  scope :sorted, -> { order("upper(name)") }

end
