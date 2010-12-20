class AddAdministration < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :banned, :boolean, :default => false

    create_table :managements do |t|
      t.integer :user_id
      t.integer :manageable_type
      t.integer :manageable_id
    end

    add_column :topics, :status, :string, :default => "published"
    add_column :posts, :status, :string, :default => "published"
  end

  def self.down
    remove_column :users, :admin
    remove_column :users, :banned

    drop_table :managements

    remove_column :topics, :status
    remove_column :posts, :status
  end
end
