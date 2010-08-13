class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.integer :user_id
      t.string :username
      t.string :avatar
      t.string :title
      t.string :description
      t.string :link_digg
      t.string :link_external
      t.datetime :date_posted

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
