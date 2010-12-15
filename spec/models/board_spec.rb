# == Schema Information
#
# Table name: boards
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer
#
# Indexes
#
#  index_boards_on_category_id  (category_id)
#

require 'spec_helper'

describe Board do
  describe "validator" do
    before :each do
      @params = {
        :name => Faker::Lorem.sentence,
        :category_id => 6,
      }
    end

    it "should be valid with valid attributes" do
      Board.new(@params).should be_valid
    end

    it "should be invalid without name" do
      Board.new(@params.except(:name)).should_not be_valid
    end

    it "must belong to a category" do
      Board.new(@params.except(:category_id)).should_not be_valid
    end
  end

  describe "instance" do
    before(:each) do
      @board = Factory(:board)
    end

    it "should be able to get its category" do
      @board.category.should be
    end

    it "should be able to get its topics" do
      topic = Factory(:topic, :board => @board)
      @board.reload
      @board.topics.should include(topic)
    end

    it "should be able to get its managers" do
      @manager = Factory(:user)
      @board.managers << @manager

      @board.reload
      @board.managers.should include(@manager)
    end
  end

end
