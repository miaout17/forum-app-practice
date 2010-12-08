class Post < ActiveRecord::Base
  belongs_to :topic

  validates_presence_of :content, :topic_id
end
