require 'spec_helper'

describe Topic do
  describe "validator" do
    before :each do
      @params = {
        :title => Faker::Lorem.sentence
      }
    end

    it "should be valid with valid attributes" do
      Topic.new(@params).should be_valid
    end

    it "should be invalid without name" do
      Topic.new(@params.except(:title)).should_not be_valid
    end
  end
end
