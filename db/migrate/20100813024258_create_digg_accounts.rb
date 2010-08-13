class CreateDiggAccounts < ActiveRecord::Migration
  def self.up
    create_table :digg_accounts do |t|
      t.integer :user_id
      t.string :username

      t.timestamps
    end
  end

  def self.down
    drop_table :digg_accounts
  end
end
