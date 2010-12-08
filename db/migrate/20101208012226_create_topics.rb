class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.references :board
      t.string :title

      t.timestamps
    end

    add_index :topics, :board_id
  end

  def self.down
    drop_table :topics
  end
end
