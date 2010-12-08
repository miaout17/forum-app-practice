class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts, :inverse_of => :topic

  validates_presence_of :title, :board_id
end
