# == Schema Information
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  board_id    :integer
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  posts_count :integer         default(0)
#
# Indexes
#
#  index_topics_on_board_id  (board_id)
#

class Topic < ActiveRecord::Base
  belongs_to :board, :counter_cache => true
  belongs_to :user, :counter_cache => true
  has_many :posts, :inverse_of => :topic

  default_scope :order => 'id DESC'

  validates_presence_of :title, :board_id, :user_id
end
