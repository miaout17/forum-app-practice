# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Category do
  describe "validator" do
    before :each do
      @params = {
        :name => Faker::Lorem.sentence,
      }
    end

    it "should be valid with valid attributes" do
      Category.new(@params).should be_valid
    end

    it "should be invalid without name" do
      Category.new(@params.except(:name)).should_not be_valid
    end

    it "should be valid with a parent" do
      parent = Factory(:category)
      category = Factory.build(:category, :parent => parent)
      category.should be_valid
    end

    pending "should be invalid when setting self as parent" do
      category = Factory(:category)
      category = Factory.build(:category, :parent => category)
      category.should_not be_valid
    end

    pending "should be invalid with circular parent association" do
      parent = Factory(:category)
      category = Factory(:category, :parent => parent)
      parent.parent = category
      parent.should_not be_valid
    end

  end

  describe "instance" do
    before(:each) do
      @category = Factory(:category)
    end

    it "can get its boards" do
      board = Factory(:board, :category => @category)
      @category.reload
      @category.boards.should include(board)
    end

    it "should be able to get its managers" do
      @manager = Factory(:user)
      @category.managers << @manager

      @category.reload
      @category.managers.should include(@manager)
    end

    it "can get its descendant topics" do
      @root = @category
      
      # TODO: Refator with factory_girl?
      # need to deal with "move_to_child_of" method

      @game = Factory(:category, :parent => @root)
      @programming = Factory(:category, :parent => @root)

      @mmorpg = Factory(:category, :parent => @game)
      @pcgame = Factory(:category, :parent => @game)

      @sango = Factory(:board, :category => @pcgame, :name => "Sango")
      @wow = Factory(:board, :category => @mmorpg, :name => "WoW")
      @lineage = Factory(:board, :category => @mmorpg, :name => "Lineage")

      @ruby = Factory(:board, :category => @programming, :name => "Ruby")
      @python = Factory(:board, :category => @programming, :name => "Python")

      @wow_topic = Factory(:topic, :board => @wow, :title => "WoW")
      @lineage_topic = Factory(:topic, :board => @lineage, :title => "Lineage")
      @sango_topic = Factory(:topic, :board => @sango, :title => "Sango")
      @ruby_topic = Factory(:topic, :board => @ruby)
      @python_topic = Factory(:topic, :board => @python)
      
      @pcgame_topics = [@sango_topic]
      @mmorpg_topics = [@wow_topic, @lineage_topic]
      @game_topics = @pcgame_topics + @mmorpg_topics
      @programming_topics = [@python_topic, @ruby_topic]
      @all_topics = @game_topics + @programming_topics
      
      @game.descendant_topics.to_set.should == @game_topics.to_set
      @pcgame.descendant_topics.to_set.should == @pcgame_topics.to_set
      @mmorpg.descendant_topics.to_set.should == @mmorpg_topics.to_set
      @programming.descendant_topics.to_set.should == @programming_topics.to_set
      @root.descendant_topics.to_set.should == @all_topics.to_set
    end

    it "could get its valid parent" do
      @programming = @category
      @ruby = Factory(:category, :parent => @programming)
      @python = Factory(:category, :parent => @programming)

      @game = Factory(:category)
      @mmorpg = Factory(:category, :parent => @game)
      @wow = Factory(:category, :parent => @mmorpg)
      @lineage = Factory(:category, :parent => @mmorpg)

      @pcgame = Factory(:category, :parent => @game)
      @sango = Factory(:category, :parent => @pcgame)
      @pal = Factory(:category, :parent => @pcgame)

      got = @pcgame.valid_parents
      expected = [@programming, @ruby, @python, @game, @mmorpg, @wow, @lineage]
      
      got.should =~ expected
    end
  end
end
