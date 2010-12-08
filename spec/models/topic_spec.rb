require 'spec_helper'

describe Topic do
  describe "validator" do
    before :each do
      @params = {
        :title => Faker::Lorem.sentence,
        :board_id => 3,
      }
    end

    it "should be valid with valid attributes" do
      Topic.new(@params).should be_valid
    end

    it "should be invalid without name" do
      Topic.new(@params.except(:title)).should_not be_valid
    end

    it "must belong to a board" do
      Topic.new(@params.except(:board_id)).should_not be_valid
    end
  end

  describe "instance" do
    before :each do
      @topic = Factory(:topic)
    end

    it "should be able to get its board" do
      board = @topic.board
      board.should be
    end

    it "should be able to get its posts" do
      post = Factory(:post, :topic => @topic)
      @topic.reload
      @topic.posts.should include(post)
    end
  end
end
