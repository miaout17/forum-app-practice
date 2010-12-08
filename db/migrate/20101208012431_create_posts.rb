class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.references :topic
      t.text :content

      t.timestamps
    end
    add_index :posts, :topic_id
  end

  def self.down
    drop_table :posts
  end
end
