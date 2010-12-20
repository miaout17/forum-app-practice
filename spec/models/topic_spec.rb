# == Schema Information
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  board_id    :integer
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  posts_count :integer         default(0)
#
# Indexes
#
#  index_topics_on_board_id  (board_id)
#

require 'spec_helper'

describe Topic do
  describe "validator" do
    before :each do
      @params = {
        :title => Faker::Lorem.sentence,
        :board_id => 3,
        :user_id => 7,
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

    it "must belong to a user" do
      Topic.new(@params.except(:user_id)).should_not be_valid
    end
    
  end

  describe "instance" do
    before :each do
      @topic = Factory(:topic)
      @origin_post = Factory(:post, :topic => @topic, :user => @topic.user)
      @topic.reload
    end

    it "should be able to get its board" do
      board = @topic.board
      board.should be
    end

    it "should be able to get its posts" do
      @topic.posts.should include(@origin_post)
    end

    it "should cache its posts count" do
      @topic.posts_count.should == 1
      Factory(:post, :topic => @topic)
      @topic.reload
      @topic.posts_count.should == 2
    end

    it "could get its author" do
      @topic.user.should be
    end

    it "is published by default" do
      @topic.status.should == "published"
    end

    it "could be deleted" do
      @topic.soft_delete
      @topic.reload
      @topic.status.should == "deleted"
    end

    it "could be undeleted" do
      @topic.soft_delete
      @topic.soft_undelete
      @topic.reload
      @topic.status.should == "published"
    end

    describe ".published scope" do
      it "should get published topics" do
        Topic.published.all.should include(@topic)
      end
      it "shouldn't get deleted topics" do
        @topic.soft_delete
        Topic.published.all.should_not include(@topic)
      end
    end


    describe "#last_reply" do

      it "returns the last reply if exists" do
        reply = nil
        3.times do
          reply = Factory(:post, :topic => @topic, :user => @topic.user)
        end
        @topic.reload
        @topic.last_reply.should eq(reply)
      end

      it "return nil if no one replies" do
        @topic.reload
        @topic.last_reply.should be_nil
      end
    end

    describe "#last_replies" do

      it "returns [] if on one replies" do
        @topic.last_replies(1).should == []
      end

      it "returns last n replies if replies is enough" do
        5.times { Factory(:post, :topic => @topic) }
        @topic.reload

        @topic.last_replies(3).should == @topic.posts.last(3).reverse
      end

      it "returns all replies if replies is not enough" do
        5.times { Factory(:post, :topic => @topic) }
        @topic.reload
        @topic.last_replies(10).should_not include(@origin_post)
        @topic.last_replies(10).should == @topic.posts.last(5).reverse
      end

    end

  end
end
