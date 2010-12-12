class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
      t.timestamps

      # Custom fields
      t.string :name 

      # personal icon
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.datetime :icon_updated_at
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true

    add_index :users, :name, :unique => true

    add_column :topics, :user_id, :integer, :default => nil
    add_column :posts, :user_id, :integer, :default => nil

    add_index :topics, :user_id
    add_index :posts, :user_id
  end

  def self.down
    drop_table :users

    remove_column :topics, :user_id
    remove_column :posts, :user_id
  end
end
