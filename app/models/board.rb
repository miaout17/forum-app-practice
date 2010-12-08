# == Schema Information
#
# Table name: boards
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer(4)
#
# Indexes
#
#  index_boards_on_category_id  (category_id)
#

class Board < ActiveRecord::Base
  has_many :topics

  validates_presence_of :name
end
