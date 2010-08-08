class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :site_id
      t.string :name
      t.string :name_id
      t.string :message
      t.string :link
      t.string :avatar
      t.datetime :date_posted

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
