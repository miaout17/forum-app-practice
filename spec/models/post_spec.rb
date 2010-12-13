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

require 'spec_helper'

describe Post do
  describe "validator" do
    before :each do
      @topic = Factory(:topic)
      @params = {
        :topic => @topic,
        :user_id => 8,
        :content => Faker::Lorem.sentence,
      }
    end

    it "should be valid with valid attributes" do
      Post.new(@params).should be_valid
    end

    it "should be invalid without name" do
      Post.new(@params.except(:content)).should_not be_valid
    end

    it "must belong to a topic" do
      Post.new(@params.except(:topic)).should_not be_valid
    end

    it "must belong to a user" do
      Post.new(@params.except(:user_id)).should_not be_valid
    end
  end

  describe "instance" do
    before :each do
      @post = Factory(:post)
    end

    it "should be able to get its topic" do
      topic = @post.topic
      topic.should be
    end

    it "could be attached by obtain_attachments" do
      attachments = []
      2.times { attachments << Factory(:attachment) }
      @post.obtain_attachments(attachments)
      @post.reload
      @post.attachments.count.should == 2
      @post.attachments.should =~ attachments
    end

    it "could get its author" do
      @post.user.should be
    end

    it "could be edited by author" do
      author = @post.user
      @post.editable_by?(author).should be
    end

    it "couldn't be edited by author" do
      other_user = Factory(:user)
      @post.editable_by?(other_user).should_not be
    end

    it "couldn't be edited by nil user" do # case of not logged in
      @post.editable_by?(nil).should_not be
    end

  end
end
