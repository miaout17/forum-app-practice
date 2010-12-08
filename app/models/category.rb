# == Schema Information
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  acts_as_tree :order => "name"
  has_many :boards

  validates_presence_of :name

  def descendant_topics
    # Todo: This is a very slow implementation now..
    # maybe the category hierarchy should be cached
    board_ids = descendant_boards.collect { |board| board.id }
    return Topic.where(:board_id => board_ids)
  end

  protected
  
  # returns all descendant categories including self
  def descendant_categories
    categories = children.collect do |child|
      child.descendant_categories
    end.flatten
    categories << self
    return categories
  end

  def descendant_boards
    boards = descendant_categories.collect do |category|
      category.boards
    end.flatten
    return boards
  end

end
