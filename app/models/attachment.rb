class Attachment < ActiveRecord::Base

  has_attached_file :data,
                    :url  => "/attachments/:id",
                    :path => ":rails_root/attachments/:id/:style/:basename.:extension"

  def url(*args)
    data.url(*args)
  end
  
  def name
    data_file_name
  end
  
  def content_type
    data_content_type
  end
  
  def file_size
    data_file_size
  end


end
