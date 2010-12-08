# == Schema Information
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  topic_id   :integer(4)
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
  end

  describe "instance" do
    before :each do
      @post = Factory(:post)
    end

    it "should be able to get its topic" do
      topic = @post.topic
      topic.should be
    end
  end
end
