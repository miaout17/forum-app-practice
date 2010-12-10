class Attachment < ActiveRecord::Base
  has_attached_file :data, :styles => { :thumb => ["100x100#", :png] }
  belongs_to :post

  validates_attachment_presence :data

  def attach(the_post)
    return false unless post_id.nil?
    self.post = the_post
    return true
  end
end
