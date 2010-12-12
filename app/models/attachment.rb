# == Schema Information
#
# Table name: attachments
#
#  id                :integer         not null, primary key
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  post_id           :integer
#

class Attachment < ActiveRecord::Base
  has_attached_file :data, :styles => { :thumb => ["100x100#", :png] }
  belongs_to :post

  validates_attachment_presence :data

  def attach(the_post)
    return false unless post_id.nil?
    self.post_id = the_post.id
    return self.save
  end

end
