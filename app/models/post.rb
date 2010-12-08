class Post < ActiveRecord::Base

  # Workaround for nested form
  # Reference: 
  # https://rails.lighthouseapp.com/projects/8994/tickets/2815-nested-models-build-should-directly-assign-the-parent
  belongs_to :topic, :inverse_of => :posts

  validates_presence_of :content
  validates_presence_of :topic
end
