class Board < ActiveRecord::Base
  has_many :topics

  validates_presence_of :name
end
