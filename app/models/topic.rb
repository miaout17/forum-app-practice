# == Schema Information
#
# Table name: topics
#
#  id         :integer(4)      not null, primary key
#  board_id   :integer(4)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Topic < ActiveRecord::Base
  belongs_to :board
  has_many :posts, :inverse_of => :topic

  validates_presence_of :title, :board_id
end
