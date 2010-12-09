class Attachment < ActiveRecord::Base

  has_attached_file :data
  validates_attachment_presence :data

end
