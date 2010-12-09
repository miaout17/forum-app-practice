require 'spec_helper'

describe Attachment do
  describe "validator" do
    it "is valid with valid attachment data" do 
      @params = {
        :data_file_name => "example.jpg",
        :data_content_type => "image/jpg",
        :data_file_size => "8192",
        :data_updated_at => nil
      }
      @attachment = Attachment.new(@params)
      @attachment.should be_valid
    end
    it "must have attachment data" do
      @attachment = Attachment.new({})
      @attachment.should_not be_valid
    end
  end
end
