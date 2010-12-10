class AddPostIdToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :post_id, :integer, :default => nil
  end

  def self.down
    remove_column :attachments, :post_id
  end
end
