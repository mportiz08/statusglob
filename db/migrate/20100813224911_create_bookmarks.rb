class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.integer :user_id
      t.string :username
      t.string :title
      t.string :description
      t.string :link
      t.string :tags
      t.datetime :date_posted

      t.timestamps
    end
  end

  def self.down
    drop_table :bookmarks
  end
end
