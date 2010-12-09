class AddPostsCountToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :posts_count, :integer, :default => 0
    Topic.reset_column_information
    Topic.find(:all).each do |p|
      p.update_attribute :posts_count, p.posts.length
    end
  end

  def self.down
    remove_column :topics, :posts_count
  end
end
