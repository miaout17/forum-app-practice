require 'spec_helper'

describe Board do
  describe "validator" do
    before :each do
      @params = {
        :name => Faker::Lorem.sentence
      }
    end

    it "should be valid with valid attributes" do
      Board.new(@params).should be_valid
    end

    it "should be invalid without name" do
      Board.new(@params.except(:name)).should_not be_valid
    end
  end

  describe "instance" do
    before :each do
      @board = Factory(:board)
    end

    it "should be able to get its topics" do
      topic = Factory(:topic, :board => @board)
      @board.reload
      @board.topics.should include(topic)
    end
  end

end
