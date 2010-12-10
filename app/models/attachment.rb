class Attachment < ActiveRecord::Base

  has_attached_file :data, :styles => { :thumb => ["100x100#", :png] }
  validates_attachment_presence :data

end
