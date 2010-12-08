class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts

  validates_presence_of :title, :board_id
end
