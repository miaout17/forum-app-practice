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
  validate :validate_parent

  has_many :managements, :as => :manageable
  has_many :managers, 
    :through => :managements,
    :source => :user


  def descendant_topics
    # TODO: This is a very slow implementation now..
    # maybe the category hierarchy should be cached
    board_ids = descendant_boards.collect { |board| board.id }
    return Topic.where(:board_id => board_ids)
  end

  def valid_parents
    all_categories = Category.all
    descendants = self.descendant_categories

    invalid_ids = descendants.map { |c| c.id }

    valid = all_categories.select do |c| 
      !invalid_ids.include?(c.id) 
    end 

    return valid
  end

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

  protected

  def validate_parent
    # return if parent_id.nil?

    # valid_parent_ids = self.valid_parents.map { |c| c.id }
    # if !valid_parent_ids.include?(parent_id)
    #   errors.add(:base, "Circular parent association")
    # end
  end

end
