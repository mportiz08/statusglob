class AddAvatarColumnToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :avatar, :string
  end

  def self.down
    remove_column :tweets, :avatar
  end
end
