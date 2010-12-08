class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts, :inverse_of => :topic

  # accepts_nested_attributes_for :posts

  validates_presence_of :title, :board_id
end
