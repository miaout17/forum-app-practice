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
end
