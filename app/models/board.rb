# == Schema Information
#
# Table name: boards
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer
#
# Indexes
#
#  index_boards_on_category_id  (category_id)
#

class Board < ActiveRecord::Base
  has_many :topics
  belongs_to :category

  validates_presence_of :name, :category_id
end
