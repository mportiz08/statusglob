class CreateFacebookAccounts < ActiveRecord::Migration
  def self.up
    create_table :facebook_accounts do |t|
      t.integer :user_id
      t.string :token
      t.string :secret

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_accounts
  end
end
