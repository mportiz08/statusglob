class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :user_id
      t.string :username
      t.string :content
      t.datetime :date_posted
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
