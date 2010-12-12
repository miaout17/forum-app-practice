class AddCounterCaches < ActiveRecord::Migration
  def self.up
    
    # Adds all missing counter caches

    add_column :boards, :topics_count, :integer, :default => 0
    add_column :users, :topics_count, :integer, :default => 0
    add_column :users, :posts_count, :integer, :default => 0

    Board.reset_column_information
    Board.find(:all).each do |b|
      b.update_attribute :topics_count, b.topics.length
    end

    User.reset_column_information
    User.find(:all).each do |u|
      u.update_attribute :topics_count, p.topics.length
      u.update_attribute :posts_count, p.posts.length
    end

  end

  def self.down
    remove_column :boards, :topics_count
    remove_column :users, :topics_count
    remove_column :users, :posts_count
  end
end
