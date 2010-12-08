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
    board_ids = descendant_boards.collect { |board| board.id }
    return Topic.where(:board_id => board_ids)
  end

  protected
  
  # returns all descendant categories including self
  def descendant_categories
    categories = [self]
    children.each do |child|
      categories += child.descendant_categories
    end
    return categories
  end

  def descendant_boards
    boards = []
    descendant_categories.each do |category|
      boards += category.boards
    end
    return boards
  end

end
