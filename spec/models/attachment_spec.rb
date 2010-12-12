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

  describe "instance" do
    before(:each) do
      @attachment = Factory(:attachment)
      @attachment.post.should be_nil
      @post = Factory(:post)
      @another_post = Factory(:post)
    end
    
    describe "which doesn't belongs to a post" do
      it "could be attached to a post " do
        @attachment.attach(@post).should be
        @attachment.post.should == @post
      end
    end

    describe "which already belongs to a post" do
      it "cannot be attached to a post " do
        @attachment.attach(@post)
        @attachment.attach(@another_post).should_not be
        @attachment.post.should == @post
      end
    end
  end
end
