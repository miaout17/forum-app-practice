class Topic < ActiveRecord::Base
  belongs_to :board

  validates_presence_of :title, :board_id
end
