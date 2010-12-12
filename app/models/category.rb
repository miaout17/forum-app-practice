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

class Category < ActiveRecord::Base
  acts_as_tree :order => "name"
  has_many :boards

  validates_presence_of :name

  def descendant_topics
    # TODO: This is a very slow implementation now..
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
    category_ids = descendant_categories.map { |c| c.id }
    boards = Board.where( :category_id => category_ids )
    return boards
  end

end
