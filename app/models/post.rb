# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  topic_id   :integer
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
  belongs_to :user, :counter_cache => true
  has_many :attachments

  validates_presence_of :content, :topic, :user_id

  def attach_by_ids(attachment_ids)
    attachments = Attachment.where(:id => attachment_ids)
    attachments.each do |attachment|
      attachment.attach(self)
    end
  end

  def editable_by?(user)
    return false if user.nil?
    return user_id == user.id
  end

end
