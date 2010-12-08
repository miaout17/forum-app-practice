class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end

    add_column :boards, :category_id, :integer
    add_index :boards, :category_id
  end

  def self.down
    drop_table :categories
    remove_column :boards, :category_id
  end
end
