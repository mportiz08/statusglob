class CreateTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :twitter_accounts do |t|
      t.integer :user_id
      t.string :token
      t.string :secret
      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_accounts
  end
end
