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