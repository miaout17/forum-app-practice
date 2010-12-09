# == Schema Information
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  topic_id   :integer(4)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_posts_on_topic_id  (topic_id)
#

class Post < ActiveRecord::Base

  # Workaround for nested form
  # Reference: 
  # https://rails.lighthouseapp.com/projects/8994/tickets/2815-nested-models-build-should-directly-assign-the-parent
  belongs_to :topic, :inverse_of => :posts, :counter_cache => true

  validates_presence_of :content
  validates_presence_of :topic
end
