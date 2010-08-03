class AddSiteIdColumnToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :site_id, :integer
  end

  def self.down
    remove_column :tweets, :site_id
  end
end
